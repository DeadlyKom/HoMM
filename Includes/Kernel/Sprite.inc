
                ifndef _KERNEL_SPRITE_
                define _KERNEL_SPRITE_
Sprite:
.Initialize     EQU Kernel.Sprite.Initialize                                    ; инициализация массива информации о спрайтах SpriteInfoBuffer
.Add            EQU Kernel.Sprite.Add                                           ; добавление спрайта
.Copy           EQU Kernel.Sprite.Copy                                          ; копирование линейной структуры FSptrite в буфер SpriteInfoBuffer

                endif ; ~_KERNEL_SPRITE_
