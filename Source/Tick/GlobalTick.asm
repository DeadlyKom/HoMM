
                ifndef _TICK_GLOBAL_
                define _TICK_GLOBAL_
; -----------------------------------------
; глобальный тик
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Global:         JP Object.Tick                                                  ; обработчик тика объектов

                endif ; ~_TICK_GLOBAL_
