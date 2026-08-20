
                ifndef _GRAPHICS_UI_GAMEPLAY_PACK_COMMON_
                define _GRAPHICS_UI_GAMEPLAY_PACK_COMMON_

                DB Graph.Num                                                    ; количество заголовков графики
Graph:          EQU $
                GRAPH_HEADER "Pointer",     Overlay.Pointer.SpriteInfo,             4   ; OBJECT_UI_COMMON_POINTER
                GRAPH_HEADER "FrameHero",   Overlay.FaceOfHeroes.Frame.SpriteInfo,  1   ; OBJECT_UI_COMMON_FRAME_HERO
                GRAPH_HEADER "SmallHero",   Overlay.FaceOfHeroes.Small.SpriteInfo,  8   ; OBJECT_UI_COMMON_SMALL_HERO
                GRAPH_HEADER "Standard",    Overlay.Standard.SpriteInfo,            4   ; OBJECT_UI_COMMON_STANDARD
Graph.Num:      EQU ($-Graph) / FGraphicHeader

                include "Overlay/Include.inc"

                endif ; ~ _GRAPHICS_UI_GAMEPLAY_PACK_COMMON_
