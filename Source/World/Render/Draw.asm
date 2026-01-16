
                ifndef _WORLD_RENDER_DRAW_
                define _WORLD_RENDER_DRAW_
; -----------------------------------------
; отображение "мира"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Draw:           ; -----------------------------------------
                ; точка входа отображения
                ; -----------------------------------------

.Transiton      ; -----------------------------------------
                ; переход между меню
                ; -----------------------------------------
                CHECK_MAIN_FLAG ML_TRANSITION_BIT
                JR Z, .Enter

.Enter          ; -----------------------------------------
                ; первичная инициализация
                ; -----------------------------------------
                CHECK_MAIN_FLAG ML_ENTER_BIT
                JR Z, .Update

                ; сброс возможности восстановления фона курсора
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                LD HL, Adr.TempBuffer + 2
                LD (HL), #00

                ; первичная инициализация локации
                LD HL, Adr.Hextile
                LD (GameSession.WorldInfo + FWorldInfo.Tilemap), HL

                ; принудительное обновление Tilemap- и Render-буферов
                SET_PAGE_WORLD                                                  ; включить страницу работы с картой "мира"
                CALL World.Base.Tilemap.Update.RenderBuffer
                CALL World.Base.Tilemap.Update.TileBuffer
                CALL Draw.HexDLGeneration
                CALL Reset

.Update         ; -----------------------------------------
                ; обновление
                ; -----------------------------------------
                CHECK_MAIN_FLAG ML_UPDATE_BIT
                JR Z, .Tick

.Tick           ; -----------------------------------------
                ; тик
                ; -----------------------------------------

                ; -----------------------------------------
                ; ⚠️ холодный запуск:
                ;    1. принудительно выставить адрес левого верхнего угла отображаемой карты
                ;       данные о центрировании карты могут браться из метаданных карты и/или иным способом
                ;    2. принудительное копирование в Tilemap-буфер из тайловой карты на странице 1
                ;    3. принудительное выставление флагов в Render-буфере
                ;       формируется для каждого тайла
                ;
                ; ⚠️ горячий запуск:
                ;    не должен самовозбуждать флаги обновления в Render-буфере,
                ;    дабы снизить нагрузку на обновление экрана
                ;
                ; ℹ️ цикл обновления экрана:
                ;    1. в выставленные тайминги скролла проверить вектор движения карты,
                ;       обновить адрес левого верхнего угла отображаемой карты
                ;    2. принудительное обновление Tilemap- и Render-буферов по необходимости,
                ;       если адрес левого верхнего угла отображения карты изменился
                ;       * Tilemap-буфер копируется из тайловой карты на странице 1
                ;       * Render-буфер формируется для каждого тайла, где:
                ;         - выставляется флаг HU (принудительного обновления гексагона)
                ;         - копируется флаг FG (тумана, 0 — гексагон закрашен туманом целиком)
                ;           из буфера метаданных карты
                ;         - номер анимации гексагона устанавливается в ноль,
                ;           в последующих шагах он будет модифицирован
                ;       * Render-буфер для каждого столбца гексагона выставляется флаг CU
                ;           необходимости обновить столбец гексагона (0 - обновление столбца не требуется)
                ;    3. применение внешних событий изменения/обновления гексагонов
                ;       * основной список гексагон-объектов,
                ;         которые обязаны менять анимацию каждый тик гексагонов
                ;         каждый такой объект имеет информацию о количестве анимаций в цикле
                ;       * дополнительный список гексагон-объектов,
                ;         которые рандомно выбираются из доступных на экране
                ;         каждый такой объект после проигрывания одного цикла анимации
                ;         удаляется из списка
                ;    4. отображение гексагонов
                ;    5. отображение объектов на карте
                ;       * список динамических объектов влияет на флаг HU (принудительного обновления гексагона)
                ;         спрайты героя, VFX заклинаний и т.п.
                ;    6. отображение тумана на видимых гексагонах
                ;    7. копирование узора рамки на игровой части экрана
                ;    8. анализ флагов HU (принудительного обновления гексагона) и высот гексагонов,
                ;       позволяет определить, какие экранные блоки требуется копировать в теневой экран
                ;       * выставленный флаг HU говорит о том, что гексагон изменился
                ;         используя высоты гексагона, можно определить,
                ;         какие соседние экранные блоки были задеты,
                ;         и на их основе формируются флаги обновления грязных экранных блоков
                ;       * экранные блоки копируются в теневой экран
                ;
                ; ℹ️ цикл обновления курсора:
                ;    1. если не требуется копирование из основного экрана в теневой:
                ;       ⚠️ важно: обязательно в начале прерывания (избежать сечения луча)
                ;       * восстанавливаем фон под курсором (в теневом экране), если он имеется
                ;       * отображаем курсор в новой позиции (в теневом экране)
                ;       ℹ️ ToDo: можно избежать этого пункта,
                ;           если предыдущая анимация и положение не изменились
                ;       * любая логика прерывания
                ;    2. буферный экран (основной) готов копироваться в теневой экран
                ;       * включить в адресном пространстве #C000–#FFFF страницу 7
                ;         (с теневым экраном)
                ;       * отображаем курсор в новой позиции (в основном экране)
                ;       * переключаемся на отображение основного экрана
                ;         (теневой экран перестаёт быть видимым)
                ;       * на странице 7 расположен код копирования экранных блоков,
                ;         буфер под курсор и другие необходимые массивы
                ;         (гексагон-объектов и т.п.)
                ;         копируются блоки экрана в теневой
                ;         (ℹ️ сечение луча не страшен)
                ;       * отображаем курсор в новой позиции (в теневом экране)
                ;       * переключаемся на отображение теневого экрана
                ;         (основной экран перестаёт быть видимым)
                ;       * восстановить фон в основном экране под курсором
                ;       * сброс флагов готовности экрана
                ; -----------------------------------------

                ; -----------------------------------------
                ; обновление позиции карты
                CHECK_INPUT_TIMER_FLAG SCROLL_MAP_BIT
                CALL NZ, World.Base.Tilemap.UpdateMovement
                ; -----------------------------------------
                ; обновление Tilemap- и Render-буферов
                SET_PAGE_WORLD                                                  ; включить страницу работы с картой "мира"
                CHECK_VIEW_FLAG UPDATE_RENDER_BUF_BIT
                CALL NZ, World.Base.Tilemap.Update.RenderBuffer
                CHECK_VIEW_FLAG UPDATE_TILEMAP_BUF_BIT
                CALL NZ, World.Base.Tilemap.Update.TileBuffer
                ; -----------------------------------------
                CALL Fog.Make
                CALL Fog.Tick
                ; -----------------------------------------

                RESTORE_BC                                                      ; защитная от порчи данных с разрешённым прерыванием
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана

                ; CALL Draw.Hex.World
                CALL Draw.HexByDL

                ; CALL World.Base.Tilemap.VisibleObjects                          ; определение видимых объектов - ОТКЛ
                ; CALL NZ, Object.Draw                                            ; отображение объектов в массиве SortBuffer - ОТКЛ

                ifdef _DEBUG
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                CALL Convert.SetBaseScreen                                      ; установка работы с основным экраном
                ; -----------------------------------------
                ; отображение позиции мыши на экране
                LD DE, #1700
                CALL Console.SetCursor
                LD A, (Mouse.PositionX)
                CALL Console.DrawByte
                LD A, ','
                CALL Console.DrawChar
                LD A, (Mouse.PositionY)
                CALL Console.DrawByte
                ; -----------------------------------------

                ; -----------------------------------------
                ; отображение позиции карты (горизонталь)
                LD DE, #1706
                CALL Console.SetCursor
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.X)
                CALL Console.DrawByte
                LD A, (GameSession.WorldInfo + FWorldInfo.MapOffset.X)
                CALL Console.DrawHalfByte
                LD A, ','
                CALL Console.DrawChar
                ; отображение позиции карты (вертикаль)
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.Y)
                CALL Console.DrawByte
                LD A, (GameSession.WorldInfo + FWorldInfo.MapOffset.Y)
                CALL Console.DrawHalfByte
                ; -----------------------------------------
                
                ; ; -----------------------------------------
                ; ; отображение размера видимой области в чанках
                ; LD DE, #170C
                ; CALL Console.SetCursor
                ; LD A, (World.Base.Tilemap.VisibleObjects.VisibleSize + 0)
                ; CALL Console.DrawByte
                ; LD A, ','
                ; CALL Console.DrawChar
                ; LD A, (World.Base.Tilemap.VisibleObjects.VisibleSize + 1)
                ; CALL Console.DrawByte
                ; ; -----------------------------------------

                ; ; -----------------------------------------
                ; ; отображение количество видимых объектов
                ; LD DE, #1712
                ; CALL Console.SetCursor
                ; LD A, (World.Base.Tilemap.VisibleObjects.Num)
                ; CALL Console.DrawByte
                ; ; -----------------------------------------

                endif

                RES_ALL_MAIN_FLAGS                                              ; сброс всех флагов
                SET_RENDER_FLAG FINISHED_BIT                                    ; установка флага завершения отрисовки
                JP World.Base.Event.Handler                                     ; обработчик событий
Fog.Make:       LD HL, MakeCounter
                DEC (HL)
                RET NZ

                LD A, R
                AND %00000111
                ADD A, #06
                LD (HL), A
                
                LD A, (BufferNum)
                OR A
                RET Z
                EX AF, AF'

                EXX
                ; A = rand() % 40
                CALL Math.Rand8
                ; -----------------------------------------
                ; деление D на E
                ; In:
                ;   D - делимое
                ;   E - делитель
                ; Out:
                ;   D - результат деления (D / E)
                ;   A - остаток (D % E)
                ; Corrupt:
                ;   D, AF
                ; -----------------------------------------
                LD D, A
                LD E, 40-5
                CALL Math.Div8x8                                                ; mod
                EXX
                ; LD A, 6
                LD E, A

                LD BC, 10
                LD HL, Buffer

                ; поиск одинакового индекса
.IdxLoop        CPI
                RET Z               ; есть такой индекс
                JP PE, .IdxLoop

                ; поиск свободного индекса
                EX AF, AF'
                LD C, A
                LD A, #FF
                DEC HL

.FreeLoop       CPD
                JR Z, .Make         ; есть свободный индекс
                JP PE, .FreeLoop
                RET

.Make           ; сохраним индекс
                INC HL
                LD D, HIGH Adr.RenderBuffer
                ; -----------------------------------------
                ; обновление вокруг указанного гексагона
                ; In:
                ;   A - индекс в рендер буфере (0-39)
                ; Out:
                ; Corrupt:
                ;   IX, HL', D', BC', AF, AF'
                ; Note:
                ;   код расположен рядом с картой (страница 1)
                ; -----------------------------------------
                CALL Update
                RET C

                LD (HL), E

                LD A, %10001111
                LD (DE), A

                LD A, (BufferNum)
                DEC A
                LD (BufferNum), A
                RET

Fog.Tick:       LD HL, TickCounter
                DEC (HL)
                RET NZ
                LD (HL), #08

                LD A, (BufferNum)
                LD B, A
                LD A, 10
                SUB B
                RET Z

                LD B, A
                LD HL, Buffer-1
                LD D, HIGH Adr.RenderBuffer

.Loop           INC HL
                LD A, (HL)
                CP #FF
                JR Z, .Loop

                LD E, A

                LD A, (DE)
                AND %00000111
                DEC A
                JP P, .SetFog

                LD (HL), #FF
                LD A, (BufferNum)
                INC A
                LD (BufferNum), A

                LD A, %10000000
                JR .Set

.SetFog         OR %10001000
.Set            LD (DE), A

                ; -----------------------------------------
                ; обновление вокруг указанного гексагона
                ; In:
                ;   A - индекс в рендер буфере (0-39)
                ; Out:
                ; Corrupt:
                ;   IX, HL', D', BC', AF, AF'
                ; Note:
                ;   код расположен рядом с картой (страница 1)
                ; -----------------------------------------
                CALL Update
                DJNZ .Loop
                RET

; Copy:           LD A, (BufferNum)
;                 LD B, A
;                 LD A, 10
;                 SUB B
;                 RET Z
;
;                 LD B, A
;                 LD HL, Buffer-1
;                 LD D, HIGH Adr.RenderBuffer
;
; .Loop           INC HL
;                 LD A, (HL)
;                 CP #FF
;                 JR Z, .Loop
;
;                 LD E, A
;                 LD A, (DE)
;                 BIT 6, A
;                 JR NZ, .Next
;
; .Next           DJNZ .Loop
;                 RET

Reset:          LD HL, Buffer
                LD A, 10
                LD (BufferNum), A
                LD B, A
.Loop           LD (HL), #FF
                INC HL
                DJNZ .Loop
                RET

Update:         PUSH DE
                LD A, E
                EXX
                ; -----------------------------------------
                ; определение адреса Render-буфера по индексу гексагона
                ; In:
                ;   A - индекс в рендер буфере (0-39)
                ; Out:
                ;   B - -1/0 чётность, нечётность строки
                ;   C - ширина (оставшиеся/целая) гексагона
                ;   A - найденый индекс/смещение в рендер буфере обрабатываемого гексагона +80
                ; Corrupt:
                ;   IX, D, BC, AF, AF'
                ; Note:
                ;   код расположен рядом с картой (страница 1)
                ; -----------------------------------------
                CALL UtilsBuffer.GetRender                                      ; обновление адреса Render-буфера по индексу гексагона
                POP HL
                EXX
                RET C
                
                EXX
                LD D, H
                LD E, L
                LD L, A
                PUSH BC

.CalcOffset     ; расчёт смещения верёд/назад
                LD A, B
                NEG
                ADD A, TILEMAP_WIDTH_DATA
                LD C, A     ; назад
                LD A, B
                ADD A, TILEMAP_WIDTH_DATA
                LD B, A     ; вперёд

.SetFlagUpdate  ; вперёд
                LD A, E
                ADD A, B
                LD B, E
                CP 40
                EX DE, HL
                JR NC, .Back1

                LD L, A
                SET 7, (HL)
                INC A
                CP 40
                JR NC, .Back1

                LD L, A
                SET 7, (HL)
.Back1          EX DE, HL

                ; назад
                LD A, B
                SUB C
                LD E, A
                EX DE, HL
                JP M, .Back2

                SET 7, (HL)
.Back2          INC L
                JP M, .Back3

                SET 7, (HL)
.Back3          EX DE, HL

                POP BC
                LD B, C
.Loop           LD (HL), #01    ; текущий тайл

                ; тайл ниже
                LD A, L
                ADD A, 22
                JR C, .L1
                LD E, A
                EX DE, HL
                SET 0, (HL)
                SET 1, (HL)
                EX DE, HL
.L1
                ; тайл выше
                LD A, L
                SUB 22
                CP 80
                JR C, .L3
                LD E, A
                EX DE, HL
                SET 0, (HL)
                RES 1, (HL)
                EX DE, HL
.L3
                INC L
                DJNZ .Loop
                EXX

                OR A
                RET

Buffer          DS 10, #FF
BufferNum       DB 10
MakeCounter     DB #03
TickCounter     DB #03

                display " - Main draw:\t\t\t\t\t\t", /A, Draw, "\t= busy [ ", /D, $-Draw, " byte(s)  ]"

                endif ; ~_WORLD_RENDER_DRAW_
