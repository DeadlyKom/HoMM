
                ifndef _MODULE_WORLD_UI_HANDLER_GAME_WINDOW_
                define _MODULE_WORLD_UI_HANDLER_GAME_WINDOW_
; -----------------------------------------
; обработчик UI элемента "игрового окна"
; In:
;   флаг переполнения Carrry сброшен, если  таймера подсказки обнулился
; Out:
; Corrupt:
; Note:
; -----------------------------------------
GameWindow:     ; проверка клавиши "выбор"
                LD A, (GameConfig.KeySelect)
                CALL Input.CheckKeyState
                RET NZ                                                          ; выход, если не нажата клавиша "выбор"

                ; ToDo: в зависимости от действий игрока GameState.PlayerActions
                ;       меняем поведение, пока только одно выбор гексагона!

                ; копировать объект "герой"
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                LD E, A
                LD DE, Adr.ExtraBuffer
                EXX
                LD A, Page.Object
                LD HL, Hero.Utilities.MemcpyObject
                CALL Func.CallAnotherPage
                ;   IX - адрес героя            (FHero)
                ;   IY - адрес объекта героя    (FObjectHero)

                CALL World.Hexagon.GetPosByMouse                                ; определение позиции гексагона под курсором мыши

                ; координаты выбранного героя
                LD L, (IY + FObjectHero.Super.Position.X.High)
                LD H, (IY + FObjectHero.Super.Position.Y.High)

                ; сравнение позиций
                OR A
                SBC HL, BC
                RET Z                                                           ; выход, если позиции совпадают
                ADD HL, BC

                ; проверка на перемещение по оси Y, необходимо учитывать чётность осиY
                LD A, B
                SUB H
                JR Z, $+4
                LD A, #0C   ; INC C
                LD (.AxisAdjust), A                                             ; NOP/INC C

                ; проверка длины шага
                PUSH BC
                EX DE, HL
                CALL World.Hexagon.Distance                                     ; определение расстояния между гексагонами
                DEC A
                POP BC
                RET NZ

                ; определение индекса Render-буфера по координатам гексагона
                PUSH BC
                LD D, B
                LD E, C
                EXX
                LD A, Page.Page1
                LD HL, BufferUtilities.GetHextileIDByCoord.Wrap
                CALL Func.CallAnotherPage
                ; ToDo построеть очередь для перемещения от текущего WayPoint'а
                ;      к указанному, на основе координат назначения

                POP BC
                LD HL, Adr.SortBuffer                                           ; т.к. обновление UI и обработка событий,
                                                                                ; происходит перед отрисовкой, данный буфер свободный
                                                                                ; для временного хранения
                ; корректировка значения, позволяет корректно в
                ; tick'е считать направление (Directon) персонажа
                BIT 0, B
                JR Z, $+3
.AxisAdjust     EQU $
                INC C

                LD (HL), C      ; FPath.HexCoord.X
                INC L
                LD (HL), B      ; FPath.HexCoord.Y
                INC L
                EX AF, AF'
                LD (HL), A      ; FPath.HextileID
                INC L
                LD (HL), #00    ; FPath.WayPointIdx (пока нулевой)
                
                ; инициализация пути героя
                LD C, #01       ; длина пути в массиве
                EXX
                LD A, Page.Page0
                LD HL, Hero.PathInitialize.Wrap
                JP Func.CallAnotherPage

                endif ; ~_MODULE_WORLD_UI_HANDLER_GAME_WINDOW_
