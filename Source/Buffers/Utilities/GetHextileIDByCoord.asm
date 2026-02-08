
                ifndef _BUFFERS_GET_HEXTILE_ID_BY_COORDINATES_
                define _BUFFERS_GET_HEXTILE_ID_BY_COORDINATES_
; -----------------------------------------
; определение индекса Render-буфера по координатам гексагона (обёртка)
; In:
;   DE' - координаты гексагона под крсором (D - y, E - x)
; Out:
;   A'  - ID гексагона в координатах
; Corrupt:
;   HL, AF
; Note:
;   код расположен рядом с картой (страница 1)
; -----------------------------------------
GetHextileIDByCoord.Wrap:
                EXX
                CALL GetHextileIDByCoord
                EX AF, AF'
                RET
; -----------------------------------------
; получение ID гексагона по координатам
; In:
;   DE - координаты гексагона под крсором (D - y, E - x)
; Out:
;   A  - ID гексагона в координатах
; Corrupt:
;   HL, AF
; Note:
;   код расположен рядом с картой (страница 1)
; -----------------------------------------
GetHextileIDByCoord:
                CALL GetMapArrayAdr                                             ; определение адреса карты по координатам
                LD A, (HL)
                RET

                display " - Get hextile ID by coodinates:\t\t\t", /A, GetHextileIDByCoord, "\t= busy [ ", /D, $-GetHextileIDByCoord, " byte(s)  ]"

                endif ; ~_BUFFERS_GET_HEXTILE_ID_BY_COORDINATES_
