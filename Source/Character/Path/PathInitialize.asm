
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
;   каждому персонажу-человеку с CharacterID [0..3] соответствует собственный
;   слот из восьми элементов FPath в Adr.HeroPath;
;   ℹ️ код расположен в странице 0
; -----------------------------------------
                if HERO_PATH_SLOT_CAPACITY != 8
                error "PathInitialize requires an 8-element HeroPath slot"
                endif
                if FPath != 4
                error "PathInitialize requires a 4-byte FPath"
                endif
                if HERO_PATH_SLOT_COUNT * HERO_PATH_SLOT_CAPACITY * FPath != Size.HeroPath
                error "HeroPath slots do not match Size.HeroPath"
                endif
PathInitialize: ; сохранение длины пути
                LD A, C
                EX AF, AF'

                ; CharacterID персонажа-человека напрямую определяет его слот HeroPath
                LD E, (IY + FObjectCharacter.CharacterID)

                ifdef _DEBUG
                LD A, E                                                         ; номер слота HeroPath
                CP HERO_PATH_SLOT_COUNT
                DEBUG_BREAK_POINT_NC                                            ; ошибка, CharacterID персонажа-человека не входит в диапазон [0..3]
                endif

                ; восстановить длину пути в C, сохранив её также в AF'
                EX AF, AF'
                LD C, A
                EX AF, AF'

                ; отменить предыдущий путь и очистить незавершённое движение
                CALL PathCancel

                ; инициализация объекта персонажа
                LD A, E
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8                                                ; первый абсолютный индекс слота
                LD E, A
                ADD A, C
                DEC A                                                           ; текущий FPath = slot * 8 + length - 1
                LD (IY + FObjectCharacter.PathID), A

                ; ToDo: определить общее размещение WayPointID для player/AI
                ;       индекс должен сохранять положение внутри маршрута независимо от текущего гексагона

                ; адрес начала собственного слота: Adr.HeroPath + slot * 32
                LD A, E
                ADD A, A    ; x16
                ADD A, A    ; x32
                ADD A, LOW Adr.HeroPath
                LD E, A
                LD D, HIGH Adr.HeroPath

                ; расчёт размера копируемых данных: длина пути * FPath
                EX AF, AF'
                ADD A, A    ; x2
                ADD A, A    ; x4
                LD C, A
                LD B, #00                                                       ; BC = размер пути

                ; копирование пути из временного буфера в слот персонажа
                LD HL, Adr.SortBuffer                                           ; т.к. обновление UI и обработка событий,
                                                                                ; происходит перед отрисовкой, данный буфер свободный
                                                                                ; для временного хранения
                JP Memcpy.FastLDIR

                endif ; ~_CHARACTER_PATH_INITIALIZE_
