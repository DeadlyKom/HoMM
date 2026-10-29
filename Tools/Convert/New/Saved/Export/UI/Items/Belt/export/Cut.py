# Version: 5

# Назначение:
#   подготовка спрайтов по знакоместам для вывода модулем Boundary
#
# Позиция на экране:
#   - выравнивание по знакоместам
#
# Атрибуты:
#   используются
#
# Типы вывода:
#   тип вывода задаётся свойством SpriteType:
#   - 0 — LD_ATTR, копирование пикселей спрайта с атрибутами
#   - 1 — OR_XOR_ATTR, наложение спрайта по маске OR & XOR с атрибутами
#
# Методы вывода модуля Boundary:
#   LD_ATTR
#   LD_ATTR_HM
#   LD_ATTR_VM
#   LD_ATTR_HVM
#
#   OR_XOR_ATTR
#   OR_XOR_ATTR_HM
#   OR_XOR_ATTR_VM
#   OR_XOR_ATTR_HVM
#
#   - координаты задаются в целых пикселях
#   - без суффикса — прямой вывод
#   - HM — отражение по горизонтали
#   - VM — отражение по вертикали
#   - HVM — отражение по обеим осям
#   - режим вывода и отражение задаются в настройках блока спрайта
#   - флаги блока также задают абсолютную позицию или смещение
#     относительно координат вывода и позволяют пропустить блок
#   - отсечение по границам экрана не поддерживается
#
# Ограничения:
#   - ширина и высота кратны 8 пикселям
#   - максимальный размер блока — 256x192 пикселя
#   - спрайт должен полностью помещаться в области экрана
#
# Формат данных:
#   - файл .bin не содержит заголовка
#   - знакоместа хранятся столбцами слева направо,
#     внутри каждого столбца — сверху вниз
#   - пиксельные строки внутри знакоместа идут сверху вниз
#
#   LD_ATTR:
#     - 8 байтов пикселей, байт атрибута, байт управления
#     - биты пикселей в 1-й, 3-й, 5-й и 7-й строках знакоместа зеркалируются
#     - остальные пиксельные строки хранятся без зеркалирования
#     - одно знакоместо занимает 10 байт
#
#   OR_XOR_ATTR:
#     - 8 пар байтов пиксельных строк, байт атрибута, байт управления
#     - первый байт пары — OR-маска с зеркальным порядком битов
#     - второй байт — XOR-данные, (INK ^ MASK) AND MASK
#     - MASK в формуле — исходная маска до зеркалирования
#     - XOR-данные хранятся без зеркалирования
#     - одно знакоместо занимает 18 байт
#
#   Атрибут:
#     - исходный байт атрибута знакоместа без преобразований
#
#   Байт управления:
#     - бит 0 — в текущем столбце есть следующее знакоместо
#     - бит 1 — последнее знакоместо всего спрайта
#     - бит 2 — пропустить запись атрибута знакоместа
#     - остальные биты равны 0
#
#   контейнер для методов вывода задаётся отдельно в коде:
#     - байт количества блоков
#     - массив FSpriteBlock с размерами, положением, флагами
#       и смещениями до данных блоков
#     - данные блоков из файлов .bin
#
# Свойства:
#   SpriteType — обязательное свойство всего спрайта:
#     - 0 — Load, в настройках вывода нужен режим LD_ATTR
#     - 1 — OR_XOR, в настройках вывода нужен режим OR_XOR_ATTR
#
#   SkipAttr — пропуск записи атрибута:
#     - false или отсутствие свойства — записать атрибут спрайта
#     - true — сохранить атрибут экрана
#     - задаётся для всего спрайта или отдельной области
#     - попадание в область определяется по верхнему левому пикселю знакоместа
#     - при нескольких подходящих значениях используется последнее
#
# Подготовка данных:
#   - читаются InkData и AttributeData
#   - для OR_XOR дополнительно требуется MaskData
#   - исходный прямоугольник сохраняется, пустые поля не обрезаются
#   - результат сохраняется в файл .bin

import os
import re
import json
import struct
from enum import Enum
from typing import List, Dict, Any, Optional

class ESpriteType(Enum):
    Load = 0
    OR_XOR = 1

SPRITE_BOUNDARY_NEXT_VERTICAL = 1 << 0
SPRITE_BOUNDARY_LAST = 1 << 1
SPRITE_BOUNDARY_SKIP_ATTR = 1 << 2


def reverse_byte(b: int) -> int:
    b = ((b & 0xF0) >> 4) | ((b & 0x0F) << 4)
    b = ((b & 0xCC) >> 2) | ((b & 0x33) << 2)
    b = ((b & 0xAA) >> 1) | ((b & 0x55) << 1)
    return b

def get_metadata_sprite(sprite: Dict[str, Any], name: str) -> List[Dict[str, Any]]:
    """
    Возвращает метаданные всего спрайта с указанным именем.
    В текущем формате они хранятся в Regions без RegionRect.
    """
    result = []
    for region in sprite.get("Regions", []):
        if "RegionRect" in region:
            continue

        for meta in region.get("Metadata", []):
            if meta.get("Type") == name:
                result.append(meta)

    return result

def get_metadata(sprite: Dict[str, Any], x: int, y: int,
                 name: str) -> List[Dict[str, Any]]:
    """
    Возвращает метаданные для точки спрайта.
    Метаданные без RegionRect распространяются на весь спрайт.
    """
    result = []

    for region in sprite.get("Regions", []):
        if "RegionRect" in region:
            x1, y1, x2, y2 = region["RegionRect"]
            if not (x1 <= x < x2 and y1 <= y < y2):
                continue

        for metadata in region.get("Metadata", []):
            if metadata.get("Type") == name:
                result.append(metadata)

    return result


def get_cell_flags(sprite: Dict[str, Any], bx: int, by: int,
                   boundary_width: int, boundary_height: int) -> int:
    """
    Формирует байт управления знакоместом.
    SkipAttr пропускает запись атрибута экрана.
    """
    flags = 0

    if by < boundary_height - 1:
        flags |= SPRITE_BOUNDARY_NEXT_VERTICAL

    if bx == boundary_width - 1 and by == boundary_height - 1:
        flags |= SPRITE_BOUNDARY_LAST

    metadata = get_metadata(sprite, bx * 8, by * 8, "SkipAttr")
    if metadata and bool(metadata[-1].get("Value", False)):
        flags |= SPRITE_BOUNDARY_SKIP_ATTR

    return flags


def sprite_type_from_metadata(sprite: dict) -> Optional[ESpriteType]:
    """
    Возвращает тип enum спрайта.
    """
    meta_list = get_metadata_sprite(sprite, "SpriteType")
    if not meta_list:
        return None

    value = meta_list[0].get("Value")

    try:
        return ESpriteType(value)
    except ValueError:
        raise ValueError(f"Unknown SpriteType: {value}")
    
def filename_from_sprite(name: str, Ext: str = ".bin") -> str:
    """
    функция для безопасного имени файла
    """
    safe_name = re.sub(r'[\\/*?:"<>|]', "", name)   # убираем недопустимые символы
    safe_name = safe_name.replace(" ", "_")         # пробелы → _
    safe_name = safe_name.lower()                   # приводим к нижнему регистру
    return safe_name + Ext

def get_index(boundary_width: int, bx: int, by: int, dy: Optional[int] = None) -> int:
    """
    Возвращает линейный индекс для массива Ink, Mask или Attribute.
    Если dy не указан, возвращает индекс для атрибута.
    Если dy указан, возвращает индекс по пикселю внутри знакоместа.
    """
    if dy is None:
        return by * boundary_width + bx
    return (by * 8 + dy) * boundary_width + bx

def get_height_boundary(boundary_width: int, mask_data: bytearray, bx: int, by: int) -> int:
    """
    Определяет высоту заполнения знакоместа (поиск пустой маски).
    """
    for dy in range(7, -1, -1):
        mask = mask_data[get_index(boundary_width, bx, by, dy)]
        if mask == 0:
            return 7 - dy
    return 8

def Load(sprite: Dict[str, Any],
         sprite_width: int,
         sprite_height: int,
         ink_data: bytearray,
         attribute_data: bytearray,
         mask_data: bytearray,          # неиспользуется
         sprite_data: bytearray):
    
    boundary_width = sprite_width >> 3
    boundary_height = sprite_height >> 3

    for bx in range(0, boundary_width, 1):
        for by in range(0, boundary_height, 1):
            for dy in range(8):
                ink = ink_data[get_index(boundary_width, bx, by, dy)]
                # каждый второй dy (например, 1,3,5,7) разворачиваем байт
                if dy % 2 == 0:
                    ink = reverse_byte(ink)
                sprite_data.append(ink)

            # атрибут один раз на тайл
            attribute = attribute_data[get_index(boundary_width, bx, by)]
            sprite_data.append(attribute)

            # байт управления знакоместом
            flags = get_cell_flags(sprite, bx, by, boundary_width, boundary_height)
            sprite_data.append(flags)

    return True

def OR_XOR(sprite: Dict[str, Any],
           sprite_width: int,
           sprite_height: int,
           ink_data: bytearray,
           attribute_data: bytearray,
           mask_data: bytearray,
           sprite_data: bytearray):
    
    boundary_width = sprite_width >> 3
    boundary_height = sprite_height >> 3

    for bx in range(0, boundary_width, 1):
        for by in range(0, boundary_height, 1):
            for dy in range(8):
                ink = ink_data[get_index(boundary_width, bx, by, dy)]
                mask = mask_data[get_index(boundary_width, bx, by, dy)]
                
                byte_or = mask
                byte_xor = (ink ^ byte_or) & mask

                # спрайт с маской зеркальный (маска всегда хранится отзеркаленная, а спрайт нормальный)
                mirror_byte_or = reverse_byte(byte_or)
                sprite_data.append(mirror_byte_or)
                sprite_data.append(byte_xor)

            # атрибут один раз на тайл
            attribute = attribute_data[get_index(boundary_width, bx, by)]
            sprite_data.append(attribute)

            # байт управления знакоместом
            flags = get_cell_flags(sprite, bx, by, boundary_width, boundary_height)
            sprite_data.append(flags)

    return True

SWITCH_BEHAVIOR = {
    ESpriteType.Load: Load,
    ESpriteType.OR_XOR: OR_XOR,
}

def main():
    BASE_DIR = os.path.dirname(os.path.abspath(__file__))
    json_path = os.path.join(BASE_DIR, "Export.json")

    with open(json_path, "r", encoding="utf-8") as file:
        export = json.load(file)

    # основной цикл спрайтов
    for sprite in export:
        sprite_name = sprite["SprName"]
        sprite_width = sprite["SprWidth"]
        sprite_height = sprite["SprHeight"]

        # Загрузка бинарных данных
        with open(sprite["InkData"], "rb") as f: ink_data = bytearray(f.read())
        with open(sprite["AttributeData"], "rb") as f: attribute_data = bytearray(f.read())
        
        # Пустая маска для спрайтов без файла маски
        mask_data = bytearray()
        mask_path = sprite.get("MaskData")
        # Проверка наличия файла маски перед чтением
        if mask_path and os.path.isfile(mask_path):
            with open(mask_path, "rb") as f: mask_data = bytearray(f.read())

        sprite_data = bytearray()
        sprite_type = sprite_type_from_metadata(sprite)
        if sprite_type is None:
            raise ValueError(f"Sprite '{sprite_name}' has no SpriteType metadata")

        behavior = SWITCH_BEHAVIOR[sprite_type]
        if behavior(sprite, sprite_width, sprite_height, ink_data, attribute_data, mask_data, sprite_data):
            # сохранение спрайта в отдельный файл
            file_name = os.path.join(BASE_DIR, filename_from_sprite(sprite_name))
            with open(file_name, "wb") as f:
                f.write(sprite_data)

if __name__ == "__main__":
    main()
