
                ifndef _INVENTORY_RENDER_COPY_SCREEN_
                define _INVENTORY_RENDER_COPY_SCREEN_
; -----------------------------------------
; перенос готового кадра инвентаря в теневой экран
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
;   ℹ️ код расположен в общей памяти
; -----------------------------------------
CopyScreen:     ; блокировка работы с буфером курсора на время переноса
                SET_FLAG_MODIFY CursorCopyGate.Flag

                ; копирование готового основного экрана в теневой
                CALL Func.ShadowScrcpy

                ; проверка наличия сохранённого фона курсора
                LD HL, (Kernel.Sprite.Restore.BufferAdr)
                LD A, (HL)
                OR A
                JR Z, .Finish                                                   ; переход, если сохранённый фон курсора отсутствует

                ; чтение экранного адреса сохранённого фона курсора
                INC L
                LD E, (HL)
                INC L
                LD D, (HL)

                ; восстановление фона под скопированным курсором в теневом экране
                SET 7, D
                CALL Draw.RestoreByScrAdr

.Finish         ; подготовка обработки UI после переноса кадра
                SET_MODULE_PAGE_Inventory                                       ; включение страницы модуля инвентаря

                ; проверка возможности начать обработку запроса смены UI режима
                CALL UI.Runtime.Process
                JP C, .StartUI                                                  ; переход, если начат переход UI режима

                ; разрешение работы с курсором перед показом теневого экрана
                RES_FLAG_MODIFY CursorCopyGate.Flag

                ; завершение переноса перед показом теневого экрана
                RES_RENDER_FLAGS SWAPPED_PENDING | SWAP_PENDING
                RET

.StartUI        ; завершение переноса перед обработкой перехода UI режима
                RES_RENDER_FLAGS SWAPPED_PENDING | SWAP_PENDING
                JP Inventory.SharedCode.UI.Transition.World

.Swap           ; подтверждение показа готового основного экрана
                SET_RENDER_FLAG SWAPPED_PENDING_BIT
                JP_SHOW_BASE_SCREEN
; -----------------------------------------
; проверка разрешения работы с буфером курсора
; In:
; Out:
;   флаг, переноса установлен на время копирования кадра
; Corrupt:
;   AF
; -----------------------------------------
CursorCopyGate  ; проверка блокировки работы с курсором
.Flag           FLAG_MODIFY 0
                RET

                endif ; ~_INVENTORY_RENDER_COPY_SCREEN_

