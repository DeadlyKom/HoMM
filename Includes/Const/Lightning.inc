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
STORM_LEAD_TOP  EQU 6                                                           ; подготовительная фаза верхней части в исходных цветах
STORM_LEAD_MID  EQU 7                                                           ; подготовительная фаза средней части в исходных цветах
STORM_LEAD_TICK EQU 2                                                           ; длительность каждого подготовительного шага в прерываниях

BOLT_POINTS     EQU 7                                                           ; количество вершин случайного разряда
BOLT_TOP_SEGS   EQU 3                                                           ; число отрезков верхней части до начала вспышки
BOLT_MID_SEGS   EQU 5                                                           ; число отрезков после добавления средней части
BOLT_SEGMENTS   EQU BOLT_POINTS - 1                                             ; число отрезков между случайной точкой удара и верхом окна
BOLT_JIT_MASK   EQU 31                                                          ; маска случайного бокового излома
BOLT_JIT_BIAS   EQU 15                                                          ; смещение случайного излома, диапазон от -15 до 16 пикселей
BOLT_ARM_MIN    EQU 8                                                           ; минимальное число пикселей боковой ветви
BOLT_ARM_MASK   EQU 7                                                           ; маска случайной прибавки к длине боковой ветви
BOLT_MIN_X      EQU SCR_WORLD_POS_X << 3                                        ; левая граница случайной точки удара
BOLT_MAX_X      EQU ((SCR_WORLD_POS_X + SCR_WORLD_SIZE_X) << 3) - 1             ; правая граница случайной точки удара
BOLT_MIN_Y      EQU SCR_WORLD_POS_Y << 3                                        ; верхняя граница случайной точки удара
BOLT_MAX_Y      EQU ((SCR_WORLD_POS_Y + SCR_WORLD_SIZE_Y) << 3) - 1             ; нижняя граница случайной точки удара

                ; проверка границ разряда и допустимого наклона отрезков
                assert BOLT_POINTS >= 2 && BOLT_POINTS <= 255
                assert (BOLT_MAX_Y - BOLT_MIN_Y + BOLT_SEGMENTS - 1) / BOLT_SEGMENTS <= 127
                assert BOLT_JIT_BIAS >= 0 && BOLT_JIT_BIAS <= BOLT_JIT_MASK
                assert BOLT_JIT_MASK - BOLT_JIT_BIAS + BOLT_MAX_X <= 255
                assert BOLT_MIN_X < BOLT_MAX_X
                assert BOLT_MIN_Y < BOLT_MAX_Y
                ; проверка трёх шагов раскрытия и места для двух верхних ветвей
                assert BOLT_TOP_SEGS >= 3 && BOLT_TOP_SEGS < BOLT_MID_SEGS
                assert BOLT_MID_SEGS < BOLT_POINTS - 1
                ; проверка однобайтового диапазона запрашиваемой длины ветвей
                assert BOLT_ARM_MIN >= 1
                assert BOLT_ARM_MIN + BOLT_ARM_MASK <= 255

                ; проверка ненулевых длительностей и однобайтовых случайных интервалов
                assert STORM_OFF_MIN >= 1 && STORM_OFF_MIN + STORM_OFF_MASK <= 65535
                assert STORM_GAP_MIN >= 1 && STORM_GAP_MIN + STORM_GAP_MASK <= 255
                assert STORM_NUM_MIN >= 1 && STORM_NUM_MIN + STORM_NUM_MASK <= 255
                assert STORM_PEAK_TICK >= 1 && STORM_FADE_TICK >= 1 && STORM_WAIT_TICK >= 1
                assert STORM_LEAD_TICK >= 1 && STORM_LEAD_TICK <= 65535

                endif                                                           ; ~_CONST_LIGHTNING_
