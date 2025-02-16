
                ifndef _BUILDING_ASSETS_DATA_0_
                define _BUILDING_ASSETS_DATA_0_
CREATE_ASSETS   macro Bank?, Page?, ORG?, Include?
                MMU Bank?, Page?
                ORG ORG?
                Include?
                savetrd TRD_FILENAME, "Data-0.#", ORG?, $-ORG?
                endm
ADD_ASSETS      macro Bank?, Page?, ORG?, Include?
                MMU Bank?, Page?
                ORG ORG?
                Include?
                savetrd TRD_FILENAME, &"Data-0.#", ORG?, $-ORG?
                endm
ADD_ASSETS_DEBUG macro Bank?, Page?, ORG?, Include?
                ifdef _DEBUG
                ADD_ASSETS Bank?, Page?, ORG?, Include?
                endif
                endm

                ; ASSETS_ID_KERNEL
                CREATE_ASSETS 2, Page.Kernel, Adr.Kernel, incbin "Builder/Assets/Code/Compressed/Kernel.pack.ar"

                endif ; ~_BUILDING_ASSETS_DATA_0_
