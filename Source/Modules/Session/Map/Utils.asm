
                ifndef _MODULE_SESSION_MAP_UTILS_
                define _MODULE_SESSION_MAP_UTILS_
Begin.Utils     EQU $
; -----------------------------------------
; установка страницы загруженной карты
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
SetPageLoadedMap
.LoadedMapPage  EQU $+1                                                         ; номер страницы загруженной карты
                LD A, #00
                JP_SET_PAGE_A

                display " - Map utilities:\t\t\t\t\t", /A, Begin.Utils, "\t= busy [ ", /D, $-Begin.Utils, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_MAP_UTILS_
