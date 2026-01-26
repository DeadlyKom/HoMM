
                ifndef _MODULE_SESSION_MAP_LOAD_BASE_GRAPHICS_PACKAGES_
                define _MODULE_SESSION_MAP_LOAD_BASE_GRAPHICS_PACKAGES_
; -----------------------------------------
; загрузка базовых графических пакетов
; In:
; Out:
;   A - количество загруженных спрайтов
; Corrupt:
; Note:
;   - включена страница загруженной карты!
; -----------------------------------------
BaseGraphics:   PUSH HL
                PUSH BC
                ; загрузка обязательных - системныз графических пакетов
                LD HL, List.BaseGraphicsPackageIDs
                LD D, HIGH Session.SharedCode.BaseGraphicsBuffer
                LD BC, List.BaseGraphicsPackageIDs.Size
                CALL Session.SharedCode.Load.GraphicsPackages
                POP BC
                POP HL
                LD A, #08                                                       ; всегда резервируем 8 спрайтов
                RET
List.BaseGraphicsPackageIDs:
                ; список ID ассетов графических пакетов
                MAKE_TO_GRAPHICS_PACKAGE BASE_HEX_GRAPHICS_PACKAGE, ASSETS_ID_HEX_FOG 
List.BaseGraphicsPackageIDs.Size EQU $-List.BaseGraphicsPackageIDs

                display " - Load base graphics packages:\t\t\t", /A, BaseGraphics, "\t= busy [ ", /D, $-BaseGraphics, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_MAP_LOAD_BASE_GRAPHICS_PACKAGES_