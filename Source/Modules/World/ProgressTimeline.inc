
                ifndef _MODULE_WORLD_PROGRESS_TIMELINE_
                define _MODULE_WORLD_PROGRESS_TIMELINE_
; -----------------------------------------
; временная шкала прогресса запуска мира
;
; значения задаются в процентах общего прогресса загрузки сессии
; -----------------------------------------

                ; порог завершения подготовки и генерации текстуры Bayer
                define WORLD_PROGRESS_TEXTURE_END 83.0

                ; порог завершения развёртывания кода мира
                define WORLD_PROGRESS_DEPLOY_END 85.0

                ; порог завершения формирования таблиц мира
                define WORLD_PROGRESS_TABLES_END 92.0

                ; порог завершения инициализации спрайтов
                define WORLD_PROGRESS_SPRITES_END 97.0

                ; порог завершения загрузки мира
                define WORLD_PROGRESS_END 100.0

                endif ; ~_MODULE_WORLD_PROGRESS_TIMELINE_
