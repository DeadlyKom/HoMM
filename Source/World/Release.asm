
                ifndef _WORLD_RELEASE_
                define _WORLD_RELEASE_

; -----------------------------------------
; освобождение памяти и модуля мира
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   процедура пока не вызывается
; -----------------------------------------
Release:        ; освобождение памяти и модуля мира
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                ; получение линейного адреса дополнительного блока памяти
                LD A, (Kernel.Modules.World.Page)
                LD HL, (Kernel.Modules.World.MemoryAddress)
                CALL AssetsManager.MemRelease                                   ; освобождение дополнительного блока памяти
                JP Kernel.Modules.World.Release                                 ; освобождение модуля

                endif ; ~_WORLD_RELEASE_
