
                ifndef _WORLD_RENDER_DEBUG_INFO_
                define _WORLD_RENDER_DEBUG_INFO_
; -----------------------------------------
; отладочное отображение информации о мире
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   вызывается после настройки Console для отображения на двух экранах
;   дополнительные блоки включаются соответствующими define в начале файла
; ----------------------------------------
DebugInfo:      CALL .Coordinates
                ifdef DEBUG_INFO_SCREEN_BLOCKS
                CALL .ScreenBlocks
                endif
                ifdef DEBUG_INFO_MOUSE_POSITION
                CALL .MousePosition
                endif
                ifdef DEBUG_INFO_VISIBLE_AREA
                CALL .VisibleArea
                endif
                ifdef DEBUG_INFO_VISIBLE_OBJECTS
                CALL .VisibleObjects
                endif
                RET
; -----------------------------------------
; отображение координат карты и гексагона под курсором
; ----------------------------------------
.Coordinates:
.Coordinates.Flag FLAG_MODIFY 1                                                 ; флаг, необходимости обновления координат
                RET NC                                                          ; выход, если координаты не изменились
                RES_FLAG_MODIFY DebugInfo.Coordinates.Flag                      ; сброс флага, после завершения отрисовки

                SET_REG_ATTR_IPB A, WHITE, BLACK, 0
                CALL Console.SetAttribute

                ; позиция карты
                LD DE, #0D19
                CALL Console.SetCursor
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.X)
                CALL Console.DrawByte
                LD A, (GameSession.WorldInfo + FWorldInfo.MapOffset.X)
                CALL Console.DrawHalfByte
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.Y)
                CALL Console.DrawByte
                LD A, (GameSession.WorldInfo + FWorldInfo.MapOffset.Y)
                CALL Console.DrawHalfByte

                ; гексагон под курсором
                LD DE, #0E1A
                CALL Console.SetCursor
                LD A, (GameSession.WorldInfo + FWorldInfo.Cursor.X)
                CALL Console.DrawByte
                LD A, (GameSession.WorldInfo + FWorldInfo.Cursor.Y)
                JP Console.DrawByte
; -----------------------------------------
; отображение содержимого ScreenBlock
; ----------------------------------------
                ifdef DEBUG_INFO_SCREEN_BLOCKS
.ScreenBlocks:  LD HL, Adr.ScreenBlock
                LD DE, .ScreenBlocks.Value
                LD B, #10
.ScreenBlocks.Compare:
                LD A, (DE)
                CP (HL)
                JR NZ, .ScreenBlocks.Changed
                INC HL
                INC DE
                DJNZ .ScreenBlocks.Compare
                JR .ScreenBlocks.CheckFlag

.ScreenBlocks.Changed:
                LD HL, Adr.ScreenBlock
                LD DE, .ScreenBlocks.Value
                LD BC, #0010
                LDIR
                SET_FLAG_MODIFY DebugInfo.ScreenBlocks.Flag                    ; установка флага, изменения содержимого ScreenBlock

.ScreenBlocks.CheckFlag:
.ScreenBlocks.Flag FLAG_MODIFY 1                                               ; флаг, необходимости обновления содержимого ScreenBlock
                RET NC                                                          ; выход, если содержимое ScreenBlock не изменилось

                LD DE, #031A
                CALL Console.SetCursor
                LD HL, .ScreenBlocks.Value + 0
                CALL .DrawScreenBlock

                LD DE, #041A
                CALL Console.SetCursor
                LD HL, .ScreenBlocks.Value + 1
                CALL .DrawScreenBlock

                LD DE, #051A
                CALL Console.SetCursor
                LD HL, .ScreenBlocks.Value + 2
                CALL .DrawScreenBlock

                LD DE, #061A
                CALL Console.SetCursor
                LD HL, .ScreenBlocks.Value + 3
                RES_FLAG_MODIFY DebugInfo.ScreenBlocks.Flag                    ; сброс флага, после завершения отрисовки
                JP .DrawScreenBlock

.DrawScreenBlock:
                CALL .DrawScreenBlockCell
                LD A, L
                ADD A, #04
                LD L, A
                CALL .DrawScreenBlockCell
                LD A, L
                ADD A, #04
                LD L, A
                CALL .DrawScreenBlockCell
                LD A, L
                ADD A, #04
                LD L, A

.DrawScreenBlockCell:
                PUSH HL
                LD A, (HL)
                CP #10
                JR C, $+4
                LD A, #0F
                CALL Console.DrawHalfByte
                POP HL
                RET

.ScreenBlocks.Value:
                DS #10, #FF                                                     ; последнее отображённое содержимое ScreenBlock
                endif
; -----------------------------------------
; отображение позиции мыши на экране
; ----------------------------------------
                ifdef DEBUG_INFO_MOUSE_POSITION
.MousePosition: LD A, (Mouse.PositionX)
.MousePosition.ValueX EQU $+1
                CP #FF                                                          ; последняя отображённая позиция мыши по оси X
                JR NZ, .MousePosition.Changed
                LD A, (Mouse.PositionY)
.MousePosition.ValueY EQU $+1
                CP #FF                                                          ; последняя отображённая позиция мыши по оси Y
                JR Z, .MousePosition.CheckFlag

.MousePosition.Changed:
                LD A, (Mouse.PositionX)
                LD (.MousePosition.ValueX), A
                LD A, (Mouse.PositionY)
                LD (.MousePosition.ValueY), A
                SET_FLAG_MODIFY DebugInfo.MousePosition.Flag                    ; установка флага, изменения позиции мыши

.MousePosition.CheckFlag:
.MousePosition.Flag FLAG_MODIFY 1                                              ; флаг, необходимости обновления позиции мыши
                RET NC                                                          ; выход, если позиция мыши не изменилась

                LD DE, #1700
                CALL Console.SetCursor
                LD A, (Mouse.PositionX)
                CALL Console.DrawByte
                LD A, ','
                CALL Console.DrawChar
                RES_FLAG_MODIFY DebugInfo.MousePosition.Flag                    ; сброс флага, после завершения отрисовки
                LD A, (Mouse.PositionY)
                JP Console.DrawByte
                endif
; -----------------------------------------
; отображение размера видимой области в чанках
; ----------------------------------------
                ifdef DEBUG_INFO_VISIBLE_AREA
.VisibleArea:   LD HL, (World.Base.Render.Object.InView.VisibleSize)
.VisibleArea.Value EQU $+1
                LD DE, #FFFF                                                    ; последний отображённый размер видимой области
                OR A
                SBC HL, DE
                JR Z, .VisibleArea.CheckFlag
                ADD HL, DE
                LD (.VisibleArea.Value), HL
                SET_FLAG_MODIFY DebugInfo.VisibleArea.Flag                      ; установка флага, изменения размера видимой области

.VisibleArea.CheckFlag:
.VisibleArea.Flag FLAG_MODIFY 1                                                ; флаг, необходимости обновления размера видимой области
                RET NC                                                          ; выход, если размер видимой области не изменился

                LD DE, #170C
                CALL Console.SetCursor
                LD A, (World.Base.Render.Object.InView.VisibleSize + 0)
                CALL Console.DrawByte
                LD A, ','
                CALL Console.DrawChar
                RES_FLAG_MODIFY DebugInfo.VisibleArea.Flag                      ; сброс флага, после завершения отрисовки
                LD A, (World.Base.Render.Object.InView.VisibleSize + 1)
                JP Console.DrawByte
                endif
; -----------------------------------------
; отображение количества видимых объектов
; ----------------------------------------
                ifdef DEBUG_INFO_VISIBLE_OBJECTS
.VisibleObjects LD A, (World.Base.Render.Object.InView.Num)
.VisibleObjects.Value EQU $+1
                CP #FF                                                          ; последнее отображённое количество видимых объектов
                JR Z, .VisibleObjects.CheckFlag
                LD (.VisibleObjects.Value), A
                SET_FLAG_MODIFY DebugInfo.VisibleObjects.Flag                   ; установка флага, изменения количества видимых объектов

.VisibleObjects.CheckFlag:
.VisibleObjects.Flag FLAG_MODIFY 1                                             ; флаг, необходимости обновления количества видимых объектов
                RET NC                                                          ; выход, если количество видимых объектов не изменилось

                LD DE, #1712
                CALL Console.SetCursor
                RES_FLAG_MODIFY DebugInfo.VisibleObjects.Flag                   ; сброс флага, после завершения отрисовки
                LD A, (World.Base.Render.Object.InView.Num)
                JP Console.DrawByte
                endif

                endif ; ~_WORLD_RENDER_DEBUG_INFO_
