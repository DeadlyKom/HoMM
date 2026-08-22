
                ifndef _CHARACTER_PATH_INITIALIZE_
                define _CHARACTER_PATH_INITIALIZE_
; -----------------------------------------
; инициализация пути (обёртка)
; In:
;   C' - длина пути
;   IX - адрес исходного персонажа          (FCharacter)
;   IY - адрес исходного объекта персонажа  (FObjectCharacter)
; Out:
;   A' - 1, если маршрут применён к исходному объекту; иначе 0
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
;   IX - адрес исходного персонажа          (FCharacter)
;   IY - адрес исходного объекта персонажа  (FObjectCharacter)
; Out:
;   A' - 1, если маршрут применён к исходному объекту; иначе 0
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ код расположен в странице 0
; -----------------------------------------
PathInitialize  ; сохранение длины пути
                LD A, C
                EX AF, AF'

                ; ЗАЩИТНАЯ ПРОВЕРКА route context.
                ; Текущий BFS синхронный: пока он выполняется, мир не тикает,
                ; поэтому герой штатно не может удалиться или сменить слот.
                ; Проверка страхует от повреждённой связи и будущего изменения lifecycle;
                ; при переходе на асинхронный поиск сюда также нужно добавить сравнение
                ; стартовой Position и generation/version объекта.
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                LD B, A
                LD A, (GameSession.WorldInfo + FWorldInfo.HeroNum)
                CP B
                JR Z, .ContextChanged
                JR C, .ContextChanged

                LD A, B
                CALL Character.Utilities.GetAdr.HL
                PUSH IX
                POP DE
                OR A
                SBC HL, DE
                JR NZ, .ContextChanged

                LD A, (IX + FCharacter.ObjectID)
                LD C, A
                LD A, (GameSession.WorldInfo + FWorldInfo.ObjectNum)
                CP C
                JR Z, .ContextChanged
                JR C, .ContextChanged

                LD A, C
                CALL Object.Utilities.GetAdr.HL
                PUSH IY
                POP DE
                OR A
                SBC HL, DE
                JR NZ, .ContextChanged

                LD A, (IY + FObject.Class)
                CP OBJECT_CLASS_CHARACTER
                JR NZ, .ContextChanged
                BIT OBJECT_PENDING_KILL_STATE_BIT, (IY + FObject.Flags)
                JR NZ, .ContextChanged
                LD A, B
                CP (IY + FObjectCharacter.CharacterID)
                JR NZ, .ContextChanged

                ; инициализация живого объекта персонажа
                EX AF, AF'                                                      ; восстановить длину пути
                LD C, A
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
                LD A, C
                INC A                                                           ; PathID -> количество FPath
                ADD A, A    ; x2
                ADD A, A    ; x4
                LD C, A
                LD B, #00                                                       ; BC = размер пути; B выше содержал SelectedHeroID

                ; копирование пути в буфер
                LD HL, Adr.SortBuffer                                           ; т.к. обновление UI и обработка событий,
                                                                                ; происходит перед отрисовкой, данный буфер свободный
                                                                                ; для временного хранения
                LD DE, Adr.HeroPath
                CALL Memcpy.FastLDIR

                LD A, #01
                EX AF, AF'                                                      ; результат переживает возврат страницы
                RET

.ContextChanged
                ; ToDo: диагностическое событие устаревшего route context;
                ; штатно недостижимо, пока мир остановлен синхронным поиском
                XOR A
                EX AF, AF'
                RET

                endif ; ~_CHARACTER_PATH_INITIALIZE_
