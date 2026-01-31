
                ifndef _WORLD_RENDER_DRAW_CURSOR_
                define _WORLD_RENDER_DRAW_CURSOR_
; -----------------------------------------
; отображение курсора
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Cursor.Draw:    ; вывод курсора
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
                LD DE, (Kernel.Sprite.DrawClipping.PositionX)
                PUSH DE
                LD DE, (Kernel.Sprite.DrawClipping.PositionY)
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
                LD (Kernel.Sprite.DrawClipping.PositionX), HL

                LD A, (Mouse.PositionY)
                LD L, A
                LD H, #00
                ADD HL, HL ; x2
                ADD HL, HL ; x4
                ADD HL, HL ; x8
                ADD HL, HL ; x16
                LD (Kernel.Sprite.DrawClipping.PositionY), HL

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
                LD A, (Kernel.Sprite.DrawClipping.Flags)
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

                CALL Draw.SpriteClipping.HL                                     ; отображение спрайта из временного буфера
                                                                                ; HL - указывает на структуру FSprite

                ; всосстановление флагов функции отсечения
                POP AF
                LD (Kernel.Sprite.DrawClipping.Flags), A

                ; восстановление отсечение спрайтов
                POP HL
                LD (GameState.TopEdge), HL
                POP HL
                LD (GameState.LeftEdge), HL

                ; восстановление позиции ранее рисуемого спрайта функции отсечения
                POP DE
                LD (Kernel.Sprite.DrawClipping.PositionY), DE
                POP DE
                LD (Kernel.Sprite.DrawClipping.PositionX), DE
                
.Screen         EQU $+1
                LD A, #00
                LD (GameState.Screen), A
                RET
Cursor.CurrentState FCursorState

                endif ; ~_WORLD_RENDER_DRAW_CURSOR_
