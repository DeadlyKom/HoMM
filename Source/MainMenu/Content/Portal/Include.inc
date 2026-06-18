
                ifndef _MAIN_MENU_CONTENT_PORTAL_INCLUDE_
                define _MAIN_MENU_CONTENT_PORTAL_INCLUDE_

                module Portal
                include "Load.asm"
                include "Release.asm"

                ; массив идентификаторов загружаемых ассетов
ArrayAssets     DB ASSETS_ID_MAIN_MENU_GRAPH_PACK_0
                DB ASSETS_ID_MAIN_MENU_GRAPH_PACK_1
                DB ASSETS_ID_MAIN_MENU_GRAPH_PACK_2
.Num            EQU $-ArrayAssets
Adr.FrameArray  EQU Adr.TilemapBuffer                                           ; позволит разместить 64 фрейма
FrameArray.Num  DB #00                                                          ; количество элементов в массиве Adr.FrameArray
                endmodule

                endif ; ~_MAIN_MENU_CONTENT_PORTAL_INCLUDE_
