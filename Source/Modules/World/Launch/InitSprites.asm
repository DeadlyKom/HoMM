
                ifndef _MODULE_WORLD_LAUNCH_INIT_SPRITES_
                define _MODULE_WORLD_LAUNCH_INIT_SPRITES_
; -----------------------------------------
; загрузка и инициализация спрайтов
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ необходимо включить страницу модуля "мира"
; -----------------------------------------
InitSprites:    ; инициализация спрайтов
                MEMCPY World.Adr.Deploy.Sprite, Adr.CodeToScr, \
                        World.Size.Deploy.Sprite                                ; копирование блока
                CALL World.Sprite.Character.Load                                ; загрузка и инициализация спрайтов персонажа
                CALL World.Sprite.Cursor.Load                                   ; загрузка и инициализация спрайтов курсора
                CALL World.Sprite.UI.Load                                       ; загрузка и инициализация спрайтов UI

                ; установка порога завершения инициализации спрайтов
                PROGRESS_PERCENT_FIXED WORLD_PROGRESS_SPRITES_END
                JP_LAUNCH_ASSET_FUNCTION Progress.ToPercent, ExecuteModule.Progress

                endif ; ~_MODULE_WORLD_LAUNCH_INIT_SPRITES_
