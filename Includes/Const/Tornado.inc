                ifndef _CONST_TORNADO_
                define _CONST_TORNADO_
TORNADO_CORE_COUNT EQU 8                                                       ; число головок 2 на 2 у единственного смерча
TORNADO_TAIL_COUNT EQU 1                                                        ; число прежних позиций 1 на 1 за каждой головкой
TORNADO_SMALL_COUNT EQU 32                                                      ; число самостоятельных мелких частиц силуэта
TORNADO_SPIN_PERCENT EQU 150                                                    ; скорость вращения относительно базовой
TORNADO_MOVE_PERCENT EQU 45                                                     ; скорость перемещения центра относительно базовой
TORNADO_LIFE_SECONDS EQU 30                                                     ; время жизни одного запуска, без автоматического повтора
TORNADO_IRQ_HZ  EQU 50                                                          ; частота счётчика прерываний для пересчёта секунд
TORNADO_PERIOD  EQU 2                                                           ; минимальный интервал шага частиц в прерываниях
TORNADO_RISE_STEP EQU 2                                                         ; прирост фазы подъёма головки за шаг, полный цикл равен 256
TORNADO_FORM_TICKS EQU 96                                                       ; нарастание плотности за время появления
TORNADO_HEIGHT  EQU 48                                                          ; полная высота подъёма в пикселях
TORNADO_X       EQU RAIN_MIN_X + RAIN_RANGE_X / 2                               ; середина горизонтального пути центра
TORNADO_Y       EQU RAIN_MIN_Y + RAIN_RANGE_Y * 3 / 4                           ; средняя высота основания
TORNADO_GROUP   EQU TORNADO_TAIL_COUNT + 1                                      ; головка и её история
TORNADO_CORE_PARTICLES EQU TORNADO_CORE_COUNT * TORNADO_GROUP                   ; записи головок и шлейфов
TORNADO_PARTICLES EQU TORNADO_CORE_PARTICLES + TORNADO_SMALL_COUNT              ; общее число записей
TORNADO_LIFE_TICKS EQU TORNADO_LIFE_SECONDS * TORNADO_IRQ_HZ                    ; полный срок по IRQ
TORNADO_RELEASE_TICKS EQU TORNADO_LIFE_TICKS * 65 / 100                         ; начало рассеивания
TORNADO_SPIN_STEP EQU (6 * TORNADO_SPIN_PERCENT + 50) / 100                     ; угловой шаг, оборот равен 256
TORNADO_MOVE_X   EQU (300 * TORNADO_PERIOD * TORNADO_MOVE_PERCENT + 45) / 90    ; первая гармоника
TORNADO_MOVE_X2  EQU (588 * TORNADO_PERIOD * TORNADO_MOVE_PERCENT + 45) / 90    ; вторая гармоника
TORNADO_MOVE_Y   EQU (346 * TORNADO_PERIOD * TORNADO_MOVE_PERCENT + 45) / 90    ; вертикальная гармоника
                ; проверка числа записей для восьмибитных циклов
                assert TORNADO_CORE_COUNT >= 1 && TORNADO_TAIL_COUNT >= 1
                assert TORNADO_SMALL_COUNT >= 1 && TORNADO_PARTICLES <= 255
                ; проверка длительности и доступного диапазона скоростей
                assert TORNADO_LIFE_TICKS > 0 && TORNADO_LIFE_TICKS <= 2047
                assert TORNADO_PERIOD >= 1 && TORNADO_PERIOD <= 255
                assert TORNADO_SPIN_STEP >= 1 && TORNADO_SPIN_STEP <= 31
                assert TORNADO_MOVE_PERCENT >= 0 && TORNADO_MOVE_PERCENT <= 120
                assert TORNADO_HEIGHT == 48 && TORNADO_RISE_STEP >= 1 && TORNADO_RISE_STEP <= 4
                assert TORNADO_FORM_TICKS >= 1 && TORNADO_FORM_TICKS < TORNADO_RELEASE_TICKS
                endif                                                           ; ~_CONST_TORNADO_
