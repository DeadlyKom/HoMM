
                ifndef _MAIN_MENU_RENDER_DRAW_CHUR_
                define _MAIN_MENU_RENDER_DRAW_CHUR_
; -----------------------------------------
; отображение символа "Чур"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Draw_Chur:      RES_FLAG_MODIFY MainMenu.Base.Render.UpdateScreen.ChurFlag      ; сброс флага символа "Чур"
.Counter        EQU $+1
                LD A, #00
.Direction      EQU $+1
                LD HL, .ForwardTable
                JP Func.JumpTable

.ForwardTable   ; таблица переходов прямого рисования
                DW #0000
                DW Chur_Forward.Frame_0
                DW Chur_Forward.Frame_1
                DW Chur_Forward.Frame_2
                DW Chur_Forward.Frame_3
                DW Chur_Forward.Frame_4
                DW Chur_Forward.Frame_5
                DW Chur_Forward.Frame_6
                DW Chur_Forward.Frame_7
                DW Chur_Forward.Frame_8
                DW Chur_Forward.Frame_9
                DW Chur_Forward.Frame_10
                DW Chur_Forward.Frame_11
                DW Chur_Forward.Frame_12
                DW Chur_Forward.Frame_13
                DW Chur_Forward.Frame_14
                DW Chur_Forward.Frame_15
                DW Chur_Forward.Frame_16
                DW Chur_Forward.Frame_17
                DW Chur_Forward.Frame_18
                DW Chur_Forward.Frame_19

.BackwardTable  ; таблица переходов обратного рисования
                DW Chur_Backward.Frame_0
                DW Chur_Backward.Frame_1
                DW Chur_Backward.Frame_2
                DW Chur_Backward.Frame_3
                DW Chur_Backward.Frame_4
                DW Chur_Backward.Frame_5
                DW Chur_Backward.Frame_6
                DW Chur_Backward.Frame_7
                DW Chur_Backward.Frame_8
                DW Chur_Backward.Frame_9
                DW Chur_Backward.Frame_10
                DW Chur_Backward.Frame_11
                DW Chur_Backward.Frame_12
                DW Chur_Backward.Frame_13
                DW Chur_Backward.Frame_14
                DW Chur_Backward.Frame_15
                DW Chur_Backward.Frame_16
                DW Chur_Backward.Frame_17
                DW Chur_Backward.Frame_18
                DW Chur_Backward.Frame_19
SCR_CHUR_POX_X  EQU 29                                                          ; положение символа на экране по горизонтали в знакоместах
SCR_CHUR_POX_Y  EQU 20                                                          ; положение символа на экране по вертикали в знакоместах
Chur_Forward:
.Frame_0        ; рисование
                LD HL, #3FF9
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 6
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 7
                RET
.Frame_1        ; рисование
                LD HL, #3FF9
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 4
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 5
                RET
.Frame_2        ; рисование
                LD HL, #3FF9
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 2
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 3
                RET
.Frame_3        ; рисование
                LD HL, #3FF9
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 0
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 1
                LD HL, #27C9
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 4
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 5
                RET
.Frame_4        ; рисование
                LD HL, #3FF9
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 6
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 7
                LD HL, #27C9
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 2
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 3
                RET
.Frame_5        ; рисование
                LD A, #FE
                SET_TO_SCREEN_ADR A, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 4
                LD HL, #7FFC
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 5
                LD HL, #27C9
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 0
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 1
                RET
.Frame_6        ; рисование
                LD HL, #27C9
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 6
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 7
                RET
.Frame_7        ; рисование
                LD HL, #9FF2
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 4
                LD HL, #4FE4
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 5
                RET
.Frame_8        ; рисование
                LD HL, #7FFC
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 2
                LD HL, #3FF9
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 3
                RET
.Frame_9        ; рисование
                LD HL, #BFFB
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 7
                LD HL, #3FF9
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 0
                LD HL, #7FFC
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 1
                RET
.Frame_10       ; рисование
                LD HL, #EFEF
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 5
                LD HL, #CFE7
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 6
                LD HL, #9FF3
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 7
                RET
.Frame_11       ; рисование
                LD HL, #C7C7
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 6
                LD HL, #9393
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 7
                RET
.Frame_12       ; рисование
                LD HL, #3939
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 0
                LD HL, #7BBC
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 1
                RET
.Frame_13       ; рисование
                LD HL, #739C
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 1
                LD HL, #77DC
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 2
                RET
.Frame_14       ; рисование
                LD HL, #47C4
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 2
                LD HL, #2FE9
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 3
                RET
.Frame_15       ; рисование
                LD HL, #47C5
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 6
                LD A, #92
                SET_TO_SCREEN_ADR A, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 7
                LD HL, #5394
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 1
                RET
.Frame_16       ; рисование
                LD HL, #AFEB
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 5
                LD A, #C4
                SET_TO_SCREEN_ADR A, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 6
                RET
.Frame_17       ; рисование
                LD HL, #DFF7
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 4
                LD HL, #2FE9
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 5
                RET
.Frame_18       ; рисование
                LD HL, #7FFD
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 2
                LD HL, #BFFB
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 3
                LD HL, #9FF3
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 4
                RET
.Frame_19       ; рисование
                LD A, #FE
                SET_TO_SCREEN_ADR A, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 1
                LD A, #FC
                SET_TO_SCREEN_ADR A, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 2
                LD HL, #3FF9
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 3
                RET
Chur_Backward:
.Frame_0        ; затирание
                LD HL, #FFFF
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 6
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 7
                RET
.Frame_1        ; затирание
                LD HL, #FFFF
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 4
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 5
                RET
.Frame_2        ; затирание
                LD HL, #FFFF
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 2
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 3
                RET
.Frame_3        ; затирание
                LD HL, #FFFF
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 0
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 1
                LD HL, #3FF9
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 4
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 5
                RET
.Frame_4        ; затирание
                LD HL, #FFFF
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 6
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 7
                LD HL, #3FF9
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 2
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 3
                RET
.Frame_5        ; затирание
                LD HL, #FFFF
                LD A, L
                SET_TO_SCREEN_ADR A, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 4
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 5
                LD HL, #3FF9
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 0
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 2) << 3) + 1
                RET
.Frame_6        ; затирание
                LD HL, #3FF9
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 6
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 7
                RET
.Frame_7        ; затирание
                LD HL, #FFFE
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 4
                LD HL, #7FFC
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 5
                RET
.Frame_8        ; затирание
                LD HL, #FFFF
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 2
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 3
                RET
.Frame_9        ; затирание
                LD HL, #FFFF
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 7
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 0
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 1
                RET
.Frame_10       ; затирание
                LD HL, #FFFF
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 5
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 6
                LD HL, #BFFB
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 7
                RET
.Frame_11       ; затирание
                LD HL, #CFE7
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 6
                LD HL, #9FF3
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 7
                RET
.Frame_12       ; затирание
                LD HL, #3FF9
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 0
                LD HL, #7FFC
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 1
                RET
.Frame_13       ; затирание
                LD HL, #7BBC
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 1
                LD HL, #7FFC
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 2
                RET
.Frame_14       ; затирание
                LD HL, #77DC
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 2
                LD HL, #3FF9
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 3
                RET
.Frame_15       ; затирание
                LD HL, #C7C7
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 6
                LD A, #93
                SET_TO_SCREEN_ADR A, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 7
                LD HL, #739C
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 1) << 3) + 1
                RET
.Frame_16       ; затирание
                LD HL, #EFEF
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 5
                LD A, #C5
                SET_TO_SCREEN_ADR A, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 6
                RET
.Frame_17       ; затирание
                LD HL, #FFFF
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 4
                LD HL, #AFEB
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 5
                RET
.Frame_18       ; затирание
                LD HL, #FFFF
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 2
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 3
                LD HL, #DFF7
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 4
                RET
.Frame_19       ; затирание
                LD A, #FF
                SET_TO_SCREEN_ADR A, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 1
                LD A, #FD
                SET_TO_SCREEN_ADR A, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 2
                LD HL, #BFFB
                SET_TO_SCREEN_ADR HL, SCR_ADR_BASE, \
                    SCR_CHUR_POX_X << 3, \
                    ((SCR_CHUR_POX_Y + 0) << 3) + 3
                RET

                display " - Draw 'Chur':\t\t\t\t\t", /A, Draw_Chur, "\t= busy [ ", /D, $-Draw_Chur, " byte(s)  ]"

                endif ; ~_MAIN_MENU_RENDER_DRAW_CHUR_
