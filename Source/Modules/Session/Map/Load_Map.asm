
                ifndef _MODULE_SESSION_LOAD_MAP_
                define _MODULE_SESSION_LOAD_MAP_
; -----------------------------------------
; загрузка карты
; In:
;   A - идентификатор загружаемого ресурса карты
; Out:
; Corrupt:
; Note:
;   код расположен в общей
; -----------------------------------------
Load.Map:       ; сохранение идентификатора загружаемой карты
                LD (.MapAssetID), A
                EX AF, AF'
                CALL Load.Metadata                                              ; загрузка ресурса карты

                ; -----------------------------------------
                ; парсинг FMapHeader
                ; -----------------------------------------

                ; сохранение информации о карте (0)
                LD DE, GameSession.MapInfo
                LD BC, FMapInfo
                LDIR
                CALL Initialize.Initial                                         ; первичная инициализация карты после загрузки

                ; инициализация фикла обхода блоков данных FMapHeader
                LD IX, .ProcessedBlocks
                LD B, 3                                                         ; количество блоков (FMapDataBlockInfo) в FMapHeader

.DataBlockLoop  PUSH BC

                ; чтение размера блока
                LD C, (HL)
                INC L
                LD B, (HL)
                INC L

                ; чтение смещение от текущего адреса до блока данных
                LD E, (HL)
                INC L
                LD D, (HL)
                INC L
                PUSH HL                                                         ; сохранение адреса
                ADD HL, DE                                                      ; расчёт адреса блока данных
                EX DE, HL

                LD HL, .NextDataBlock
                PUSH HL
                LD HL, (IX + 0)
                JP (HL)

.NextDataBlock  INC IX
                INC IX
                POP HL                                                          ; восстановление адреса
                POP BC
                DJNZ .DataBlockLoop

                ; освобождение ресурса карты
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
.MapAssetID     EQU $+1
                LD A, #00
                RELEASE_ASSET_A
                JP_SET_MODULE_PAGE_Session                                      ; включить страницу модуля "Session"

.SetPageLoadedMap ; установка страницы загруженной карты
.LoadedMapPage  EQU $+1                                                         ; номер страницы загруженной карты
                LD A, #00
                JP_SET_PAGE_A

.ProcessedBlocks; последовательность обрабатываемых блоков (FMapDataBlockInfo) в FMapHeader
                DW DataBlock.Hextile
                DW DataBlock.HextileTable
                DW DataBlock.GraphicPack

                display " - Load map:\t\t\t\t\t\t", /A, Load.Map, "\t= busy [ ", /D, $-Load.Map, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_LOAD_MAP_
