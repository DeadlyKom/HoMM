
                ifndef _CONST_ASSETS_REGISTER_
                define _CONST_ASSETS_REGISTER_
ASSETS_ID_COUNTER   defl 0
REG_ASSETS_ID       macro Label?
Label?              EQU ASSETS_ID_COUNTER
ASSETS_ID_COUNTER   = ASSETS_ID_COUNTER + 1
                    endm
REG_ASSETS_ID_DEBUG macro Label?

                    ifdef _DEBUG
                    REG_ASSETS_ID Label?
                    endif

                    endm

                    REG_ASSETS_ID       ASSETS_ID_KERNEL                        ; кернел

                endif ; ~_CONST_ASSETS_REGISTER_
