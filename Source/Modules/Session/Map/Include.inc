
                ifndef _MODULE_SESSION_MAP_INCLUDE_
                define _MODULE_SESSION_MAP_INCLUDE_

                include "Load/Include.inc"
                include "DataBlock/Include.inc"
                include "Initialize/Include.inc"
                include "Load_Map.asm"
                include "Utilities.asm"

                align 256, #55
BaseGraphicsBuffer: DS 256, 0                                                   ; ToDo: при распаковки модуля, всегда есть 256 байт  в конце модуля, перенести туда буфер
                
                endif ; ~_MODULE_SESSION_MAP_INCLUDE_
