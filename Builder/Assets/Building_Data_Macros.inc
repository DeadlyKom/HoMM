                ifndef _BUILDING_ASSETS_DATA_MACROS_
                define _BUILDING_ASSETS_DATA_MACROS_

                DEFARRAY ASSETS_DATA_FILE_NUMBERS \
                    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"

ASSETS_DATA_FILE_INDEX     = 0
ASSETS_DATA_FILE_SECTORS   = 0

ADD_ASSETS      macro Bank?, Page?, ORG?, Include?, SizeSec?
                if SizeSec? > #FF
                error "размер ассета превышает 255 секторов"
                endif

                if ASSETS_DATA_FILE_SECTORS + SizeSec? > #FF
ASSETS_DATA_FILE_INDEX     = ASSETS_DATA_FILE_INDEX + 1
ASSETS_DATA_FILE_SECTORS   = 0
                endif

                if ASSETS_DATA_FILE_INDEX >= ASSETS_DATA_FILE_NUMBERS[#]
                error "недостаточно имён файлов Data-N.#"
                endif

                MMU Bank?, Page?
                ORG ORG?
                incbin Include?

                if ASSETS_DATA_FILE_SECTORS = 0
                savetrd TRD_FILENAME, "Data-" .. ASSETS_DATA_FILE_NUMBERS[ASSETS_DATA_FILE_INDEX] .. ".#", ORG?, $-ORG?
                else
                savetrd TRD_FILENAME, &"Data-" .. ASSETS_DATA_FILE_NUMBERS[ASSETS_DATA_FILE_INDEX] .. ".#", ORG?, $-ORG?
                endif

ASSETS_DATA_FILE_SECTORS   = ASSETS_DATA_FILE_SECTORS + SizeSec?
                endm

ADD_ASSETS_DEBUG macro Bank?, Page?, ORG?, Include?, SizeSec?
                ifdef _DEBUG
                ADD_ASSETS Bank?, Page?, ORG?, Include?, SizeSec?
                endif
                endm

                endif ; ~_BUILDING_ASSETS_DATA_MACROS_
