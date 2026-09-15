
                ifndef _MODULE_WORLD_UI_HANDLER_LAYER_GAME_UI_
                define _MODULE_WORLD_UI_HANDLER_LAYER_GAME_UI_
; -----------------------------------------
; обработчик UI слоя "иконок"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Layer_GameUI:   ; очистка
                ifdef _DEBUG
                LD BC, World.SharedCode.Render.IconDebug.Text.Empty
                CALL .Draw
                endif
                
                ; подготовка обхода таблицы иконок
                LD IY, World.Display.GameplayUI.IconsList
                LD B, World.Display.GameplayUI.IconsList.Num

.IconLoop       ; проверка видимости и интерактивности подложки
                LD A, (IY + World.Display.FUIIcon.BackType)
                AND %11000000                                                   ; изолирование флага видимости и интерактивности
                JR NZ, .NextIcon                                                ; переход, если иконка скрыта или неинтерактивна

                ; проверка попадания курсора в ромб
                LD DE, (IY + World.Display.FUIIcon.BackPosition)                ; чтение позиции ромба
                CALL .HitTest
                JR NC, .NextIcon                                                ; переход, если курсор вне ромба

                ; чтение адреса обработчика
                LD HL, (IY + World.Display.FUIIcon.Handler)

                ; проверка адреса обработчика
                ifdef _DEBUG
                LD A, H
                OR L
                DEBUG_BREAK_POINT_Z                                             ; ошибка, обработчик не назначен
                endif

                ; вызов обработчика
                PUSH BC
                PUSH IY
                CALL_HL
                POP IY
                POP BC

.NextIcon       ; переход к следующей записи
                LD DE, World.Display.FUIIcon
                ADD IY, DE
                DJNZ .IconLoop

                RET
; -----------------------------------------
; проверка попадания курсора в ромб 23x23
; In:
;   DE - левый верхний угол ромба (D - y, E - x)
; Out:
;   флаг переполнения установлен, если курсор внутри ромба включительно
; Corrupt:
;   DE, AF
; Note:
; -----------------------------------------
.HitTest        ; расчёт смещения курсора по горизонтали
                LD A, (Mouse.PositionX)
                SUB E
                CCF                                                             ; предустановка флага
                RET NC                                                          ; выход, если курсор левее ромба

                CP 23
                RET NC                                                          ; выход, если курсор правее ромба

                ; расчёт расстояния от центра по горизонтали
                SUB 11
                JR NC, .HitTest.AbsX                                            ; переход, если курсор не левее центра ромба
                NEG
.HitTest.AbsX   LD E, A

                ; расчёт смещения курсора по вертикали
                LD A, (Mouse.PositionY)
                SUB D
                CCF                                                             ; предустановка флага
                RET NC                                                          ; выход, если курсор выше ромба

                CP 23
                RET NC                                                          ; выход, если курсор ниже ромба

                ; расчёт расстояния от центра по вертикали
                SUB 11
                JR NC, .HitTest.AbsY                                            ; переход, если курсор не выше центра ромба
                NEG
.HitTest.AbsY   ; расчёт суммы расстояний от центра
                ADD A, E

                ; проверка попадания внутрь ромба или на его границу
                CP 12
                RET
; -----------------------------------------
; отладочные обработчики наведения на иконки
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
; -----------------------------------------
                ifdef _DEBUG
.Center         LD BC, World.SharedCode.Render.IconDebug.Text.Center
                JR .Draw
.SpellsBook     LD BC, World.SharedCode.Render.IconDebug.Text.Spells
                JR .Draw
.Inventory      LD BC, World.SharedCode.Render.IconDebug.Text.Inventory
                JR .Draw
.Quest          LD BC, World.SharedCode.Render.IconDebug.Text.Quest
                JR .Draw
.Map            LD BC, World.SharedCode.Render.IconDebug.Text.Map
                JR .Draw
.Options        LD BC, World.SharedCode.Render.IconDebug.Text.Options
.Draw           ; сохранение флагов рендера и режима консоли
                LD A, (GameState.Render)
                PUSH AF
                LD A, (Kernel.Console.DrawChar.Function)
                PUSH AF

                ; вывод в основной экран без корректировки
                SET_RENDER_FLAG SWAP_DISABLE_BIT
                CALL Console.SetDrawToOne
                SET_REG_ATTR_IPB A, RED, BLACK, 0
                CALL Console.SetAttribute
                LD HL, SCR_ADR_BASE + 25
                CALL Console.SetScreenAdr
                CALL Console.DrawString

                ; восстановление режима консоли и флагов рендера
                POP AF
                LD (Kernel.Console.DrawChar.Function), A
                POP AF
                LD (GameState.Render), A
                RET
                else
.Center         EQU Func.RET
.SpellsBook     EQU Func.RET
.Inventory      EQU Func.RET
.Quest          EQU Func.RET
.Map            EQU Func.RET
.Options        EQU Func.RET
                endif

                endif ; ~_MODULE_WORLD_UI_HANDLER_LAYER_GAME_UI_
