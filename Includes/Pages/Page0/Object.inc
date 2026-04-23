
                ifndef _PAGE_0_OBJECT_
                define _PAGE_0_OBJECT_
Object:
.Initialize             EQU Page0.Object.Initialize                             ; инициализация работы с объектами
.Spawn                  EQU Page0.Object.Spawn                                  ; спавн объекта
.PlacemantNew           EQU Page0.Object.PlacemantNew                           ; размещение нового объекта
.RemoveAtSwap           EQU Page0.Object.RemoveAtSwap                           ; удаление объекта, перемещая последний элемент в массиве
.SmartRemove            EQU Page0.Object.SmartRemove                            ; умное удаление объекта
.FindLastByPredicate    EQU Page0.Object.FindLastByPredicate                    ; поиск объекта с конца массива, используя предикат

TickScheduler:
.Variables              EQU Page0.Object.TickScheduler                          ; структура переменных "планировщика тиков"
.Initialize             EQU Page0.Object.TickScheduler.Initialize               ; инициализация планировщика по умолчанию
Object.Class:
.UI                     EQU Page0.Object.Class.UI
.Character              EQU Page0.Object.Class.Character
.CharacterAI            EQU Page0.Object.Class.CharacterAI
.Construction           EQU Page0.Object.Class.Construction
Object.Utilities:
.GetAdr.IX              EQU Page0.Object.Utilities.Adr.IX                       ; получить адрес объекта
.GetAdr.IY              EQU Page0.Object.Utilities.Adr.IY                       ; получить адрес объекта
.CadencePassIdByChunk   EQU Page0.Object.Utilities.GetCadencePassIdByChunk      ; получить CadencePassId по номеру чанка
.IncCadencePassIDs      EQU Page0.Object.Utilities.IncCadencePassIDs            ; увеличение CadencePass'ы ID
                endif ; ~_PAGE_0_OBJECT_
