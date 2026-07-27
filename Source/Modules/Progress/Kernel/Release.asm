
                ifndef _MODULE_PROGRESS_RELEASE_
                define _MODULE_PROGRESS_RELEASE_
; -----------------------------------------
; освобождение ассета
; In:
; Out:
; Corrupt:
; Note:
;    адрес исполнения неизвестен
; -----------------------------------------
Release:        POP AF                                                          ; удаление значения со стека
                JP_RELEASE_ASSETS_IN_PAGE ASSETS_ID_PROGRESS_STAGES             ; освобождение ассета (находясь в странице)

                endif ; ~_MODULE_PROGRESS_RELEASE_
