
                ifndef _MAIN_MENU_CONTENT_PORTAL_LOAD_
                define _MAIN_MENU_CONTENT_PORTAL_LOAD_
; -----------------------------------------
; загрузка данных контента "главного меню"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Load:           ; инициализация
                LD HL, ArrayAssets
                LD IY, Adr.FrameArray
                LD BC, ArrayAssets.Num << 8                                     ; С - счётчик количества элементов в массиве Adr.FrameArray
                LD A, C
                LD (FrameArray.Num), A

.Loop           ; чтение идентификатора загружаемого ассета
                LD A, (HL)
                INC HL
                EXX
                EX AF, AF'
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                EX AF, AF'
                LOAD_ASSETS_A                                                   ; загрузка ресурса
                                                                                ;   HL - адрес загрузки/распаковки
                ; чтение количество кадров в блоке
                LD B, (HL)
                LD A, B
                EXX
                ADD A, C
                LD C, A
                EXX
                INC HL

.FrameLoop      ; чтение продолжительности кадра
                LD A, (HL)
                INC HL
                LD (IY + FFrame.Duration), A

                ; сохранение страницы
                LD A, (GameState.Assets + FAssets.Address.Page)                 ; страница и загруженного ассета
                LD (IY + FFrame.Address.Page), A

                ; расчёт расположения кадра
                LD E, (HL)
                INC HL
                LD D, (HL)
                INC HL
                EX DE, HL
                ADD HL, DE
                EX DE, HL
                LD (IY + FFrame.Address.Adr), DE

                ; слудующий кадр
                LD DE, FFrame
                ADD IY, DE
                DJNZ .FrameLoop

                EXX
                DJNZ .Loop

                ; сохранение количество элементов в массиве Adr.FrameArray
                LD A, C
                LD (FrameArray.Num), A
                RET

                endif ; ~_MAIN_MENU_CONTENT_PORTAL_LOAD_
