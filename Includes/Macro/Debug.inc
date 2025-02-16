
                ifndef _MACRO_DEBUG_
                define _MACRO_DEBUG_
DEBUG_BREAK_POINT_C: macro
                ifdef _DEBUG
                JR C, $                                                         ; произошла ошибка
                endif
                endm
DEBUG_BREAK_POINT_NC: macro
                ifdef _DEBUG
                JR NC, $                                                        ; произошла ошибка
                endif
                endm
DEBUG_BREAK_POINT_Z: macro
                ifdef _DEBUG
                JR Z, $                                                         ; произошла ошибка
                endif
                endm
DEBUG_BREAK_POINT_NZ: macro
                ifdef _DEBUG
                JR NZ, $                                                        ; произошла ошибка
                endif
                endm
DEBUG_BREAK_POINT_PO: macro
                ifdef _DEBUG
                JP PO, $                                                        ; произошла ошибка
                endif
                endm

                endif ; ~_MACRO_DEBUG_
