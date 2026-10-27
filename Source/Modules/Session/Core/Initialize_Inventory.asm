
                ifndef _MODULE_SESSION_CORE_INITIALIZE_INVENTORY_
                define _MODULE_SESSION_CORE_INITIALIZE_INVENTORY_
; -----------------------------------------
; подготовка области предметов
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX
; Note:
;   ℹ️ код расположен в "общей памяти"
; -----------------------------------------
Init_Inventory: ; проверка наличия выделенной области предметов
                LD A, (GameState.Inventory.High)
                OR A
                CALL Z, .Allocate                                               ; вызов, если область предметов ещё не выделена

                ; получение адреса области предметов
                LD A, (GameState.Inventory.High)
                LD H, A
                LD L, #00

                ; включение страницы области предметов
                LD A, (GameState.Inventory.Page)
                SET_PAGE_A

                ; расчёт адреса конца области для заполнения стеком
                LD BC, .Blocks << 8
                ADD HL, BC

                ; очистка выделенной области блоками по 256 байт
                LD DE, #0000
                LD B, .Blocks
.ClearLoop      CALL SafeFill.b256
                DEC H
                DJNZ .ClearLoop

                ; инициализация количества предметов в выделенной области
                XOR A
                LD (GameState.ItemsNum), A

                ; восстановление страницы модуля сессии
                SET_MODULE_PAGE_Session
                OR A
                RET

.Size           EQU ITEM_MAX * (FItem + FItemLocation)                          ; размер массивов предметов и их размещения
                DIV_ROUND_UP .Size, #0100, @.Blocks
; -----------------------------------------
; выделение области предметов
; In:
; Out:
;   GameState.Inventory - расположение выделенной области
; Corrupt:
;   HL, DE, BC, AF, AF', IX
; Note:
;   ℹ️ код расположен в "общей памяти"
; -----------------------------------------
.Allocate       ; выделение непрерывной области для обоих массивов
                LD D, #80
                LD E, .Blocks
                CALL_IN_PAGE Page.AssetManager, AssetsManager.MemAllocation.Wrap
                EX AF, AF'                                                      ; восстановление результата выделения памяти

                ; ToDo: добавить сообщение или другой сигнал об ошибке выделения памяти
                DEBUG_BREAK_POINT_C                                             ; ошибка, выделение памяти не удалось

                ; сохранение расположения выделенной области
                LD A, D
                LD (GameState.Inventory.Page), A
                LD A, IXH
                LD (GameState.Inventory.High), A
                RET

                endif ; ~_MODULE_SESSION_CORE_INITIALIZE_INVENTORY_
