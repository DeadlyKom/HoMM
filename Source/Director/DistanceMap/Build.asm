                
                ifndef _AI_DIRECTOR_DISTANCE_MAP_BUILD_
                define _AI_DIRECTOR_DISTANCE_MAP_BUILD_
; -----------------------------------------
; формирование карты расстояний до дорог и поселений
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IY
; Note:
;   код расположен в общей памяти
; -----------------------------------------
Build:          ; инициализация
                RES_FLAG_MODIFY Build.ChangedFlag                               ; сброс флага обновления расстояния
                LD DE, Adr.DistanceMap

                ; инициализация счётчика оси Y
                LD A, (GameSession.MapSize.Height)
                LD IYH, A

.VerticalLoop   ; инициализация счётчика оси X
                LD A, (GameSession.MapSize.Width)
                LD IYL, A

.HorizontalLoop ; IYL — количество оставшихся гексов по оси X, включая текущий
                ; IYH — количество оставшихся строк по оси Y, включая текущую
                
.Left           ; проверка наличия левого соседа
                LD A, (GameSession.MapSize.Width)
                CP IYL
                JR Z, .Right                                                    ; переход, если гексагон не имеет левого соседа
                
                ; инициализация проверки левого соседа
                LD H, D
                LD L, E
                DEC HL

                ; DE  - текущий гекс
                ; HL  - соседний гекс   (левый)
                CALL UpdateFromNeighbor

.Right          ; проверка наличия правого соседа
                LD A, IYL
                DEC A
                JR Z, .Vertical                                                 ; переход, если гексагон не имеет правого соседа

                ; инициализация проверки правого соседа
                LD H, D
                LD L, E
                INC HL

                ; DE  - текущий гекс
                ; HL  - соседний гекс   (правый)
                CALL UpdateFromNeighbor

.Vertical       ; проверка наличия верхних соседей
                LD A, (GameSession.MapSize.Height)
                CP IYH
                CALL NZ, .Up                                                    ; вызов, если у гексагона есть верхние соседи

                ; проверка наличия нижних соседей
                LD A, IYH
                DEC A
                CALL NZ, .Down                                                  ; вызов, если у гексагона есть нижние соседи

                ; переход к следующему элементу карты расстояний
                INC DE

                ; уменьшение счётчика гексов по горизонтали
                DEC IYL
                JR NZ, .HorizontalLoop                                          ; переход, если счётчик не обнулён

                ; уменьшение счётчика строк по вертикали
                DEC IYH
                JR NZ, .VerticalLoop                                            ; переход, если счётчик не обнулён

                ; продвижение прогресса после полного волнового прохода
                PROGRESS_PERCENT_FIXED DIRECTOR_PROGRESS_DISTANCE_BUILD_STEP
                CALL Session.SharedCode.Director.ProgressIncrement

.ChangedFlag    FLAG_MODIFY 0                                                   ; флаг обновления расстояния
                JR C, Build                                                     ; переход, если было зафиксировано изменение расстояния

                ; установка точного порога завершения карты расстояний
                PROGRESS_PERCENT_FIXED DIRECTOR_PROGRESS_DISTANCE_BUILD_END
                JP Session.SharedCode.Director.ProgressToPercent
; -----------------------------------------
; проверка двух соседей в верхней строке
; In:
;   DE — адрес текущего гекса
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   вычисление адреса гекса (X, Y-1)
; -----------------------------------------

.Up             ; инициализация адреса верхнего гекса
                LD H, D
                LD L, E

                ; BC = ширина строки
                LD A, (GameSession.MapSize.Width)
                LD C, A
                XOR A
                LD B, A

                ; HL = DE - Width
                SBC HL, BC

                ; HL — соседний гекс (X, Y-1)
                JP .VerticalPair
; -----------------------------------------
; проверка двух соседей в нижней строке
; In:
;   DE — адрес текущего гекса
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   вычисление адреса гекса (X, Y+1)
; -----------------------------------------
.Down           ; инициализация адреса нижнего гекса
                LD H, D
                LD L, E

                ; BC = ширина строки
                LD A, (GameSession.MapSize.Width)
                LD C, A
                LD B, #00

                ; HL = DE + Width
                ADD HL, BC

                ; HL — соседний гекс (X, Y+1)
; -----------------------------------------
; проверка пары соседей в верхней или нижней строке
; In:
;   DE  — адрес текущего гекса
;   HL  — адрес гекса (X, Y±1)
;   IYL — счётчик оси X
;   IYH — счётчик оси Y
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   координата текущей строки определяется по формуле:
;       Y = Height - IYH
;
;   поскольку IYH является обратным счётчиком,
;   чётность координаты определяется по формуле:
;       (Height XOR IYH) AND #01
; -----------------------------------------
.VerticalPair   ; определение чётности текущей строки
                LD A, (GameSession.MapSize.Height)
                XOR IYH
                AND #01
                JR NZ, .OddRow                                                  ; переход, если строка нечётная

                ; -----------------------------------------
                ; для чётной строки необходимо проверить:
                ;   (X-1, Y±1)
                ;   (X,   Y±1)
                ; -----------------------------------------

                ; проверка наличия соседа слева (X-1, Y±1)
                LD A, (GameSession.MapSize.Width)
                CP IYL
                JP Z, UpdateFromNeighbor                                        ; переход к проверке единственного соседа, если X == 0
                                                                                ; DE — текущий гекс
                                                                                ; HL — единственный соседний гекс (X, Y±1)
                ; инициализация проверки соседа слева (X-1, Y±1)
                DEC HL
                PUSH HL

                ; DE — текущий гекс
                ; HL — соседний гекс (X-1, Y±1)
                CALL UpdateFromNeighbor

                POP HL
                INC HL

                ; DE — текущий гекс
                ; HL — соседний гекс (X, Y±1)
                JP UpdateFromNeighbor

.OddRow         ; -----------------------------------------
                ; для нечётной строки необходимо проверить:
                ;   (X,   Y±1)
                ;   (X+1, Y±1)
                ; -----------------------------------------

                PUSH HL

                ; DE — текущий гекс
                ; HL — соседний гекс (X, Y±1)
                CALL UpdateFromNeighbor

                POP HL

                ; проверка наличия соседа (X+1, Y±1)
                LD A, IYL
                DEC A
                RET Z                                                           ; возврат, если X == Width - 1:
                                                                                ; сосед (X+1, Y±1) отсутствует
                INC HL

                ; DE — текущий гекс
                ; HL — соседний гекс (X+1, Y±1)
                JP UpdateFromNeighbor

                endif ; ~_AI_DIRECTOR_DISTANCE_MAP_BUILD_
