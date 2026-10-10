
                ifndef _MODULE_PROGRESS_RELEASE_
                define _MODULE_PROGRESS_RELEASE_
; -----------------------------------------
; освобождение ресурса
; In:
; Out:
; Corrupt:
; Note:
;    ℹ️ адрес исполнения неизвестен
; -----------------------------------------
Release:        POP AF                                                          ; удаление значения со стека
                JP_RELEASE_ASSETS_IN_PAGE ASSETS_ID_PROGRESS_STAGES             ; освобождение ресурса (находясь в странице)

                endif ; ~_MODULE_PROGRESS_RELEASE_
