
                ifndef _STRUCTS_FRAME_
                define _STRUCTS_FRAME_

                struct FFrame                                                   ; структура описывающий один кадр                           [4 байта]
Duration        DB #00                                                          ; продолжительность кадра в прерываниях (1/50)              [1 байт]
Address         FLinearAddress                                                  ; адрес расположения кадра                                  [3 байта]
                ends

                endif ; ~_STRUCTS_FRAME_
