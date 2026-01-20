
                ifndef _MODULE_WORLD_LAUNCH_
                define _MODULE_WORLD_LAUNCH_
; -----------------------------------------
; запуск "мира"
; In:
; Out:
; Corrupt:
; Note:
;    адрес исполнения неизвестен
; -----------------------------------------
Launch:         ; -----------------------------------------
                ; сохранение страницы
                LD A, (GameState.Assets + FAssets.Address.Page)
                LD (Kernel.Modules.World.Page), A

                ATTR_IPB SCR_ADR_BASE, BLACK, BLACK, 0                          ; скрытие атрибутами основного экрана
                MEMCPY Adr.Deploy.World, Adr.World, Size.Deploy.World           ; копирование блока
                MEMCPY_PAGE Adr.Deploy.ScreenRefresh, Adr.ScreenRefresh, \
                            Page.ScreenRefresh, Size.Deploy.ScreenRefresh       ; копирование блока между страницами
                ; -----------------------------------------
                ; генерация таблица для поиска первого установленного бита
                LD HL, Adr.CodeToScr
                CALL Tables.TG_BitScanLsbTable
                MEMCPY_PAGE Adr.CodeToScr, Adr.BitScanLsbTable, \
                            Page.BitScanLsbTable, Size.BitScanLsbTable          ; копирование блока cгенерированной таблицы для поиска первого установленного бита
                ; генерация таблица вычисления mod 6 числа (0-21)
                LD HL, Adr.CodeToScr
                CALL Tables.TG_Mod6Table
                MEMCPY_PAGE Adr.CodeToScr, Adr.Mod6Table, \
                            Page.Mod6Table, Size.Mod6Table                      ; копирование блока cгенерированной таблицы для вычисления mod 6 числа (0-21)
                ; генерация таблицы номера экранного блока (с 1 по 22 строку включительно) с высотой гексагона
                LD HL, Adr.CodeToScr+80
                LD D, HIGH Adr.CodeToScr
                CALL Tables.TG_ScrBlockTable
                MEMCPY_PAGE Adr.CodeToScr+80, Adr.ScrBlockTable, \
                            Page.ScrBlockTable, Size.ScrBlockTable              ; копирование блока cгенерированной таблицы номера экранного блока (с 1 по 22 строку включительно) с высотой гексагона
                ; -----------------------------------------
                ; инициализация спрайтов
                MEMCPY Adr.Deploy.Sprite, Adr.CodeToScr, Size.Deploy.Sprite     ; копирование блока
                CALL World.Sprite.Hero.Load                                     ; загрузка и инициализация спрайтов героя
                CALL World.Sprite.Cursor.Load                                   ; загрузка и инициализация спрайтов курсора
                CALL World.Sprite.UI.Load                                       ; загрузка и инициализация спрайтов UI

                ; -----------------------------------------
                ; подготовка основного экрана
                CLS SCR_ADR_BASE, 0xFF                                          ; очистка основного экрана
                ATTR_IPB SCR_ADR_BASE, BLACK, WHITE, 0                          ; очистка атрибутов основного экрана

                ; -----------------------------------------
                ; инициализация мира 
                SET_MAIN_LOOP World.Base.Loop                                   ; установка главного цикла
                SET_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE             ; установка флагов
                SET_MAIN_SWAP World.Base.Render.PipelineHexagons.Swap           ; установить функцию долгого переключения экранов
                SET_WORLD_RENDER World.Base.Render.Draw                         ; инициализаци главного рендера "мира"
                SET_USER_HANDLER World.Base.Interrupt                           ; установка обработчика прерываний
                RES_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                           ; разрешить сканирование ввода
                ; SET_RENDER_FLAG SWAP_DISABLE_BIT                                ; запретить смену экранов
                SET_RENDER_SHADOW                                               ; установка Render флага переключение экрана на теневой
                RES_RENDER_FLAG FPS_DISABLE_BIT                                 ; разрешить отображение FPS
                SET_MOUSE_POSITION 128, 96                                      ; установить позицию мыши
                RET

                display " - Launch 'World':\t\t\t\t\t\t\t= busy [ ", /D, $-Launch, " byte(s) ]"

                endif ; ~_MODULE_WORLD_LAUNCH_
