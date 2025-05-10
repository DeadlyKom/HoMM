
                ifndef _MODULE_SESSION_LOAD_SHARED_CODE_
                define _MODULE_SESSION_LOAD_SHARED_CODE_

                module SharedCode
                DISP Adr.Session
                display "Shared code 'Session':\t\t\t\t\t-------------------- [ ", /D, Size, "/", /D, Size.SharedPoint, " byte(s) / free ", /D, Size.SharedPoint - Size, "]\t[", /D, Page.Session, "]\t ------------------------"

                include "SaveSlot/Include.inc"
Size            EQU $-Adr.World

                ENT
                endmodule

                endif ; ~_MODULE_SESSION_LOAD_SHARED_CODE_
