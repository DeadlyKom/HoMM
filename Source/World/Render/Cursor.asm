
                ifndef _WORLD_RENDER_DRAW_CURSOR_
                define _WORLD_RENDER_DRAW_CURSOR_

ANIMATION_FORWARD EQU 1
ANIMATION_BACK    EQU -1

; состояние крусора
CURSOR_STATE_IDLE   EQU #00                                                     ; бездействие
CURSOR_STATE_CLICK  EQU #01                                                     ; нажатие

                struct FCursorState
State           DB #00
Direction       DB #00
SpriteIndex     DB #00
SpriteID        DB #00
Counter         DB #00
IndexMax        DB #00
                ends

; -----------------------------------------
; отображение "мира"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Cursor.Draw:    LD IX, CurrentState

                ; проверка состояния курсора
                LD A, (IX + FCursorState.State)
                OR A        ; CURSOR_STATE_NONE
                JR NZ, .StateTick

                ; состояние курсора отсутствует

                ; проверка нажатия клавиши "выбор"
                LD A, (GameState.Input.Value)
                BIT SELECT_KEY_BIT, A
                LD A, CURSOR_STATE_CLICK
                JR NZ, .SetState_A                                              ; переход, была нажата клавиша "выбор"

                ; проверка бездействия курсора
                LD A, (Mouse.PositionFlag)                                      ; если курсор не поменяет позицию, хранит #FF
                OR A
                JR Z, .SetState_Idle                                            ; переход, если курсор переместился

.StateTick      ; уменьшение счётчика
                DEC (IX + FCursorState.Counter)
                JR NZ, .Draw                                                    ; переход, если счётчик бездействия курсора не обнулён

                ; счётчик времени достик нуля,
                ; необходимо перейти к следующему кадру
                LD A, (IX + FCursorState.SpriteIndex)
                ADD A, (IX + FCursorState.Direction)
                JP M, .SetState_Idle                                            ; переход, если достигли последнего кадра анимации flip-flop

                ; проверка достижения максимального кадра
                CP (IX + FCursorState.IndexMax)
                JR NZ, .SetAnimIndex                                            ; переход, если не достигли максимальный кадр анимации

                ; достигли максимальный кадр анимации,
                ; необходимо сменить направление анимации
                LD (IX + FCursorState.Direction), ANIMATION_BACK
                JR .SetSubcounter

.Initialize     LD IX, CurrentState
                LD A, CURSOR_STATE_IDLE

.SetState       ; копирование дефолтных настроек устанавливаемого состояния
                LD (IX + FCursorState.State), A
                LD (IX + FCursorState.Direction), ANIMATION_FORWARD

                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, LOW StateTable
                LD L, A
                ADC A, HIGH StateTable
                SUB L
                LD H, A

                LD DE, CurrentState + FCursorState.SpriteIndex
                LDI
                LDI
                LDI
                LDI

                RET

.SetState_Idle  LD A, CURSOR_STATE_IDLE
.SetState_A     CALL .SetState
                JR .Draw

.SetAnimIndex   ; сохранение индекса анимации
                LD (IX + FCursorState.SpriteIndex), A

.SetSubcounter  ; установка промежуточного счётчика
                LD (IX + FCursorState.Counter), DURATION.DELAY_CURSOR

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

                ; сохранение позиции ранее рисуемого спрайта функции отсечения
                LD DE, (Kernel.Sprite.DrawClipped.PositionX)
                PUSH DE
                LD DE, (Kernel.Sprite.DrawClipped.PositionY)
                PUSH DE

                ; установка положения спрайта курсора
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

                ; сохранение флагов функции отсечения
                LD A, (Kernel.Sprite.DrawClipped.Flags)
                PUSH AF

                ; расчёт адреса структуры FSprite в буфере спрайтов
                LD A, (IX + FCursorState.SpriteID)
                ADD A, A    ; x2
                LD L, A
                EX AF, AF'
                LD H, HIGH Adr.SpriteInfoBuffer >> 2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8

                INC L                                                           ; пропуск FSpritesRef.Num

                ; чтение страницы расположения данных о структурах
                LD A, (HL)                                                      ; FSpritesRef.Data.Page
                INC L
                SET_PAGE_A                                                      ; установка страницы спрайта

                ; чтение адреса расположения массива структур
                LD E, (HL)
                INC L
                LD D, (HL)
            
                ; корректировка адреса расположения необходимой структуры FSprite
                EX AF, AF'
                LD A, (IX + FCursorState.SpriteIndex)
                LD L, A
                LD H, #00
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                ADD HL, DE

                ; копирование структуры
                SPRITE_DE SPRITE_CUR_IDX
                rept FSprite
                LDI
                endr
                SPRITE_HL SPRITE_CUR_IDX

                CALL Draw.Sprite.HL                                             ; отображение спрайта из временного буфера
                                                                                ; HL - указывает на структуру FSprite

                ; всосстановление флагов функции отсечения
                POP AF
                LD (Kernel.Sprite.DrawClipped.Flags), A

                ; восстановление отсечение спрайтов
                POP HL
                LD (GameState.TopEdge), HL
                POP HL
                LD (GameState.LeftEdge), HL

                ; восстановление позиции ранее рисуемого спрайта функции отсечения
                POP DE
                LD (Kernel.Sprite.DrawClipped.PositionY), DE
                POP DE
                LD (Kernel.Sprite.DrawClipped.PositionX), DE
                
.Screen         EQU $+1
                LD A, #00
                LD (GameState.Screen), A
                RET
                display $
CurrentState    EQU $
                FCursorState
StateTable:
Idle            ; CURSOR_STATE_IDLE
                DB #00
.SpriteID       DB #00
                DB DURATION.IDLE_CURSOR
                DB #03
Click           ; CURSOR_STATE_CLICK
                DB #00
.SpriteID       DB #00
                DB DURATION.CLICK_CURSOR
                DB #02

                endif ; ~_WORLD_RENDER_DRAW_CURSOR_
