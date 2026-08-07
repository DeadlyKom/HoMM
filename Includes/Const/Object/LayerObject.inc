
                ifndef _CONST_LAYER_OBJECT_
                define _CONST_LAYER_OBJECT_
; значения для поля FLayerObject.Flags
LAYER_OBJECT_ATTR_ALIGN_BIT    EQU 0x00                                         ; флаг, выравнивать положение объекта по знакоместу

LAYER_OBJECT_ATTR_ALIGN        EQU 1 << LAYER_OBJECT_ATTR_ALIGN_BIT

                endif ; ~_CONST_LAYER_OBJECT_
