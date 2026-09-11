                ifndef _MODULE_WORLD_GRAPHICS_FIRMAMENT_
                define _MODULE_WORLD_GRAPHICS_FIRMAMENT_

                struct FFirmamentObject                                         ; описание объекта небосвода                            [6 байт]
Function        DW #0000                                                        ; адрес функции вывода                                  [2 байта]
PhaseOffset     DW #0000                                                        ; смещение фазы объекта 0..511                          [2 байта]
PhaseScale      DB #00                                                          ; масштаб фазы fixed point 4.4                          [1 байт]
Argument        DB #00                                                          ; аргумент функции вывода                               [1 байт]
                ends     

Const:          ; константные значения
.Sun.Width      EQU 48                                                          ; размер спрайта "солнце" по горизнтали
.Sun.Height     EQU 48                                                          ; размер спрайта "солнце" по вертикали
.Sun.Ox         EQU 24                                                          ; смещение спрайта "солнце" по горизнтали
.Sun.Oy         EQU 24                                                          ; смещение спрайта "солнце" по горизнтали
.Moon.Width     EQU 32                                                          ; размер спрайта "луна" по горизонтали
.Moon.Height    EQU 32                                                          ; размер спрайта "луна" по вертикали
.Moon.Ox        EQU 16                                                          ; смещение спрайта "луна" по горизонтали
.Moon.Oy        EQU 16                                                          ; смещение спрайта "луна" по вертикали

                TO_FP_EQU Firmament.SunPhaseScale, 1.5, 4
                TO_FP_EQU Firmament.MoonPhaseScale, 1.5, 4
Firmament:      ; данные и спрайты небосвода
; -----------------------------------------
; отображение объектов небосвода по фазе суток
; In:
;   HL - текущая фаза суток 0..511
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY, SP
; Note:
; -----------------------------------------
.Display        ; сохранение текущей фазы суток
                LD D, H
                LD E, L

                ; подготовка обхода таблицы объектов
                LD B, .Objects.Num
                LD IY, .Objects

.ObjectLoop     PUSH BC
                PUSH DE

                ; чтение адреса функции вывода объекта
                LD A, (IY + FFirmamentObject.Function)
                LD IXL, A
                LD A, (IY + FFirmamentObject.Function + 1)
                LD IXH, A

                ; расчёт фактической фазы объекта
                LD HL, (IY + FFirmamentObject.PhaseOffset)
                ADD HL, DE
                RES 1, H                                                        ; приведение фазы к диапазону 0..511

                ; чтение масштаба фазы объекта
                LD B, (IY + FFirmamentObject.PhaseScale)

                ; расчёт масштабированной фазы объекта
                CALL .ScalePhase
                JR NC, .NextObject                                              ; переход, если объект находится вне масштабированного цикла

                ; чтение аргумента функции вывода
                LD A, (IY + FFirmamentObject.Argument)

                ; вызов функции с сохранением состояния обхода
                PUSH IY
                CALL_IX
                POP IY

.NextObject     ; переход к следующему объекту небосвода
                LD BC, FFirmamentObject
                ADD IY, BC

                POP DE
                POP BC
                DJNZ .ObjectLoop
                RET
; -----------------------------------------
; масштабирование фазы движения относительно зенита
; In:
;   HL - фаза движения объекта 0..511
;   B  - масштаб фазы fixed point 4.4
; Out:
;   HL - масштабированная фаза движения 0..511
;   флаг переполнения установлен, если фаза находится в диапазоне 0..511
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   PhaseScale хранится в формате fixed point 4.4, 16 = 1.0
;   MotionPhase = 256 + round(abs(ObjectPhase - 256) * PhaseScale / 16) * Sign
; -----------------------------------------
.ScalePhase     ; масштабирование фазы движения объекта
                ; расчёт знакового смещения фазы относительно зенита
                DEC H                                                           ; Delta = ObjectPhase - 256
                LD C, #00                                                       ; положительное смещение фазы

                ; проверка знака смещения фазы
                BIT 7, H
                JR Z, .ScaleMagnitude                                           ; переход, если смещение фазы положительное
                DEC C                                                           ; отрицательное смещение фазы

                ; преобразование отрицательного смещения в абсолютное значение
                XOR A
                SUB L
                LD L, A
                SBC A, A
                SUB H
                LD H, A

.ScaleMagnitude ; расчёт масштаба абсолютного смещения фазы
                LD D, H
                LD E, L
                LD A, B
                CALL Kernel.Math.Mul16x8_16                                     ; Product = abs(Delta) * PhaseScale

                ; округление и преобразование произведения fixed point 4.4
                LD DE, #0008
                ADD HL, DE                                                      ; Product + 0.5
                SRL H
                RR L
                SRL H
                RR L
                SRL H
                RR L
                SRL H
                RR L                                                            ; ScaledDelta = round(Product / 16)

                ; проверка исходного знака смещения фазы
                INC C
                JR NZ, .AddZenith                                               ; переход, если смещение фазы положительное

                ; восстановление отрицательного знака смещения фазы
                XOR A
                SUB L
                LD L, A
                SBC A, A
                SUB H
                LD H, A

.AddZenith      ; восстановление положения относительно зенита
                INC H                                                           ; MotionPhase = 256 + ScaledDelta

                ; проверка диапазона масштабированной фазы
                LD A, H
                CP #02
                RET
; -----------------------------------------
; отображение солнца по фазе суток
; In:
;   HL - фаза движения солнца 0..511
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY, SP
; Note:
; -----------------------------------------
.DisplaySun     ; отображение солнца через трафарет

                ; сохранение фазы движения солнца
                LD D, H
                LD E, L

                ; расчёт отрицательного горизонтального смещения вдоль дуги
                ; OffsetX = (Phase >> 4) - (Phase >> 2)
                SRL H
                RR L
                SRL L
                LD H, L                                                         ; Phase >> 2
                SRL L
                SRL L                                                           ; Phase >> 4
                LD A, L
                SUB H                                                           ; OffsetX = -96..0

                ; изменение направления движения справа налево
                ADD A, (World.Stencil.Const.StencilWidth << 3) + \
                        Const.Sun.Width                                         ; OffsetX = 96..0
                ; преобразование положения pivot в левую координату спрайта
                SUB (World.Stencil.Const.StencilWidth << 3)
                ADD A, (World.Stencil.Const.StencilPosX << 3) + \
                        (World.Stencil.Const.StencilWidth << 2)
                SUB Const.Sun.Ox

                ; проверка положения солнца относительно левой границы трафарета
                CP (World.Stencil.Const.StencilPosX << 3) - Const.Sun.Width + 1
                RET C                                                           ; выход, если солнце полностью находится слева от трафарета

                ; проверка положения солнца относительно правой границы трафарета
                CP World.Stencil.Const.StencilRight
                RET NC                                                          ; выход, если солнце полностью находится справа от трафарета

                ; сохранение горизонтальной позиции и восстановление фазы
                EX AF, AF'
                LD H, D
                LD L, E
                CALL .GetArcHeight                                              ; получение вертикального смещения

                ; расчёт положения pivot по вертикали
                ADD A, (World.Stencil.Const.StencilPosY << 3) + \
                        (World.Stencil.Const.StencilHeight << 2)
                SUB Const.Sun.Oy
                LD D, A

                ; восстановление горизонтальной позиции
                EX AF, AF'
                LD E, A

                ; отображение солнца
                LD HL, .Sun
                LD BC, (Const.Sun.Height << 8) + Const.Sun.Width                ; B = высота, C = ширина
                LD IX, Stencil
                JP World.Stencil.DrawOR_XOR
; -----------------------------------------
; отображение луны по фазе суток
; In:
;   HL - фаза движения луны 0..511
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY, SP
; Note:
; -----------------------------------------
.DisplayMoon    ; отображение луны через трафарет

                ; сохранение фазы движения луны
                LD D, H
                LD E, L

                ; расчёт горизонтального пути луны 0..80 пикселей
                ; TravelX = round(Phase * 80 / 512) = (Phase * 5 + 16) >> 5
                ADD HL, HL                                                      ; Phase * 2
                ADD HL, HL                                                      ; Phase * 4
                ADD HL, DE                                                      ; Phase * 5
                LD BC, #0010
                ADD HL, BC                                                      ; Phase * 5 + 16
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL                                                      ; H = TravelX 0..80

                ; расчёт левой координаты луны относительно правой границы трафарета
                LD A, World.Stencil.Const.StencilRight
                SUB H                                                           ; X = StencilRight - TravelX

                ; проверка положения луны относительно левой границы трафарета
                CP (World.Stencil.Const.StencilPosX << 3) - Const.Moon.Width + 1
                RET C                                                           ; выход, если луна полностью находится слева от трафарета

                ; проверка положения луны относительно правой границы трафарета
                CP World.Stencil.Const.StencilRight
                RET NC                                                          ; выход, если луна полностью находится справа от трафарета

                ; сохранение горизонтальной позиции и восстановление фазы
                EX AF, AF'
                LD H, D
                LD L, E
                CALL .GetArcHeight                                              ; получение вертикального смещения

                ; расчёт положения pivot по вертикали
                ADD A, (World.Stencil.Const.StencilPosY << 3) + \
                        (World.Stencil.Const.StencilHeight << 2)
                SUB Const.Moon.Oy
                LD D, A

                ; восстановление горизонтальной позиции
                EX AF, AF'
                LD E, A

                ; отображение луны
                LD HL, .Moon
                LD BC, (Const.Moon.Height << 8) + Const.Moon.Width              ; B = высота, C = ширина
                LD IX, Stencil
                JP World.Stencil.DrawOR_XOR
; -----------------------------------------
; получение вертикального смещения по фазе суток
; In:
;   HL - фаза суток 0..511
; Out:
;   A  - вертикальное смещение 0..63
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   NormalizedPosition = Phase / 2
; -----------------------------------------
.GetArcHeight   ; получение высоты траектории небосвода
                ; расчёт нормализованной позиции 0..255
                SRL H
                RR L
                LD A, L

                ; подготовка получения значения кривой
                LD HL, .ArcHeight
                LD B, .ArcHeight.Num
                JP Kernel.Math.Curve.GetValue
.ArcHeight      ; кривая вертикального смещения для фазы суток 0..511
                ; Position = Phase >> 1, диапазон 0..255
                ; Value содержит вертикальное смещение 0..63
                FCurveKey {   0, 63 }
                FCurveKey {  10, 39 }
                FCurveKey {  37, 18 }
                FCurveKey {  79,  5 }
                FCurveKey { 128,  0 }
                FCurveKey { 176,  5 }
                FCurveKey { 218, 18 }
                FCurveKey { 245, 39 }
                FCurveKey { 255, 63 }
.ArcHeight.Num  EQU ($-.ArcHeight) / FCurveKey
                ; -----------------------------------------
.Objects        ; таблица объектов небосвода  
                FFirmamentObject { .DisplaySun,  #0000, .SunPhaseScale,  #00 }  ; солнце
                FFirmamentObject { .DisplayMoon, #0100, .MoonPhaseScale, #00 }  ; луна
.Objects.Num    EQU ($-.Objects) / FFirmamentObject
                ; -----------------------------------------
                ; спрайты небосвода в прямом формате OR & XOR
                ; 48x48
.Sun            incbin "Builder/Assets/Graphics/Original/UI/Gameplay/Screen/World_Icons/sun.bin"
                ; 32x32
.Moon           incbin "Builder/Assets/Graphics/Original/UI/Gameplay/Screen/World_Icons/moon.bin"
                ; 12x11
.Star_0         incbin "Builder/Assets/Graphics/Original/UI/Gameplay/Screen/World_Icons/star_0.bin"
                ; 11x11
.Star_1         incbin "Builder/Assets/Graphics/Original/UI/Gameplay/Screen/World_Icons/star_1.bin"
                ; 7x7
.Star_2         incbin "Builder/Assets/Graphics/Original/UI/Gameplay/Screen/World_Icons/star_2.bin"
                ; 8x8
.Star_3         incbin "Builder/Assets/Graphics/Original/UI/Gameplay/Screen/World_Icons/star_3.bin"

                endif                                                           ; ~_MODULE_WORLD_GRAPHICS_FIRMAMENT_
