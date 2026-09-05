
                ifndef _MODULE_WORLD_LAUNCH_CREATE_TABLES_
                define _MODULE_WORLD_LAUNCH_CREATE_TABLES_
; -----------------------------------------
; формирование таблиц "мира"
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF'
; Note:
;   ℹ️ необходимо включить страницу модуля "мира"
; -----------------------------------------
CreateTables:   ; генерация таблицы для поиска первого установленного бита
                LD HL, Adr.CodeToScr
                CALL World.Tables.TG_BitScanLsbTable
                MEMCPY_PAGE Adr.CodeToScr, Adr.BitScanLsbTable, \
                            Page.BitScanLsbTable, Size.BitScanLsbTable          ; копирование блока cгенерированной таблицы для поиска первого установленного бита
                ; генерация таблица вычисления mod 6 числа (0-21)
                LD HL, Adr.CodeToScr
                LD B, 22
                CALL World.Tables.TG_Div6Table
                MEMCPY_PAGE Adr.CodeToScr, Adr.Div6Table22, \
                            Page.Div6Table22, Size.Div6Table22                  ; копирование блока cгенерированной таблицы деления 0-21 на 6
                ; генерация таблицы номера экранного блока (с 1 по 22 строку включительно) с высотой гексагона
                LD HL, Adr.CodeToScr + 80
                LD D, HIGH Adr.CodeToScr
                CALL World.Tables.TG_ScrBlockTable
                MEMCPY_PAGE Adr.CodeToScr + 80, Adr.ScrBlockTable, \
                            Page.ScrBlockTable, Size.ScrBlockTable              ; копирование блока cгенерированной таблицы номера экранного блока (с 1 по 22 строку включительно) с высотой гексагона

                ; установка порога завершения формирования таблиц "мира"
                PROGRESS_PERCENT_FIXED WORLD_PROGRESS_TABLES_END
                JP_LAUNCH_ASSET_FUNCTION Progress.ToPercent, ExecuteModule.Progress

                endif ; ~_MODULE_WORLD_LAUNCH_CREATE_TABLES_
