
                ifndef _CONST_LAYER_OBJECT_
                define _CONST_LAYER_OBJECT_
; значения для поля FLayerObject.Flags
LAYER_OBJECT_ATTR_ALIGN_BIT         EQU 0x00                                    ; флаг, выравнивать положение объекта по знакоместу
LAYER_OBJECT_AXIS_Y_OFFSET_BIT      EQU 0x01                                    ; операция со смещением AxisOffset.Y
                                                                                ;   0 - прибавить к экранной позиции
                                                                                ;   1 - вычесть из экранной позиции
LAYER_OBJECT_AXIS_X_OFFSET_BIT      EQU 0x02                                    ; операция со смещением AxisOffset.X
                                                                                ;   0 - прибавить к экранной позиции
                                                                                ;   1 - вычесть из экранной позиции

LAYER_OBJECT_ATTR_ALIGN             EQU 1 << LAYER_OBJECT_ATTR_ALIGN_BIT
LAYER_OBJECT_AXIS_Y_OFFSET_ADD      EQU 0 << LAYER_OBJECT_AXIS_Y_OFFSET_BIT     ; прибавить AxisOffset.Y к экранной позиции
LAYER_OBJECT_AXIS_Y_OFFSET_SUBTRACT EQU 1 << LAYER_OBJECT_AXIS_Y_OFFSET_BIT     ; вычесть AxisOffset.Y из экранной позиции
LAYER_OBJECT_AXIS_X_OFFSET_ADD      EQU 0 << LAYER_OBJECT_AXIS_X_OFFSET_BIT     ; прибавить AxisOffset.X к экранной позиции
LAYER_OBJECT_AXIS_X_OFFSET_SUBTRACT EQU 1 << LAYER_OBJECT_AXIS_X_OFFSET_BIT     ; вычесть AxisOffset.X из экранной позиции

                endif ; ~_CONST_LAYER_OBJECT_
