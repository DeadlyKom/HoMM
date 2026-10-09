
                ifndef _MODULE_WORLD_LAUNCH_
                define _MODULE_WORLD_LAUNCH_
; -----------------------------------------
; запуск "мира"
; In:
; Out:
; Corrupt:
; Note:
;    ℹ️ адрес исполнения неизвестен
; -----------------------------------------
Launch:         SAVE_ASSETS_PAGE Kernel.Modules.World.Page                      ; сохранение страницы загруженного ресурса

                CALL Launch.CreateTexture                                       ; подготовка и генерация текстуры Bayer
                CALL Launch.Deploy                                              ; развёртывание кода "мира"
                CALL Launch.CreateTables                                        ; формирование таблиц "мира"
                CALL Launch.InitSprites                                         ; загрузка и инициализация спрайтов
                CALL Launch.WaitProgress                                        ; ожидание завершения загрузки "мира"
                CALL Launch.GameplayWindow                                      ; отображение игрового окна
                JP Launch.Initialize                                            ; инициализация "мира"

                display " - Launch 'World':\t\t\t\t\t\t\t= busy [ ", /D, $-Launch, " byte(s) ]"

                endif ; ~_MODULE_WORLD_LAUNCH_
