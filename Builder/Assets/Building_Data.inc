
                ifndef _BUILDING_ASSETS_DATA_
                define _BUILDING_ASSETS_DATA_

                if PASS = 2

                ; ASSETS_ID_KERNEL
                ADD_ASSETS 2, Page.Kernel, Adr.Kernel, "Builder/Assets/Code/Compressed/Kernel.pack.ar", Kernel.Size.Sector.ar
                ; ASSETS_ID_CORE
                ADD_ASSETS 1, Page.Core, Adr.Core, "Builder/Assets/Code/Compressed/Core.pack.ar", Core.Size.Sector.ar
                ; ASSETS_ID_PAGE_0
                ADD_ASSETS 3, Page.Page0, Adr.Code.Page0, "Builder/Assets/Code/Compressed/Page0.pack.ar", Page0.Size.Sector.ar
                ; ASSETS_ID_PAGE_1
                ADD_ASSETS 3, Page.Page1, Adr.Code.Page1, "Builder/Assets/Code/Compressed/Page1.pack.ar", Page1.Size.Sector.ar
                ; ASSETS_ID_PAGE_3
                ADD_ASSETS 3, Page.Page3, Adr.Code.Page3, "Builder/Assets/Code/Compressed/Page3.pack.ar", Page3.Size.Sector.ar
                ; ASSETS_ID_PAGE_4
                ADD_ASSETS 3, Page.Page4, Adr.Code.Page4, "Builder/Assets/Code/Compressed/Page4.pack.ar", Page4.Size.Sector.ar
                ; ASSETS_ID_PROGRESS
                ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Code/Compressed/Progress.pack.ar", Progress.Size.Sector.ar
                ; ASSETS_ID_PROGRESS_STAGES
                ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Graphics/Compressed/Progress/Stages.pack.ar", Graphics.UI.Progress.Stages.Size.Sector.ar
                ; ASSETS_ID_MAIN_MENU
                ADD_ASSETS 1, PAGE_N, 0x0000, "Builder/Assets/Code/Compressed/MainMenu.pack.ar", MainMenu.Size.Sector.ar
                ; ASSETS_ID_MAIN_MENU_GRAPH_PACK_0
                ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Graphics/Compressed/MainMenu/First/0_7.pack.ar", Graphics.UI.MainMenu.Portal.Pack.Frame0_7.Size.Sector.ar
                ; ASSETS_ID_MAIN_MENU_GRAPH_PACK_1
                ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Graphics/Compressed/MainMenu/First/8_11.pack.ar", Graphics.UI.MainMenu.Portal.Pack.Frame8_11.Size.Sector.ar
                ; ASSETS_ID_MAIN_MENU_GRAPH_PACK_2
                ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Graphics/Compressed/MainMenu/First/12_16.pack.ar", Graphics.UI.MainMenu.Portal.Pack.Frame12_16.Size.Sector.ar
                ; ASSETS_ID_FONT_RU_8
                ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Graphics/Compressed/Font/Ru.pack.ar", Graphics.Font.Pack.Ru.Size.Sector.ar
                ; ASSETS_ID_FONT_RU_8_PARTICLE
                ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Metadata/Compressed/Font/Glyphs ru.pack.ar", Metadata.Font.Pack.Size.Sector.ar
                ; ASSETS_ID_SESSION
                ADD_ASSETS 1, PAGE_N, 0x0000, "Builder/Assets/Code/Compressed/Session.pack.ar", Session.Size.Sector.ar
                ; ASSETS_ID_WORLD
                ADD_ASSETS 1, PAGE_N, 0x0000, "Builder/Assets/Code/Compressed/world.pack.ar", World.Size.Sector.ar
                ; ASSETS_ID_DEFAULT_SETTINGS
                ADD_ASSETS 3, Page.ObjectDefaultSettings, Adr.ObjectDefaultSettings, "Builder/Assets/Metadata/Compressed/Default/DefaultSettings.meta.ar", Metadata.Default.Size.Sector.ar
                ; ASSETS_ID_CURSOR_PACK
                ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Graphics/Compressed/Cursor.pack.ar", Graphics.Cursor.Size.Sector.ar
                ; ASSETS_ID_HERO_PACK
                ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Graphics/Compressed/Hero.pack.ar", Graphics.Hero.Size.Sector.ar
                ; ASSETS_ID_UI_GAMEPLAY_COMMON_PACK
                ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Graphics/Compressed/UI/Common.pack.ar", Graphics.UI.Gameplay.Common.Size.Sector.ar
                ; ASSETS_ID_HEX_FOG
                ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Graphics/Compressed/Hex/Fog.pack.ar", Graphics.Hexagon.Fog.Size.Sector.ar
                ; ASSETS_ID_HEX_GRASSLANDS
                ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Graphics/Compressed/Hex/Grasslands.pack.ar", Graphics.Hexagon.NaturalLandscapes.Grasslands.Size.Sector.ar
                ; ASSETS_ID_MAP_DEBUG
                ADD_ASSETS 3, PAGE_N, 0x0000, "Builder/Assets/Metadata/Compressed/Map/Debug.map.ar", Metadata.Map.Debug.Size.Sector.ar
                ; ASSETS_ID_MUSIC_01
                ADD_ASSETS 3, PAGE_4, 0x0000, "Builder/Assets/Sound/Compressed/Music_01.pack.ar", Sound.Music_01.Size.Sector.ar

                endif

                endif ; ~_BUILDING_ASSETS_DATA_
