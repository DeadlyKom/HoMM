
                ifndef _METADATA_MAP_DEFAULT_INCLUDE_
                define _METADATA_MAP_DEFAULT_INCLUDE_

                module Default

                ORG #0000
                
                include "DefaultSettings.inc"
Size            EQU $
                savebin "Builder/Assets/Metadata/Original/Default/DefaultSettings.meta", 0, Size
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Metadata/Original/Default/DefaultSettings.meta Builder/Assets/Metadata/Compressed/Default/DefaultSettings.meta.ar"
                ASSETS_SIZE "Builder/Assets/Metadata/Compressed/Default/DefaultSettings.meta.ar"
                endmodule

                endif ; ~ _METADATA_MAP_DEFAULT_INCLUDE_
