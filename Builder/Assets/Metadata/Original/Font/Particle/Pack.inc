
                ifndef _METADATA_FONT_PARTICLE_PACK_
                define _METADATA_FONT_PARTICLE_PACK_

                module Pack

                ORG #0000
Begin:          EQU $
                DB Glyphs.Num                                                   ; количество глифов

                ; таблица глифов
                DW Glyphs.space                                                 ; -- space
                DW Glyphs.exclamation                                           ; -- !
                DW Glyphs.empty                                                 ; -- нет символа "
                DW Glyphs.empty                                                 ; -- нет символа #
                DW Glyphs.empty                                                 ; -- нет символа $
                DW Glyphs.empty                                                 ; -- нет символа %
                DW Glyphs.empty                                                 ; -- нет символа &
                DW Glyphs.empty                                                 ; -- нет символа '
                DW Glyphs.empty                                                 ; -- нет символа (
                DW Glyphs.empty                                                 ; -- нет символа )
                DW Glyphs.empty                                                 ; -- нет символа *
                DW Glyphs.empty                                                 ; -- нет символа +
                DW Glyphs.comma                                                 ; -- ,
                DW Glyphs.minus                                                 ; -- -
                DW Glyphs.minus                                                 ; -- .
                DW Glyphs.empty                                                 ; -- нет символа /

                DW Glyphs.zero                                                  ; -- 0
                DW Glyphs.one                                                   ; -- 1
                DW Glyphs.two                                                   ; -- 2
                DW Glyphs.three                                                 ; -- 3
                DW Glyphs.four                                                  ; -- 4
                DW Glyphs.five                                                  ; -- 5
                DW Glyphs.six                                                   ; -- 6
                DW Glyphs.seven                                                 ; -- 7
                DW Glyphs.eight                                                 ; -- 8
                DW Glyphs.nine                                                  ; -- 9
                DW Glyphs.colon                                                 ; -- :
                DW Glyphs.semicolon                                             ; -- ;
                DW Glyphs.empty                                                 ; -- нет символа <
                DW Glyphs.empty                                                 ; -- нет символа =
                DW Glyphs.empty                                                 ; -- нет символа >
                DW Glyphs.question                                              ; -- ?

                DW Glyphs.empty                                                 ; -- нет символа ¡
                DW Glyphs.empty                                                 ; -- нет символа A
                DW Glyphs.empty                                                 ; -- нет символа B
                DW Glyphs.empty                                                 ; -- нет символа C
                DW Glyphs.empty                                                 ; -- нет символа D
                DW Glyphs.empty                                                 ; -- нет символа E
                DW Glyphs.empty                                                 ; -- нет символа F
                DW Glyphs.empty                                                 ; -- нет символа G
                DW Glyphs.empty                                                 ; -- нет символа H
                DW Glyphs.empty                                                 ; -- нет символа I
                DW Glyphs.empty                                                 ; -- нет символа J
                DW Glyphs.empty                                                 ; -- нет символа K
                DW Glyphs.empty                                                 ; -- нет символа L
                DW Glyphs.empty                                                 ; -- нет символа M
                DW Glyphs.empty                                                 ; -- нет символа N
                DW Glyphs.empty                                                 ; -- нет символа O

                DW Glyphs.empty                                                 ; -- нет символа P
                DW Glyphs.empty                                                 ; -- нет символа Q
                DW Glyphs.empty                                                 ; -- нет символа R
                DW Glyphs.empty                                                 ; -- нет символа S
                DW Glyphs.empty                                                 ; -- нет символа T
                DW Glyphs.empty                                                 ; -- нет символа U
                DW Glyphs.empty                                                 ; -- нет символа V
                DW Glyphs.empty                                                 ; -- нет символа W
                DW Glyphs.empty                                                 ; -- нет символа X
                DW Glyphs.empty                                                 ; -- нет символа Y
                DW Glyphs.empty                                                 ; -- нет символа Z
                DW Glyphs.empty                                                 ; -- нет символа [
                DW Glyphs.empty                                                 ; -- нет символа косая влево
                DW Glyphs.empty                                                 ; -- нет символа ]
                DW Glyphs.empty                                                 ; -- нет символа очистка
                DW Glyphs.empty                                                 ; -- нет символа _

                DW Glyphs.empty                                                 ; -- нет символа '
                DW Glyphs.empty                                                 ; -- нет символа a
                DW Glyphs.empty                                                 ; -- нет символа b
                DW Glyphs.empty                                                 ; -- нет символа c
                DW Glyphs.empty                                                 ; -- нет символа d
                DW Glyphs.empty                                                 ; -- нет символа e
                DW Glyphs.empty                                                 ; -- нет символа f
                DW Glyphs.empty                                                 ; -- нет символа g
                DW Glyphs.empty                                                 ; -- нет символа h
                DW Glyphs.empty                                                 ; -- нет символа i
                DW Glyphs.empty                                                 ; -- нет символа j
                DW Glyphs.empty                                                 ; -- нет символа k
                DW Glyphs.empty                                                 ; -- нет символа l
                DW Glyphs.empty                                                 ; -- нет символа m
                DW Glyphs.empty                                                 ; -- нет символа n
                DW Glyphs.empty                                                 ; -- нет символа o

                DW Glyphs.empty                                                 ; -- нет символа p
                DW Glyphs.empty                                                 ; -- нет символа q
                DW Glyphs.empty                                                 ; -- нет символа r
                DW Glyphs.empty                                                 ; -- нет символа s
                DW Glyphs.empty                                                 ; -- нет символа t
                DW Glyphs.empty                                                 ; -- нет символа u
                DW Glyphs.empty                                                 ; -- нет символа v
                DW Glyphs.empty                                                 ; -- нет символа w
                DW Glyphs.empty                                                 ; -- нет символа x
                DW Glyphs.empty                                                 ; -- нет символа y
                DW Glyphs.empty                                                 ; -- нет символа z
                DW Glyphs.empty                                                 ; -- нет символа {
                DW Glyphs.empty                                                 ; -- нет символа |
                DW Glyphs.empty                                                 ; -- нет символа }
                DW Glyphs.empty                                                 ; -- нет символа ~
                DW Glyphs.empty                                                 ; -- нет символа ¿

                DW Glyphs.ru_0                                                  ; -- А
                DW Glyphs.ru_1                                                  ; -- Б
                DW Glyphs.ru_2                                                  ; -- В
                DW Glyphs.ru_3                                                  ; -- Г
                DW Glyphs.ru_4                                                  ; -- Д
                DW Glyphs.ru_5                                                  ; -- Е
                DW Glyphs.ru_6                                                  ; -- Ё
                DW Glyphs.ru_7                                                  ; -- Ж
                DW Glyphs.ru_8                                                  ; -- З
                DW Glyphs.ru_9                                                  ; -- И
                DW Glyphs.ru_10                                                 ; -- Й
                DW Glyphs.ru_11                                                 ; -- К
                DW Glyphs.ru_12                                                 ; -- Л
                DW Glyphs.ru_13                                                 ; -- М
                DW Glyphs.ru_14                                                 ; -- Н
                DW Glyphs.ru_15                                                 ; -- О

                DW Glyphs.ru_16                                                 ; -- П
                DW Glyphs.ru_17                                                 ; -- Р
                DW Glyphs.ru_18                                                 ; -- С
                DW Glyphs.ru_19                                                 ; -- Т
                DW Glyphs.ru_20                                                 ; -- У
                DW Glyphs.ru_21                                                 ; -- Ф
                DW Glyphs.ru_22                                                 ; -- Х
                DW Glyphs.ru_23                                                 ; -- Ц
                DW Glyphs.ru_24                                                 ; -- Ч
                DW Glyphs.ru_25                                                 ; -- Ш
                DW Glyphs.ru_26                                                 ; -- Щ
                DW Glyphs.ru_27                                                 ; -- Ъ
                DW Glyphs.ru_28                                                 ; -- Ы
                DW Glyphs.ru_29                                                 ; -- Ь
                DW Glyphs.ru_30                                                 ; -- Э
                DW Glyphs.ru_31                                                 ; -- Ю

                DW Glyphs.ru_32                                                 ; -- Я
                DW Glyphs.ru_low_0                                              ; -- а
                DW Glyphs.ru_low_1                                              ; -- б
                DW Glyphs.ru_low_2                                              ; -- в
                DW Glyphs.ru_low_3                                              ; -- г
                DW Glyphs.ru_low_4                                              ; -- д
                DW Glyphs.ru_low_5                                              ; -- е
                DW Glyphs.ru_low_6                                              ; -- ё
                DW Glyphs.ru_low_7                                              ; -- ж
                DW Glyphs.ru_low_8                                              ; -- з
                DW Glyphs.ru_low_9                                              ; -- и
                DW Glyphs.ru_low_10                                             ; -- й
                DW Glyphs.ru_low_11                                             ; -- к
                DW Glyphs.ru_low_12                                             ; -- л
                DW Glyphs.ru_low_13                                             ; -- м
                DW Glyphs.ru_low_14                                             ; -- н

                DW Glyphs.ru_low_15                                             ; -- о
                DW Glyphs.ru_low_16                                             ; -- п
                DW Glyphs.ru_low_17                                             ; -- р
                DW Glyphs.ru_low_18                                             ; -- с
                DW Glyphs.ru_low_19                                             ; -- т
                DW Glyphs.ru_low_20                                             ; -- у
                DW Glyphs.ru_low_21                                             ; -- ф
                DW Glyphs.ru_low_22                                             ; -- х
                DW Glyphs.ru_low_23                                             ; -- ц
                DW Glyphs.ru_low_24                                             ; -- ч
                DW Glyphs.ru_low_25                                             ; -- ш
                DW Glyphs.ru_low_26                                             ; -- щ
                DW Glyphs.ru_low_27                                             ; -- ъ
                DW Glyphs.ru_low_28                                             ; -- ы
                DW Glyphs.ru_low_29                                             ; -- ь
                DW Glyphs.ru_low_30                                             ; -- э

                DW Glyphs.ru_low_31                                             ; -- ю
                DW Glyphs.ru_low_32                                             ; -- я
                DW Glyphs.ru_low_33                                             ; -- ѣ
                DW Glyphs.ru_low_34                                             ; -- ї
                DW Glyphs.ru_low_35                                             ; -- ѥ

Glyphs.Num      EQU ($-Begin-1) / 2
Glyphs:         ; глифы
.empty          FGlyphHeader { 0, 1, 0 }                                        ; нет символа
.space          FGlyphHeader { 0, 4, 0 }                                        ; пробел
.exclamation    incbin "Glyph sym_0.bin"                                        ; !
.question       incbin "Glyph sym_1.bin"                                        ; ? 
.colon          incbin "Glyph sym_2.bin"                                        ; :
.semicolon      incbin "Glyph sym_3.bin"                                        ; ;
.comma          incbin "Glyph sym_4.bin"                                        ; ,
.dot            incbin "Glyph sym_5.bin"                                        ; .
.minus          incbin "Glyph sym_6.bin"                                        ; -

.zero           incbin "Glyph num_0.bin"                                        ; 0
.one            incbin "Glyph num_1.bin"                                        ; 1
.two            incbin "Glyph num_2.bin"                                        ; 2
.three          incbin "Glyph num_3.bin"                                        ; 3
.four           incbin "Glyph num_4.bin"                                        ; 4
.five           incbin "Glyph num_5.bin"                                        ; 5
.six            incbin "Glyph num_6.bin"                                        ; 6
.seven          incbin "Glyph num_7.bin"                                        ; 7
.eight          incbin "Glyph num_8.bin"                                        ; 8
.nine           incbin "Glyph num_9.bin"                                        ; 9

.ru_0           incbin "Glyph ru_0.bin"                                         ; А
.ru_1           incbin "Glyph ru_1.bin"                                         ; Б
.ru_2           incbin "Glyph ru_2.bin"                                         ; В
.ru_3           incbin "Glyph ru_3.bin"                                         ; Г
.ru_4           incbin "Glyph ru_4.bin"                                         ; Д
.ru_5           incbin "Glyph ru_5.bin"                                         ; Е
.ru_6           incbin "Glyph ru_6.bin"                                         ; Ё
.ru_7           incbin "Glyph ru_7.bin"                                         ; Ж
.ru_8           incbin "Glyph ru_8.bin"                                         ; З
.ru_9           incbin "Glyph ru_9.bin"                                         ; И
.ru_10          incbin "Glyph ru_10.bin"                                        ; Й
.ru_11          incbin "Glyph ru_11.bin"                                        ; К
.ru_12          incbin "Glyph ru_12.bin"                                        ; Л
.ru_13          incbin "Glyph ru_13.bin"                                        ; М
.ru_14          incbin "Glyph ru_14.bin"                                        ; Н
.ru_15          incbin "Glyph ru_15.bin"                                        ; О

.ru_16          incbin "Glyph ru_16.bin"                                        ; П
.ru_17          incbin "Glyph ru_17.bin"                                        ; Р
.ru_18          incbin "Glyph ru_18.bin"                                        ; С
.ru_19          incbin "Glyph ru_19.bin"                                        ; Т
.ru_20          incbin "Glyph ru_20.bin"                                        ; У
.ru_21          incbin "Glyph ru_21.bin"                                        ; Ф
.ru_22          incbin "Glyph ru_22.bin"                                        ; Х
.ru_23          incbin "Glyph ru_23.bin"                                        ; Ц
.ru_24          incbin "Glyph ru_24.bin"                                        ; Ч
.ru_25          incbin "Glyph ru_25.bin"                                        ; Ш
.ru_26          incbin "Glyph ru_26.bin"                                        ; Щ
.ru_27          incbin "Glyph ru_27.bin"                                        ; Ъ
.ru_28          incbin "Glyph ru_28.bin"                                        ; Ы
.ru_29          incbin "Glyph ru_29.bin"                                        ; Ь
.ru_30          incbin "Glyph ru_30.bin"                                        ; Э
.ru_31          incbin "Glyph ru_31.bin"                                        ; Ю

.ru_32          incbin "Glyph ru_32.bin"                                        ; Я
.ru_low_0       incbin "Glyph ru_low_0.bin"                                     ; а
.ru_low_1       incbin "Glyph ru_low_1.bin"                                     ; б
.ru_low_2       incbin "Glyph ru_low_2.bin"                                     ; в
.ru_low_3       incbin "Glyph ru_low_3.bin"                                     ; г
.ru_low_4       incbin "Glyph ru_low_4.bin"                                     ; д
.ru_low_5       incbin "Glyph ru_low_5.bin"                                     ; е
.ru_low_6       incbin "Glyph ru_low_6.bin"                                     ; ё
.ru_low_7       incbin "Glyph ru_low_7.bin"                                     ; ж
.ru_low_8       incbin "Glyph ru_low_8.bin"                                     ; з
.ru_low_9       incbin "Glyph ru_low_9.bin"                                     ; и
.ru_low_10      incbin "Glyph ru_low_10.bin"                                    ; й
.ru_low_11      incbin "Glyph ru_low_11.bin"                                    ; к
.ru_low_12      incbin "Glyph ru_low_12.bin"                                    ; л
.ru_low_13      incbin "Glyph ru_low_13.bin"                                    ; м
.ru_low_14      incbin "Glyph ru_low_14.bin"                                    ; н

.ru_low_15      incbin "Glyph ru_low_15.bin"                                    ; о
.ru_low_16      incbin "Glyph ru_low_16.bin"                                    ; п
.ru_low_17      incbin "Glyph ru_low_17.bin"                                    ; р
.ru_low_18      incbin "Glyph ru_low_18.bin"                                    ; с
.ru_low_19      incbin "Glyph ru_low_19.bin"                                    ; т
.ru_low_20      incbin "Glyph ru_low_20.bin"                                    ; у
.ru_low_21      incbin "Glyph ru_low_21.bin"                                    ; ф
.ru_low_22      incbin "Glyph ru_low_22.bin"                                    ; х
.ru_low_23      incbin "Glyph ru_low_23.bin"                                    ; ц
.ru_low_24      incbin "Glyph ru_low_24.bin"                                    ; ч
.ru_low_25      incbin "Glyph ru_low_25.bin"                                    ; ш
.ru_low_26      incbin "Glyph ru_low_26.bin"                                    ; щ
.ru_low_27      incbin "Glyph ru_low_27.bin"                                    ; ъ
.ru_low_28      incbin "Glyph ru_low_28.bin"                                    ; ы
.ru_low_29      incbin "Glyph ru_low_29.bin"                                    ; ь
.ru_low_30      incbin "Glyph ru_low_30.bin"                                    ; э

.ru_low_31      incbin "Glyph ru_low_31.bin"                                    ; ю
.ru_low_32      incbin "Glyph ru_low_32.bin"                                    ; я
.ru_low_33      incbin "Glyph ru_low_33.bin"                                    ; ѣ
.ru_low_34      incbin "Glyph ru_low_34.bin"                                    ; ї
.ru_low_35      incbin "Glyph ru_low_35.bin"                                    ; ѥ

Size            EQU $
                COMPRESSED_ASSET \
                "Builder/Assets/Metadata/Original/Font/Particle/Glyphs ru.pack", \
                "Builder/Assets/Metadata/Compressed/Font/Glyphs ru.pack.ar"
                endmodule

                endif ; ~ _METADATA_FONT_PARTICLE_PACK_
