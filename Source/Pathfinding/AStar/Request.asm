
                ifndef _PATHFINDING_REQUEST_
                define _PATHFINDING_REQUEST_
; -----------------------------------------
; запрос поиска пути
; In:
;   HL - координаты назначения в тайлах (H - y, L - x)
;   DE - координаты начальные в тайлах (D - y, E - x)
; Out:
;   флаг переполнения установлен, вслучае успешного поиска
; Corrupt:
; Note:
; -----------------------------------------
Request:        
                SCF                                                             ; операция прошла успешно
                RET

                endif ; ~ _PATHFINDING_REQUEST_