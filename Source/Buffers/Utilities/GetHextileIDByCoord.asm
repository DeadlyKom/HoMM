
                ifndef _BUFFERS_GET_HEXTILE_ID_BY_COORDINATES_
                define _BUFFERS_GET_HEXTILE_ID_BY_COORDINATES_
; -----------------------------------------
; определение индекса Render-буфера по координатам гексагона (обёртка)
; In:
;   DE' - координаты гексагона под курсором (D - y, E - x)
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
;   DE - координаты гексагона под курсором (D - y, E - x)
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
; -----------------------------------------
; получение стоимости перемещения по координатам гексагона (обёртка)
; In:
;   DE' - координаты гексагона под объектом (D - y, E - x)
; Out:
;   A'  - базовая стоимость DDA-шага для поверхности
; Corrupt:
;   HL, AF
; Note:
;   код расположен рядом с картой и таблицей проходимости (страница 1)
;   HextileID используется только как временный индекс таблицы Adr.SurfPassability
; -----------------------------------------
GetSurfaceStepCostByCoord.Wrap:
                EXX
                CALL GetSurfaceStepCostByCoord
                EX AF, AF'
                RET
; -----------------------------------------
; получение стоимости перемещения по координатам гексагона
; In:
;   DE - координаты гексагона под объектом (D - y, E - x)
; Out:
;   A  - базовая стоимость DDA-шага для поверхности
; Corrupt:
;   HL, AF
; Note:
;   HextileID используется только как временный индекс таблицы Adr.SurfPassability
; -----------------------------------------
GetSurfaceStepCostByCoord:
                CALL GetHextileIDByCoord
                LD L, A
                LD H, HIGH Adr.SurfPassability
                LD A, (HL)
                AND SURFACE_STEP_COST_MASK
                RET

                display " - Get hextile ID by coodinates:\t\t\t", /A, GetHextileIDByCoord.Wrap, "\t= busy [ ", /D, $-GetHextileIDByCoord.Wrap, " byte(s)  ]"

                endif ; ~_BUFFERS_GET_HEXTILE_ID_BY_COORDINATES_
