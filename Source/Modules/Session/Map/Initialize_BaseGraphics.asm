
                ifndef _MODULE_SESSION_INITIALIZE_BASE_GRAPHICS_PACKAGES_
                define _MODULE_SESSION_INITIALIZE_BASE_GRAPHICS_PACKAGES_
; -----------------------------------------
; инициализация графических пакетов
; In:
; Out:
; Corrupt:
; Note:
;   - включена страница загруженной карты!
;   - размер блока данных необходимых графических пакетов для текущей карты, не должен превышать 128
; -----------------------------------------
Initialize.BaseGraphics:
                EXX
                PUSH HL
                PUSH BC

                ; загрузка обязательных - системныз графических пакетов
                LD HL, Block.HextileTable
                LD BC, Block.HextileTable.Size
                EXX
                LD D, HIGH BaseGraphicsBuffer

                ; переход к базовым спрайтам гексагонов
                LD A, (HEX.StartRenderIdx)
                SUB 2 << 1
                CALL Initialize.GraphicsPackages

                POP BC
                POP HL
                EXX
                RET

                ; таблица сопоставления гексагональных тайлов и графического пакетов, где
                ;  1. индекс массива - ID гексагонального тайла
                ;  2. первый байт - индекс в массиве FMapHeader.GraphicPack
                ;  3. второй байт - смещение внутри текущего графического пакета (0-7)
                ;
                ;   | <---------- первый байт ---------- > |   | <---------- второй байт ---------- >  |
                ;
                ;  +----+----+----+----+----+----+----+----+   +----+----+----+----+----+----+----+----+
                ;  | 15 | 14 | 13 | 12 | 11 | 10 |  9 |  8 |   |  7 |  6 |  5 |  4 |  3 |  2 |  1 |  0 |
                ;  +----+----+----+----+----+----+----+----+   +----+----+----+----+----+----+----+----+
                ;  | UB | I6 | I5 | I4 | I3 | I2 | I1 | I0 |   | O2 | O1 | O0 | .. | .. | .. | .. | .. |
                ;  +----+----+----+----+----+----+----+----+   +----+----+----+----+----+----+----+----+
                ;
                ;   UB      [15]        - флаг, использования гесагонального тайла (1 - не используется)
                ;   I6-I0   [14..8]     - ндекс в массиве FMapHeader.GraphicPack
                ;   O2-O0   [7..5]      - смещение внутри текущего графического пакета (0-7)
Block.HextileTable:
                MAKE_HEXTILE_BIND BASE_HEX_GRAPHICS_PACKAGE, #00                ; 0 
Block.HextileTable.Size EQU $-Block.HextileTable

                display " - Initialize base graphics packages:\t\t\t", /A, Initialize.GraphicsPackages, "\t= busy [ ", /D, $-Initialize.GraphicsPackages, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_INITIALIZE_BASE_GRAPHICS_PACKAGES_