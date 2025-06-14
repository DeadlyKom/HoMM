
                ifndef _METADATA_MAP_OBJECT_DEFAULT_SETTINGS_
                define _METADATA_MAP_OBJECT_DEFAULT_SETTINGS_

ODS_ID_COUNTER  defl 0                                                          ; счётчик настроек объектов по умолчанию
MAKE_ODS        macro Label?, Class?, Flags?
@Label?         EQU ODS_ID_COUNTER

                FObjectDefaultSettings {
                    (Class?),
                    (Flags?)
                }
ODS_ID_COUNTER = ODS_ID_COUNTER + 1
                endm
            
                ; таблица настроек объектов по умолчанию

                ; герой
                MAKE_ODS ODS_ID_HERO,                                           /*тестовый герой*/\
                /*Class*/   OBJECT_CLASS_HERO,                                  \
                /*Flags*/   OBJECT_NEUTRAL
                
                ; тестовый объект
                MAKE_ODS ODS_ID_TEST,                                           /*тестовый объект*/\
                /*Class*/   OBJECT_CLASS_CONSTRUCTION,                          \
                /*Flags*/   OBJECT_NEUTRAL

                ; UI объект
                MAKE_ODS ODS_ID_UI_ARROWPATH,                                   /* UI элемент стрелки пути*/\
                /*Class*/   OBJECT_CLASS_UI,                                    \
                /*Flags*/   OBJECT_NEUTRAL

                endif ; ~ _METADATA_MAP_OBJECT_DEFAULT_SETTINGS_
