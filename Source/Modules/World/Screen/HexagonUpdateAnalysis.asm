
                ifndef _MODULE_WORLD_SCREEN_REFRESH_HEXAGON_UPDATE_ANALYSIS_
                define _MODULE_WORLD_SCREEN_REFRESH_HEXAGON_UPDATE_ANALYSIS_
; -----------------------------------------
; анализ обновления гексагонов
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
HexUpdateAnalysis:
                LD HL, Adr.RenderBuffer
                RET

                display " - Hexagon update analysis:\t\t\t\t", /A, HexUpdateAnalysis, "\t= busy [ ", /D, $ - HexUpdateAnalysis, " byte(s)  ]"

                endif ; ~_MODULE_WORLD_SCREEN_REFRESH_HEXAGON_UPDATE_ANALYSIS_
