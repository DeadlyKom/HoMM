
                ifndef _METADATA_MAP_DEFAULT_OBJECTS_
                define _METADATA_MAP_DEFAULT_OBJECTS_

                module MapObjects
ODS_ID_COUNTER  defl 0                                                          ; счётчик настроек объектов по умолчанию
MAKE_ODS        macro Label?, Flags?
@Label?         EQU ODS_ID_COUNTER

                FObjectDefaultSettings {
                    (Flags?)
                }
ODS_ID_COUNTER = ODS_ID_COUNTER + 1
                endm
            
                ; таблица настроек объектов по умолчанию
                
                ; #00 - тестовый объект
                MAKE_ODS ID_TEST,                                               /*тестовый объект*/\
                /*Flags*/   OBJECT_NEUTRAL                                      \

                endmodule

                endif ; ~ _METADATA_MAP_DEFAULT_OBJECTS_
