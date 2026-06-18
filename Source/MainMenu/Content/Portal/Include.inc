
                ifndef _MAIN_MENU_CONTENT_PORTAL_INCLUDE_
                define _MAIN_MENU_CONTENT_PORTAL_INCLUDE_

                module Portal
                include "Load.asm"
                include "Release.asm"

                ; массив идентификаторов загружаемых ассетов
ArrayAssets     DB ASSETS_ID_MAIN_MENU_GRAPH_PACK_0
                DB ASSETS_ID_MAIN_MENU_GRAPH_PACK_1
.Num            EQU $-ArrayAssets

                struct FFrame                                                   ; структура описывающий один кадр
Duration        DB #00
Address         FLinearAddress
                ends
Frame           DS FFrame * ArrayAssets.Num, 0

                endmodule

                endif ; ~_MAIN_MENU_CONTENT_PORTAL_INCLUDE_
