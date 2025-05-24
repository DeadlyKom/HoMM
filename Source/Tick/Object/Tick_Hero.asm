
                ifndef _TICK_OBJECT_HERO_
                define _TICK_OBJECT_HERO_
; -----------------------------------------
; обработчик тика объекта "герой"
; In:
;   IX - адрес структуры объекта (FObjectHero)
; Out:
; Corrupt:
; Note:
; ----------------------------------------
Hero:           ; проверка смены анимации героя
                LD A, (GameSession.PeriodTick + FTick.Hero)
                CP DURATION.HERO_TICK
                RET NZ                                                          ; выход, если счётчик не обнулён

                ; проверка перемещения героя
                LD C, (IX + FObjectHero.Super.Sprite)
                BIT ANIM_STATE_BIT, C
                JR NZ, Move.Prepare                                             ; переход, если герой движется

                ; проверка наличия пути
                LD A, (IX + FObjectHero.PathID)
                CP PATH_ID_NONE
                ; RET Z                                                           ; выход, если нет пути
                CALL Z, SetPath

                ; расчёт адреса позиции движения
                LD A, (IX + FObjectHero.PathID)
                ADD A, A    ; x2
                ADD A, LOW Path
                LD L, A
                ADC A, HIGH Path
                SUB L
                LD H, A

                ; --------------------------------------------------------------
                ; определение направления
                LD A, (IX + FObjectHero.Super.Position.X.High)
                SUB (HL)
                ; преобразование:
                ; если равен 0, то #00
                ; если больше 0 то #01
                ; если меньше 0 то #FF
                JR Z, $+6
                SBC A, A
                CCF
                ADC A, #00
                ; xxxxxxxx
                LD C, A

                INC HL

                LD A, (IX + FObjectHero.Super.Position.Y.High)
                SUB (HL)
                ; преобразование:
                ; если равен 0, то #00
                ; если больше 0 то #01
                ; если меньше 0 то #FF
                JR Z, $+6
                SBC A, A
                CCF
                ADC A, #00
                ; yyyyyyyy

                ADD A, A    ; yyyyyyy0
                ADD A, A    ; yyyyyy00
                XOR C
                AND %11111100
                XOR C       ; yyyyyyxx
                AND %00001111

                ; расчёт адреса хранения направления
                ADD A, LOW Direction
                LD L, A
                ADC A, HIGH Direction
                SUB L
                LD H, A
                LD B, (HL)                                                      ; направление
                ; --------------------------------------------------------------
                ; проверка необходимости поворота в направление движения
                LD C, (IX + FObjectHero.Super.Sprite)

                ; направление спрайта
                LD A, C
                RRA
                RRA
                RRA
                AND DIR_MASK

                ; сравнение напрвлений
                SUB B
                JR Z, Move                                                      ; перехд, если направление совподает, поворот не требуется
                
                ; требуется поворот в направлдение движения
                CCF                                                             ; меняем знак

                LD B, #00   ; NOP
                JR C, .Clockwise                                                ; переход, если поворот против часовой стрелке

                ; вращение по часовой стрелке
                LD B, #3F   ; CCF
                NEG

.Clockwise      ; проверка на кратчайший путь поворота
                SUB #04
                JR NZ, .NotEqual                                                ; переход, если путь поворота не одинаковый

                ; путь поворота по часовой и против равнозначный
                SCF                                                             ; выбираем поворот против часовой стрелке
.NotEqual       LD A, B
                LD (.Direction), A
.Direction      NOP                     ; NOP/CCF

.Rotation       ; шаг поворота (-1 или 1), в зависимости от флага переполнения
                SBC A, A
                CCF
                ADC A, #00
Turn            ; --------------------------------------------------------------
                ; расчёт направления вращения
                ; положительная по часовой стрелка, иначе против часовой стрелке

                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8

                ADD A, C
                XOR C
                AND %00111000
                XOR C
                AND %00111111
                OR ANIM_STATE_TURN

                LD (IX + FObjectHero.Super.Sprite), A

SetCell         ; установить доступное расстояние между тайлами 16х16 пикселей 
                LD HL, 16 << 4
                LD (IX + FObjectHero.Delta.X), HL
                LD (IX + FObjectHero.Delta.Y), HL

                RET
Move.Prepare    ; --------------------------------------------------------------
                ; направление спрайта
                LD A, C
                RRA
                RRA
                RRA
                AND DIR_MASK
                LD B,  A
Move            ; перемещение

                ; расчёт адреса хранения направления
                LD A, B
                ADD A, A    ; x2
                ADD A, LOW Velocity
                LD E, A
                ADC A, HIGH Velocity
                SUB E
                LD D, A
                
                ; --------------------------------------------------------------
                ; горизонтальное смещение

                ; приведение шага к 16-битному числу
                LD A, (DE)
                LD C, A
                ADD A, A    ; x2
                SBC A, A
                LD B, A

                ; проверка доступности шага
                LD HL, (IX + FObjectHero.Delta.X)
                LD A, C
                OR A
                JR Z, .ResetDeltaX                                              ; переход, если шаг равен 0
                JP P, .IsPositiveX                                              ; переход, если шаг положительный

                ADC HL, BC
                JP P, .SetDeltaX                                                ; переход, если шаг возможен

                ; перемещение на ширину шага невозможно,
                ; расчёт нового шага, с учётом размещения в центре тайла

                ; NEG BC
                LD BC, (IX + FObjectHero.Delta.X)
                XOR A
                SUB C
                LD C, A
                SBC A, A
                SUB B
                LD B, A
                JR .ResetDeltaX

.IsPositiveX    SBC HL, BC
                JP P, .SetDeltaX                                                ; переход, если шаг возможен

                LD BC, (IX + FObjectHero.Delta.X)

.ResetDeltaX    LD HL, #0000
.SetDeltaX      LD (IX + FObjectHero.Delta.X), HL
                LD HL, (IX + FObjectHero.Super.Position.X)
                ADD HL, BC
                LD (IX + FObjectHero.Super.Position.X), HL
                ; --------------------------------------------------------------

                INC DE

                ; --------------------------------------------------------------
                ; вертикальное смещение
                ; приведение шага к 16-битному числу
                LD A, (DE)
                LD C, A
                ADD A, A    ; x2
                SBC A, A
                LD B, A

                ; проверка доступности шага
                LD HL, (IX + FObjectHero.Delta.Y)
                LD A, C
                OR A
                JR Z, .ResetDeltaY                                              ; переход, если шаг равен 0
                JP P, .IsPositiveY                                              ; переход, если шаг положительный

                ADC HL, BC
                JP P, .SetDeltaY                                                ; переход, если шаг возможен

                ; перемещение на ширину шага невозможно,
                ; расчёт нового шага, с учётом размещения в центре тайла

                ; NEG BC
                LD BC, (IX + FObjectHero.Delta.Y)
                XOR A
                SUB C
                LD C, A
                SBC A, A
                SUB B
                LD B, A
                JR .ResetDeltaY

.IsPositiveY    SBC HL, BC
                JP P, .SetDeltaY                                                ; переход, если шаг возможен

                LD BC, (IX + FObjectHero.Delta.Y)

.ResetDeltaY    LD HL, #0000
.SetDeltaY      LD (IX + FObjectHero.Delta.Y), HL
                LD HL, (IX + FObjectHero.Super.Position.Y)
                ADD HL, BC
                LD (IX + FObjectHero.Super.Position.Y), HL
                ; --------------------------------------------------------------
                ; установить состояние перемещения героя,
                ; изменить кадр спрайта
                LD C, (IX + FObjectHero.Super.Sprite)
                LD A, C
                INC A
                XOR C
                AND %00000111
                XOR C
                AND %00111111
                OR ANIM_STATE_MOVE
                LD (IX + FObjectHero.Super.Sprite), A

                ; --------------------------------------------------------------
                ; проверка что герой дошёл до центра тайла
                LD A, (IX + FObjectHero.Delta.X.Low)
                OR (IX + FObjectHero.Delta.X.High)
                OR (IX + FObjectHero.Delta.Y.Low)
                OR (IX + FObjectHero.Delta.Y.High)

                RET NZ

                DEC (IX + FObjectHero.PathID)
                RES ANIM_STATE_BIT, (IX + FObjectHero.Super.Sprite)

                JP SetCell
SetPath         ; установка длины пути
                LD (IX + FObjectHero.PathID), Path.Num-1
                RET
Path            ; начало 8, 8
                FPath {  8,  8 }                                                ; 0
                FPath {  7,  9 }                                                ; 11
                FPath {  8, 10 }                                                ; 10
                FPath {  9, 10 }                                                ; 9
                FPath { 10,  9 }                                                ; 8
                FPath { 11,  9 }                                                ; 7
                FPath { 12,  8 }                                                ; 6
                FPath { 12,  7 }                                                ; 5
                FPath { 11,  6 }                                                ; 4
                FPath { 10,  6 }                                                ; 3
                FPath {  9,  6 }                                                ; 2
                FPath {  8,  7 }                                                ; 1
.Num            EQU ($-Path) / FPath
Direction       ; направление                                                   ; ---- yy xx
                DB DIR_UP                                                       ; 0000 00 00    (не действительная)
                DB DIR_LEFT                                                     ; 0000 00 01
                DB DIR_UP                                                       ; 0000 00 10    (не действительная)
                DB DIR_RIGHT                                                    ; 0000 00 11
                DB DIR_UP                                                       ; 0000 01 00
                DB DIR_UP_LEFT                                                  ; 0000 01 01
                DB DIR_UP                                                       ; 0000 01 10    (не действительная)
                DB DIR_UP_RIGHT                                                 ; 0000 01 11
                DB DIR_UP                                                       ; 0000 10 00    (не действительная)
                DB DIR_UP                                                       ; 0000 10 01    (не действительная)
                DB DIR_UP                                                       ; 0000 10 10    (не действительная)
                DB DIR_UP                                                       ; 0000 10 11    (не действительная)
                DB DIR_DOWN                                                     ; 0000 11 00
                DB DIR_DOWN_LEFT                                                ; 0000 11 01
                DB DIR_UP                                                       ; 0000 11 10    (не действительная)
                DB DIR_DOWN_RIGHT                                               ; 0000 11 11
Velocity        ; скорость перемещения
                lua allpass
                local speed = 1.0 / 10.0
                local dir = {   {  0, -1 },
                                {  1, -1 },
                                {  1,  0 },
                                {  1,  1 },
                                {  0,  1 },
                                { -1,  1 },
                                { -1,  0 },
                                { -1, -1 },
                            }
                for i = 1, #dir do
                    local x = dir[i][1]
                    local y = dir[i][2]

                    local angle = math.atan(y,x)
                    local cos = math.floor(math.cos(angle) * speed * 256) & 0xFF
                    local sin = math.floor(math.sin(angle) * speed * 256) & 0xFF

                    _pc("DB " .. cos)
                    _pc("DB " .. sin)

                    --print (x, y, math.deg(angle), string.format("#%02X", cos), cos, string.format("#%02X", sin), sin)
                end
                endlua

                endif ; ~_TICK_OBJECT_HERO_
