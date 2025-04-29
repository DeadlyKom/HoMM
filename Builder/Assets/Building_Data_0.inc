
                ifndef _BUILDING_ASSETS_DATA_0_
                define _BUILDING_ASSETS_DATA_0_
CREATE_ASSETS   macro Bank?, Page?, ORG?, Include?
                MMU Bank?, Page?
                ORG ORG?
                Include?
                savetrd TRD_FILENAME, "Data-0.#", ORG?, $-ORG?
                endm
ADD_ASSETS      macro Bank?, Page?, ORG?, Include?
                MMU Bank?, Page?
                ORG ORG?
                Include?
                savetrd TRD_FILENAME, &"Data-0.#", ORG?, $-ORG?
                endm
ADD_ASSETS_DEBUG macro Bank?, Page?, ORG?, Include?
                ifdef _DEBUG
                ADD_ASSETS Bank?, Page?, ORG?, Include?
                endif
                endm

                ; ASSETS_ID_KERNEL
                CREATE_ASSETS 2, Page.Kernel, Adr.Kernel, incbin "Builder/Assets/Code/Compressed/Kernel.pack.ar"
                ; ASSETS_ID_CORE
                ADD_ASSETS 1, Page.Core, Adr.Core, incbin "Builder/Assets/Code/Compressed/Core.pack.ar"
                ; ASSETS_ID_PAGE_0
                ADD_ASSETS 3, Page.Page0, Adr.Code.Page0, incbin "Builder/Assets/Code/Compressed/Page0.pack.ar"
                ; ASSETS_ID_MAP
                ADD_ASSETS 1, Page.Map, Adr.Map, incbin "Builder/Assets/Code/Compressed/Map.pack.ar"
                ; ASSETS_ID_WORLD
                ADD_ASSETS 1, Page.World, Adr.World, incbin "Builder/Assets/Code/Compressed/world.pack.ar"
                ; ASSETS_ID_DEFAULT_SETTINGS
                ADD_ASSETS 3, Page.TileSprites, Adr.TileSprites, incbin "Builder/Assets/Metadata/Compressed/Default/DefaultSettings.meta.ar"
                ; ASSETS_ID_TILE_BIOME_GRASS_SAND
                ADD_ASSETS 3, Page.TileSprites, Adr.TileSprites, incbin "Builder/Assets/Graphics/Compressed/Biomes/Grass_Sand.pack.ar"
                ; ASSETS_ID_CURSOR_PACK
                ADD_ASSETS 3, PAGE_N, 0x0000, incbin "Builder/Assets/Graphics/Compressed/Cursor.pack.ar"
                ; ASSETS_ID_HERO_PACK
                ADD_ASSETS 3, PAGE_N, 0x0000, incbin "Builder/Assets/Graphics/Compressed/Hero.pack.ar"
                ; ASSETS_ID_GRAPH_PACK_01
                ADD_ASSETS 3, PAGE_N, 0x0000, incbin "Builder/Assets/Graphics/Compressed/GraphPack/01.pack.ar"
                ; ASSETS_ID_MAP_DEBUG
                ADD_ASSETS 3, PAGE_N, 0x0000, incbin "Builder/Assets/Metadata/Compressed/Map/Debug.map.ar"

                endif ; ~_BUILDING_ASSETS_DATA_0_
