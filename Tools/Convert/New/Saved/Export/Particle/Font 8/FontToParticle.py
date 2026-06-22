import json
from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent
EXPORT_PATH = BASE_DIR / "Export.json"


def filename_from_sprite(name: str) -> str:
    """Добавляет расширение к исходному имени спрайта."""
    return name + ".bin"


def get_metadata(sprite: dict, metadata_type: str) -> int:
    """Читает метаданные глифа из всех Regions записи Export.json."""
    values = [
        metadata["Value"]
        for region in sprite.get("Regions", [])
        for metadata in region.get("Metadata", [])
        if metadata.get("Type") == metadata_type
    ]

    if not values:
        raise ValueError(
            f'{sprite.get("SprName", "<без имени>")}: '
            f'не найдены метаданные "{metadata_type}"'
        )
    if len(values) > 1:
        raise ValueError(
            f'{sprite.get("SprName", "<без имени>")}: '
            f'найдено несколько значений "{metadata_type}"'
        )

    value = values[0]
    if not isinstance(value, int) or not 0 <= value <= 0xFF:
        raise ValueError(f'Значение "{metadata_type}" должно быть байтом: {value!r}')
    return value


def resolve_data_path(path: str) -> Path:
    data_path = Path(path)
    return data_path if data_path.is_absolute() else BASE_DIR / data_path


def collect_points(ink_data: bytes, width: int, height: int) -> bytearray:
    """Преобразует нулевые биты InkData в координаты: YYYYXXXX."""
    if not 1 <= width <= 16 or not 1 <= height <= 16:
        raise ValueError(
            f"Размер глифа должен помещаться в 4-битные координаты: {width}x{height}"
        )

    width_bytes = (width + 7) // 8
    expected_size = width_bytes * height
    if len(ink_data) != expected_size:
        raise ValueError(
            f"Некорректный размер InkData: {len(ink_data)}, ожидалось {expected_size}"
        )

    points = bytearray()
    for y in range(height):
        for byte_x in range(width_bytes):
            ink = ink_data[y * width_bytes + byte_x]
            for bit in range(8):
                x = byte_x * 8 + bit
                if x < width and not (ink & (0x80 >> bit)):
                    points.append((y << 4) | x)

    if len(points) > 0xFF:
        raise ValueError(f"Количество точек не помещается в FGlyphHeader.Count: {len(points)}")
    return points


def build_glyph(sprite: dict) -> bytearray:
    sprite_name = sprite["SprName"]
    width = sprite["SprWidth"]
    height = sprite["SprHeight"]
    ink_path = resolve_data_path(sprite["InkData"])

    try:
        ink_data = ink_path.read_bytes()
    except OSError as error:
        raise OSError(f'{sprite_name}: не удалось прочитать "{ink_path}"') from error

    points = collect_points(ink_data, width, height)
    advance = get_metadata(sprite, "Advance")
    baseline = get_metadata(sprite, "Baseline")

    # FGlyphHeader: Count, Advance, Baseline, затем массив Points.
    return bytearray((len(points), advance, baseline)) + points


def main() -> None:
    with EXPORT_PATH.open("r", encoding="utf-8-sig") as file:
        export = json.load(file)

    if not isinstance(export, list):
        raise ValueError("Корневой элемент Export.json должен быть массивом")

    for sprite in export:
        glyph_data = build_glyph(sprite)
        output_path = BASE_DIR / filename_from_sprite(sprite["SprName"])
        output_path.write_bytes(glyph_data)
        print(f'{sprite["SprName"]}: {glyph_data[0]} точек -> "{output_path.name}"')


if __name__ == "__main__":
    main()
