
                ifndef _ASSETS_PACKING_SOUND_MUSIC_02_PACK_
                define _ASSETS_PACKING_SOUND_MUSIC_02_PACK_

                module Music_02
                ORG #0000
Begin:          EQU $
                incbin "30__.pt3"
Size            EQU $-Begin
                assert Size <= Size.Music.Slots, "music exceeds slot capacity"
                COMPRESSED_ASSET \
                "Builder/Assets/Sound/Compressed/Music_02.pack", \
                "Builder/Assets/Sound/Compressed/Music_02.pack.ar"
                endmodule

                endif ; ~_ASSETS_PACKING_SOUND_MUSIC_02_PACK_
