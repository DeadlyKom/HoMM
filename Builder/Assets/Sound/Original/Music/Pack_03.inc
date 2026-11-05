
                ifndef _ASSETS_PACKING_SOUND_MUSIC_03_PACK_
                define _ASSETS_PACKING_SOUND_MUSIC_03_PACK_

                module Music_03
                ORG #0000
Begin:          EQU $
                incbin "31___.pt3"
Size            EQU $-Begin
                assert Size <= Size.Music.Slots, "music exceeds slot capacity"
                COMPRESSED_ASSET \
                "Builder/Assets/Sound/Compressed/Music_03.pack", \
                "Builder/Assets/Sound/Compressed/Music_03.pack.ar"
                endmodule

                endif ; ~_ASSETS_PACKING_SOUND_MUSIC_03_PACK_
