
                ifndef _MODULE_CORE_INCLUDE_
                define _MODULE_CORE_INCLUDE_

                include "Kernal.asm"                                            ; (0)

                module Initialize

                include "Initialize_Core.asm"
                include "Initialize_Input.asm"
                include "VersionText.asm"

                endmodule

                endif ; ~_MODULE_CORE_INCLUDE_
