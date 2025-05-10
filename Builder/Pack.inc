
                ifndef _BUILDER_PACK_
                define _BUILDER_PACK_

                if PASS = 2
                emptytrd TRD_FILENAME, TRD_DISK_1
                endif

                display "Packing..."

                include "Bootloader/Pack.inc"
                include "Assets/Packing.inc"

                display "-------------------------------------------------------------------------------------------------------------------------------"

                endif ; ~_BUILDER_PACK_
