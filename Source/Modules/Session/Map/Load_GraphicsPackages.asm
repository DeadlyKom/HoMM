
                ifndef _MODULE_SESSION_LOAD_GRAPHICS_PACKAGES_
                define _MODULE_SESSION_LOAD_GRAPHICS_PACKAGES_
; -----------------------------------------
; загрузка графических пакетов
; In:
;   HL  - адрес блока данных необходимых графических пакетов для текущей карты
;   BC  - размер блока данных необходимых графических пакетов для текущей карты
;   HL' - адрес блока данных таблицы сопоставления гексагонального тайла и графического пакета
;   BC' - размер блока данных таблицы сопоставления гексагонального тайла и графического пакета
; Out:
; Corrupt:
; Note:
;   - включена страница загруженной карты!
;   - размер блока данных необходимых графических пакетов для текущей карты, не должен превышать 128
; -----------------------------------------
Load.GraphicsPackages:
                PUSH_PAGE                                                       ; сохранение номера страницы в стеке
                ; копирование блока данных необходимых графических пакетов для текущей карты
                LD DE, Adr.TilemapBuffer
                LD A, C                                                         ; копирование количество идентификаторов графических пакетов для текущей карты
                LDIR

                ; обнуление значений страших адресов
                DEC E
                SET 7, E
                LD C, A
                LD H, D
                LD L, E
                DEC E
                LD (HL), B
                DEC C
                JR Z, $+4
                LDDR

                RES 7, L
                LD B, A
.Loop           PUSH BC
                
                ; загрузка ассета
                LD E, (HL)                                                      ; чтение ID ассета
                PUSH HL                                                         ; сохранение адреса указывающий на загружаемый ассет

                ; загрузка ассета
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                LOAD_ASSETS_REG E                                               ; загрузка ресурса
                SET_MODULE_PAGE_Session                                         ; включить страницу модуля "Session"

                POP HL                                                          ; восстановление адреса указывающий на загружаемый ассет

                ; инициализация буфера новыми значениями
                ; позволит избавится от лишних обращений к ассет менеджеру
                LD A, (GameState.Assets + FAssets.Address.Page)
                LD (HL), A
                SET 7, L
                LD A, (GameState.Assets + FAssets.Address.Adr.High)
                LD (HL), A
                RES 7, L
                INC L

                POP BC
                DJNZ .Loop

                JP_POP_PAGE                                                     ; восстановление номера страницы из стека

                display " - Load graphics packages:\t\t\t\t", /A, Load.GraphicsPackages, "\t= busy [ ", /D, $-Load.GraphicsPackages, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_LOAD_GRAPHICS_PACKAGES_