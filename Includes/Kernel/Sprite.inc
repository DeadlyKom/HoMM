
                ifndef _KERNEL_SPRITE_
                define _KERNEL_SPRITE_
Sprite:
.Initialize     EQU Kernel.Sprite.Initialize                                    ; инициализация массива информации о спрайтах SpriteInfoBuffer
.Add            EQU Kernel.Sprite.Add                                           ; добавление спрайта
.Copy           EQU Kernel.Sprite.Copy                                          ; копирование линейной структуры FSptrite в буфер SpriteInfoBuffer
.FindGraphHeader            EQU Kernel.Sprite.FindGraphHeader                   ; поиск графического заголовка
.FindGraphHeader.HeaderNum  EQU Kernel.Sprite.FindGraphHeader.HeaderNum
.FindGraphHeader.HeaderAdr  EQU Kernel.Sprite.FindGraphHeader.HeaderAdr
.FillSpriteIndices          EQU Kernel.Sprite.FillSpriteIndices                 ; заполнение массива индексов спрайтов, согласно указанной последовательности

                endif ; ~_KERNEL_SPRITE_
