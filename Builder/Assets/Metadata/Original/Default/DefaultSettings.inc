
                ifndef _METADATA_MAP_OBJECT_DEFAULT_SETTINGS_
                define _METADATA_MAP_OBJECT_DEFAULT_SETTINGS_

ODS_ID_COUNTER  defl 0                                                          ; счётчик настроек объектов по умолчанию
MAKE_ODS        macro Label?, Class?, Flags?, SpriteInfo?
@Label?         EQU ODS_ID_COUNTER

                FObjectDefaultSettings {
                    (Class?),
                    (Flags?),
                    (SpriteInfo?)
                }
ODS_ID_COUNTER = ODS_ID_COUNTER + 1
                endm
            
                ; таблица настроек объектов по умолчанию
                
                ; #00 - тестовый объект
                MAKE_ODS ODS_ID_TEST,                                           /*тестовый объект*/\
                /*Class*/   OBJECT_CLASS_CONSTRUCTION,                          \
                /*Flags*/   OBJECT_NEUTRAL,                                     \
                /*SpriteInfo*/  0

                endif ; ~ _METADATA_MAP_OBJECT_DEFAULT_SETTINGS_
