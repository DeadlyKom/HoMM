
                ifndef _ASSETS_PACKING_SOUND_MUSIC_PACK_
                define _ASSETS_PACKING_SOUND_MUSIC_PACK_

                module Music_01
                ORG #0000
Begin:          EQU $
                inchob "KSA - Spec17 07 (1996).$m"                              ; inchob пропускает 17 байт HOBETA header
                                                                                ; ToDo: можно упрознить шапку высвободив 0х63 байта, но нужно дорабатывать проигрыватель
Size            EQU $-Begin
                COMPRESSED_ASSET \
                "Builder/Assets/Sound/Compressed/Music_01.pack", \
                "Builder/Assets/Sound/Compressed/Music_01.pack.ar"
                endmodule

                endif ; ~ _ASSETS_PACKING_SOUND_MUSIC_PACK_
