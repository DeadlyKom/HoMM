
                ifndef _BUILDING_ASSETS_MAP_
                define _BUILDING_ASSETS_MAP_

REG_BUILD_ASSETS_ID macro Label?, Size?, SizeSec?, FlagAr?, Message?
                ; -----------------------------------------
                ;      7    6    5    4    3    2    1    0
                ;   +----+----+----+----+----+----+----+----+
                ;   | S6 | S5 | S4 | S3 | S2 | S1 | S0 | AR |
                ;   +----+----+----+----+----+----+----+----+
                ;
                ;   S6-S0   [7..1]      - размер блока          (в секторах)
                ;   AR      [0]         - флаг, архивности ресурса на диске
                ; -----------------------------------------
                DB (SizeSec? << 1) | (FlagAr? & 0x01)

                ; -----------------------------------------
                ;   +----+----+----+----+----+----+----+----+   +----+----+----+----+----+----+----+----+
                ;   | 15 | 14 | 13 | 12 | 11 | 10 |  9 |  8 |   |  7 |  6 |  5 |  4 |  3 |  2 |  1 |  0 |
                ;   +----+----+----+----+----+----+----+----+   +----+----+----+----+----+----+----+----+
                ;   | S13| S12| S11| S10| S9 | S8 | S7 | S6 |   | S5 | S4 | S3 | S2 | S1 | S0 |  0 |  0 |
                ;   +----+----+----+----+----+----+----+----+   +----+----+----+----+----+----+----+----+
                ;
                ;   S13-S0  [15..2] - реальный размер блока (в байтах)
                ; -----------------------------------------
                DW (Size? & 0x3FFF) << 2
                display /D, Label?, Message?, "[ original size: ", /D, Size?, " byte(s),\tdisk space: ", /D, SizeSec?, " sector(s) ]"
                endm

REG_BUILD_ASSETS_ID_DEBUG macro Label?, Size?, SizeSec?, FlagAr?, Message?
                ifdef _DEBUG
                REG_BUILD_ASSETS_ID Label?, Size?, SizeSec?, FlagAr?, Message?
                endif
                endm

                ORG 0x0000

                REG_BUILD_ASSETS_ID ASSETS_ID_KERNEL, \
                                    Kernel.Size, \
                                    Kernel.Size.Sector.ar, \
                                    ASSETS_ARCHIVE, \
                                    "  - Kernel\t\t\t\t\t\t"
                REG_BUILD_ASSETS_ID ASSETS_ID_CORE, \
                                    Core.Size, \
                                    Core.Size.Sector.ar, \
                                    ASSETS_ARCHIVE, \
                                    "  - Core\t\t\t\t\t\t"
                REG_BUILD_ASSETS_ID ASSETS_ID_PAGE_0, \
                                    Page0.Size, \
                                    Page0.Size.Sector.ar, \
                                    ASSETS_ARCHIVE, \
                                    "  - Page 0\t\t\t\t\t\t"
                REG_BUILD_ASSETS_ID ASSETS_ID_PAGE_1, \
                                    Page1.Size, \
                                    Page1.Size.Sector.ar, \
                                    ASSETS_ARCHIVE, \
                                    "  - Page 1\t\t\t\t\t\t"
                REG_BUILD_ASSETS_ID ASSETS_ID_PAGE_3, \
                                    Page3.Size, \
                                    Page3.Size.Sector.ar, \
                                    ASSETS_ARCHIVE, \
                                    "  - Page 3\t\t\t\t\t\t"
                REG_BUILD_ASSETS_ID ASSETS_ID_MAIN_MENU, \
                                    MainMenu.Size, \
                                    MainMenu.Size.Sector.ar, \
                                    ASSETS_ARCHIVE, \
                                    "  - Main menu\t\t\t\t\t"
                REG_BUILD_ASSETS_ID ASSETS_ID_SESSION, \
                                    Session.Size, \
                                    Session.Size.Sector.ar, \
                                    ASSETS_ARCHIVE, \
                                    "  - Session\t\t\t\t\t\t"
                REG_BUILD_ASSETS_ID ASSETS_ID_WORLD, \
                                    World.Size, \
                                    World.Size.Sector.ar, \
                                    ASSETS_ARCHIVE, \
                                    "  - World\t\t\t\t\t\t"
                REG_BUILD_ASSETS_ID ASSETS_ID_DEFAULT_SETTINGS, \
                                    Default.Size, \
                                    Default.Size.Sector.ar, \
                                    ASSETS_ARCHIVE, \
                                    "  - Object default settings\t\t\t\t"
                REG_BUILD_ASSETS_ID ASSETS_ID_TILE_BIOME_GRASS_SAND, \
                                    Biomes.Grass_Sand.Size, \
                                    Biomes.Grass_Sand.Size.Sector.ar, \
                                    ASSETS_ARCHIVE, \
                                    "  - Graphic tile biome 'Grass-Sand'\t\t\t"
                REG_BUILD_ASSETS_ID ASSETS_ID_CURSOR_PACK, \
                                    Graphics.Cursor.Size, \
                                    Graphics.Cursor.Size.Sector.ar, \
                                    ASSETS_ARCHIVE, \
                                    "  - Graphic Cursor\t\t\t\t\t"
                REG_BUILD_ASSETS_ID ASSETS_ID_UI_ARROW_PATH_PACK, \
                                    UI.Graphics.ArrowPath.Size, \
                                    UI.Graphics.ArrowPath.Size.Sector.ar, \
                                    ASSETS_ARCHIVE, \
                                    "  - UI Graphic 'Arrow Path'\t\t\t\t"
                REG_BUILD_ASSETS_ID ASSETS_ID_HERO_PACK, \
                                    Graphics.Hero.Size, \
                                    Graphics.Hero.Size.Sector.ar, \
                                    ASSETS_ARCHIVE, \
                                    "  - Graphic Hero\t\t\t\t\t"
                REG_BUILD_ASSETS_ID ASSETS_ID_HEX_GRASSLANDS, \
                                    Hexagon.NaturalLandscapes.Grasslands.Size, \
                                    Hexagon.NaturalLandscapes.Grasslands.Size.Sector.ar, \
                                    ASSETS_ARCHIVE, \
                                    "  - Hexagon NaturalLandscapes: 'Grasslands'\t\t"
                REG_BUILD_ASSETS_ID ASSETS_ID_MAP_DEBUG, \
                                    Map.Debug.Size, \
                                    Map.Debug.Size.Sector.ar, \
                                    ASSETS_ARCHIVE, \
                                    "  - Map 'Debug'\t\t\t\t\t"
Num             EQU $ / 3                                                       ; количество ресурсов в карте
Size            EQU (((Num % TRDOS.SECTOR_SIZE > 0) & 0x01) + (Num >> 8)) << 8  ; размер карты ресурсов (кратный 256)
Sector          EQU ((Size % TRDOS.SECTOR_SIZE > 0) & 0x01) + (Size >> 8)       ; размер карты ресурсов (в секторах)

                if PASS = 2
                savetrd TRD_FILENAME, "Resource.#", 0, Num * 3
                endif

                if Num * FAssets > Size.AssetsTable
                error "превышен доступный размер таблицы"
                endif
                

                endif ; ~_BUILDING_ASSETS_MAP_
