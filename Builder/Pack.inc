
                ifndef _BUILDER_PACK_
                define _BUILDER_PACK_

                emptytrd TRD_FILENAME, TRD_DISK_1
                display "Packing..."

                include "Bootloader/Pack.inc"
                include "Assets/Packing.inc"

                display "-------------------------------------------------------------------------------------------------------------------------------"

                endif ; ~_BUILDER_PACK_
