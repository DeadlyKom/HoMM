
                ifndef _MODULE_PROGRESS_INITIALIZE_
                define _MODULE_PROGRESS_INITIALIZE_
; -----------------------------------------
; первичная инициализация
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Initialize:     POP AF                                                          ; чтение идентификатора картинки
                JR$

                endif ; ~_MODULE_PROGRESS_INITIALIZE_
