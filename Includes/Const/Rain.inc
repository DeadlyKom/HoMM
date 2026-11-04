                ifndef _CONST_RAIN_
                define _CONST_RAIN_

RAIN_DROP_COUNT EQU 8                                                           ; количество капель экспериментального дождя
RAIN_FALL_PHASE EQU 6                                                           ; первая фаза всплеска
RAIN_END_PHASE  EQU 8                                                           ; конец цикла капли
RAIN_FALL_STEP  EQU 4                                                           ; перемещение капли за игровой кадр в пикселях
RAIN_FALL_PATH  EQU RAIN_FALL_PHASE * RAIN_FALL_STEP                            ; длина пути падения в пикселях
RAIN_MIN_X      EQU SCR_WORLD_POS_X << 3                                        ; левая граница области появления капель
RAIN_RANGE_X    EQU SCR_WORLD_SIZE_X << 3                                       ; ширина области появления капель в пикселях
RAIN_MIN_Y      EQU SCR_WORLD_POS_Y << 3                                        ; верхняя граница области появления капель
RAIN_RANGE_Y    EQU SCR_WORLD_SIZE_Y << 3                                       ; высота области появления капель в пикселях

RAIN_WIND_AUTO EQU 1                                                            ; автоматический выбор целей ветра и скорости, 0 ручные цели
RAIN_WIND_MAX  EQU 8                                                            ; максимальная сила ветра, 0..8, значение 8 соответствует 45 градусам
RAIN_WIND_TICK EQU 4                                                            ; период изменения ветра и скорости в игровых кадрах
RAIN_HOLD_MIN  EQU 16                                                           ; минимальная выдержка достигнутых целей в периодах RAIN_WIND_TICK
RAIN_HOLD_MASK EQU 31                                                           ; маска случайной прибавки к выдержке, 31 даёт 0..31 период
RAIN_SPEED_MIN EQU 208                                                          ; минимальная скорость, доли шага падения с делителем 256
RAIN_SPEED_MAX EQU 240                                                          ; максимальная скорость, доли шага падения с делителем 256
RAIN_SPEED_DEF EQU 224                                                          ; начальная скорость, 224 даёт в среднем 3,5 пикселя за игровой кадр

                ; проверка диапазонов управляемого ветра и дробной скорости
                assert RAIN_WIND_MAX >= 0 && RAIN_WIND_MAX <= 8
                assert RAIN_WIND_TICK >= 1 && RAIN_WIND_TICK <= 255
                assert RAIN_SPEED_MIN >= 1 && RAIN_SPEED_MAX <= 255
                assert RAIN_SPEED_MIN <= RAIN_SPEED_DEF && RAIN_SPEED_DEF <= RAIN_SPEED_MAX
                assert RAIN_HOLD_MIN >= 1 && RAIN_HOLD_MIN + RAIN_HOLD_MASK <= 255

                endif                                                           ; ~_CONST_RAIN_
