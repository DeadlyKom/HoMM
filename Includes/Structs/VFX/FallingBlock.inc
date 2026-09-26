
                ifndef _STRUCT_FALLING_BLOCK_
                define _STRUCT_FALLING_BLOCK_

                struct FFallingBlock                                            ; состояние падающего блока, 4 байта
Index           DB #00                                                          ; номер исходного блока, от 0 до 191
Step            DB #00                                                          ; индекс в общей таблице смещений падения
Source          DW #0000                                                        ; полный адрес графики исходного блока
                ends

                endif ; ~_STRUCT_FALLING_BLOCK_
