
                ifndef _MAIN_MENU_CONTENT_FONT_LOAD_
                define _MAIN_MENU_CONTENT_FONT_LOAD_
; -----------------------------------------
; загрузка ассета шрифта (для частиц)
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Load:           ; загрузка графики курсора
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                LOAD_ASSETS ASSETS_ID_FONT_RU_8_PARTICLE                        ; загрузка ресурса шрифта

                ; сохранение страницы
                LD A, (GameState.Assets + FAssets.Address.Page)
                LD (Page), A

                ; инициализация для корректировки адреса
                LD HL, (GameState.Assets + FAssets.Address.Adr)
                LD B, H
                LD C, L
                LD A, (HL)                                                      ; количество глифов
                INC HL

.Loop           ; чтение смещения
                LD E, (HL)
                INC HL
                LD D, (HL)
                EX DE, HL
                ADD HL, BC
                EX DE, HL
                LD (HL), D
                DEC HL
                LD (HL), E
                INC HL
                INC HL

                DEC A
                JR NZ, .Loop

                RET

                endif ; ~_MAIN_MENU_CONTENT_PORTAL_LOAD_
