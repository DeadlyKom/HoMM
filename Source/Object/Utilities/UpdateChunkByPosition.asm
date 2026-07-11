                ifndef _OBJECT_UTILITIES_UPDATE_CHUNK_BY_POSITION_
                define _OBJECT_UTILITIES_UPDATE_CHUNK_BY_POSITION_
; -----------------------------------------
; обновить принадлежность объекта к чанку по текущей позиции
; In:
;   IX - адрес структуры объекта (FObject)
; Out:
; Corrupt:
;   все регистры, кроме IX
; Note:
;   необходимо включить страницу работы с объектами (страница 0)
; -----------------------------------------
UpdateChunkByPosition:
                ; определение текущего чанка
                LD E, (IX + FObject.Position.X.High)
                LD D, (IX + FObject.Position.Y.High)
                ; -----------------------------------------
                ; получение номера чанка
                ; In:
                ;   DE - координаты в тайлах (D - y, E - x)
                ; Out:
                ;   A  - порядковый номер чанка
                ; Corrupt:
                ;   HL, AF
                ; Note:
                ; -----------------------------------------
                CALL ChunkArray.GetChunkIndex

                ; сравнение чанков
                LD E, (IX + FObject.Chunk)
                CP E
                RET Z                                                           ; выход, если объект остался в прежнем чанке

                LD D, A                                                         ; сохранение нового чанка
                LD (IX + FObject.Chunk), A                                      ; новый чанк становится текущей принадлежностью объекта
                CALL Object.Utilities.GetObjectID.IX                            ; получить ID объекта

                ; перенос ID объекта из старого чанка в новый
                LD HL, GameSession.WorldInfo + FWorldInfo.ObjectNum
                LD C, (HL)
                LD B, #00
                LD HL, Adr.ChunkArrayValues
                ; -----------------------------------------
                ; перемещение значения в другой чанк
                ; In:
                ;   HL - адрес значений массива чанков (выровненый 256 байт)
                ;   A  - перемещяемое значение
                ;   D  - номер чанка назначения
                ;   E  - номер чанка источника
                ;   BC - размер массива чанков
                ; Out:
                ; Corrupt:
                ; Note:
                ; -----------------------------------------
                CALL ChunkArray.Move

                ; привязка к текущему CadencePassID диапазона нового чанка
                LD A, (IX + FObject.Chunk)
                CALL Object.Utilities.CadencePassIdByChunk
                LD (IX + FObject.CadencePassID), A
                RET

                endif ; ~_OBJECT_UTILITIES_UPDATE_CHUNK_BY_POSITION_
