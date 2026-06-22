
                ifndef _MODULE_MAIN_MENU_CORE_INITIALIZE_
                define _MODULE_MAIN_MENU_CORE_INITIALIZE_
; -----------------------------------------
; первичная инициализация "главного меню"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Initialize:     ; генерация таблицы
                SET_MODULE_PAGE_MainMenu                                        ; включить страницу модуля "MainMenu"
                LD HL, Adr.ExtraBuffer
                CALL MainMenu.Tables.TG_Force.Default                           ; генерация таблица величины силы
                MEMCPY_TO_PAGE Adr.ExtraBuffer, Adr.ForceTable, \
                            Page.ForceTable, Size.ForceTable                    ; копирование блока между страницами

                ; загрузка данных контента "главного меню"
                CALL MainMenu.Base.Content.Portal.Load
                CALL MainMenu.Base.Render.Portal.Initialize                     ; первичная инициализация
                CALL MainMenu.Base.Particle.Initialize                          ; инициализация работы счастицами
                RET

                endif ; ~_MODULE_MAIN_MENU_CORE_INITIALIZE_
