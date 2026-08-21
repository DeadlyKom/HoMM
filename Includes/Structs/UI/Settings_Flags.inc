
                ifndef _STRUCTS_UI_SETTINGS_FLAGS_
                define _STRUCTS_UI_SETTINGS_FLAGS_

                struct FUISettings_Flags                                        ; настройки установки или сброса флагов UI объекта          [1 байт]
Flags           DB #00                                                          ; маска изменяемых флагов FObjectUI.Layer.Flags             [1 байт]
                ends

                endif ; ~_STRUCTS_UI_SETTINGS_FLAGS_
