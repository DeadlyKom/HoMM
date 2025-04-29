
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
                CP 3*1
                JR NZ, .IsFirst                                                 ; переход, если кадр не равен 3 фрейму анимации

                ; установка обратного прохода смены анимации
                LD (HL), -1
                DEC HL
                JR .SetSubcounter

.IsFirst        ; проверка достижения -1 кадра анимации
                CP -1
                JR NZ, .SetAnimIdx                                              ; переход, если кадр не равен 0 фрейму анимации

                ; установка прямого проход смены анимации
                LD (HL), 1
                DEC HL
                DEC HL
                LD (HL), DURATION.IDLE_CURSOR
                JR .Draw

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

                LD DE, (Kernel.Sprite.DrawClipped.PositionX)                    ; !
                PUSH DE
                LD DE, (Kernel.Sprite.DrawClipped.PositionY)                    ; !
                PUSH DE

                EX DE, HL
                LD A, (Mouse.PositionX)
                LD L, A
                LD H, #00
                ADD HL, HL ; x2
                ADD HL, HL ; x4
                ADD HL, HL ; x8
                ADD HL, HL ; x16
                LD (Kernel.Sprite.DrawClipped.PositionX), HL

                LD A, (Mouse.PositionY)
                LD L, A
                LD H, #00
                ADD HL, HL ; x2
                ADD HL, HL ; x4
                ADD HL, HL ; x8
                ADD HL, HL ; x16
                LD (Kernel.Sprite.DrawClipped.PositionY), HL

                ; сохранение отсечение спрайтов
                LD HL, (GameState.LeftEdge)
                PUSH HL
                LD HL, (GameState.TopEdge)
                PUSH HL

                ; установка отсечение курсора
                LD HL, (SCREEN_CURSOR_X >> 3) << 8  | 0                         ; LeftEdge      - левая грань видимой части     (в пикселах)
                                                                                ; VisibleWidth  - ширина видимой части          (в знакоместах)
                LD (GameState.LeftEdge), HL
                LD HL, SCREEN_CURSOR_Y << 8         | 0                         ; TopEdge       - верхняя грань видимой части   (в пикселах)
                                                                                ; VisibleHeight - высота видимой части          (в пикселах)
                LD (GameState.TopEdge), HL
                
                EX DE, HL

                LD A, (Kernel.Sprite.DrawClipped.Flags)                         ; !
                PUSH AF
                ; SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана

                LD A, (Cursor.Indexes)
                ADD A, A    ; x2
                LD L, A
                EX AF, AF'
                LD H, HIGH Adr.SpriteInfoBuffer >> 2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                EX AF, AF'
                LD A, (.SpriteIdx)
                CALL Draw.Sprite
                POP AF
                LD (Kernel.Sprite.DrawClipped.Flags), A

                ; восстановление отсечение спрайтов
                POP HL
                LD (GameState.TopEdge), HL
                POP HL
                LD (GameState.LeftEdge), HL

                POP DE
                LD (Kernel.Sprite.DrawClipped.PositionY), DE
                POP DE
                LD (Kernel.Sprite.DrawClipped.PositionX), DE
                
.Screen         EQU $+1
                LD A, #00
                LD (GameState.Screen), A
                RET

.TickCounter    DB 250
.SpriteIdx      DB #00
.Direction      DB #01

                endif ; ~_WORLD_RENDER_DRAW_CURSOR_
