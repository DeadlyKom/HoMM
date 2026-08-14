# Version: 1

import os
import re
import json
from enum import Enum
from typing import List, Dict, Any, Optional

class ESpriteType(Enum):
    LD_ATTR = 0
    OR_XOR_ATTR = 1

def get_metadata_sprite(sprite: Dict[str, Any], name: str) -> List[Dict[str, Any]]:
    """
    Возвращает метаданные всего спрайта с указанным именем.
    В текущем формате они хранятся в Regions без RegionRect.
    """
    result = []
    for region in sprite.get("Regions", []):
        if "RegionRect" in region:
            continue

        for metadata in region.get("Metadata", []):
            if metadata.get("Type") == name:
                result.append(metadata)

    return result

def get_metadata(sprite: Dict[str, Any], x: int, y: int, name: str) -> List[Dict[str, Any]]:
    """
    Возвращает метаданные указанного типа для точки (x, y) спрайта.
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

def sprite_type_from_metadata(sprite: Dict[str, Any]) -> ESpriteType:
    """
    Возвращает тип вывода атрибутного спрайта.
    """
    metadata = get_metadata_sprite(sprite, "SpriteType")
    if not metadata:
        raise ValueError(f"Sprite '{sprite['SprName']}' has no SpriteType metadata")

    value = metadata[0].get("Value")
    try:
        return ESpriteType(value)
    except ValueError:
        raise ValueError(f"Unknown SpriteType: {value}")

def filename_from_sprite(name: str, extension: str = ".bin") -> str:
    """
    Возвращает безопасное имя выходного файла.
    """
    safe_name = re.sub(r'[\\/*?:"<>|]', "", name)
    safe_name = safe_name.replace(" ", "_")
    safe_name = safe_name.lower()
    return safe_name + extension

def get_index(boundary_width: int, bx: int, by: int, dy: Optional[int] = None) -> int:
    """
    Возвращает линейный индекс для Ink, Mask или Attribute.
    """
    if dy is None:
        return by * boundary_width + bx
    return (by * 8 + dy) * boundary_width + bx

def is_attribute_override(sprite: Dict[str, Any], bx: int, by: int) -> bool:
    """
    Проверяет необходимость заменить атрибут указанного знакоместа.
    По умолчанию атрибут экрана сохраняется.
    """
    metadata = get_metadata(sprite, bx * 8, by * 8, "OverrideAttr")
    if not metadata:
        return False
    return bool(metadata[-1].get("Value"))

def append_attribute(sprite: Dict[str, Any],
                     attribute_data: bytearray,
                     sprite_data: bytearray,
                     boundary_width: int,
                     bx: int,
                     by: int):
    """
    Добавляет пару OR/XOR для атрибута знакоместа.
    """
    if not is_attribute_override(sprite, bx, by):
        sprite_data.append(0x00)
        sprite_data.append(0x00)
        return

    attribute = attribute_data[get_index(boundary_width, bx, by)]
    sprite_data.append(0xFF)
    sprite_data.append(0xFF - attribute)

def convert_ld_attr(sprite: Dict[str, Any],
                    width: int,
                    height: int,
                    ink_data: bytearray,
                    attribute_data: bytearray) -> bytearray:
    """
    Формирует данные LD_ATTR.
    """
    boundary_width = width >> 3
    sprite_data = bytearray()

    for y in range(height):
        for bx in range(boundary_width):
            sprite_data.append(ink_data[y * boundary_width + bx])

        if (y & 0x07) == 0x07:
            by = y >> 3
            for bx in range(boundary_width):
                append_attribute(sprite, attribute_data, sprite_data,
                                 boundary_width, bx, by)

    return sprite_data

def convert_or_xor_attr(sprite: Dict[str, Any],
                        width: int,
                        height: int,
                        ink_data: bytearray,
                        attribute_data: bytearray,
                        mask_data: bytearray) -> bytearray:
    """
    Формирует данные OR_XOR_ATTR.
    """
    boundary_width = width >> 3
    sprite_data = bytearray()

    for y in range(height):
        for bx in range(boundary_width):
            index = y * boundary_width + bx
            ink = ink_data[index]
            byte_or = mask_data[index]
            byte_xor = (ink ^ byte_or) & byte_or

            sprite_data.append(byte_or)
            sprite_data.append(byte_xor)

        if (y & 0x07) == 0x07:
            by = y >> 3
            for bx in range(boundary_width):
                append_attribute(sprite, attribute_data, sprite_data,
                                 boundary_width, bx, by)

    return sprite_data

def validate_sprite(sprite: Dict[str, Any],
                    ink_data: bytearray,
                    attribute_data: bytearray,
                    mask_data: bytearray):
    """
    Проверяет ограничения атрибутного рендера.
    """
    width = sprite["SprWidth"]
    height = sprite["SprHeight"]

    if width < 8 or width > 32 or (width & 0x07):
        raise ValueError(
            f"Sprite '{sprite['SprName']}' width must be 8..32 and divisible by 8")

    if height < 8 or height > 32 or (height & 0x07):
        raise ValueError(
            f"Sprite '{sprite['SprName']}' height must be 8..32 and divisible by 8")

    boundary_width = width >> 3
    pixel_size = boundary_width * height
    attribute_size = boundary_width * (height >> 3)

    if len(ink_data) != pixel_size:
        raise ValueError(
            f"Sprite '{sprite['SprName']}' InkData size must be {pixel_size}, got {len(ink_data)}")

    if len(mask_data) != pixel_size:
        raise ValueError(
            f"Sprite '{sprite['SprName']}' MaskData size must be {pixel_size}, got {len(mask_data)}")

    if len(attribute_data) != attribute_size:
        raise ValueError(
            f"Sprite '{sprite['SprName']}' AttributeData size must be {attribute_size}, got {len(attribute_data)}")

def main():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    json_path = os.path.join(base_dir, "Export.json")

    with open(json_path, "r", encoding="utf-8") as file:
        export = json.load(file)

    for sprite in export:
        with open(sprite["InkData"], "rb") as file:
            ink_data = bytearray(file.read())
        with open(sprite["AttributeData"], "rb") as file:
            attribute_data = bytearray(file.read())
        with open(sprite["MaskData"], "rb") as file:
            mask_data = bytearray(file.read())

        validate_sprite(sprite, ink_data, attribute_data, mask_data)

        sprite_type = sprite_type_from_metadata(sprite)
        width = sprite["SprWidth"]
        height = sprite["SprHeight"]

        if sprite_type == ESpriteType.LD_ATTR:
            sprite_data = convert_ld_attr(
                sprite, width, height, ink_data, attribute_data)
        else:
            sprite_data = convert_or_xor_attr(
                sprite, width, height, ink_data, attribute_data, mask_data)

        file_name = os.path.join(
            base_dir, filename_from_sprite(sprite["SprName"]))
        with open(file_name, "wb") as file:
            file.write(sprite_data)

        info_name = os.path.join(
            base_dir, filename_from_sprite(sprite["SprName"], ".sprinfo"))
        with open(info_name, "w", encoding="utf-8") as file:
            file.write(f"Width: {width}\n")
            file.write(f"Height: {height}\n")
            file.write("SOx: 0\n")
            file.write("SOy: 0\n")

if __name__ == "__main__":
    main()
