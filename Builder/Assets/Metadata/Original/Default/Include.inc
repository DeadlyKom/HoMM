
                ifndef _METADATA_MAP_DEFAULT_INCLUDE_
                define _METADATA_MAP_DEFAULT_INCLUDE_

                module Default

                ORG #0000
Begin:          EQU $
                include "DefaultSettings.inc"
Size            EQU $
                COMPRESSED_ASSET \
                "Builder/Assets/Metadata/Original/Default/DefaultSettings.meta", \
                "Builder/Assets/Metadata/Compressed/Default/DefaultSettings.meta.ar"
                endmodule

                endif ; ~ _METADATA_MAP_DEFAULT_INCLUDE_
