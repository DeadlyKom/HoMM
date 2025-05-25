
                ifndef _PARTICIPANT_ADD_HERO_
                define _PARTICIPANT_ADD_HERO_
; -----------------------------------------
; добавить героя
; In:
;   HL - стартовая позиция игрока
;   DE - указатель на адрес структуры FHeroSettings
;   IY - указатель на адрес структуры FParticipant
;   C  - идентификатор владельца героем
; Out:
;   флаг переполнения Carry установлен,
;   в случае успешного добавления героя
; Corrupt:
; Note:
; -----------------------------------------
Add_Hero:       ; проверка достижения максимального количества игроков
                LD A, (IY + FParticipant.HeroesNum)                             ; получение индекса доступного элемента в массиве героев у игрока
                CP MAX_PARTICIPANT_HEROES
                RET NC                                                          ; выход, если массив переполнен

                PUSH HL                                                         ; сохранение стартовой позиции игрока
                ; проверка переполнения массива Adr.HeroArray не требуется, т.к.
                ; позволяет вместить максимальное количество героев для каждого игрока
                LD HL, GameSession.WorldInfo + FWorldInfo.HeroNum
                LD B, (HL)                                                      ; чтение свободного идентификатора героя
                INC (HL)                                                        ; увеличение общего счётчика героев в массиве Adr.HeroArray
                PUSH BC                                                         ; сохранение идентификатора героя
                ;--------------------------------------
                ; добавление в массиве героев у игрока идентификатор игрока
                PUSH IY
                POP HL
                LD A, B
                EX AF, AF'                                                      ; сохранение идентификатора героя
                LD BC, FParticipant.Heroes
                ADD HL, BC
                ADD A, L
                LD L, A
                EX AF, AF'                                                      ; восстановление идентификатора героя
                LD (HL), A                                                      ; добавление героя игроку
                INC (IY + FParticipant.HeroesNum)                               ; увеличение счётчика героев у игрока
                ;---------------------------------------------------------------
                ; расчёт адреса распологаемого героя
                ; HL = HERO_SIZE * индекс добовляемого героя (64)
                LD A, B
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, LOW Adr.HeroArray >> 3
                LD L, A
                ADC A, HIGH Adr.HeroArray >> 3
                SUB L
                LD H, A
                ADD HL, HL  ; x8
                ADD HL, HL  ; x16
                ADD HL, HL  ; x32
                ;---------------------------------------------------------------
                ; инициализация FHero
                LD A, (DE)
                INC DE
                LD (HL), A                                                      ; FHero.Class
                INC L
                LD (HL), C                                                      ; FHero.ParticipantID
                INC L
                EX DE, HL
                LD BC, FHeroSkills
                CALL Memcpy.FastLDIR                                            ; копирование FHero.Skils
                EX DE, HL
                ; обнуление FHero.CombatStates и FHero.Equipment
                XOR A
                LD B, FCombatStates + FHeroEquipment
.ClearLoop      LD (HL), A
                INC L
                DJNZ .ClearLoop
                ; -----------------------------------------
                ; спавн объекта
                ; In:
                ;   B  - тип объекта (настройки по умолчанию)
                ;   DE - положение объекта в знакоместах (D - y, E - x)
                ; Out:
                ;   A' - идентификатор объекта
                ;   IX - адрес структуры FObjectDefaultSettings
                ;   IY - адрес структуры FObject (FObjectHero)
                ;   флаг переполнения Carry установлен, если нет свободного места в массиве
                ; Corrupt:
                ;   HL, DE, BC, AF, AF'
                ; Note:
                ; -----------------------------------------
                POP BC                                                          ; восстановление идентификатора героя
                EXX
                LD B, ODS_ID_HERO
                POP DE                                                          ; восстановление стартовой позиции игрока
                CALL Object.Spawn
                EXX
                JR C, .Exit                                                     ; переход, если была ошибка
                                                                                ; пропус инициализации объекта
                LD (IY + FObjectHero.HeroID), B                                 ; установка идентификатора героя
                EX AF, AF'
                LD (HL), A                                                      ; FHero.ObjectID
                EX AF, AF'

.Exit           CCF                                                             ; инверсия флага, после спавна героя
                                                                                ; см. описание спавна
                RET

                display " - Add hero:\t\t\t\t\t\t", /A, Add_Hero, "\t= busy [ ", /D, $-Add_Hero, " byte(s)  ]"

                endif ; ~_PARTICIPANT_ADD_HERO_
