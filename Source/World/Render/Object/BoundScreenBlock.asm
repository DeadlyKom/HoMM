
                ifndef _WORLD_RENDER_OBJECT_BOUND_SCREEN_BLOCK_
                define _WORLD_RENDER_OBJECT_BOUND_SCREEN_BLOCK_
; -----------------------------------------
; работа bound объекта с dirty screen block'ами кадра
; Note:
;   Adr.ScreenBlock хранит 4x4 блока игрового окна по столбцам:
;       index = column * 4 + row
;   ненулевое значение означает, что блок экрана был затронут в текущем кадре
; -----------------------------------------
BoundScreenBlock:
; -----------------------------------------
; проверить пересечение bound объекта с обновлёнными screen block'ами
; In:
;   IY - адрес FObject, включена страница работы с объектами
; Out:
;   Carry установлен, если хотя бы один пересекаемый screen block обновляется
;   восстановлена страница работы с объектами
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   игровая область разбита на блоки 6x6 знакомест;
;   Adr.ScreenBlock хранит их по столбцам: column * 4 + row
; -----------------------------------------
.Intersects     ; проверка ширины bound объекта
                LD A, (IY + FObject.Bound + FSpriteBound.Size.Width)
                OR A                                                            ; Carry сброшен
                RET Z                                                           ; выход, если bound объекта не определён, 
                                                                                ; страница объектов не менялась
                LD C, A

                ; расчёт стартового столбца и количества проверяемых столбцов
                LD A, (IY + FObject.Bound + FSpriteBound.Location.X)
                SRL A
                SRL A
                SRL A
                SUB SCR_WORLD_POS_X
                JR NC, $+3
                XOR A
                ADD A, LOW .ScreenBlockIndexTable
                LD L, A
                ADC A, HIGH .ScreenBlockIndexTable
                SUB L
                LD H, A
                LD B, (HL)
                LD E, B                                                         ; стартовый столбец
                LD A, (IY + FObject.Bound + FSpriteBound.Location.X)
                ADD A, C
                DEC A
                SRL A
                SRL A
                SRL A
                SUB SCR_WORLD_POS_X
                JR NC, $+3
                XOR A
                ADD A, LOW .ScreenBlockIndexTable
                LD L, A
                ADC A, HIGH .ScreenBlockIndexTable
                SUB L
                LD H, A
                LD B, (HL)
                LD A, B
                SUB E
                INC A
                LD C, A                                                         ; количество проверяемых столбцов
                LD A, E
                ADD A, A
                ADD A, A
                LD E, A                                                         ; смещение стартового столбца в Adr.ScreenBlock

                ; проверка высоты bound объекта
                LD A, (IY + FObject.Bound + FSpriteBound.Size.Height)
                OR A                                                            ; Carry сброшен
                RET Z                                                           ; выход, если bound объекта не определён,
                                                                                ; страница объектов не менялась
                LD D, A

                ; расчёт стартовой строки
                LD A, (IY + FObject.Bound + FSpriteBound.Location.Y)
                SRL A
                SRL A
                SRL A
                SUB SCR_WORLD_POS_Y
                JR NC, $+3
                XOR A
                ADD A, LOW .ScreenBlockIndexTable
                LD L, A
                ADC A, HIGH .ScreenBlockIndexTable
                SUB L
                LD H, A
                LD B, (HL)
                LD A, E
                ADD A, B
                LD E, A                                                         ; смещение первого проверяемого screen block'а

                ; расчёт количества проверяемых строк
                LD A, (IY + FObject.Bound + FSpriteBound.Location.Y)
                ADD A, D
                DEC A
                LD D, B                                                         ; стартовая строка
                SRL A
                SRL A
                SRL A
                SUB SCR_WORLD_POS_Y
                JR NC, $+3
                XOR A
                ADD A, LOW .ScreenBlockIndexTable
                LD L, A
                ADC A, HIGH .ScreenBlockIndexTable
                SUB L
                LD H, A
                LD B, (HL)
                LD A, B
                SUB D
                INC A
                LD B, A

                ; расчёт перехода к той же строке следующего столбца
                LD A, #04
                SUB B
                LD D, A                                                         ; смещение к следующему столбцу после проверки строк

                ; расчёт смещения JR для входа в развёрнутую проверку строк
                LD A, D
                ADD A, A                                                        ; x2
                ADD A, A                                                        ; x4
                LD (.Jump), A

                ; расчёт адреса первого проверяемого screen block'а
                LD A, E
                ADD A, LOW Adr.ScreenBlock
                LD L, A
                LD H, HIGH Adr.ScreenBlock

                LD E, D                                                         ; смещение к следующему столбцу после проверки строк
                LD D, C                                                         ; количество проверяемых столбцов

                ; переход к буферу обновлённых screen block'ов
                SET_PAGE_SCREEN_SHADOW
                LD B, D                                                         ; восстановление счётчика столбцов,
                                                                                ; т.к. переключение страницы портит BC

.ColumnLoop     ; цикл прохода по столбцам
                XOR A
.Jump           EQU $+1
                JR $

                ; вход, если требуется проверить 4 строки текущего столбца
                OR (HL)
                JR NZ, .ScreenBlockFound                                        ; переход, если screen block был обновлён
                INC L

                ; вход, если требуется проверить 3 строки текущего столбца
                OR (HL)
                JR NZ, .ScreenBlockFound                                        ; переход, если screen block был обновлён
                INC L

                ; вход, если требуется проверить 2 строки текущего столбца
                OR (HL)
                JR NZ, .ScreenBlockFound                                        ; переход, если screen block был обновлён
                INC L

                ; вход, если требуется проверить 1 строку текущего столбца
                OR (HL)
                JR NZ, .ScreenBlockFound                                        ; переход, если screen block был обновлён
                INC L

                ; переход к следующему столбцу screen block'ов
                LD A, E
                ADD A, L
                LD L, A
                DJNZ .ColumnLoop                                                ; переход, если остались непроверенные столбцы

.ScreenBlockNotFoundRestore ; обновлённые screen block'и не найдены, страница была переключена
                OR A                                                            ; Carry сброшен
                PUSH AF
                SET_PAGE_OBJECT                                                 ; восстановить страницу работы с объектами
                POP AF
                RET

.ScreenBlockFound ; найден обновлённый screen block, страница была переключена
                SCF
                PUSH AF
                SET_PAGE_OBJECT                                                 ; восстановить страницу работы с объектами
                POP AF
                RET
; -----------------------------------------
; таблица номера screen block'а по относительной координате игрового окна в знакоместах
; -----------------------------------------
.ScreenBlockIndexTable
                DB 0, 0, 0, 0, 0, 0
                DB 1, 1, 1, 1, 1, 1
                DB 2, 2, 2, 2, 2, 2
                DB 3, 3, 3, 3

                display " - Object bound screen block:\t\t\t\t", /A, BoundScreenBlock, "\t= busy [ ", /D, $-BoundScreenBlock, " byte(s)  ]"

                endif ; ~_WORLD_RENDER_OBJECT_BOUND_SCREEN_BLOCK_
