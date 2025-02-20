
                ifndef _STRUCTS_DISK_
                define _STRUCTS_DISK_

                struct FDisk                                                    ; информация о данных на диске              [3 байта]
Sector          FValue                                                          ; начальный сектор
Size            DB #00                                                          ; размер на диске (в секторах)

                ends

                endif ; ~_STRUCTS_DISK_
