
                ifndef _MODULE_PROGRESS_EXECUTE_
                define _MODULE_PROGRESS_EXECUTE_
; -----------------------------------------
; запуск модуля "окно прогресса"
; In:
;   A - идентификатор запускаемой функции
;   B - идентификатор картинки
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Progress:       PUSH BC                                                         ; сохранение идентификатор картинки
                PUSH AF                                                         ; сохранение индификатора запускаемой фцункции
                JP_EXE_ASSET_FUNCTION_TWO_PARAMS ASSETS_ID_PROGRESS             ; загрузка ресурса и запуск функции ассета
.Page           DB #00                                                          ; страница расположения загруженого FAssets'а

                endif ; ~_MODULE_PROGRESS_EXECUTE_
