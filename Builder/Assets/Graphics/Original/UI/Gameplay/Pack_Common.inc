
                ifndef _GRAPHICS_UI_GAMEPLAY_PACK_COMMON_
                define _GRAPHICS_UI_GAMEPLAY_PACK_COMMON_

                DB Graph.Num                                                    ; количество заголовков графики
Graph:          EQU $
                GRAPH_HEADER "Pointer",     Overlay.Pointer.SpriteInfo,     4
Graph.Num:      EQU ($-Graph) / FGraphicHeader

                include "Overlay/Include.inc"

                endif ; ~ _GRAPHICS_UI_GAMEPLAY_PACK_COMMON_
