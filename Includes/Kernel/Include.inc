
                ifndef _KERNEL_INCLUDE_
                define _KERNEL_INCLUDE_

                include "Math.inc"
                include "Draw.inc"
                include "Input.inc"
                include "World.inc"
                include "Render.inc"
                include "Screen.inc"
                include "Sprite.inc"
                include "TR-DOS.inc"
                include "Memory.inc"
                include "Convert.inc"
                include "Interrupt.inc"
                include "Functions.inc"
                include "ChunkArray.inc"
                include "MemoryPages.inc"
                include "Decompressor.inc"
                include "AssetsManager.inc"
                include "ExecuteModule.inc"

                ifdef SHOW_FPS | _DEBUG
                include "Console.inc"
                include "FPS_Counter.inc"
                endif

                endif ; ~_KERNEL_INCLUDE_
