
                ifndef _WORLD_OBJECT_SET_VIEW_WORLD_BOUND_
                define _WORLD_OBJECT_SET_VIEW_WORLD_BOUND_
; -----------------------------------------
; установить границы мира для просмотра
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
SetViewBound:   ; установка отсечение спрайтов
                LD HL, (SCR_WORLD_SIZE_X) << 8 | (SCR_WORLD_POS_X << 3)         ; LeftEdge      - левая грань видимой части     (в пикселах)
                                                                                ; VisibleWidth  - ширина видимой части          (в знакоместах)
                LD (GameState.LeftEdge), HL
                LD HL, ((SCR_WORLD_SIZE_Y << 3) << 8)  | (SCR_WORLD_POS_Y << 3) ; TopEdge       - верхняя грань видимой части   (в пикселах)
                                                                                ; VisibleHeight - высота видимой части          (в пикселах)
                LD (GameState.TopEdge), HL
                RET

                display " - Set view world bound:\t\t\t\t", /A, SetViewBound, "\t= busy [ ", /D, $-SetViewBound, " byte(s)  ]"

                endif ; ~_WORLD_OBJECT_SET_VIEW_WORLD_BOUND_
