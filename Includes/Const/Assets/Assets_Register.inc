
                ifndef _CONST_ASSETS_REGISTER_
                define _CONST_ASSETS_REGISTER_
ASSETS_ID_COUNTER   defl 0
REG_ASSETS_ID       macro Label?
Label?              EQU ASSETS_ID_COUNTER
ASSETS_ID_COUNTER   = ASSETS_ID_COUNTER + 1
                    endm
REG_ASSETS_ID_DEBUG macro Label?

                    ifdef _DEBUG
                    REG_ASSETS_ID Label?
                    endif

                    endm

                    REG_ASSETS_ID       ASSETS_ID_KERNEL                        ; кернел
                    REG_ASSETS_ID       ASSETS_ID_CORE                          ; ядро
                    REG_ASSETS_ID       ASSETS_ID_PAGE_0                        ; код 0 страницы
                    REG_ASSETS_ID       ASSETS_ID_PAGE_1                        ; код 1 страницы
                    REG_ASSETS_ID       ASSETS_ID_PAGE_3                        ; код 3 страницы
                    REG_ASSETS_ID       ASSETS_ID_PAGE_4                        ; код 4 страницы
                    REG_ASSETS_ID       ASSETS_ID_PROGRESS                      ; окно прогресса
                    REG_ASSETS_ID       ASSETS_ID_PROGRESS_STAGES               ; графика стадий прогресса
                    REG_ASSETS_ID       ASSETS_ID_MAIN_MENU                     ; главное меню
                    REG_ASSETS_ID       ASSETS_ID_MAIN_MENU_GRAPH_PACK_0        ; главное меню - графический пакет #00
                    REG_ASSETS_ID       ASSETS_ID_MAIN_MENU_GRAPH_PACK_1        ; главное меню - графический пакет #01
                    REG_ASSETS_ID       ASSETS_ID_MAIN_MENU_GRAPH_PACK_2        ; главное меню - графический пакет #02
                    REG_ASSETS_ID       ASSETS_ID_FONT_RU_8_PARTICLE            ; русский шрифт 8 (для частиц)
                    REG_ASSETS_ID       ASSETS_ID_SESSION                       ; сессия
                    REG_ASSETS_ID       ASSETS_ID_WORLD                         ; мир
                    REG_ASSETS_ID       ASSETS_ID_DEFAULT_SETTINGS              ; дефолтные настройки объектов
                    REG_ASSETS_ID       ASSETS_ID_CURSOR_PACK                   ; графика курсора
                    ; REG_ASSETS_ID       ASSETS_ID_UI_ARROW_PATH_PACK            ; графика UI стрелок пути
                    REG_ASSETS_ID       ASSETS_ID_HERO_PACK                     ; графика героев
                    REG_ASSETS_ID       ASSETS_ID_HEX_FOG                       ; графика гексагонная, туман
                    REG_ASSETS_ID       ASSETS_ID_HEX_GRASSLANDS                ; графика гексагонная, природные ландшафты - луга
                    REG_ASSETS_ID       ASSETS_ID_MAP_DEBUG                     ; карта "отладочная"
                    REG_ASSETS_ID       ASSETS_ID_MUSIC_01                      ; музыка №01

                endif ; ~_CONST_ASSETS_REGISTER_
