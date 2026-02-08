
                ifndef _KERNEL_MATH_
                define _KERNEL_MATH_
Math
.Mul16x8_16     EQU Kernel.Math.Mul16x8_16

.Div8x8         EQU Kernel.Math.Div8x8
.Div16x8_16     EQU Kernel.Math.Div16x8_16

.Sqrt           EQU Kernel.Math.Sqrt
.DistSquared    EQU Kernel.Math.DistSquared
.Normalize      EQU Kernel.Math.Normalize

.Rand8          EQU Kernel.Math.Rand8
.PopSeed        EQU Kernel.Math.PopSeed
.PushSeed       EQU Kernel.Math.PushSeed
.SetSeed16      EQU Kernel.Math.SetSeed16
.SetSeed32      EQU Kernel.Math.SetSeed32
.SetSeed80      EQU Kernel.Math.SetSeed80

.ROL.x32        EQU Kernel.Math.Rotate.Left
.ROR.x32        EQU Kernel.Math.Rotate.Right
.Hash           EQU Kernel.Math.Hash.Function
                endif ; ~_KERNEL_MATH_
