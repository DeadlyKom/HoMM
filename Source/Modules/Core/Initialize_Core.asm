
                ifndef _MODULE_CORE_INITIALIZE_CORE_
                define _MODULE_CORE_INITIALIZE_CORE_
; -----------------------------------------
; инициализация "ядра"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Core:           BORDER WHITE                                                    ; установка бордюра
                ; принудительная установка места загрузки ресурса
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                SET_TR_DOS_FLAG ENABLE_IM2_BIT                                  ; включить прерывание IM2 по завершению работы с ПЗУ TR-DOS
                RET

                endif ; ~_MODULE_CORE_INITIALIZE_CORE_
