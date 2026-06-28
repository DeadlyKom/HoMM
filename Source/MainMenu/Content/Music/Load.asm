
                ifndef _MAIN_MENU_CONTENT_MUSIC_LOAD_
                define _MAIN_MENU_CONTENT_MUSIC_LOAD_
; -----------------------------------------
; загрузка ассета шрифта (для частиц)
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Load:           ; загрузка графики курсора
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                ; загрузка ресурса музыки
                SET_LOAD_ASSETS \
                ASSETS_ID_MUSIC_01, \
                Page.Music, Adr.Music.Slots
                LOAD_ASSETS ASSETS_ID_MUSIC_01
                RET

                endif ; ~_MAIN_MENU_CONTENT_MUSIC_LOAD_
