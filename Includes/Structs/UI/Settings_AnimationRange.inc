
                ifndef _STRUCTS_UI_SETTINGS_ANIMATION_RANGE_
                define _STRUCTS_UI_SETTINGS_ANIMATION_RANGE_

                struct FUISettings_AnimationRange                               ; настройки диапазона анимации UI объекта                   [1 байт]
; -----------------------------------------
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | F3 | F2 | F1 | F0 | R3 | R2 | R1 | R0 |
;   +----+----+----+----+----+----+----+----+
;
;   F3-F0   [7..4]  - индекс первого кадра диапазона
;   R3-R0   [3..0]  - количество кадров в диапазоне
;
;   диапазон должен находиться внутри FSpritesRef:
;     FrameNum = (Range & UI_ANIMATION_RANGE_FRAME_MAX_MASK) + 1
;     First + FrameNum <= FSpritesRef.Num
; -----------------------------------------
Range           DB #00                                                          ; диапазон кадров анимации                                  [1 байт]
                ends

                endif ; ~_STRUCTS_UI_SETTINGS_ANIMATION_RANGE_
