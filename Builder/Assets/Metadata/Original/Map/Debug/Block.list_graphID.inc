
                ifndef _METADATA_MAP_DEBUG_LIST_GRAPHICS_PACKAGE_IDs_
                define _METADATA_MAP_DEBUG_LIST_GRAPHICS_PACKAGE_IDs_
GRAPHICS_PACKAGE_COUNTER  defl 0                                                ; счётчик гексагональных тайлов
ADD_TO_GRAPHICS_PACKAGE macro Label?, AssetID?
Label?          EQU GRAPHICS_PACKAGE_COUNTER
                DB AssetID?
GRAPHICS_PACKAGE_COUNTER = GRAPHICS_PACKAGE_COUNTER+1
                endm

                ; список ID ассетов графических пакетов
                ADD_TO_GRAPHICS_PACKAGE GRAPHICS_PACKAGE_GRASSLANDS, ASSETS_ID_HEX_GRASSLANDS

                endif ; ~ _METADATA_MAP_DEBUG_LIST_GRAPHICS_PACKAGE_IDs_
