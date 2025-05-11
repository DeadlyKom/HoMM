
                ifndef _WORLD_LAUNCH_
                define _WORLD_LAUNCH_
; -----------------------------------------
; запуск "мира"
; In:
; Out:
; Corrupt:
; Note:
;    адрес исполнения неизвестен
; -----------------------------------------
Launch:         ; сохранение страницы
                LD A, (GameState.Assets + FAssets.Address.Page)
                LD (Kernel.Modules.World.Page), A

                ATTR_IPB SCR_ADR_BASE, BLACK, BLACK, 0                          ; скрытие атрибутами основного экрана
                MEMCPY Adr.Deploy.World, Adr.World, Size.Deploy.World           ; копирование блока

                ; инициализация спрайтов
                MEMCPY Adr.Deploy.Sprite, Adr.CodeToScr, Size.Deploy.Sprite     ; копирование блока
                CALL World.Sprite.Hero.Load                                     ; загрузка и инициализация спрайтов героя
                CALL World.Sprite.Cursor.Load                                   ; загрузка и инициализация спрайтов курсора

                ; подготовка основного экрана
                CLS SCR_ADR_BASE, 0xFF                                          ; очистка основного экрана
                ATTR_IPB SCR_ADR_BASE, BLACK, WHITE, 0                          ; очистка атрибутов основного экрана

                ; инициализация мира 
                SET_MAIN_LOOP World.Base.Loop                                   ; установка главного цикла
                SET_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE             ; установка флагов
                SET_WORLD_RENDER World.Base.Render.Draw                         ; инициализаци главного рендера "мира"
                SET_USER_HANDLER World.Base.Interrupt                           ; установка обработчика прерываний
                RES_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                           ; разрешить сканирование ввода
                RES_RENDER_FLAG SWAP_DISABLE_BIT                                ; разрешить смену экранов
                RES_RENDER_FLAG FPS_DISABLE_BIT                                 ; разрешить отображение FPS
                SET_MOUSE_POSITION 128, 96                                      ; установить позицию мыши
                RET

                display " - Launch 'World':\t\t\t\t\t\t     \t= busy [ ", /D, $-Launch, " byte(s) ]"

                endif ; ~_WORLD_LAUNCH_
