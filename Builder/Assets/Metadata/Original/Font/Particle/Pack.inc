
                ifndef _METADATA_FONT_PARTICLE_PACK_
                define _METADATA_FONT_PARTICLE_PACK_

                module Pack

                ORG #0000
Begin:          EQU $
                DB Glyphs.Num                                                   ; количество глифов

                ; таблица глифов
                DW Glyphs.ru_0
                DW Glyphs.ru_1
                DW Glyphs.ru_2
                DW Glyphs.ru_3
                DW Glyphs.ru_4
                DW Glyphs.ru_5
Glyphs.Num      EQU ($-Begin-1) / 2
Glyphs:         ; глифы
.ru_0           incbin "Glyph ru_0.bin"                                         ; А
.ru_1           incbin "Glyph ru_1.bin"                                         ; Б
.ru_2           incbin "Glyph ru_2.bin"                                         ; В
.ru_3           incbin "Glyph ru_3.bin"                                         ; Г
.ru_4           incbin "Glyph ru_4.bin"                                         ; Д
.ru_5           incbin "Glyph ru_5.bin"                                         ; Е
Size            EQU $
                COMPRESSED_ASSET \
                "Builder/Assets/Metadata/Original/Font/Particle/Glyphs ru.pack", \
                "Builder/Assets/Metadata/Compressed/Font/Glyphs ru.pack.ar"
                endmodule

                endif ; ~ _METADATA_FONT_PARTICLE_PACK_
