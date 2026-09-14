
                ifndef _CHARACTERISTICS_RELEASE_
                define _CHARACTERISTICS_RELEASE_
; -----------------------------------------
; освобождение ресурсов и модуля "характеристик"
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX
; Note:
;   перед вызовом необходимо завершить использование модуля
;   возврат должен выполняться в код вне освобождаемого модуля
; -----------------------------------------
Release:        ; освобождение ассета модуля характеристик
                JP_RELEASE_ASSETS_IN_PAGE ASSETS_ID_CHARACTERISTICS             ; освобождение ассета с восстановлением страницы

                endif ; ~_CHARACTERISTICS_RELEASE_
