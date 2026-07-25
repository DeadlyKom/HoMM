
                ifndef _FONT_LOAD_
                define _FONT_LOAD_
; -----------------------------------------
; загрузка шрифта
; In:
;   E - идентификатор шрифта
; Out:
; Corrupt:
; Note:
;   ⚠️ ВАЖНО ⚠️
;
;   ℹ️ необходимо включить страницу 3
; -----------------------------------------
Load:           ; проверка наличия шрифта
                LD A, E
                CP .Max
                RET NC                                                          ; выход, если в таблице отсутствует требуемый идентификатор
                
                ; расчёт адреса в таблице ассетов
                ADD A, LOW .FontAssetTable
                LD L, A
                ADC A, HIGH .FontAssetTable
                SUB L
                LD H, A
                LD A, (HL)                                                      ; чтение идентификатора ассета из таблицы
                PUSH AF                                                         ; сохранение идентификатора ассета

                ; подготовка к загрузке шрифта
                LD A, Page.Page3
                LD (GameState.Assets + FAssets.Address.Page), A
                LD HL, Adr.Font
                LD (GameState.Assets + FAssets.Address.Adr), HL
                LD HL, GameState.Assets + FAssets.Address.Adr
                RES ASSETS_ALLOCATION_BIT, (HL)

                ; копирование подготовленого блока (SET_LOAD_ASSETS находясь не в 3ей странице)
                LD HL, GameState.Assets + FAssets.Address
                ASSETS_ADR DE, ASSETS_ID_FONT_RU_8
                LD BC, FLinearAddress
                CALL Func.CopyFromPage

                POP AF                                                          ; восстановление идентификатора ассета
                JP_LOAD_ASSETS_IN_PAGE_A                                        ; загрузка ассета (находясь в странице)

.FontAssetTable ; таблица ассетов шрифтов
                DB ASSETS_ID_FONT_RU_8                                          ; FONT_ID_DEFAULT_8
.Max            EQU $-.FontAssetTable

                display " - Load font:\t\t\t\t", /A, Load, "\t= busy [ ", /D, $-Load, " byte(s)  ]"

                endif ; ~ _FONT_LOAD_
