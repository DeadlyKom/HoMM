
                ifndef _KERNEL_INPUT_
                define _KERNEL_INPUT_
Input:
.CheckKeyState  EQU Kernel.Input.CheckKeyState
.JumpKeys       EQU Kernel.Input.JumpKeys
.ArrayKeys      EQU Kernel.Input.JumpKeys.LastKey
.JumpHandlerKey EQU Kernel.Input.JumpHandlerKey
Kempston:
.Initialize     EQU Kernel.Kempston.Initialize                                  ; инициализация кемпстон джойстика
.CheckKeyState  EQU Kernel.Kempston.CheckKeyState
.GetPressedKey  EQU Kernel.Kempston.GetPressedKey
.WaitPressedKey EQU Kernel.Kempston.WaitPressedKey
.WaitReleasedKey EQU Kernel.Kempston.WaitReleasedKey                            ; ожидание отпускание ранее нажатой клавиши
.AnyKeyPressed  EQU Kernel.Kempston.AnyKeyPressed                               ; проверка нажатия либой клавиши
Keyboard:
.CheckKeyState  EQU Kernel.Keyboard.CheckKeyState
.GetPressedKey  EQU Kernel.Keyboard.GetPressedKey
.GetPressed_1_5 EQU Kernel.Keyboard.GetPressed_1_5
.GetVirtualKey  EQU Kernel.Keyboard.GetVirtualKey
.WaitPressedKey EQU Kernel.Keyboard.WaitPressedKey
.WaitReleasedKey EQU Kernel.Keyboard.WaitReleasedKey                            ; ожидание отпускание ранее нажатой клавиши
.AnyKeyPressed  EQU Kernel.Keyboard.AnyKeyPressed                               ; проверка нажатия либой клавиши

                ifdef ENABLE_MOUSE
Mouse:
.Initialize     EQU Kernel.Mouse.Initialize
.UpdateCursor   EQU Kernel.Mouse.UpdateCursor
.CheckKeyState  EQU Kernel.Mouse.CheckKeyState
.Position       EQU Kernel.Mouse.Position
.PositionX      EQU Kernel.Mouse.PositionX
.PositionY      EQU Kernel.Mouse.PositionY
.DeltaOffsetX   EQU Kernel.Mouse.LastValue.DeltaOffsetX                         ; дельта смещения мышки по горизонтали
.DeltaOffsetY   EQU Kernel.Mouse.LastValue.DeltaOffsetY                         ; дельта смещения мышки по вертикали
.PositionFlag   EQU Kernel.Mouse.PositionFlag                                   ; если курсор не поменяет позицию, хранит #FF
                endif

                endif ; ~_KERNEL_INPUT_
