import os
import re
import json
import struct
from typing import List, Dict, Any, Optional

def get_metadata(sprite: Dict[str, Any], x: int, y: int, name: str) -> List[Dict[str, Any]]:
    """
    Возвращает список метаданных указанного типа для точки (x, y) спрайта.
    """
    result = []
    for region_data in sprite.get("Regions", []):
        x1, y1, x2, y2 = region_data["RegionRect"]
        if x1 <= x < x2 and y1 <= y < y2:
            for meta in region_data.get("Metadata", []):
                if meta["Type"] == name:
                    result.append(meta)
    return result

def filename_from_sprite(name: str, Ext: str = ".bin") -> str:
    """
    функция для безопасного имени файла
    """
    safe_name = re.sub(r'[\\/*?:"<>|]', "", name)   # убираем недопустимые символы
    safe_name = safe_name.replace(" ", "_")         # пробелы → _
    safe_name = safe_name.lower()                   # приводим к нижнему регистру
    return safe_name + Ext

def get_index(boundary_x: int, bx: int, by: int, dy: Optional[int] = None) -> int:
    """
    Возвращает линейный индекс для массива Ink, Mask или Attribute.
    Если dy не указан, возвращает индекс для атрибута.
    Если dy указан, возвращает индекс по пикселю внутри знакоместа.
    """
    if dy is None:
        return by * boundary_x + bx
    return (by * 8 + dy) * boundary_x + bx

def get_height_boundary(boundary_x: int, mask_data: bytearray, bx: int, by: int) -> int:
    """
    Определяет высоту заполнения знакоместа (поиск пустой маски).
    """
    if by < 0:
        return 0
    for dy in range(7, -1, -1):
        mask = mask_data[get_index(boundary_x, bx, by, dy)]
        if mask == 0:
            return 7 - dy
    return 8

def draw(sprite: Dict[str, Any],
         boundary_x: int,
         ink_data: bytearray,
         attribute_data: bytearray,
         mask_data: bytearray,
         sprite_data: bytearray,
         bx: int,
         by: int,
         skip_line: int,
         prediction_flag: bool,
         mask_flag: bool) -> bool:
    """
    знакоместо без маски (рисуется частично или полностью)
    Возвращает True, если столбец закончился или отсутствуют данные.
    """
    height = 8
    prediction_height = 8
    is_early_exit = False
    attribute_meta_high = 0b11111111
    is_override_attribute = not mask_flag

    # определение высота следующего знакоместа
    if prediction_flag:
        prediction_height = get_height_boundary(boundary_x, mask_data, bx, by - 1)
        attribute_meta_high = prediction_height

    # высота с маской
    if mask_flag:
        mask_height = get_height_boundary(boundary_x, mask_data, bx, by)
        height = mask_height
        if mask_height < 8:
            is_early_exit = True
        
    # метаданные перегрузки для текущего знакоместа
    metadata_values_override_attribute = get_metadata(sprite, bx * 8, by * 8, "OverrideAttr")
    if metadata_values_override_attribute:
        is_override_attribute = metadata_values_override_attribute[0].get("Value")
             
    # основной цикл по знакоместам
    for dy in range(7 - skip_line, 7 - height, -1):
        if mask_flag:
            ink = ink_data[get_index(boundary_x, bx, by, dy)]
            mask = mask_data[get_index(boundary_x, bx, by, dy)]
            byte_or = mask
            byte_xor = (ink ^ byte_or) & mask
            sprite_data.append(byte_or)
            sprite_data.append(byte_xor)
        else:
            sprite_data.append(ink_data[get_index(boundary_x, bx, by, dy)])

    # атрибут знакоместа
    attribute = attribute_data[get_index(boundary_x, bx, by)]
    attribute = ((attribute >> 1) & 0xFF)           # сдвиг и сброс 7-го бита
                                                    # т.к. ink всегда чёрный, сдвигом влево можно восстановить исходное значение
    attribute |= int(is_override_attribute) << 7    # 7-ой бит отвечает за хранение флага, перегрузки записи в атрибут экрана
    sprite_data.append(attribute)

    # метаданные высоты для текущей точки (высота знакоместа)
    if not prediction_flag and not mask_flag:
        metadata_values_height = get_metadata(sprite, bx * 8, by * 8, "Height") # булевое значение, является ли данное знакоместо высоким или нет?
        attribute_meta_high = ((attribute_meta_high << 2) & 0xFF)  # сдвиг и сброс 0-го и 1-го бита
    
        # установка флага высоты (0-ой бит)
        if metadata_values_height and metadata_values_height[0].get("Value"):
            attribute_meta_high |= 1  # установка 0-го бита
    
    # переходной вариант, когда флаг prediction_flag установлен, mask_flag сброшен
    #   0ой бит отвечает за выосоту
    #   1ый бит за вывод с маской
    #   2-7 биты высота вывода с маской
    elif prediction_flag and not mask_flag:
        metadata_values_height = get_metadata(sprite, bx * 8, by * 8, "Height") # булевое значение, является ли данное знакоместо высоким или нет?
        attribute_meta_high = ((attribute_meta_high << 2) & 0xFF)  # сдвиг и сброс 0-го и 1-го бита
    
        # установка флага высоты (0-ой бит)
        if metadata_values_height and metadata_values_height[0].get("Value"):
            attribute_meta_high |= 1  # установка 0-го бита
        # установка флага маски (1-ый бит) 
        attribute_meta_high |= 1 << 1

    # переходной вариант, когда флаг prediction_flag установлен, mask_flag установлен
    #   бит отвечает за выосоту не требуется, т.к. все  знакоместа с маской высокие
    #   0-7 биты высота вывода с маской, 0 окончание
    elif prediction_flag and mask_flag:
        attribute_meta_high = attribute_meta_high

    sprite_data.append(attribute_meta_high)

    # проверка раннего выхода, когда будущая высота равна нулю, позволяет точно определить количество пропускаемых знакомест
    if not is_early_exit and prediction_height == 0:
        return True
    
    return is_early_exit

# обёртки для разных режимов рисования
def draw_full(sprite, boundary_x, ink_data, attribute_data, mask_data, sprite_data, bx, by, skip_line):
    return draw(sprite, boundary_x, ink_data, attribute_data, mask_data, sprite_data, bx, by, 0, False, False)

def draw_partial(sprite, boundary_x, ink_data, attribute_data, mask_data, sprite_data, bx, by, skip_line):
    return draw(sprite, boundary_x, ink_data, attribute_data, mask_data, sprite_data, bx, by, -skip_line, False, False)

def draw_full_with_height(sprite, boundary_x, ink_data, attribute_data, mask_data, sprite_data, bx, by, skip_line):
    return draw(sprite, boundary_x, ink_data, attribute_data, mask_data, sprite_data, bx, by, 0, True, False)

def draw_alpha_mask(sprite, boundary_x, ink_data, attribute_data, mask_data, sprite_data, bx, by, skip_line):
    return draw(sprite, boundary_x, ink_data, attribute_data, mask_data, sprite_data, bx, by, 0, True, True)

# поведение знакомест:
# 0     - знакоместо без маски (рисуется полностью)
# -2,-6 - знакоместо без маски (рисуется частично)
# -8    - знакоместо без маски (рисуется полностью), 
#         но в атрибуте указывается высота следующего вывода знакоместа с маской
# None  - вывода знакоместа с маской, но высота неопределена, расчитывается из маски спрайта
    
MATRIX_BEHAVIOR = [
    [ None,  None,  None,  None,  None,  None],
    [ None,  None,  None,  None,  None,  None],
    [ None,  None,  None,  None,  None,  None],
    [ None,  None,    -8,    -8,  None,  None],
    [   -8,    -8,     0,     0,    -8,    -8],
    [    0,     0,     0,     0,     0,     0],
    [    0,     0,     0,     0,     0,     0],
    [   -6,    -2,     0,     0,    -2,    -6],
]

SWITCH_BEHAVIOR = {
    0: draw_full,
    -2: draw_partial,
    -6: draw_partial,
    -8: draw_full_with_height,
    None: draw_alpha_mask
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

        # разбить результирующий файл на колонки
        if "MonoColumns" in sprite:
            mono_columns = sprite["MonoColumns"]
        else:
            mono_columns = False

        if mono_columns:
            # 12 байт длина таблицы смещения
            if "StartOffset" in sprite:
                start_offset = sprite["StartOffset"]
            else:
                start_offset = 0

            # каждое последующее смещение уменьшает общее на 2 байта
            if "StepOffset" in sprite:
                step_offset = sprite["StepOffset"]
            else:
                step_offset = 0
        else:
            start_offset = step_offset = 0

        # Загрузка бинарных данных
        with open(sprite["InkData"], "rb") as f: ink_data = bytearray(f.read())
        with open(sprite["AttributeData"], "rb") as f: attribute_data = bytearray(f.read())
        with open(sprite["MaskData"], "rb") as f: mask_data = bytearray(f.read())

        boundary_x = sprite_width >> 3
        boundary_y = sprite_height >> 3

        sprite_data = bytearray()
        column_offsets = []

        offset = start_offset
        for bx in range(boundary_x):
            
            # сохранение стартового адреса столбца
            column_offsets.append(len(sprite_data) + offset)
            if offset > 0:
                offset -= step_offset

            for by in range(boundary_y - 1, -1, -1):
                behavior = MATRIX_BEHAVIOR[by][bx]
                if SWITCH_BEHAVIOR[behavior](
                    sprite, boundary_x,
                    ink_data, attribute_data, mask_data,
                    sprite_data, bx, by, behavior
                ):
                    # сохраним количество оставшихся знакомест
                    sprite_data.append(by)
                    sprite_data.append(0)
                    break

        if mono_columns:
            # сохранение спрайта в отдельный файл
            file_name = os.path.join(BASE_DIR, filename_from_sprite(sprite_name))
            with open(file_name, "wb") as f:
                f.write(sprite_data)

            # column_offsets содержит 6 смещений, каждое 2 байта (unsigned short)
            # исключаем первый элемент (всегда нулевой)
            # offset_bytes = struct.pack("<5H", *column_offsets[1:])  # "<" - little endian, "H" - 2 байта
            offset_bytes = struct.pack("<6H", *column_offsets[0:])  # "<" - little endian, "H" - 2 байта

            # сохраняем смещения столбцов в отдельный файл
            offsets_name = os.path.join(BASE_DIR, filename_from_sprite(sprite_name + "_offsets"))
            with open(offsets_name, "wb") as f:
                f.write(offset_bytes)
        else:
            # разбиение файла на колонки и сохранение как отдельные файлы

            # декодируем смещения колонок
            # column_offsets = list(struct.unpack("<6H", offset_bytes))

            # добавляем конец массива как последний оффсет
            column_offsets.append(len(sprite_data))
    
            # разбиение sprite_data на 6 колонок
            for i in range(6):
                start = column_offsets[i]
                end = column_offsets[i + 1]

                column_data = sprite_data[start:end]

                # имя файла для колонки
                column_filename = os.path.join(
                    BASE_DIR,
                    filename_from_sprite(f"{sprite_name}_col_{i}")
                )

                # сохраняем колонку
                with open(column_filename, "wb") as f:
                    f.write(column_data)

if __name__ == "__main__":
    main()