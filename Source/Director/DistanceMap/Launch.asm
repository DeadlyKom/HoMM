                
                ifndef _AI_DIRECTOR_DISTANCE_MAP_LAUNCH_
                define _AI_DIRECTOR_DISTANCE_MAP_LAUNCH_
; -----------------------------------------
; формирование карты расстояний
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IY
; Note:
;   код расположен в общей памяти
; -----------------------------------------
Launch:         CALL Initialize                                                 ; инициализация карты расстояний
                JP Build                                                        ; формирование карты расстояний до дорог и поселений

                endif ; ~_AI_DIRECTOR_DISTANCE_MAP_LAUNCH_
