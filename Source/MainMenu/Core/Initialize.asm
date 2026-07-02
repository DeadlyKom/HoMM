
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

                ; сброс счётчика скипа
                XOR A
                LD (MainMenu.Base.Render.Draw_Chur.Counter), A
                RES_FLAG_MODIFY MainMenu.Base.Render.UpdateScreen.ChurFlag      ; сброс флага обновления символа "Чур"
                RES_FLAG_MODIFY MainMenu.Base.Render.ActivateIntro.Flag         ; сброс флага активации завершения интро
                RES_FLAG_MODIFY MainMenu.Base.Render.FlushIntro.Flag            ; сброс флага высвобождения завершения интро
                RES_FLAG_MODIFY MainMenu.Base.Render.CompliteIntro.Flag         ; сброс флага завершения интро
                RES_FLAG_MODIFY MainMenu.Base.Input.Scan.DisableSkipFlag        ; сброс флага запрещения пропуска интро

                ; загрузка данных контента "главного меню"
                CALL MainMenu.Base.Content.Font.Load                            ; загрузка ассета шрифта (для частиц)
                CALL MainMenu.Base.Content.Portal.Load                          ; загрузка данных контента "главного меню"
                CALL MainMenu.Base.Content.Music.Load                           ; загрузка данных контента "музыка"
                CALL MainMenu.Base.Render.Portal.Initialize                     ; первичная инициализация
                CALL MainMenu.Base.Particle.Initialize                          ; инициализация работы счастицами
                SET_PAGE_MUSIC                                                  ; включение страницу работы с музыкой
                LD HL, Adr.Music.Slots
                CALL Sound.Initialize                                           ; инициализация проигрывателя
                RET

                endif ; ~_MODULE_MAIN_MENU_CORE_INITIALIZE_
