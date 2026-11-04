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
BOLT_STEP_Y     EQU 24                                                          ; расстояние между вершинами по вертикали в пикселях
BOLT_JIT_MASK   EQU 31                                                          ; маска случайного бокового излома
BOLT_JIT_BIAS   EQU 15                                                          ; смещение случайного излома, диапазон от -15 до 16 пикселей
BOLT_MARGIN     EQU 16                                                          ; боковой запас внутри игрового окна в пикселях
BOLT_ARM_MIN    EQU 8                                                           ; минимальное число пикселей боковой ветви
BOLT_ARM_MASK   EQU 7                                                           ; маска случайной прибавки к длине боковой ветви
BOLT_MIN_X      EQU (SCR_WORLD_POS_X << 3) + BOLT_MARGIN                         ; минимальная координата вершины разряда
BOLT_MAX_X      EQU ((SCR_WORLD_POS_X + SCR_WORLD_SIZE_X) << 3) - 1 - BOLT_MARGIN ; максимальная координата вершины разряда

                ; проверка границ разряда и допустимого наклона отрезков
                assert BOLT_POINTS >= 2 && BOLT_POINTS <= 255
                assert BOLT_STEP_Y >= 1 && BOLT_STEP_Y <= 127
                assert (BOLT_POINTS - 1) * BOLT_STEP_Y < (SCR_WORLD_SIZE_Y << 3)
                assert BOLT_JIT_BIAS <= BOLT_STEP_Y && BOLT_JIT_MASK - BOLT_JIT_BIAS <= BOLT_STEP_Y
                assert BOLT_MIN_X >= BOLT_JIT_BIAS && BOLT_MAX_X + BOLT_JIT_MASK - BOLT_JIT_BIAS <= 255
                assert BOLT_MIN_X < BOLT_MAX_X
                ; проверка трёх шагов раскрытия и места для двух верхних ветвей
                assert BOLT_TOP_SEGS >= 3 && BOLT_TOP_SEGS < BOLT_MID_SEGS
                assert BOLT_MID_SEGS < BOLT_POINTS - 1
                ; проверка запаса под боковые ветви по краям окна
                assert BOLT_ARM_MIN >= 1
                assert BOLT_ARM_MIN + BOLT_ARM_MASK <= BOLT_MARGIN
                assert BOLT_ARM_MIN + BOLT_ARM_MASK <= BOLT_STEP_Y

                ; проверка ненулевых длительностей и однобайтовых случайных интервалов
                assert STORM_OFF_MIN >= 1 && STORM_OFF_MIN + STORM_OFF_MASK <= 65535
                assert STORM_GAP_MIN >= 1 && STORM_GAP_MIN + STORM_GAP_MASK <= 255
                assert STORM_NUM_MIN >= 1 && STORM_NUM_MIN + STORM_NUM_MASK <= 255
                assert STORM_PEAK_TICK >= 1 && STORM_FADE_TICK >= 1 && STORM_WAIT_TICK >= 1
                assert STORM_LEAD_TICK >= 1 && STORM_LEAD_TICK <= 65535

                endif                                                           ; ~_CONST_LIGHTNING_
