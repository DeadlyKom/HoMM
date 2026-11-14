
                ifndef _SUBMODULES_CONTOUR_RELEASE_
                define _SUBMODULES_CONTOUR_RELEASE_
; -----------------------------------------
; освобождение памяти и ресурса сабмодуля "обводки"
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX
; Note:
;   ℹ️ необходимо включить страницу сабмодуля "обводки"
; -----------------------------------------
Release:        CALL Launch.Release                                             ; освобождение рабочего буфера размером 256 байт
                JP_RELEASE_ASSETS_IN_PAGE ASSETS_ID_SUBMODULE_CONTOUR           ; освобождение кода и таблиц сабмодуля

                endif ; ~_SUBMODULES_CONTOUR_RELEASE_
