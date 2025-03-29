
                ifndef _WORLD_RENDER_DRAW_CURSOR_
                define _WORLD_RENDER_DRAW_CURSOR_
; -----------------------------------------
; отображение "мира"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Cursor.Draw:    ; проверка бездействия курсора
                LD HL, .TickCounter
                LD A, (Mouse.PositionFlag)                                      ; если курсор не поменяет позицию, хранит #FF
                OR A
                JR NZ, .Counter                                                 ; переход, если курсор не перемещается

                ; сброс анимации и выставление время ожидания бездействия
                LD (HL), DURATION.IDLE_CURSOR
                INC HL
                LD (HL), A                                                      ; SpriteIdx (сброс анимации)
                JR .Draw

.Counter        ; отсчёт счётчика бездействия курсора
                DEC (HL)
                JR NZ, .Draw                                                    ; переход, если счётчик бездействия курсора не обнулён

                ; счётчик обнулился, необходимо сменить анимацию
                INC HL                                                          ; SpriteIdx
                LD A, (HL)

                ; flip-flop анимаций в 4 кадра
                INC HL
                ADD A, (HL)

                ; проверка достижения 3 кадра анимации
                CP 3*8
                JR NZ, .IsFirst                                                 ; переход, если кадр не равен 3 фрейму анимации

                ; установка обратного прохода смены анимации
                LD (HL), -8
                DEC HL
                JR .SetSubcounter

.IsFirst        ; проверка достижения -1 кадра анимации
                CP -8
                JR NZ, .SetAnimIdx                                              ; переход, если кадр не равен 0 фрейму анимации

                ; установка прямого проход смены анимации
                LD (HL), 8
                DEC HL
                JR .SetSubcounter

.SetAnimIdx     ; сохранение индекса анимации
                DEC HL
                LD (HL), A

.SetSubcounter  ; установка промежуточного счётчика
                DEC HL
                LD (HL), #10

.Draw           ; вывод курсора
                LD HL, GameState.Screen
                LD A, (HL)
                LD (.Screen), A

                ; корректировка адреса видимого экрана
                LD A, (Adr.Port_7FFD)
                AND SCREEN
                LD A, #C0
                JR NZ, $+4
                LD A, #40
                LD (HL), A

                LD A, (.SpriteIdx)                                              ; значение * на 8
                ADD A, LOW Cursor.Sprites
                LD L, A
                ADC A, HIGH Cursor.Sprites
                SUB L
                LD H, A

                CALL Draw.Sprite
                
.Screen         EQU $+1
                LD A, #00
                LD (GameState.Screen), A
                RET

.TickCounter    DB 250
.SpriteIdx      DB #00
.Direction      DB #08

                include "Builder/Assets/Graphics/Original/Cursor/Include.inc"

                endif ; ~_WORLD_RENDER_DRAW_CURSOR_
