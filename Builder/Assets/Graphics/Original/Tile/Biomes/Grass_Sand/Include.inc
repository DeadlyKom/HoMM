
                ifndef _GRAPHICS_TILE_BIOME_GRASS_SAND_PACK_
                define _GRAPHICS_TILE_BIOME_GRASS_SAND_PACK_

                module Grass_Sand
                ORG Adr.TileSprites
Begin           EQU $
                include "ArrayAdrTileSprite.inc"
                include "Biome.inc"
Size            EQU $-Begin
                savebin "Builder/Assets/Graphics/Original/Tile/Biomes/Grass_Sand/Pack.pack", Begin, Size
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Graphics/Original/Tile/Biomes/Grass_Sand/Pack.pack Builder/Assets/Graphics/Compressed/Biomes/Grass_Sand.pack.ar"

                ORG 0x0000
Begin.ar        incbin "Builder/Assets/Graphics/Compressed/Biomes/Grass_Sand.pack.ar"
Size.ar         EQU $
Size.Sector.ar  EQU ((Size.ar % TRDOS.SECTOR_SIZE > 0) & 0x01) + (Size.ar >> 8)
                endmodule

                endif ; ~ _GRAPHICS_TILE_BIOME_GRASS_SAND_PACK_
