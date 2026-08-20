
                ifndef _METADATA_MAP_OBJECT_DEFAULT_SETTINGS_
                define _METADATA_MAP_OBJECT_DEFAULT_SETTINGS_

ODS_ID_COUNTER  defl 0                                                          ; счётчик настроек объектов по умолчанию
MAKE_ODS        macro Label?
@Label?         EQU ODS_ID_COUNTER
ODS_ID_COUNTER = ODS_ID_COUNTER + 1
                endm
            
                ; таблица настроек объектов по умолчанию

                ; персонаж
                MAKE_ODS ODS_ID_CHARACTER                                       ; тестовый персонаж
                FODS_Character {
                    {
                        /*Super.Class*/      OBJECT_CLASS_CHARACTER,
                        /*Super.Flags*/      OBJECT_NEUTRAL,
                        /*Super.Variable_A*/ ODS_ID_UI,
                        /*Super.Variable_B*/ 0
                    },
                    /*Flags*/                OBJECT_CHARACTER_SPAWN_UI_ON_HOVER
                }
                
                ; AI-персонаж
                MAKE_ODS ODS_ID_AI_CHARACTER                                    ; тестовый AI-персонаж
                FODS_Character {
                    {
                        /*Super.Class*/      OBJECT_CLASS_CHARACTER_AI,
                        /*Super.Flags*/      OBJECT_NEUTRAL,
                        /*Super.Variable_A*/ ODS_ID_UI,
                        /*Super.Variable_B*/ 0
                    },
                    /*Flags*/                OBJECT_CHARACTER_SPAWN_UI_ON_HOVER
                }
                
                ; тестовый объект
                MAKE_ODS ODS_ID_TEST                                            ; тестовый объект
                FObjectDefaultSettings {
                    /*Class*/      OBJECT_CLASS_CONSTRUCTION,
                    /*Flags*/      OBJECT_NEUTRAL,
                    /*Variable_A*/ 0,
                    /*Variable_B*/ 0
                }
                DS 4, 0                                                         ; dummy

                ; UI объект
                MAKE_ODS ODS_ID_UI
                FODS_UI {
                    {
                        /*Super.Class*/      (OBJECT_UI_COMMON_SMALL_HERO << 4) | OBJECT_CLASS_UI,
                        /*Super.Flags*/      OBJECT_NEUTRAL,
                        /*Super.Variable_A*/ #01,
                        /*Super.Variable_B*/ 0
                    },
                    /*Flags*/                OBJECT_UI_HOVER | OBJECT_UI_ATTR_ALIGN,
                    {
                        /*Offset.X*/           16,
                        /*Offset.Y*/          -24
                    }
                }

                endif ; ~ _METADATA_MAP_OBJECT_DEFAULT_SETTINGS_
