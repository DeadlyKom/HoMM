
                ifndef _GRAPHICS_UI_GAMEPLAY_PACK_COMMON_
                define _GRAPHICS_UI_GAMEPLAY_PACK_COMMON_

                DB Graph.Num                                                    ; количество заголовков графики
Graph:          EQU $
                GRAPH_HEADER "Pointer",     Overlay.Pointer.SpriteInfo,             4
                GRAPH_HEADER "FrameHero",   Overlay.FaceOfHeroes.Frame.SpriteInfo,  1
                GRAPH_HEADER "SmallHero",   Overlay.FaceOfHeroes.Small.SpriteInfo,  8
                GRAPH_HEADER "Standard",    Overlay.Standard.SpriteInfo,            4
Graph.Num:      EQU ($-Graph) / FGraphicHeader

                include "Overlay/Include.inc"

                endif ; ~ _GRAPHICS_UI_GAMEPLAY_PACK_COMMON_
