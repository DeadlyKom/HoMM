
                ifndef _ENTRY_POINT_LOOP_
                define _ENTRY_POINT_LOOP_
; -----------------------------------------
; главный цикл
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
MainLoop:
.Loop
.Address        EQU $+1
                CALL $
                JR .Loop

                endif ; ~_ENTRY_POINT_LOOP_
