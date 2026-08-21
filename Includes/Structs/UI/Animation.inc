
                ifndef _STRUCTS_UI_ANIMATION_
                define _STRUCTS_UI_ANIMATION_

                struct FUIAnimation                                             ; состояние анимации UI объекта                             [2 байта]
; -----------------------------------------
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | F3 | F2 | F1 | F0 | R3 | R2 | R1 | R0 |
;   +----+----+----+----+----+----+----+----+
;
;   F3-F0   [7..4]  - индекс первого кадра диапазона
;   R3-R0   [3..0]  - количество кадров в диапазоне
; -----------------------------------------
Range           DB #00                                                          ; диапазон кадров анимации                                  [1 байт]
Offset          DB #00                                                          ; смещение относительно FTick.Objects                       [1 байт]
                                                                                ; Offset = -FTick.Objects при установке диапазона
                                                                                ; FrameNum = (Range & UI_ANIMATION_RANGE_FRAME_MAX_MASK) + 1
                                                                                ; Frame = First + ((FTick.Objects + Offset) % FrameNum)
                                                                                ; синхронизирует первый кадр при включении и смене диапазона
                ends

                endif ; ~_STRUCTS_UI_ANIMATION_
