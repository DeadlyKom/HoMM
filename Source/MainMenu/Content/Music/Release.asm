
                ifndef _MAIN_MENU_CONTENT_MUSIC_RELEASE_
                define _MAIN_MENU_CONTENT_MUSIC_RELEASE_
; -----------------------------------------
; освобождение ассета музыки
; In:
; Out:
; Corrupt:
; Note:
;   ⚠️ ВАЖНО ⚠️
;   необходимо включить страницу расположения ассет менеджера (страница 3)
; -----------------------------------------
Release:        LD A, ASSETS_ID_MUSIC_01                                        ; идентификатора ассета
                JP_RELEASE_ASSET_A                                              ; освобождение ассета

                endif ; ~_MAIN_MENU_CONTENT_MUSIC_RELEASE_
