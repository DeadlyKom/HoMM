
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

                ; отключение обработчика прогресса перед заменой SharedCode
                RES_USER_HANDLER
                ; -----------------------------------------
                HALT                                                            ; синхронизация
                ATTR_IPB SCR_ADR_BASE, BLACK, BLACK, 0                          ; скрытие атрибутами основного экрана
                MEMCPY Adr.Deploy.World, Adr.World, Size.Deploy.World           ; копирование блока
                MEMCPY_PAGE Adr.Deploy.SharedScreen, Adr.SharedScreen, \
                            Page.SharedScreen, Size.Deploy.SharedScreen         ; копирование блока между страницами

                ; установка порога завершения развёртывания кода мира
                PROGRESS_PERCENT_FIXED WORLD_PROGRESS_DEPLOY_END
                LAUNCH_ASSET_FUNCTION Progress.ToPercent, ExecuteModule.Progress
                ; -----------------------------------------
                ; генерация таблица для поиска первого установленного бита
                LD HL, Adr.CodeToScr
                CALL Tables.TG_BitScanLsbTable
                MEMCPY_PAGE Adr.CodeToScr, Adr.BitScanLsbTable, \
                            Page.BitScanLsbTable, Size.BitScanLsbTable          ; копирование блока cгенерированной таблицы для поиска первого установленного бита
                ; генерация таблица вычисления mod 6 числа (0-21)
                LD HL, Adr.CodeToScr
                LD B, 22
                CALL Tables.TG_Div6Table
                MEMCPY_PAGE Adr.CodeToScr, Adr.Div6Table22, \
                            Page.Div6Table22, Size.Div6Table22                  ; копирование блока cгенерированной таблицы деления 0-21 на 6
                ; генерация таблицы номера экранного блока (с 1 по 22 строку включительно) с высотой гексагона
                LD HL, Adr.CodeToScr + 80
                LD D, HIGH Adr.CodeToScr
                CALL Tables.TG_ScrBlockTable
                MEMCPY_PAGE Adr.CodeToScr + 80, Adr.ScrBlockTable, \
                            Page.ScrBlockTable, Size.ScrBlockTable              ; копирование блока cгенерированной таблицы номера экранного блока (с 1 по 22 строку включительно) с высотой гексагона

                ; установка порога завершения формирования таблиц мира
                PROGRESS_PERCENT_FIXED WORLD_PROGRESS_TABLES_END
                LAUNCH_ASSET_FUNCTION Progress.ToPercent, ExecuteModule.Progress
                ; -----------------------------------------
                ; инициализация спрайтов
                MEMCPY Adr.Deploy.Sprite, Adr.CodeToScr, Size.Deploy.Sprite     ; копирование блока
                CALL World.Sprite.Character.Load                                ; загрузка и инициализация спрайтов персонажа
                CALL World.Sprite.Cursor.Load                                   ; загрузка и инициализация спрайтов курсора
                CALL World.Sprite.UI.Load                                       ; загрузка и инициализация спрайтов UI

                ; установка порога завершения инициализации спрайтов
                PROGRESS_PERCENT_FIXED WORLD_PROGRESS_SPRITES_END
                LAUNCH_ASSET_FUNCTION Progress.ToPercent, ExecuteModule.Progress

                ; установка порога завершения загрузки мира
                PROGRESS_PERCENT_FIXED WORLD_PROGRESS_END
                LAUNCH_ASSET_FUNCTION Progress.ToPercent, ExecuteModule.Progress
                DELAY 1                                                         ; небольшая задержка перед отображением мира
                LAUNCH_ASSET_FUNCTION Progress.Release, ExecuteModule.Progress  ; освобождение окна прогресса
                ; -----------------------------------------
                CALL Display.GameWindow                                         ; отображение рамки игрового мира
                ; -----------------------------------------
                ; инициализация мира
                SET_UI_MODE UI_MODE_WORLD                                       ; установить UI режим "мир"
                SET_UI_LAYER World.Base.Layers.GameWorld, \
                                World.Base.Layers.GameWorld.Num                 ; установка активного UI слоя
                SET_TICK_CONTROL_FLAGS GAME_SUSPEND                             ; мир запускается в режиме "остановки времени"
                SET_TICK_REQUEST_FLAGS GAME_SUSPEND_REQUEST                     ; запрос соответствует фактическому состоянию
                SET_MAIN_LOOP World.Base.Loop                                   ; установка главного цикла
                SET_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE             ; установка флагов
                SET_MAIN_SWAP World.Base.Render.PipelineHexagons.Swap           ; установить функцию долгого переключения экранов
                SET_WORLD_RENDER World.Base.Render.Draw                         ; инициализаци главного рендера "мира"
                SET_USER_HANDLER World.Base.Interrupt                           ; установка обработчика прерываний
                RES_MUSIC_FLAG MUSIC_ENABLE_BIT                                 ; запретить проигрывать музыку
                RES_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                           ; разрешить сканирование ввода
                ; SET_RENDER_FLAG SWAP_DISABLE_BIT                                ; запретить смену экранов
                SET_RENDER_SHADOW                                               ; установка Render флага переключение экрана на теневой
                RES_RENDER_FLAG FPS_DISABLE_BIT                                 ; разрешить отображение FPS
                SET_MOUSE_POSITION 128, 96                                      ; установить позицию мыши
                RET

                display " - Launch 'World':\t\t\t\t\t\t\t= busy [ ", /D, $-Launch, " byte(s) ]"

                endif ; ~_MODULE_WORLD_LAUNCH_
