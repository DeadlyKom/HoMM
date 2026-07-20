
                ifndef _BUILDING_ASSETS_DATA_0_
                define _BUILDING_ASSETS_DATA_0_
CREATE_ASSETS   macro Bank?, Page?, ORG?, Include?
                MMU Bank?, Page?
                ORG ORG?
                incbin Include?
                savetrd TRD_FILENAME, "Data-0.#", ORG?, $-ORG?
                endm
ADD_ASSETS      macro Bank?, Page?, ORG?, Include?
                MMU Bank?, Page?
                ORG ORG?
                incbin Include?
                savetrd TRD_FILENAME, &"Data-0.#", ORG?, $-ORG?
                endm
ADD_ASSETS_DEBUG macro Bank?, Page?, ORG?, Include?
                ifdef _DEBUG
                ADD_ASSETS Bank?, Page?, ORG?, Include?
                endif
                endm

                if PASS = 2

                ; ASSETS_ID_KERNEL
                CREATE_ASSETS 2, Page.Kernel, Adr.Kernel, "Builder/Assets/Code/Compressed/Kernel.pack.ar"
                ; ASSETS_ID_CORE
                ADD_ASSETS 1, Page.Core, Adr.Core, "Builder/Assets/Code/Compressed/Core.pack.ar"
                ; ASSETS_ID_PAGE_0
                ADD_ASSETS 3, Page.Page0, Adr.Code.Page0, "Builder/Assets/Code/Compressed/Page0.pack.ar"
                ; ASSETS_ID_PAGE_1
                ADD_ASSETS 3, Page.Page1, Adr.Code.Page1, "Builder/Assets/Code/Compressed/Page1.pack.ar"
                ; ASSETS_ID_PAGE_3
                ADD_ASSETS 3, Page.Page3, Adr.Code.Page3, "Builder/Assets/Code/Compressed/Page3.pack.ar"
                ; ASSETS_ID_PAGE_4
                ADD_ASSETS 3, Page.Page4, Adr.Code.Page4, "Builder/Assets/Code/Compressed/Page4.pack.ar"
                ; ASSETS_ID_PROGRESS
                ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Code/Compressed/Progress.pack.ar"
                ; ASSETS_ID_MAIN_MENU
                ADD_ASSETS 1, PAGE_N, 0x0000, "Builder/Assets/Code/Compressed/MainMenu.pack.ar"
                ; ASSETS_ID_MAIN_MENU_GRAPH_PACK_0
                ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Graphics/Compressed/MainMenu/First/0_7.pack.ar"
                ; ASSETS_ID_MAIN_MENU_GRAPH_PACK_1
                ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Graphics/Compressed/MainMenu/First/8_11.pack.ar"
                ; ASSETS_ID_MAIN_MENU_GRAPH_PACK_2
                ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Graphics/Compressed/MainMenu/First/12_16.pack.ar"
                ; ASSETS_ID_FONT_RU_8_PARTICLE
                ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Metadata/Compressed/Font/Glyphs ru.pack.ar"
                ; ASSETS_ID_SESSION
                ADD_ASSETS 1, PAGE_N, 0x0000, "Builder/Assets/Code/Compressed/Session.pack.ar"
                ; ASSETS_ID_WORLD
                ADD_ASSETS 1, PAGE_N, 0x0000, "Builder/Assets/Code/Compressed/world.pack.ar"
                ; ASSETS_ID_DEFAULT_SETTINGS
                ADD_ASSETS 3, Page.ObjectDefaultSettings, Adr.ObjectDefaultSettings, "Builder/Assets/Metadata/Compressed/Default/DefaultSettings.meta.ar"
                ; ASSETS_ID_CURSOR_PACK
                ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Graphics/Compressed/Cursor.pack.ar"
                ; ; ASSETS_ID_UI_ARROW_PATH_PACK
                ; ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Graphics/Compressed/UI_ArrowPath.pack.ar"
                ; ASSETS_ID_HERO_PACK
                ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Graphics/Compressed/Hero.pack.ar"
                ; ASSETS_ID_HEX_FOG
                ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Graphics/Compressed/Hex/Fog.pack.ar"
                ; ASSETS_ID_HEX_GRASSLANDS
                ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Graphics/Compressed/Hex/Grasslands.pack.ar"
                ; ASSETS_ID_MAP_DEBUG
                ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Metadata/Compressed/Map/Debug.map.ar"
                ; ASSETS_ID_MUSIC_01
                ADD_ASSETS 3, PAGE_4, 0x0000, "Builder/Assets/Sound/Compressed/Music_01.pack.ar"

                endif

                endif ; ~_BUILDING_ASSETS_DATA_0_
