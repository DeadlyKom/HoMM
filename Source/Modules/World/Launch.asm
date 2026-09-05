
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

                CALL Launch.CreateTexture                                       ; подготовка и генерация текстуры Bayer
                CALL Launch.Deploy                                              ; развёртывание кода "мира"
                CALL Launch.CreateTables                                        ; формирование таблиц "мира"
                CALL Launch.InitSprites                                         ; загрузка и инициализация спрайтов
                CALL Launch.WaitProgress                                        ; ожидание завершения загрузки "мира"
                CALL Launch.GameplayWindow                                      ; отображение игрового окна
                JP Launch.WorldInitialize                                       ; инициализация "мира"

                display " - Launch 'World':\t\t\t\t\t\t\t= busy [ ", /D, $-Launch, " byte(s) ]"

                endif ; ~_MODULE_WORLD_LAUNCH_
