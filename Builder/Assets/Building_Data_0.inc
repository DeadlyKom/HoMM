
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

                if PASS = 2

                ; ASSETS_ID_KERNEL
                CREATE_ASSETS 2, Page.Kernel, Adr.Kernel, incbin "Builder/Assets/Code/Compressed/Kernel.pack.ar"
                ; ASSETS_ID_CORE
                ADD_ASSETS 1, Page.Core, Adr.Core, incbin "Builder/Assets/Code/Compressed/Core.pack.ar"
                ; ASSETS_ID_PAGE_0
                ADD_ASSETS 3, Page.Page0, Adr.Code.Page0, incbin "Builder/Assets/Code/Compressed/Page0.pack.ar"
                ; ASSETS_ID_PAGE_1
                ADD_ASSETS 3, Page.Page1, Adr.Code.Page1, incbin "Builder/Assets/Code/Compressed/Page1.pack.ar"
                ; ASSETS_ID_PAGE_3
                ADD_ASSETS 3, Page.Page3, Adr.Code.Page3, incbin "Builder/Assets/Code/Compressed/Page3.pack.ar"
                ; ASSETS_ID_MAIN_MENU
                ADD_ASSETS 1, PAGE_N, 0x0000, incbin "Builder/Assets/Code/Compressed/MainMenu.pack.ar"
                ; ASSETS_ID_SESSION
                ADD_ASSETS 1, PAGE_N, 0x0000, incbin "Builder/Assets/Code/Compressed/Session.pack.ar"
                ; ASSETS_ID_WORLD
                ADD_ASSETS 1, PAGE_N, 0x0000, incbin "Builder/Assets/Code/Compressed/world.pack.ar"
                ; ; ASSETS_ID_DEFAULT_SETTINGS
                ; ADD_ASSETS 3, Page.TileSprites, Adr.TileSprites, incbin "Builder/Assets/Metadata/Compressed/Default/DefaultSettings.meta.ar"
                ; ASSETS_ID_CURSOR_PACK
                ADD_ASSETS 3, PAGE_N, 0x0000, incbin "Builder/Assets/Graphics/Compressed/Cursor.pack.ar"
                ; ASSETS_ID_UI_ARROW_PATH_PACK
                ADD_ASSETS 3, PAGE_N, 0x0000, incbin "Builder/Assets/Graphics/Compressed/UI_ArrowPath.pack.ar"
                ; ASSETS_ID_HERO_PACK
                ADD_ASSETS 3, PAGE_N, 0x0000, incbin "Builder/Assets/Graphics/Compressed/Hero.pack.ar"
                ; ASSETS_ID_HEX_GRASSLANDS
                ADD_ASSETS 3, PAGE_N, 0x0000, incbin "Builder/Assets/Graphics/Compressed/Hex/Grasslands.pack.ar"
                ; ASSETS_ID_MAP_DEBUG
                ADD_ASSETS 3, PAGE_N, 0x0000, incbin "Builder/Assets/Metadata/Compressed/Map/Debug.map.ar"

                endif

                endif ; ~_BUILDING_ASSETS_DATA_0_
