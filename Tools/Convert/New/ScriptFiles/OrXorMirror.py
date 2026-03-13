import os
import re
import json
from typing import List, Dict, Any, Optional

def first_bit(byte: int, pixel_value: int):
    """
    Найти первый бит слева, равный pixel_value (0 или 1)
    """
    for bit in reversed(range(8)):
        bit_val = 1 if (byte & (1 << bit)) else 0
        if bit_val == pixel_value:
            return bit
    return None

def last_bit(byte: int, pixel_value: int) -> int:
    """
    Найти последний бит справа, равный pixel_value (0 или 1)
    """
    for bit in range(8):
        bit_val = 1 if (byte & (1 << bit)) else 0
        if bit_val == pixel_value:
            return bit
    return None

def to_rows(sprite: bytes, width_bytes: int, height: int) -> list[bytes]:
    """
    разрезделение спрайта на строки
    """
    return [
        sprite[y*width_bytes:(y+1)*width_bytes]
        for y in range(height)
    ]

def shift_row_left(row: bytes, shift_pixels: int) -> bytes:
    """
    Сдвиг строки спрайта влево на shift_pixels
        row - строка в виде bytes
        shift_pixels - количество пикселей для сдвига
    """

    width = len(row)  # количество байтов в строке

    # целочисленный сдвиг по байтам и остаток по битам
    byte_shift = shift_pixels // 8
    bit_shift = shift_pixels % 8

    # убираем полные байты слева, добавляем нули справа для сохранения ширины
    row = row[byte_shift:] + bytes(byte_shift)

    # если сдвиг только по байтам, возвращаем
    if bit_shift == 0:
        return row

    # сдвиг по битам
    result = bytearray(width)
    for i in range(width):
        left = (row[i] << bit_shift) & 0xFF  # сдвигаем текущий байт
        right = 0
        if i + 1 < width:
            right = row[i + 1] >> (8 - bit_shift)  # переносим старшие биты следующего байта
        result[i] = left | right

    return bytes(result)
 
def shift_sprite_left(sprite_rows: list[bytes], shift_pixels: int) -> list[bytes]:
    """
    Сдвигает весь спрайт влево на shift_pixels пикселей.
        sprite_rows - список строк спрайта (каждая строка в виде bytes)
        shift_pixels - количество пикселей для сдвига
    """
    return [shift_row_left(row, shift_pixels) for row in sprite_rows]

def analyze_sprite(sprite: list[bytes], width_bytes: int, height: int,
                   left_padding: int = 0, pixel_value: int = 0) -> dict:
    """
    Анализ спрайта
        sprite - спрайт (маска)
        width_bytes - ширина спрайта в байтах
        height - высота спрайта в строках
        left_padding - отступ слева после сдвига
        pixel_value - какой бит считать пикселем (0 или 1)
    """

    min_y = height
    max_y = -1

    # --- вертикальный bound
    for y in range(height):
        row = sprite[y]
        for xb in range(width_bytes):
            b = row[xb]
            if (pixel_value == 0 and b != 0xFF) or (pixel_value == 1 and b != 0x00):
                min_y = min(min_y, y)
                max_y = max(max_y, y)
                break

    if max_y == -1:
        return None  # пустой спрайт

    # --- горизонтальный bound
    min_x = width_bytes * 8
    max_x = -1

    for y in range(min_y, max_y + 1):
        row = sprite[y]

        # слева
        for xb in range(width_bytes):
            b = row[xb]
            bit = first_bit(b, pixel_value)
            if bit is not None:
                x = xb * 8 + (7- bit)
                min_x = min(min_x, x)
                break

        # справа
        for xb in reversed(range(width_bytes)):
            b = row[xb]
            bit = last_bit(b, pixel_value)
            if bit is not None:
                x = xb * 8 + (7- bit)
                max_x = max(max_x, x)
                break

    width = max_x - min_x + 1
    height = max_y - min_y + 1
    shift_pixels = max(min_x - left_padding, 0)

    return {
        "shift_pixels": shift_pixels,           # Количество пикселей, на которое можно сдвинуть спрайт влево с учётом left_padding.
        "min_x": min_x,                         # Левая граница спрайта в пикселях (по маске). Первый пиксель спрайта.
        "max_x": max_x,                         # Правая граница спрайта в пикселях (по маске). Последний пиксель спрайта.
        "min_y": min_y,                         # Верхняя граница спрайта (по маске), строка с первым пикселем.
        "max_y": max_y,                         # Нижняя граница спрайта (по маске), строка с последним пикселем.
        "width": width,                         # Ширина спрайта в пикселях внутри найденного bounding box: max_x - min_x + 1
        "height": height                        # Высота спрайта в пикселях внутри bounding box: max_y - min_y + 1
    }

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

def reverse_byte(b: int) -> int:
    b = ((b & 0xF0) >> 4) | ((b & 0x0F) << 4)
    b = ((b & 0xCC) >> 2) | ((b & 0x33) << 2)
    b = ((b & 0xAA) >> 1) | ((b & 0x55) << 1)
    return b

def OR_XOR(sprite: Dict[str, Any],
           width: int,
           sprite_width: int,
           sprite_height: int,
           ink_data: bytearray,
           mask_data: bytearray,
           sprite_data: bytearray):
    
    boundary_width = ((sprite_width + 7) // 8)

    for by in range(0, sprite_height, 1):
        for bx in range(0, boundary_width, 1):
            ink = ink_data[get_index(width >> 3, bx, by)]
            mask = mask_data[get_index(width >> 3, bx, by)]
            
            byte_or = mask
            byte_xor = (ink ^ byte_or) & mask

            # спрайт с маской зеркальный (маска всегда хранится отзеркаленная, а спрайт нормальный)
            mirror_byte_or = reverse_byte(byte_or)
            sprite_data.append(mirror_byte_or)
            sprite_data.append(byte_xor)
    return True

def export_sprite(filename: str,
                  width: int, height: int,
                  sox: int, soy: int,
                  sprite_bytes: bytearray):
    """
    Выгружает спрайт в бинарный файл для просмотра в HEX редакторе.
    """
    # --- FSpriteInfo
    fsprite_info = bytearray(4)
    fsprite_info[0] = width & 0b00011111   # ширина 5 бит
    fsprite_info[1] = height & 0b00011111  # высота 5 бит
    fsprite_info[2] = sox
    fsprite_info[3] = soy

    # --- Создаем полный блок данных
    data = fsprite_info + sprite_bytes

    # --- Записываем в файл
    with open(filename, "wb") as f:
        f.write(data)

    print(f"Спрайт сохранен в {filename}, размер {len(data)} байт")

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

        width_bytes = sprite_width // 8
        inc_rows = to_rows(ink_data, width_bytes, sprite_height)
        mask_rows = to_rows(mask_data, width_bytes, sprite_height)

        info = analyze_sprite(
            mask_rows,
            width_bytes,
            sprite_height,
            left_padding=0,
            pixel_value=1
        )
    
        shift_pixels = info["shift_pixels"]
        width = info["width"]
        height = info["height"]
        min_y = info["min_y"]
        max_y = info["max_y"]

        ink_rows_ = shift_sprite_left(inc_rows, shift_pixels)
        mask_rows_ = shift_sprite_left(mask_rows, shift_pixels)

        # оставляем только строки с пикселями
        ink_rows_trimmed = ink_rows_[min_y:max_y+1]
        mask_rows_trimmed = mask_rows_[min_y:max_y+1]
        ink_shifted_data = bytearray(b''.join(ink_rows_trimmed))
        mask_shifted_data = bytearray(b''.join(mask_rows_trimmed))
    
        sprite_data = bytearray()
        if OR_XOR (sprite, sprite_width, width, height, ink_shifted_data, mask_shifted_data, sprite_data):
            # сохранение спрайта в отдельный файл
            file_name = os.path.join(BASE_DIR, filename_from_sprite(sprite_name))
            with open(file_name, "wb") as f:
                f.write(sprite_data)

            # выгрузка информации о спрайте
            width_pixels  = info["width"]           # ширина bounding box
            height_pixels = info["height"]          # высота bounding box
            shift_x       = info["shift_pixels"]    # смещение по X (левый край)
            shift_y       = info["min_y"]           # смещение по Y (верхний край)

            # берем только 5 младших бит
            width_byte  = width_pixels  & 0b00011111
            height_byte = height_pixels & 0b00011111

            # см структуру FSpriteInfo
            file_info_name = os.path.join(BASE_DIR, filename_from_sprite(sprite_name, ".sprinfo"))
            with open(file_info_name, "w") as f:
                f.write(f"Width: {width_byte}\n")
                f.write(f"Height: {height_byte}\n")
                f.write(f"SOx: {shift_x}\n")
                f.write(f"SOy: {shift_y}\n")

if __name__ == "__main__":
    main()