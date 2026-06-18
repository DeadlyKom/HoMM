
                ifndef _GRAPHICS_UI_MAIN_MENU_PORTAL_FIRST_PACK_
                define _GRAPHICS_UI_MAIN_MENU_PORTAL_FIRST_PACK_

                module Pack
                
                // архивация кадров
                ifdef _COMPRESSED_ASSET
                COMPRESS_FILE \
                "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_0.bin", \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_0.bin.ar"
                COMPRESS_FILE \
                "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_3.bin", \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_3.bin.ar"
                COMPRESS_FILE \
                "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_4.bin", \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_4.bin.ar"
                COMPRESS_FILE \
                "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_5.bin", \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_5.bin.ar"
                COMPRESS_FILE \
                "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_6.bin", \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_6.bin.ar"
                COMPRESS_FILE \
                "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_7.bin", \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_7.bin.ar"
                COMPRESS_FILE \
                "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_8.bin", \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_8.bin.ar"
                COMPRESS_FILE \
                "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_9.bin", \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_9.bin.ar"
                COMPRESS_FILE \
                "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_10.bin", \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_10.bin.ar"
                COMPRESS_FILE \
                "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_11.bin", \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_11.bin.ar"
                COMPRESS_FILE \
                "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_12.bin", \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_12.bin.ar"
                COMPRESS_FILE \
                "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_13.bin", \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_13.bin.ar"
                COMPRESS_FILE \
                "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_14.bin", \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_14.bin.ar"
                COMPRESS_FILE \
                "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_15.bin", \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_15.bin.ar"
                COMPRESS_FILE \
                "Builder/Assets/Graphics/Original/UI/MainMenu/Portal/First/Frame_16.bin", \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_16.bin.ar"
                endif

                ; продолжительность кадра
Duration        EQU 80 /*миллисекунды*/ / 20 /*период прерывания в миллисекундах*/
                ; ----------------------------------------
                module Frame0_7

                // формирование блоков кадров анимации
                ORG #0000
Begin:          EQU $
                DB Frame.Num

                /* дополнительное смещения -2 для удобства расчёта */
                DB UI.Graphics.MainMenu.Portal.Pack.Duration * 3
                DW Frame._0-$-2

                DB UI.Graphics.MainMenu.Portal.Pack.Duration
                DW Frame._3-$-2

                DB UI.Graphics.MainMenu.Portal.Pack.Duration
                DW Frame._4-$-2

                DB UI.Graphics.MainMenu.Portal.Pack.Duration
                DW Frame._5-$-2

                DB UI.Graphics.MainMenu.Portal.Pack.Duration
                DW Frame._6-$-2

                DB UI.Graphics.MainMenu.Portal.Pack.Duration
                DW Frame._7-$-2
Frame:
._0             incbin "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_0.bin.ar"
._3             incbin "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_3.bin.ar"
._4             incbin "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_4.bin.ar"
._5             incbin "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_5.bin.ar"
._6             incbin "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_6.bin.ar"
._7             incbin "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_7.bin.ar"
.Num:           EQU 6   // устанавливать в ручную
Size            EQU $-Begin
                COMPRESSED_ASSET \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/0_7.bin.pack.ar", \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/0_7.pack.ar"
                endmodule

                ; ----------------------------------------
                module Frame8_16

                // формирование блоков кадров анимации
                ORG #0000
Begin:          EQU $
                DB Frame.Num
                DW Frame._8-$
                DW Frame._9-$
                DW Frame._10-$
                DW Frame._11-$
                DW Frame._12-$
                DW Frame._13-$
                DW Frame._14-$
                DW Frame._15-$
                DW Frame._16-$
Frame:
._8             incbin "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_8.bin.ar"
._9             incbin "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_9.bin.ar"
._10            incbin "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_10.bin.ar"
._11            incbin "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_11.bin.ar"
._12            incbin "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_12.bin.ar"
._13            incbin "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_13.bin.ar"
._14            incbin "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_14.bin.ar"
._15            incbin "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_15.bin.ar"
._16            incbin "Builder/Assets/Graphics/Compressed/MainMenu/First/Frame_16.bin.ar"
.Num:           EQU 9   // устанавливать в ручную
Size            EQU $-Begin
                
                COMPRESSED_ASSET \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/8_16.bin.pack.ar", \
                "Builder/Assets/Graphics/Compressed/MainMenu/First/8_16.pack.ar"
                endmodule
                endmodule

                endif ; ~ _GRAPHICS_UI_MAIN_MENU_PORTAL_FIRST_PACK_
