
                ifndef _HERO_PATH_INITIALIZE_
                define _HERO_PATH_INITIALIZE_
; -----------------------------------------
; инициализация пути (обёртка)
; In:
;   C' - длина пути
;   IX - адрес героя            (FHero)
;   IY - адрес объекта героя    (FObjectHero)
; Out:
; Corrupt:
; Note:
;   код расположен рядом с картой (страница 0)
; -----------------------------------------
PathInitialize.Wrap:
                EXX
; -----------------------------------------
; инициализация пути
; In:
;   C  - длина пути
;   IX - адрес героя            (FHero)
;   IY - адрес объекта героя    (FObjectHero)
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   код расположен рядом с картой (страница 0)
; -----------------------------------------
PathInitialize  ; сохранение длины пути
                LD A, C
                EX AF, AF'
                
                ; инициализация героя в буфере
                DEC C                                                           ; начинается с -1
                LD (IY + FObjectHero.PathID), C

                ; копирования данных из буфера в массив
                PUSH IY
                PUSH IX
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                CALL Hero.Utilities.GetHeroAdr
                
                ; копирование FHero
                PUSH IX
                POP DE
                POP HL
                LD BC, HERO_SIZE
                CALL Memcpy.FastLDIR

                ; копирование FObjectHero
                PUSH IY
                POP DE
                POP HL
                LD C, OBJECT_SIZE
                CALL Memcpy.FastLDIR

                ; ToDo: FObjectHero.WayPointID по идее должен не изменяться,
                ;       т.к. он отражает текущее положение на гексагоне

                ; расчёт размер копируемых данных, длина пути (С) * FPath
                EX AF, AF'
                ADD A, A    ; x2
                ADD A, A    ; x4
                LD C, A

                ; копирование пути в буфер
                LD HL, Adr.SortBuffer                                           ; т.к. обновление UI и обработка событий,
                                                                                ; происходит перед отрисовкой, данный буфер свободный
                                                                                ; для временного хранения
                LD DE, Adr.HeroPath
                JP Memcpy.FastLDIR

                endif ; ~_HERO_PATH_INITIALIZE_
