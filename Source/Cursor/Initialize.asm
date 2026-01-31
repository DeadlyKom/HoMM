
                ifndef _CURSOR_INITIALIZE_
                define _CURSOR_INITIALIZE_
; -----------------------------------------
; инициализация курсора
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Initialize      LD IX, UI_Cursor.CurrentState
                LD A, CURSOR_STATE_IDLE

.SetState       ; копирование дефолтных настроек устанавливаемого состояния
                LD (IX + FCursorState.State), A
                LD (IX + FCursorState.Direction), CURSOR_ANIMATION_FORWARD

                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, LOW StateTable
                LD L, A
                ADC A, HIGH StateTable
                SUB L
                LD H, A

                LD DE, UI_Cursor.CurrentState + FCursorState.SpriteIndex
                LDI
                LDI
                LDI
                LDI

                RET

                endif ; ~_CURSOR_INITIALIZE_
