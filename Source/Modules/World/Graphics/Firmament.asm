                ifndef _MODULE_WORLD_GRAPHICS_FIRMAMENT_
                define _MODULE_WORLD_GRAPHICS_FIRMAMENT_
Const:          ; константные значения
.Sun.Width      EQU 48                                                          ; размер спрайта "солнце" по горизнтали
.Sun.Height     EQU 48                                                          ; размер спрайта "солнце" по вертикали
.Sun.Ox         EQU 24                                                          ; смещение спрайта "солнце" по горизнтали
.Sun.Oy         EQU 24                                                          ; смещение спрайта "солнце" по горизнтали
Firmament:      ; данные и спрайты небосвода
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
                LD B, .ArcHeightNum
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
.ArcHeightNum   EQU ($-.ArcHeight) / FCurveKey

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
