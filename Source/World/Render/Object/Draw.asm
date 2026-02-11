
                ifndef _WORLD_RENDER_OBJECT_DRAW_
                define _WORLD_RENDER_OBJECT_DRAW_
; -----------------------------------------
; отображение объектов "мира"
; In:
;   A  - количество объектов в массиве SortBuffer
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Draw:           ; инициализация
                LD DE, Adr.SortBuffer
                LD B, A

.Loop           ; чтение адреса объекта
                LD A, (DE)
                LD IYL, A
                INC E
                LD A, (DE)
                LD IYH, A
                INC E

                PUSH BC
                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами

                ; проверка флага обновления объекта
                BIT OBJECT_DIRTY_BIT, (IY + FObject.Flags)
                JR Z, .ForcedVisibility                                         ; переход, если флаг не установлен,
                                                                                ; но необходимо проверить обновление screen block'а или принудительное обновление
                RES OBJECT_DIRTY_BIT, (IY + FObject.Flags)                      ; сброс флага

.NeedRefresh    PUSH DE
                ; расчёт положения объекта относительно верхнего-левого видимойго края
                CALL Utilities.TransformToScr                     
                LD (Kernel.Sprite.DrawClipping.PositionX), DE
                LD (Kernel.Sprite.DrawClipping.PositionY), HL

                ; определение способа отображения объекта
                LD A, (IY + FObjectDefaultSettings.Class)
                AND OBJECT_CLASS_MASK

                ; ловушка
                ifdef _DEBUG
                CP OBJECT_CLASS_MAX
                DEBUG_BREAK_POINT_NC                                            ; ошибка, нет такого объекта
                endif

                LD HL, .JumpTable
                LD IX, Draw.SpriteClipping
                CALL Func.JumpTable

                POP DE
.NextObject     POP BC
                DJNZ .Loop
.RET            RET

.ForcedVisibility; проверка принудительной видимости
                CHECK_VIEW_FLAG FORCED_FRAME_UPDATE_BIT
                JR NZ, .NeedRefresh                                             ; переход, если требуется принудительное обновление

                ; проверка обновления screen block'а
                ; JR .NeedRefresh                                                 ; переход, если screen block обновляется, необходимо обновить и объект
                JR .NextObject                                                  ; переход, если screen block не обновляется

.JumpTable      DW Hero.Draw                                                    ; OBJECT_CLASS_HERO
                DW Simple.Draw                                                  ; OBJECT_CLASS_CONSTRUCTION
                DW .RET                                                         ; OBJECT_CLASS_PROPS
                DW .RET                                                         ; OBJECT_CLASS_INTERACTION
                DW .RET                                                         ; OBJECT_CLASS_PARTICLE
                DW .RET                                                         ; OBJECT_CLASS_DECAL
                DW UI.Draw                                                      ; OBJECT_CLASS_UI

                endif ; ~_WORLD_RENDER_OBJECT_DRAW_
