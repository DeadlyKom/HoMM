
                ifndef _GRAPHICS_UI_MAIN_MENU_PORTAL_FIRST_PACK_
                define _GRAPHICS_UI_MAIN_MENU_PORTAL_FIRST_PACK_

                module Pack
                ; ----------------------------------------
                module Frame0_7

                // формирование блоков кадров анимации
                ORG #0000
Begin:          EQU $
                DB Frame.Num

                /* дополнительное смещения -2 для удобства расчёта */
                DB #03
                DW Frame._0-$-2

                DB #01
                DW Frame._3-$-2

                DB #01
                DW Frame._4-$-2

                DB #01
                DW Frame._5-$-2

                DB #01
                DW Frame._6-$-2

                DB #01
                DW Frame._7-$-2
Frame:
._0             incbin "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_0.bin"
._3             incbin "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_3.bin"
._4             incbin "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_4.bin"
._5             incbin "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_5.bin"
._6             incbin "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_6.bin"
._7             incbin "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_7.bin"
.Num:           EQU 6   ; устанавливать вручную
Size            EQU $-Begin
                COMPRESSED_ASSET \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/0_7.pack", \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/0_7.pack.ar"
                endmodule

                ; ----------------------------------------
                module Frame8_11

                // формирование блоков кадров анимации
                ORG #0000
Begin:          EQU $
                DB Frame.Num

                /* дополнительное смещения -2 для удобства расчёта */
                DB #01
                DW Frame._8-$-2

                DB #01
                DW Frame._9-$-2

                DB #01
                DW Frame._10-$-2

                DB #01
                DW Frame._11-$-2
Frame:
._8             incbin "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_8.bin"
._9             incbin "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_9.bin"
._10            incbin "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_10.bin"
._11            incbin "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_11.bin"
.Num:           EQU 4   // устанавливать вручную
Size            EQU $-Begin
                
                COMPRESSED_ASSET \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/8_11.pack", \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/8_11.pack.ar"
                endmodule

                ; ----------------------------------------
                module Frame12_16

                // формирование блоков кадров анимации
                ORG #0000
Begin:          EQU $
                DB Frame.Num

                /* дополнительное смещения -2 для удобства расчёта */
                DB #01
                DW Frame._12-$-2

                DB #01
                DW Frame._13-$-2

                DB #01
                DW Frame._14-$-2

                DB #01
                DW Frame._15-$-2

                DB #01
                DW Frame._16-$-2
Frame:
._12            incbin "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_12.bin"
._13            incbin "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_13.bin"
._14            incbin "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_14.bin"
._15            incbin "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_15.bin"
._16            incbin "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_16.bin"
.Num:           EQU 5   // устанавливать вручную
Size            EQU $-Begin
                COMPRESSED_ASSET \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/12_16.pack", \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/12_16.pack.ar"
                endmodule

                ; ----------------------------------------

                endmodule

                endif ; ~ _GRAPHICS_UI_MAIN_MENU_PORTAL_FIRST_PACK_
