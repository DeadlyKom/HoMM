                ifndef _SUBMODULES_CONTOUR_LAUNCH_ALLOCATE_
                define _SUBMODULES_CONTOUR_LAUNCH_ALLOCATE_
; -----------------------------------------
; выделение рабочего буфера сабмодуля "обводка"
; In:
; Out:
;   HL - адрес таблицы расширения
; Corrupt:
;   DE, BC, AF, AF', IX
; Note:
;   ℹ️ необходимо включить страницу сабмодуля "обводка"
; -----------------------------------------
Allocate:       ; расчёт адреса рабочего буфера после памяти ресурса
                LD A, (Kernel.Submodules.Contour.Page)
                LD D, A
                LD IX, GameState.Assets
                CALL_IN_PAGE Page.AssetManager, AssetsManager.CalcNextBlock

                ; выделение служебных 256 байт для рабочего буфера
                LD E, #01
                SET_REGISTER IX, HL
                CALL_IN_PAGE Page.AssetManager, AssetsManager.MemAllocation.Wrap

                ; расчёт адреса таблицы перед рабочим буфером
                SET_REGISTER HL, IX
                LD A, H
                SUB Submodules.Contour.Size.Tables / #0100
                LD H, A
                RET

                endif ; ~_SUBMODULES_CONTOUR_LAUNCH_ALLOCATE_
