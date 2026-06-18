
                ifndef _MAIN_MENU_CONTENT_PORTAL_RELEASE_
                define _MAIN_MENU_CONTENT_PORTAL_RELEASE_
; -----------------------------------------
; освобождение контент данных "главного меню"
; In:
; Out:
; Corrupt:
; Note:
;   ⚠️ ВАЖНО ⚠️
;   необходимо включить страницу расположения ассет менеджера (страница 3)
; -----------------------------------------
Release:        ; инициализация
                LD HL, ArrayAssets
                LD B, ArrayAssets.Num

.Loop           ; чтение идентификатора загружаемого ассета
                LD A, (HL)
                INC HL
                EXX
                RELEASE_ASSET_A                                                 ; освобождение ресурса
                EXX
                DJNZ .Loop
                RET

                endif ; ~_MAIN_MENU_CONTENT_PORTAL_RELEASE_
