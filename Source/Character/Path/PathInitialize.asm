
                ifndef _CHARACTER_PATH_INITIALIZE_
                define _CHARACTER_PATH_INITIALIZE_
; -----------------------------------------
; инициализация пути (обёртка)
; In:
;   C' - длина пути
;   IX - адрес персонажа          (FCharacter)
;   IY - адрес объекта персонажа  (FObjectCharacter)
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ код расположен в странице 0
; -----------------------------------------
PathInitialize.Wrap:
                EXX
; -----------------------------------------
; инициализация пути
; In:
;   C  - длина пути
;   IX - адрес персонажа          (FCharacter)
;   IY - адрес объекта персонажа  (FObjectCharacter)
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ код расположен в странице 0
; -----------------------------------------
PathInitialize  ; сохранение длины пути
                LD A, C
                EX AF, AF'

                ; инициализация объекта персонажа
                DEC C                                                           ; начинается с -1
                LD (IY + FObjectCharacter.PathID), C
                XOR A
                LD (IY + FObjectCharacter.MovementBudget.Low), A
                LD (IY + FObjectCharacter.MovementBudget.High), A               ; новый маршрут не наследует остаток бюджета предыдущего действия
                LD (IY + FObjectCharacter.MovementPending.Low), A
                LD (IY + FObjectCharacter.MovementPending.High), A

                ; ToDo: FObjectCharacter.WayPointID по идее должен не изменяться,
                ;       т.к. он отражает текущее положение на гексагоне

                ; расчёт размер копируемых данных, длина пути (С) * FPath
                EX AF, AF'
                ADD A, A    ; x2
                ADD A, A    ; x4
                LD C, A
                LD B, #00                                                       ; BC = размер пути; B выше содержал SelectedHeroID

                ; копирование пути в буфер
                LD HL, Adr.SortBuffer                                           ; т.к. обновление UI и обработка событий,
                                                                                ; происходит перед отрисовкой, данный буфер свободный
                                                                                ; для временного хранения
                LD DE, Adr.HeroPath
                JP Memcpy.FastLDIR

                endif ; ~_CHARACTER_PATH_INITIALIZE_
