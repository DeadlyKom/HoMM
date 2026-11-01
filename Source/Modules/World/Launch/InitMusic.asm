
                ifndef _MODULE_WORLD_LAUNCH_INIT_MUSIC_
                define _MODULE_WORLD_LAUNCH_INIT_MUSIC_
; -----------------------------------------
; загрузка и инициализация общей музыки игрового процесса
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ необходимо включить страницу модуля "мира"
;   вызывается только при холодном запуске
;   временный код использует Adr.CodeToScr после завершения загрузки спрайтов
; -----------------------------------------
InitMusic:      ; запрет музыкальных тиков на время загрузки и инициализации трека
                RES_MUSIC_FLAG MUSIC_ENABLE_BIT

                ; копирование загрузчика в существующий временный блок кода
                MEMCPY .Code, Adr.CodeToScr, .Size
                JP .Load

.Code           EQU $
                DISP Adr.CodeToScr

.Load           ; загрузка трека в существующий музыкальный слот
                SET_PAGE_ASSETS
                SET_LOAD_ASSETS ASSETS_ID_MUSIC_02, Page.Music, Adr.Music.Slots
                LOAD_ASSETS ASSETS_ID_MUSIC_02

                ; инициализация проигрывателя общим треком игрового процесса
                SET_PAGE_MUSIC
                LD HL, Adr.Music.Slots
                CALL Sound.Initialize
                JP_SET_MODULE_PAGE_World ; восстановление страницы модуля мира

.Size           EQU $-Adr.CodeToScr
                ENT
                assert .Size <= Size.CodeToScr, "music loader exceeds temporary code buffer"

                endif ; ~_MODULE_WORLD_LAUNCH_INIT_MUSIC_
