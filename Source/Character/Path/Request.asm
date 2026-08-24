
                ifndef _PATHFINDING_REQUEST_
                define _PATHFINDING_REQUEST_
                module Pathfinding
; -----------------------------------------
; ограниченный поиск пути в ширину  (обёртка)
; In:
;   DE' - начальные координаты (D - y, E - x)
;   BC' - координаты назначения (B - y, C - x)
; Out:
;   A'  - длина найденного пути либо 0 (1..PATHFINDING_MAX_DISTANCE)
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
;   ℹ️ код расположен в странице 1
; -----------------------------------------
Request.Wrap:   EXX
                CALL Request
                EX AF, AF'
                RET
; -----------------------------------------
; ограниченный поиск пути в ширину
;   Red Blob Games: Obstacles - https://www.redblobgames.com/grids/hexagons/#range-obstacles
; In:
;   DE - начальные координаты (D - y, E - x)
;   BC - координаты назначения (B - y, C - x)
; Out:
;   A  - длина найденного пути либо 0 (1..PATHFINDING_MAX_DISTANCE)
; Note:
;   ℹ️ код расположен в странице 1
;
;   IX и IY сохраняются для последующего Character.PathInitialize;
;   для цели дальше PATHFINDING_MAX_DISTANCE полный маршрут НЕ строится:
;   возвращается только достижимый локальный префикс из 8 шагов;
;   дальняя цель не сохраняется и автоматического перепланирования пока нет;
;   ненулевая стоимость поверхности пока означает только "проходимо".
;
;   ToDo(weighted-bounded-search):
;   для выбора маршрута по цене нужно заменить FIFO-BFS на bounded Dijkstra/A* и добавить:
;   gCost[17*17], priority open set, relaxation gCost/parent и отдельный hop count
;   для ограничения в 8 переходов. Существующий .Reconstruct можно оставить.
;   Это даст дешёвые дороги/болота внутри локального радиуса, но само по себе
;   не сделает маршрут глобальным.
; -----------------------------------------
Request:        ; проверить границы начальной и конечной координат
                LD A, (GameSession.MapSize.Height)
                LD H, A
                LD A, D
                CP H
                JP NC, .NotFound
                LD A, (GameSession.MapSize.Width)
                LD H, A
                LD A, E
                CP H
                JP NC, .NotFound
                LD A, (GameSession.MapSize.Height)
                LD H, A
                LD A, B
                CP H
                JP NC, .NotFound
                LD A, (GameSession.MapSize.Width)
                LD H, A
                LD A, C
                CP H
                JP NC, .NotFound

                LD A, B
                LD (.TargetY), A
                LD A, C
                LD (.TargetX), A

                ; сохранить строку старта и преобразовать start odd-r -> axial q
                LD A, D
                LD (.StartR), A
                SRL A
                LD H, A
                LD A, E
                SUB H
                LD (.StartQ), A

                ; относительная axial r цели
                LD A, B
                SUB D
                LD (.TargetR), A

                ; относительная axial q цели
                LD A, B
                SRL A
                LD H, A
                LD A, C
                SUB H                                                           ; A - target axial q
                LD H, A
                LD A, (.StartQ)
                LD L, A
                LD A, H
                SUB L
                LD (.TargetQ), A

                ; старт не является элементом возвращаемого пути
                LD H, A
                LD A, (.TargetR)
                OR H
                JP Z, .NotFound

                ; классифицировать запрос по cube distance до настоящей цели
                LD BC, #0000                                                    ; старт в относительных axial-координатах
                CALL .DistanceToTarget
                LD (.StartDistance), A
                LD (.BestDistance), A
                CP #01
                JP Z, .DirectPath                                               ; соседний гекс не требует BFS

                XOR A
                LD (.BestQ), A
                LD (.BestR), A
                LD (.FarTarget), A                                              ; точная цель находится внутри bounded-области
                LD A, (.StartDistance)
                CP PATHFINDING_MAX_DISTANCE + 1
                JR C, .InitSearch

                LD A, #01
                LD (.FarTarget), A                                              ; построить только локальный префикс к дальней цели

.InitSearch     ; очистить локальную карту родителей значением "не посещён"
                LD HL, Adr.PathfindParents
                LD (HL), PATHFINDING_CELL_UNVISITED
                LD DE, Adr.PathfindParents + 1
                LD BC, Size.PathfindParents - 1
                LDIR

                ; центр локальной карты является стартовой клеткой
                LD HL, Adr.PathfindParents + PATHFINDING_MAX_DISTANCE * PATHFINDING_RANGE_DIAMETER + PATHFINDING_MAX_DISTANCE
                LD (HL), PATHFINDING_CELL_START

                ; первый элемент FIFO: dq=0, dr=0, depth=0
                LD HL, Adr.PathfindQueue
                LD (.HeadPtr), HL
                XOR A
                LD (HL), A
                INC HL
                LD (HL), A
                INC HL
                LD (HL), A
                INC HL
                LD (.TailPtr), HL

.SearchLoop     ; очередь пуста, если head == tail
                LD HL, (.HeadPtr)
                LD DE, (.TailPtr)
                OR A
                SBC HL, DE
                JR Z, .SearchExhausted

                ; извлечь следующий элемент FIFO
                LD HL, (.HeadPtr)
                LD C, (HL)                                                      ; relative q
                INC HL
                LD B, (HL)                                                      ; relative r
                INC HL
                LD A, (HL)                                                      ; depth
                INC HL
                LD (.HeadPtr), HL

                CP PATHFINDING_MAX_DISTANCE
                JR NC, .SearchLoop                                              ; последний слой не расширяется
                LD (.CurrentDepth), A

                ; fixed axial directions; при равной длине BFS сохраняет первого родителя,
                ; поэтому этот порядок является детерминированным tie-break;
                ; A хранит направление от ребёнка к родителю
                PUSH BC
                INC C                                                           ; +1,  0
                LD A, 3
                CALL .TryNeighbor
                POP BC
                JR C, .Found

                PUSH BC
                INC C
                DEC B                                                           ; +1, -1
                LD A, 4
                CALL .TryNeighbor
                POP BC
                JR C, .Found

                PUSH BC
                DEC B                                                           ;  0, -1
                LD A, 5
                CALL .TryNeighbor
                POP BC
                JR C, .Found

                PUSH BC
                DEC C                                                           ; -1,  0
                XOR A
                CALL .TryNeighbor
                POP BC
                JR C, .Found

                PUSH BC
                DEC C
                INC B                                                           ; -1, +1
                LD A, 1
                CALL .TryNeighbor
                POP BC
                JR C, .Found

                PUSH BC
                INC B                                                           ;  0, +1
                LD A, 2
                CALL .TryNeighbor
                POP BC
                JR C, .Found

                JR .SearchLoop

.Found          CALL .Reconstruct
                RET

.SearchExhausted
                LD A, (.FarTarget)
                OR A
                JR Z, .NotFound                                                ; точная цель внутри радиуса не достигнута

                LD A, (.BestDistance)
                LD H, A
                LD A, (.StartDistance)
                CP H
                JR Z, .NotFound                                                ; за восемь шагов приблизиться к цели невозможно

                ; ToDo(long-route), варианты расширения:
                ;   1. Построить глобальный путь до TargetX/TargetY, а в HeroPath скопировать
                ;      только первые 8 шагов. Хранить весь путь не нужно, но global planner
                ;      всё равно потребует workspace для всех исследованных клеток.
                ;      При равной цене шагов достаточно full-map BFS; при разных ценах —
                ;      global Dijkstra/A*. Bounded-поиск не может доказать достижимость дальней цели.
                ;   2. Сохранить дальнюю цель и повторять bounded Request после каждых 8 шагов.
                ;      Это сохранит малый workspace, но может застрять в локальном минимуме
                ;      около больших и U-образных преград.
                LD A, (.BestQ)
                LD (.TargetQ), A
                LD A, (.BestR)
                LD (.TargetR), A
                CALL .Reconstruct
                RET

.DirectPath     ; соседний гекс проходит через ту же политику, что и BFS
                LD A, (.TargetY)
                LD D, A
                LD A, (.TargetX)
                LD E, A
                CALL .CanTraverse
                OR A
                JR Z, .NotFound

                CALL Page1.Buffer.Utilities.GetHextileIDByCoord
                LD HL, Adr.SortBuffer
                LD (HL), E                                                      ; FPath.HexCoord.X
                INC HL
                LD (HL), D                                                      ; FPath.HexCoord.Y
                INC HL
                LD (HL), A                                                      ; FPath.HextileID
                INC HL
                LD (HL), #00                                                    ; FPath.WayPointIdx
                LD A, #01
                RET

.NotFound       XOR A
                RET
; -----------------------------------------
; проверить и добавить соседнюю клетку
; In:
;   BC - относительные axial координаты соседа (B - r, C - q)
;   A  - направление от соседа к родителю (0..5)
; Out:
;   Carry установлен, если добавленная клетка является целью
; Corrupt:
;   HL, DE, AF
; -----------------------------------------
.TryNeighbor    LD (.ParentDirection), A
                CALL .GetParentAdr
                LD A, (HL)
                CP PATHFINDING_CELL_UNVISITED
                JR NZ, .RejectNeighbor
                PUSH HL                                                         ; адрес parent-dir отмечается только после разрешённого ребра

                ; relative axial -> absolute odd-r; одновременно проверить границы
                LD A, (.StartR)
                ADD A, B
                LD D, A                                                         ; absolute y
                LD A, (GameSession.MapSize.Height)
                LD H, A
                LD A, D
                CP H
                JR NC, .RejectNeighborPop
                SRL A
                LD E, A                                                         ; floor(y / 2)
                LD A, (.StartQ)
                ADD A, C
                ADD A, E
                LD E, A                                                         ; absolute x
                LD A, (GameSession.MapSize.Width)
                LD H, A
                LD A, E
                CP H
                JR NC, .RejectNeighborPop

                CALL .CanTraverse
                OR A
                JR Z, .RejectNeighborPop

                ; только успешно пройденная грань делает клетку посещённой;
                ; это оставляет CanTraverse расширяемым до directional edge-check
                POP HL
.ParentDirection EQU $+1
                LD (HL), #00

                ; добавить q, r и глубину в хвост FIFO
                LD HL, (.TailPtr)
                LD (HL), C
                INC HL
                LD (HL), B
                INC HL
.CurrentDepth   EQU $+1
                LD A, #00
                INC A
                LD (HL), A
                INC HL
                LD (.TailPtr), HL

                ; для дальней цели рассматриваются только полные префиксы из 8 шагов
                CP PATHFINDING_MAX_DISTANCE
                JR NZ, .CheckExactTarget
                LD A, (.FarTarget)
                OR A
                JR Z, .CheckExactTarget
                CALL .ConsiderFarTarget
                RET C                                                           ; достигнута теоретически лучшая граница области

                ; ранний выход при первом достижении цели
.CheckExactTarget
                LD A, (.TargetQ)
                CP C
                JR NZ, .RejectNeighbor
                LD A, (.TargetR)
                CP B
                JR NZ, .RejectNeighbor
                SCF
                RET

.RejectNeighborPop
                POP HL
.RejectNeighbor OR A                                                            ; Carry = 0
                RET
; -----------------------------------------
; оценить достижимый гекс восьмого слоя как конец дальнего префикса
; In:
;   BC - относительные axial координаты кандидата (B - r, C - q)
; Out:
;   Carry установлен, если найден теоретический оптимум h(start,target)-8
; Corrupt:
;   HL, DE, AF
; -----------------------------------------
.ConsiderFarTarget
                CALL .DistanceToTarget
                LD H, A                                                         ; H - расстояние кандидата до настоящей цели
                LD A, (.BestDistance)
                CP H
                JR C, .CandidateRejected                                        ; лучший кандидат уже ближе
                JR Z, .CandidateRejected                                        ; равенство сохраняет первый BFS-вариант

                LD A, H
                LD (.BestDistance), A
                LD A, C
                LD (.BestQ), A
                LD A, B
                LD (.BestR), A

                LD A, (.StartDistance)
                SUB PATHFINDING_MAX_DISTANCE
                CP H
                JR NZ, .CandidateRejected

                ; ближе чем h-8 за восемь соседних переходов оказаться невозможно
                LD A, C
                LD (.TargetQ), A
                LD A, B
                LD (.TargetR), A
                SCF
                RET

.CandidateRejected
                OR A                                                            ; Carry = 0
                RET
; -----------------------------------------
; cube distance от относительной клетки до настоящей цели
; In:
;   BC - относительные axial координаты клетки (B - r, C - q)
; Out:
;   A - расстояние в гексагонах
; Corrupt:
;   HL, DE, AF
; -----------------------------------------
.DistanceToTarget
                LD A, (.TargetQ)
                SUB C
                LD D, A                                                         ; signed dq
                JP P, $+5
                NEG
                LD L, A                                                         ; max = abs(dq)

                LD A, (.TargetR)
                SUB B
                LD E, A                                                         ; signed dr
                JP P, $+5
                NEG
                CP L
                JR C, .DistanceCheckSum
                LD L, A                                                         ; max(abs(dq), abs(dr))

.DistanceCheckSum
                LD A, D
                ADD A, E
                JP P, $+5
                NEG                                                             ; abs(dq + dr)
                CP L
                RET NC
                LD A, L
                RET
; -----------------------------------------
; проверить возможность перехода в соседний гекс
; In:
;   DE - абсолютные координаты назначения (D - y, E - x)
; Out:
;   A  - 0 для непроходимой клетки, иначе базовая стоимость поверхности
; Corrupt:
;   HL, AF
; Note:
;   единая точка расширения политики перехода;
;   ToDo: передавать исходный гекс, направление ребра и контекст выбранного героя;
;         проверить занятость объектами, маски входа/выхода граней, воду/реки,
;         способности, экипировку и временные эффекты;
;   ToDo(weighted-bounded-search): разделить "ребро запрещено" и логическую цену ребра;
;   0 означает blocked, ненулевая цена участвует в tentativeG и не зависит
;   от количества визуальных DDA-итераций.
; -----------------------------------------
.CanTraverse:   JP Page1.Buffer.Utilities.GetSurfaceStepCostByCoord
; -----------------------------------------
; получить адрес байта локальной карты родителей
; In:
;   BC - относительные axial координаты (B - r, C - q), диапазон -8..+8
; Out:
;   HL - адрес элемента Adr.PathfindParents
; Corrupt:
;   DE, HL, AF
; -----------------------------------------
.GetParentAdr   LD A, B
                ADD A, PATHFINDING_MAX_DISTANCE
                LD E, A
                LD D, #00
                LD H, D
                LD L, E
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                ADD HL, HL  ; x16
                ADD HL, DE  ; x17
                LD A, C
                ADD A, PATHFINDING_MAX_DISTANCE
                ADD A, L
                LD L, A
                JR NC, $+3
                INC H
                LD DE, Adr.PathfindParents
                ADD HL, DE
                RET
; -----------------------------------------
; восстановить FPath, следуя сохранённым направлениям к старту
; Out:
;   A - длина пути
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
.Reconstruct    LD A, (.TargetQ)
                LD C, A
                LD A, (.TargetR)
                LD B, A
                LD HL, Adr.SortBuffer
                LD (.PathWritePtr), HL
                XOR A
                LD (.PathLength), A

.PathLoop       LD A, B
                OR C
                JR Z, .PathComplete

                ; relative axial -> absolute odd-r
                LD A, (.StartR)
                ADD A, B
                LD D, A                                                         ; absolute y
                SRL A
                LD E, A
                LD A, (.StartQ)
                ADD A, C
                ADD A, E
                LD E, A                                                         ; absolute x

                ; записать FPath в обратном порядке: target ... first step
                LD HL, (.PathWritePtr)
                LD (HL), E                                                      ; FPath.HexCoord.X
                INC HL
                LD (HL), D                                                      ; FPath.HexCoord.Y
                INC HL
                PUSH HL
                CALL Page1.Buffer.Utilities.GetHextileIDByCoord
                POP HL
                LD (HL), A                                                      ; FPath.HextileID
                INC HL
                LD (HL), #00                                                    ; FPath.WayPointIdx
                INC HL
                LD (.PathWritePtr), HL

                LD A, (.PathLength)
                INC A
                LD (.PathLength), A

                ; перейти от текущей клетки к родителю
                CALL .GetParentAdr
                LD A, (HL)
                ADD A, A
                LD E, A
                LD D, #00
                LD HL, .DirectionTable
                ADD HL, DE
                LD A, (HL)
                ADD A, C
                LD C, A
                INC HL
                LD A, (HL)
                ADD A, B
                LD B, A
                JR .PathLoop

.PathComplete
.PathLength     EQU $+1
                LD A, #00
                RET

.DirectionTable ; axial q, r; противоположные направления отличаются на 3
                DB  1,  0
                DB  1, -1
                DB  0, -1
                DB -1,  0
                DB -1,  1
                DB  0,  1

.StartQ         DB #00
.StartR         DB #00
.TargetQ        DB #00
.TargetR        DB #00
.TargetX        DB #00
.TargetY        DB #00
.FarTarget      DB #00
.StartDistance  DB #00
.BestDistance   DB #00
.BestQ          DB #00
.BestR          DB #00
.HeadPtr        DW Adr.PathfindQueue
.TailPtr        DW Adr.PathfindQueue
.PathWritePtr   DW Adr.SortBuffer

                display " - Bounded pathfinding (BFS):\t\t\t\t", /A, Request.Wrap, "\t= busy [ ", /D, $-Request.Wrap, " byte(s) ]"
                endmodule

                endif ; ~_PATHFINDING_REQUEST_
