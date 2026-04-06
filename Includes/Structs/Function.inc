
                ifndef _STRUCTS_FUNCTION_
                define _STRUCTS_FUNCTION_

                struct FFunctionRef                                             ; ссылка на функцию                                         [2 байта]
Adr             FAddress                                                        ; адрес                                                     [2 байта]
                ends
                
                struct FPagedFunctionRef                                        ; страничная ссылка на функцию                              [3 байта]
Page            DB #00                                                          ; номер страницы                                            [1 байт]
Function        FFunctionRef                                                    ; ссылка на функцию                                         [2 байта]
                ends

                endif ; ~_STRUCTS_FUNCTION_
