
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
                LD HL, Adr.CursorStorageA
                LD (HL), #00                                                    ; 0 байт хранит данные о размере заполнения
                CALL ScreenBlock.Clear                                          ; очистка screen block'ов

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
                ; CALL Fog.Make
                ; CALL Fog.Tick
                ; -----------------------------------------

                CALL PipelineHexagons

                ifdef _DEBUG
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                CALL Convert.SetBaseScreen                                      ; установка работы с основным экраном
                ; ; -----------------------------------------
                ; ; отображение screen block'ов
                ; LD DE, #031A
                ; CALL Console.SetCursor
                ; LD HL, Adr.ScreenBlock + 0
                ; CALL DrawScreenBlock
                ; LD DE, #041A
                ; CALL Console.SetCursor
                ; LD HL, Adr.ScreenBlock + 1
                ; CALL DrawScreenBlock
                ; LD DE, #051A
                ; CALL Console.SetCursor
                ; LD HL, Adr.ScreenBlock + 2
                ; CALL DrawScreenBlock
                ; LD DE, #061A
                ; CALL Console.SetCursor
                ; LD HL, Adr.ScreenBlock + 3
                ; CALL DrawScreenBlock
                ; ; -----------------------------------------

                ; ; -----------------------------------------
                ; ; отображение позиции мыши на экране
                ; LD DE, #1700
                ; CALL Console.SetCursor
                ; LD A, (Mouse.PositionX)
                ; CALL Console.DrawByte
                ; LD A, ','
                ; CALL Console.DrawChar
                ; LD A, (Mouse.PositionY)
                ; CALL Console.DrawByte
                ; ; -----------------------------------------

                ; -----------------------------------------
                ; отображение позиции карты (горизонталь)
                LD DE, #0919
                CALL Console.SetCursor
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.X)
                CALL Console.DrawByte
                LD A, (GameSession.WorldInfo + FWorldInfo.MapOffset.X)
                CALL Console.DrawHalfByte
                ; отображение позиции карты (вертикаль)
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.Y)
                CALL Console.DrawByte
                LD A, (GameSession.WorldInfo + FWorldInfo.MapOffset.Y)
                CALL Console.DrawHalfByte
                ; -----------------------------------------
                
                ; ; ; -----------------------------------------
                ; ; ; отображение размера видимой области в чанках
                ; ; LD DE, #170C
                ; ; CALL Console.SetCursor
                ; ; LD A, (World.Base.Tilemap.VisibleObjects.VisibleSize + 0)
                ; ; CALL Console.DrawByte
                ; ; LD A, ','
                ; ; CALL Console.DrawChar
                ; ; LD A, (World.Base.Tilemap.VisibleObjects.VisibleSize + 1)
                ; ; CALL Console.DrawByte
                ; ; ; -----------------------------------------

                ; ; ; -----------------------------------------
                ; ; ; отображение количество видимых объектов
                ; ; LD DE, #1712
                ; ; CALL Console.SetCursor
                ; ; LD A, (World.Base.Tilemap.VisibleObjects.Num)
                ; ; CALL Console.DrawByte
                ; ; ; -----------------------------------------

                endif

                RES_ALL_MAIN_FLAGS                                              ; сброс всех флагов
                JP World.Base.Event.Handler                                     ; обработчик событий
; DrawScreenBlock:
;                 CALL .Cell
;                 LD A, L
;                 ADD A, #04
;                 LD L, A
;                 CALL .Cell
;                 LD A, L
;                 ADD A, #04
;                 LD L, A
;                 CALL .Cell
;                 LD A, L
;                 ADD A, #04
;                 LD L, A
; .Cell           PUSH HL
;                 LD A, (HL)
;                 CP #10
;                 JR C, $+4
;                 LD A, #0F
;                 CALL Console.DrawHalfByte
;                 POP HL
;                 RET
Fog.Make:       LD HL, MakeCounter
                DEC (HL)
                RET NZ

                LD A, R
                AND %00000111
                ADD A, #0A
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
                ; LD A, 0
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
                CALL UtilsBuffer.UpdateHextile
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
                LD (HL), #04

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
                CALL UtilsBuffer.UpdateHextile
                DJNZ .Loop
                RET
Reset:          LD HL, Buffer
                LD A, 10
                LD (BufferNum), A
                LD B, A
.Loop           LD (HL), #FF
                INC HL
                DJNZ .Loop
                RET

Buffer          DS 10, #FF
BufferNum       DB 10
MakeCounter     DB #03
TickCounter     DB #03

                display " - Main draw:\t\t\t\t\t\t", /A, Draw, "\t= busy [ ", /D, $-Draw, " byte(s)  ]"

                endif ; ~_WORLD_RENDER_DRAW_
