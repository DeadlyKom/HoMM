
                ifndef _STRUCTS_DIGITAL_DIFFERENTIAL_ANALYZER_
                define _STRUCTS_DIGITAL_DIFFERENTIAL_ANALYZER_

                struct FDDA                                                     ; структура пошагового построения линии/движения        [9 байт]
RemainingSteps  FValue                                                          ; оставшееся число DDA-шагов до конца сегмента          [2 байта]
PrimaryLength   FValue                                                          ; проекция сегмента на главную ось DDA                  [2 байта]
SecondaryLength FValue                                                          ; проекция сегмента на вторичную ось DDA                [2 байта]
LineError       FValue                                                          ; накопленная ошибка DDA                                [2 байта]
; -----------------------------------------
;   Flags
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | .. | .. | .. | YN | XN | PY |
;   +----+----+----+----+----+----+----+----+
;
;   PY      [0] - флаг, главная ось DDA
;                 0 - X
;                 1 - Y
;   XN      [1] - флаг, направление шага по горизонтали
;                 0 - вправо
;                 1 - влево
;   YN      [2] - флаг, направление шага по вертикали
;                 0 - вниз
;                 1 - вверх
; -----------------------------------------
Flags           DB #00                                                          ; главная ось и направления DDA                         [1 байт]
                ends

                endif ; ~_STRUCTS_DIGITAL_DIFFERENTIAL_ANALYZER_
