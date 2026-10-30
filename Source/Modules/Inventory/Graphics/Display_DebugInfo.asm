
                ifndef _MODULE_INVENTORY_GRAPHICS_DISPLAY_DEBUG_INFO_
                define _MODULE_INVENTORY_GRAPHICS_DISPLAY_DEBUG_INFO_
; -----------------------------------------
; отладочное отображение информации об инвентаре
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
;   вывод включается через DEBUG_INFO_INVENTORY_ITEM
; -----------------------------------------
DebugInfo:      ifdef DEBUG_INFO_INVENTORY_ITEM

                ; проверка первого отображения после входа в инвентарь
                CHECK_MAIN_FLAG ML_ENTER_BIT
                JR NZ, .Draw                                                    ; переход, если выполняется первый показ после входа в инвентарь

                ; проверка изменения идентификатора предмета под курсором
                LD A, (Inventory.States.HoveredItem.ID)
.LastID         EQU $+1
                CP ITEM_ID_NONE
                RET Z                                                           ; выход, если идентификатор предмета не изменился

.Draw           ; сохранение отображаемого идентификатора
                LD A, (Inventory.States.HoveredItem.ID)
                LD (.LastID), A

                ; сохранение флагов рендера и режима консоли
                LD A, (GameState.Render)
                PUSH AF
                LD A, (Kernel.Console.DrawChar.Function)
                PUSH AF

                ; подготовка консоли для вывода в основной экран
                SET_RENDER_FLAG SWAP_DISABLE_BIT
                CALL Console.SetDrawToOne
                SET_REG_ATTR_IPB A, WHITE, BLACK, 0
                CALL Console.SetAttribute

                ; установка позиции вывода в левом нижнем углу
                LD DE, #1700                                                    ; D - строка 23, E - столбец 0 в знакоместах
                CALL Console.SetCursor

                ; отображение идентификатора двумя шестнадцатеричными цифрами
                LD A, (Inventory.States.HoveredItem.ID)                         ; чтение идентификатора предмета под курсором
                CALL Console.DrawByte

                ; восстановление режима консоли и флагов рендера
                POP AF
                LD (Kernel.Console.DrawChar.Function), A
                POP AF
                LD (GameState.Render), A

                ; запрос переноса отладочного вывода в теневой экран
                SET_MAIN_FLAG ML_UPDATE_BIT
                endif
                RET

                endif ; ~_MODULE_INVENTORY_GRAPHICS_DISPLAY_DEBUG_INFO_
