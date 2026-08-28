
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
                        /*Super.Flags*/      OBJECT_NEUTRAL | OBJECT_DEFAULT_PRE_TICK | OBJECT_DEFAULT_LIGHT_SOURCE,
                        /*Super.Variable_A*/ ODS_ID_UI,
                        /*Super.Variable_B*/ 7
                    },
                    /*Flags*/                OBJECT_CHARACTER_SPAWN_UI_ON_HOVER
                }
                
                ; AI-персонаж
                MAKE_ODS ODS_ID_AI_CHARACTER                                    ; тестовый AI-персонаж
                FODS_Character {
                    {
                        /*Super.Class*/      OBJECT_CLASS_CHARACTER_AI,
                        /*Super.Flags*/      OBJECT_NEUTRAL | OBJECT_DEFAULT_PRE_TICK,
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
                    },
                    /*Behavior*/             OBJECT_UI_BEHAVIOR_DEFAULT
                }

                ; падающий штандарт
                MAKE_ODS ODS_ID_UI_STANDARD
                FODS_UI {
                    {
                        /*Super.Class*/      (OBJECT_UI_COMMON_STANDARD << 4) | OBJECT_CLASS_UI,
                        /*Super.Flags*/      OBJECT_NEUTRAL,
                        /*Super.Variable_A*/ UI_LIFETIME_INFINITE,
                        /*Super.Variable_B*/ 0
                    },
                    /*Flags*/                0,
                    {
                        /*Offset.X*/          0,
                        /*Offset.Y*/          0
                    },
                    /*Behavior*/             OBJECT_UI_BEHAVIOR_STANDARD
                }

                ; факел
                MAKE_ODS ODS_ID_TORCH                                           ; статический источник света
                FObjectDefaultSettings {
                    /*Class*/      OBJECT_CLASS_CONSTRUCTION,
                    /*Flags*/      OBJECT_NEUTRAL | OBJECT_DEFAULT_LIGHT_SOURCE,
                    /*Variable_A*/ 0,
                    /*Variable_B*/ 3                                            ; профиль света радиусом около одного гексагона
                }
                DS 4, 0                                                         ; dummy

; расчёт индекса временного спрайта факела в массиве структур FSprite
@SPRITE_ID_TORCH EQU ($ - Begin) / FSprite
TorchSpriteRef  SPRITE_LINKER 4, TorchSpriteFrames
TorchSpriteFrames
                SPRITE 7, 6, -3+3, -6+0-6, OR_XOR, 0, TorchSpriteData0
                SPRITE 5, 8, -2+3, -8+4-6, OR_XOR, 0, TorchSpriteData1
                SPRITE 7, 5, -3+3, -5+4-6, OR_XOR, 0, TorchSpriteData2
                SPRITE 9, 5, -4+3, -5+4-6, OR_XOR, 0, TorchSpriteData3
TorchSpriteData0 incbin "../../../Graphics/Original/UI/Gameplay/Overlay/Pointers/pointer_10.bin"
TorchSpriteData1 incbin "../../../Graphics/Original/UI/Gameplay/Overlay/Pointers/pointer_11.bin"
TorchSpriteData2 incbin "../../../Graphics/Original/UI/Gameplay/Overlay/Pointers/pointer_12.bin"
TorchSpriteData3 incbin "../../../Graphics/Original/UI/Gameplay/Overlay/Pointers/pointer_13.bin"

                endif ; ~ _METADATA_MAP_OBJECT_DEFAULT_SETTINGS_
