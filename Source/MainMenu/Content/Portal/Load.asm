
                ifndef _MAIN_MENU_CONTENT_PORTAL_LOAD_
                define _MAIN_MENU_CONTENT_PORTAL_LOAD_
; -----------------------------------------
; загрузка контент данных "главного меню"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Load:           ; инициализация
                LD HL, ArrayAssets
                LD IY, Frame
                LD B, ArrayAssets.Num

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
                LD (IY + FFrame.Address.Adr), HL

                ; слудующий кадр
                LD DE, FFrame
                ADD IY, DE
                DJNZ .FrameLoop

                EXX
                DJNZ .Loop
                RET

                endif ; ~_MAIN_MENU_CONTENT_PORTAL_LOAD_
