
                ifndef _PAGE_7_SCREEN_
                define _PAGE_7_SCREEN_
ScreenBlock:
.Clear          EQU World.SharedScreen.ScreenRefresh.ClearScrBlock              ; очистка screen block'ов
.HexAnalysis    EQU World.SharedScreen.ScreenRefresh.HexUpdateAnalysis          ; анализ обновления гексагонов
.Memcpy         EQU World.SharedScreen.ScreenRefresh.Memcpy                     ; копирование screen block'и в теневой экран

                endif ; ~_PAGE_7_SCREEN_
