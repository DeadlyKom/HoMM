
                ifndef _GRAPHICS_UI_WORLD_TREE_SYMBOL_PACK_
                define _GRAPHICS_UI_WORLD_TREE_SYMBOL_PACK_

                module WorldTreeSymbol
                ORG #0000
Begin:          EQU $
                DB Offset.Num
Offset:         EQU $
                OFFSET #0000
                OFFSET Frame._7
                OFFSET Frame._6
                OFFSET Frame._5
                OFFSET Frame._4
                OFFSET Frame._3
                OFFSET Frame._2
                OFFSET Frame._1
                OFFSET Frame._0
Offset.Num      EQU ($-Offset) / 2
                OFFSET End
Frame:
._7             incbin "Frame_7.bin"
._6             incbin "Frame_6.bin"
._5             incbin "Frame_5.bin"
._4             incbin "Frame_4.bin"
._3             incbin "Frame_3.bin"
._2             incbin "Frame_2.bin"
._1             incbin "Frame_1.bin"
._0             incbin "Frame_0.bin"
End:            EQU $

                SAVE_PACK "Builder/Assets/Graphics/Compressed/Progress/WorldTreeSymbol.pack"
                endmodule

                endif ; ~ _GRAPHICS_UI_WORLD_TREE_SYMBOL_PACK_
