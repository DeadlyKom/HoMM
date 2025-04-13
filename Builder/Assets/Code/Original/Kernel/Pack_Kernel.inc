
                ifndef _CODE_KERNEL_PACK_
                define _CODE_KERNEL_PACK_

                ; - компиляция модуля

                MMU 2, Page.Kernel
                ORG Bootloader.KernelMinimal.End                                ; начальный адрес кернеля меняется в разных этапах компиляции
                                                                                ; указан адрес следующий за минимальныйм кернелем
                module Kernel

                display "\'Kernel\':\t\t\t\t\t\t-------------------- [ ", /D, Size, "/", /D, Size + BufferSize/*размер кода и буферов*/, " byte(s) / free ", /D, #4000 - ($ - #8000 + Size + BufferSize), "]\t[", /D, Page.Kernel, "]\t ------------------------"
Begin:          EQU $

                ; functions
                include "Source/Functions/Include.inc"
                
                ; modules
                include "Source/Modules/Include.inc"

                ; memory
                include "Source/Memory/MemcpyPages.asm"
                include "Source/Memory/MemcpySprite.asm"

                ; math
                include "Source/Math/RNG/Rand8.asm"

                ; input
                include "Source/Input/Include.inc"

                ; draw world
                include "Source/Draw/Sprite/Include.inc"
                include "Source/Draw/World/Background/Include.inc"

                ; работа с информацией о спрайтов в буфере Adr.SpriteInfoBuffer
                include "Source/Sprite/Include.inc"

                ; chunk array
                include "Source/ChunkArray/Include.inc"

                ifdef SHOW_FPS | _DEBUG
                include "Source/Utils/Debug/Console.asm"
                include "Source/Utils/Debug/FPS_Counter.asm"
                endif
Size:           EQU $-Begin                                                     ; размер кода

                display " - Sprite info buffer:\t\t\t\t", /A, Adr.SpriteInfoBuffer, "\t= busy [ ", /D, Size.SpriteInfoBuffer, " byte(s)  ]"
                display " - Extra buffer:\t\t\t\t\t", /A, Adr.ExtraBuffer, "\t= busy [ ", /D, Size.ExtraBuffer, " byte(s)  ]"
                display " - Sort buffer:\t\t\t\t\t", /A, Adr.SortBuffer, "\t= busy [ ", /D, Size.SortBuffer, " byte(s)  ]"
                display " - Shared buffer:\t\t\t\t\t", /A, Adr.SharedBuffer, "\t= busy [ ", /D, Size.SharedBuffer, " byte(s)  ]"
                display " - Render buffer:\t\t\t\t\t", /A, Adr.RenderBuffer, "\t= busy [ ", /D, Size.RenderBuffer, " byte(s)  ]"
                display " - Tilemap buffer:\t\t\t\t\t", /A, Adr.TilemapBuffer, "\t= busy [ ", /D, Size.TilemapBuffer, " byte(s)  ]"
BufferSize:     EQU Size.SpriteInfoBuffer + Size.ExtraBuffer + Size.SortBuffer +  Size.SharedBuffer + Size.RenderBuffer + Size.TilemapBuffer

                ifdef _REBUILD
                savebin "Builder/Assets/Code/Original/Kernel/Kernel.pack", Begin, Size
                shellexec "Tools\Compressor\salvador.exe -v Builder/Assets/Code/Original/Kernel/Kernel.pack Builder/Assets/Code/Compressed/Kernel.pack.ar"
                endif

                ORG 0x0000
Begin.ar        incbin "Builder/Assets/Code/Compressed/Kernel.pack.ar"
Size.ar         EQU $-Begin.ar
Size.Sector.ar  EQU ((Size.ar % TRDOS.SECTOR_SIZE > 0) & 0x01) + (Size.ar >> 8)

                endmodule

                endif ; ~ _CODE_KERNEL_PACK_
