
                ifndef _METADATA_MAP_DEFAULT_INCLUDE_
                define _METADATA_MAP_DEFAULT_INCLUDE_

                module Default

                ORG #0000
                
                include "DefaultSettings.inc"
Size            EQU $
                savebin "Builder/Assets/Metadata/Original/Default/DefaultSettings.meta", 0, Size
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Metadata/Original/Default/DefaultSettings.meta Builder/Assets/Metadata/Compressed/Default/DefaultSettings.meta.ar"

                ORG 0x0000
Begin.ar        incbin "Builder/Assets/Metadata/Compressed/Default/DefaultSettings.meta.ar"
Size.ar         EQU $
Size.Sector.ar  EQU ((Size.ar % TRDOS.SECTOR_SIZE > 0) & 0x01) + (Size.ar >> 8)
                endmodule

                endif ; ~ _METADATA_MAP_DEFAULT_INCLUDE_
