import os
import re
import json
import struct
from enum import Enum
from typing import List, Dict, Any, Optional

class ESpriteType(Enum):
    Load = 0
    OR_XOR = 1
def reverse_byte(b: int) -> int:
    b = ((b & 0xF0) >> 4) | ((b & 0x0F) << 4)
    b = ((b & 0xCC) >> 2) | ((b & 0x33) << 2)
    b = ((b & 0xAA) >> 1) | ((b & 0x55) << 1)
    return b

def get_metadata_sprite(sprite: Dict[str, Any], name: str) -> List[Dict[str, Any]]:
    """
    Возвращает список метаданных спрайта указанного имени.
    """
    result = []
    if "Metadata" in sprite:    
        for meta in sprite.get("Metadata", []):
            if meta["Type"] == name:
                result.append(meta)
    return result

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

    for by in range(0, boundary_height, 1):
        for bx in range(0, boundary_width, 1):
            for dy in range(8):
                ink = ink_data[get_index(boundary_width, bx, by, dy)]
                # каждый второй dy (например, 1,3,5,7) разворачиваем байт
                if dy % 2 == 0:
                    ink = reverse_byte(ink)
                sprite_data.append(ink)

            # атрибут один раз на тайл
            attribute = attribute_data[get_index(boundary_width, bx, by)]
            sprite_data.append(attribute)

            # ---------- ФЛАГИ ----------
            flags = 0
            # бит 0: есть ещё знакоместа по вертикали в этой колонке?
            if by < boundary_height - 1:
                flags |= 0b00000001         # продолжаем вертикально
            # бит 1: конец спрайта (последнее знакоместо)
            if (bx == boundary_width - 1) and (by == boundary_height - 1):
                flags |= 0b00000010         # спрайт исчерпан
            sprite_data.append(flags)

    return True

def OR_XOR(sprite: Dict[str, Any],
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

            # ---------- ФЛАГИ ----------
            flags = 0
            # бит 0: есть ещё знакоместа по вертикали в этой колонке?
            if by < boundary_height - 1:
                flags |= 0b00000001         # продолжаем вертикально
            # бит 1: конец спрайта (последнее знакоместо)
            if (bx == boundary_width - 1) and (by == boundary_height - 1):
                flags |= 0b00000010         # спрайт исчерпан
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
        with open(sprite["MaskData"], "rb") as f: mask_data = bytearray(f.read())

        sprite_data = bytearray()
        sprite_type = sprite_type_from_metadata(sprite)
        if SWITCH_BEHAVIOR[sprite_type] (sprite, sprite_width, sprite_height, ink_data, attribute_data, mask_data, sprite_data):
            # сохранение спрайта в отдельный файл
            file_name = os.path.join(BASE_DIR, filename_from_sprite(sprite_name))
            with open(file_name, "wb") as f:
                f.write(sprite_data)

if __name__ == "__main__":
    main()