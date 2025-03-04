
                ifndef _STRUCT_VECTOR_16_
                define _STRUCT_VECTOR_16_

                struct FVector16
X               FValue
Y               FValue
                ends

                struct FVector16_YX
Y               FValue                                                          ; для сортировки первый Y
X               FValue
                ends

                endif ; ~_STRUCT_VECTOR_16_
