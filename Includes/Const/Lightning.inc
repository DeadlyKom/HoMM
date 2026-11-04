                ifndef _CONST_LIGHTNING_
                define _CONST_LIGHTNING_

STORM_OFF_MIN   EQU 250                                                         ; минимальная пауза между сериями грозы в прерываниях
STORM_OFF_MASK  EQU 255                                                         ; маска случайной прибавки к паузе между сериями
STORM_GAP_MIN   EQU 40                                                          ; минимальный интервал между вспышками активной грозы в прерываниях
STORM_GAP_MASK  EQU 63                                                          ; маска случайной прибавки к интервалу между вспышками
STORM_NUM_MIN   EQU 2                                                           ; минимальное количество вспышек в активной серии грозы
STORM_NUM_MASK  EQU 3                                                           ; маска случайной прибавки к количеству вспышек серии
STORM_PEAK_TICK EQU 1                                                           ; длительность яркого импульса в прерываниях
STORM_FADE_TICK EQU 1                                                           ; длительность тусклой фазы после импульса в прерываниях
STORM_WAIT_TICK EQU 2                                                           ; пауза перед возможным повторным импульсом в прерываниях
STORM_NORMAL    EQU #FF                                                         ; признак восстановления исходных цветов без наложения вспышки
STORM_PEAK_ATTR EQU BLACK | (WHITE << 3) | BRIGHT                               ; чёрные пиксели на ярком белом фоне
STORM_FADE_ATTR EQU BLACK | (WHITE << 3)                                        ; чёрные пиксели на белом фоне без яркости
STORM_PHASES    EQU 5                                                           ; число фаз одной вспышки с возможным повторным импульсом

                ; проверка ненулевых длительностей и однобайтовых случайных интервалов
                assert STORM_OFF_MIN >= 1 && STORM_OFF_MIN + STORM_OFF_MASK <= 65535
                assert STORM_GAP_MIN >= 1 && STORM_GAP_MIN + STORM_GAP_MASK <= 255
                assert STORM_NUM_MIN >= 1 && STORM_NUM_MIN + STORM_NUM_MASK <= 255
                assert STORM_PEAK_TICK >= 1 && STORM_FADE_TICK >= 1 && STORM_WAIT_TICK >= 1

                endif                                                           ; ~_CONST_LIGHTNING_
