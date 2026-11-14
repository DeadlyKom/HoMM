                ifndef _MODULE_COMBAT_CONTOUR_TEST_
                define _MODULE_COMBAT_CONTOUR_TEST_

                module ContourTest
POS_X           EQU 13                                                          ; положение спрайта по горизонтали в знакоместах
POS_Y           EQU 80                                                          ; положение спрайта по вертикали в пикселях
SCREEN          EQU SCR_ADR_BASE + ((POS_Y & #C0) << 5) + ((POS_Y & #07) << 8) + ((POS_Y & #38) << 2) + POS_X
; -----------------------------------------
; инициализация теста анимации конька и обводки
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX
; Note:
;   тест отображается на основном экране
; -----------------------------------------
Initialize:     ; загрузка сабмодуля "обводка"
                CALL Combat.SharedCode.ContourTest.Load

                ; сохранение режима обводки и консоли
                LD A, (GameState.View)
                LD (State.View), A
                LD A, (Kernel.Console.DrawChar.Function)
                LD (State.Console), A
                LD A, (Kernel.Console.OneScreen.Attribute)
                LD (State.Attribute), A
                LD HL, (Kernel.Console.DrawChar.ScreenAdr)
                LD (State.Cursor), HL

                ; инициализация кадров и независимых таймеров
                XOR A
                LD (State.Frame), A
                LD (State.Phase), A
                LD A, (TickCounterRef)
                LD (State.SpriteTick), A
                LD (State.ContourTick), A

                ; подготовка основного экрана
                RES_RENDER_FLAGS ((1 << FRAME_READY_BIT) | (1 << SWAP_PENDING_BIT) | (1 << FPS_DISABLE_BIT))
                SET_RENDER_BASE
                SHOW_BASE_SCREEN
                CALL Background                                                 ; подготовка узорного фона
                ATTR_IPB SCR_ADR_BASE, BLACK, WHITE, 0
                CALL Console.SetDrawToOne
                SET_REG_ATTR_IPB A, BLACK, WHITE, 0
                CALL Console.SetAttribute

                ; отображение заголовка и пояснений
                LD DE, #0207
                CALL Console.SetCursor
                LD BC, Text.Title
                CALL Console.DrawString
                LD DE, #001A
                CALL Console.SetCursor
                LD BC, Text.FPS
                CALL Console.DrawString
                LD DE, #1209
                CALL Console.SetCursor
                LD BC, Text.Exit
                CALL Console.DrawString

                ; сброс счётчика завершённых кадров
                ifdef SHOW_FPS | _DEBUG
                XOR A
                LD (Kernel.FPS_Counter.Frame.FramesCounter), A
                LD (Kernel.FPS_Counter.Render.FPS), A
                LD A, #32
                LD (Kernel.FPS_Counter.Tick.TicksCounter), A
                endif

                ; восстановление обработчика после загрузки с диска
                SET_USER_HANDLER Combat.SharedCode.Interrupt
                RET
; -----------------------------------------
; вывод тестового кадра
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX
; Note:
;   FPS учитывает копирование, обводку и вывод одного спрайта 32x32
; -----------------------------------------
Draw:           HALT                                                            ; синхронизация с прерыванием
                CALL Animate
                CALL Copy

                ; подготовка размеров копии 32x32
                LD A, #03
                EX AF, AF'
                EXX
                LD B, #20
                EXX
                LD HL, Adr.SharedBuffer
                CALL Combat.SharedCode.ContourTest.Apply

                ; вывод кадра в штатном формате OR/XOR
                CALL Paint
                CALL Status

                ; учёт завершённого кадра и отображение FPS
                ifdef SHOW_FPS | _DEBUG
                DI
                CALL FPS_Counter.Frame
                EI
                CALL FPS_Counter.Render
                endif
                RET
; -----------------------------------------
; независимая смена кадра спрайта и фазы обводки
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   кадр меняется каждые 6 тиков, фаза каждые 10 тиков
; -----------------------------------------
Animate:        ; проверка срока смены кадра спрайта
                LD A, (TickCounterRef)
                LD B, A
                LD A, (State.SpriteTick)
                LD C, A
                LD A, B
                SUB C
                CP #06
                JR C, .Contour                                                  ; переход, если срок смены кадра ещё не наступил

                ; обновление кадра и времени его смены
                LD A, B
                LD (State.SpriteTick), A
                LD A, (State.Frame)
                INC A
                AND #07
                LD (State.Frame), A

.Contour        ; проверка срока смены фазы обводки
                LD A, (State.ContourTick)
                LD C, A
                LD A, B
                SUB C
                CP #0A
                JR C, .Phase                                                    ; переход, если срок смены фазы ещё не наступил

                ; обновление фазы и времени её смены
                LD A, B
                LD (State.ContourTick), A
                LD A, (State.Phase)
                INC A
                AND #03
                LD (State.Phase), A

.Phase          ; чтение фазы из последовательности 0, 1, 2, 1
                LD A, (State.Phase)
                LD C, A
                LD B, #00
                LD HL, Phases
                ADD HL, BC
                LD C, (HL)

                ; обновление поля фазы и разрешение обводки
                LD A, (GameState.View)
                AND ~(CONTOUR_ENABLED | CONTOUR_PHASE_MASK)
                OR C
                OR CONTOUR_ENABLED
                LD (GameState.View), A
                RET
; -----------------------------------------
; копирование кадра конька в спрайт 32x32
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IXL
; Note:
;   кадр размещается со смещением 8 пикселей вправо и 1 пиксель вниз
; -----------------------------------------
Copy:           ; выбор загруженного кадра по индексу "мира"
                LD A, (State.Frame)
                LD B, A
                LD A, (State.Index)
                JP Combat.SharedCode.ContourTest.Copy
; -----------------------------------------
; вывод копии спрайта 32x32 на узорный фон
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', IXL
; Note:
;   OR-байты читаются в штатном зеркальном формате
; -----------------------------------------
Paint:          LD HL, Adr.SharedBuffer
                LD DE, SCREEN
                LD IXL, #20
                EXX
                LD HL, Adr.ByteMirrorTable
                EXX

.Row            ; восстановление фона текущей строки
                LD A, POS_Y
                SUB IXL
                AND #03
                LD B, #00
                JR NZ, .Pattern                                                 ; переход, если строка не содержит точки узора

                LD B, #11
.Pattern        LD C, #04                                                       ; размер копии по горизонтали в знакоместах
.Byte           LD A, (HL)
                INC L
                EXX
                LD L, A
                LD A, (HL)                                                      ; OR-маска в экранном порядке битов
                EXX
                OR B                                                            ; объединение OR-маски с восстановленным фоном
                XOR (HL)                                                        ; добавление XOR-байта спрайта
                INC L
                LD (DE), A
                INC E
                DEC C
                JR NZ, .Byte                                                    ; переход, если остались байты строки

                ; расчёт адреса начала следующей экранной строки
                LD A, E
                SUB #04
                LD E, A
                CALL NextLine
                DEC IXL
                JP NZ, .Row                                                     ; переход, если остались строки спрайта

                RET
; -----------------------------------------
; подготовка точечного фона основного экрана
; In:
; Out:
; Corrupt:
;   DE, BC, AF
; -----------------------------------------
Background:     LD DE, SCR_ADR_BASE
                LD B, #C0                                                       ; размер экрана по вертикали в пикселях
.Row            ; выбор узора текущей строки
                LD A, B
                AND #03
                LD A, #00
                JR NZ, .Fill                                                    ; переход, если строка не содержит точки узора

                LD A, #11
.Fill           LD C, #20                                                       ; размер экрана по горизонтали в знакоместах
.Byte           LD (DE), A
                INC E
                DEC C
                JR NZ, .Byte                                                    ; переход, если остались байты строки

                ; расчёт адреса следующей строки экрана
                LD A, E
                SUB #20
                LD E, A
                CALL NextLine
                DJNZ .Row

                RET
; -----------------------------------------
; адрес следующей строки основного экрана
; In:
;   DE - адрес начала текущей строки
; Out:
;   DE - адрес начала следующей строки
; Corrupt:
;   DE, AF
; -----------------------------------------
NextLine:       INC D
                LD A, D
                AND #07
                RET NZ                                                          ; выход, если следующая строка остаётся в знакоместе

                LD A, E
                ADD A, #20
                LD E, A
                RET C                                                           ; выход, если выполнен переход в следующую треть экрана

                LD A, D
                SUB #08
                LD D, A
                RET
; -----------------------------------------
; отображение номера кадра и зазора контура
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
Status:         LD DE, #0404
                CALL Console.SetCursor
                LD BC, Text.Frame
                CALL Console.DrawString
                LD A, (State.Frame)
                CALL Console.DrawByte
                LD DE, #0412
                CALL Console.SetCursor
                LD BC, Text.Gap
                CALL Console.DrawString
                LD A, (GameState.View)
                AND CONTOUR_PHASE_MASK
                JP Console.DrawByte
; -----------------------------------------
; восстановление настроек после теста
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; -----------------------------------------
Stop:           LD A, (State.View)
                AND CONTOUR_ENABLED | CONTOUR_PHASE_MASK
                LD B, A
                LD A, (GameState.View)
                AND ~(CONTOUR_ENABLED | CONTOUR_PHASE_MASK)
                OR B
                LD (GameState.View), A
                LD A, (State.Console)
                LD (Kernel.Console.DrawChar.Function), A
                LD A, (State.Attribute)
                CALL Console.SetAttribute
                LD HL, (State.Cursor)
                JP Console.SetScreenAdr
; -----------------------------------------
; состояние и данные теста
; -----------------------------------------
State:          ; независимые кадры и таймеры
.Frame          DB #00
.Index          DB #00
.Phase          DB #00
.SpriteTick     DB #00
.ContourTick    DB #00
.View           DB #00
.Console        DB #00
.Attribute      DB #00
.Cursor         DW #0000
Phases          DB #00, #01, #02, #01
Text:           ; подписи тестового экрана
.Title          DB "CONTOUR TEST", #00
.Frame          DB "FRAME ", #00
.Gap            DB "GAP ", #00
.FPS            DB "FPS ", #00
.Exit           DB "ESC - WORLD", #00
                endmodule

                endif                                                           ; ~ _MODULE_COMBAT_CONTOUR_TEST_
