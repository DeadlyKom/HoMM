
                ifndef _PAGE_7_SCREEN_
                define _PAGE_7_SCREEN_
ScreenBlock:
.Clear          EQU World.ScreenRefresh.ClearScrBlock                         ; очистка screen block'ов
.HexAnalysis    EQU World.ScreenRefresh.HexUpdateAnalysis                       ; анализ обновления гексагонов
.Memcpy         EQU World.ScreenRefresh.Memcpy                                  ; копирование screen block'и в теневой экран

                endif ; ~_PAGE_7_SCREEN_
