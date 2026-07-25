
                ifndef _GRAPHICS_FONT_PACK_RU_INCLUDE_
                define _GRAPHICS_FONT_PACK_RU_INCLUDE_

                module Pack
                module Ru

                ORG #0000
Begin:          EQU $

                ; таблица символов
                DW Font.space                                                   ; -- space
                DW Font.exclamation                                             ; -- !
                DW Font.empty                                                   ; -- нет символа "
                DW Font.empty                                                   ; -- нет символа #
                DW Font.empty                                                   ; -- нет символа $
                DW Font.empty                                                   ; -- нет символа %
                DW Font.empty                                                   ; -- нет символа &
                DW Font.empty                                                   ; -- нет символа '
                DW Font.empty                                                   ; -- нет символа (
                DW Font.empty                                                   ; -- нет символа )
                DW Font.empty                                                   ; -- нет символа *
                DW Font.empty                                                   ; -- нет символа +
                DW Font.comma                                                   ; -- ,
                DW Font.minus                                                   ; -- -
                DW Font.dot                                                     ; -- .
                DW Font.empty                                                   ; -- нет символа /

                DW Font.zero                                                    ; -- 0
                DW Font.one                                                     ; -- 1
                DW Font.two                                                     ; -- 2
                DW Font.three                                                   ; -- 3
                DW Font.four                                                    ; -- 4
                DW Font.five                                                    ; -- 5
                DW Font.six                                                     ; -- 6
                DW Font.seven                                                   ; -- 7
                DW Font.eight                                                   ; -- 8
                DW Font.nine                                                    ; -- 9
                DW Font.colon                                                   ; -- :
                DW Font.semicolon                                               ; -- ;
                DW Font.empty                                                   ; -- нет символа <
                DW Font.empty                                                   ; -- нет символа =
                DW Font.empty                                                   ; -- нет символа >
                DW Font.question                                                ; -- ?

                DW Font.empty                                                   ; -- нет символа ¡
                DW Font.empty                                                   ; -- нет символа A
                DW Font.empty                                                   ; -- нет символа B
                DW Font.empty                                                   ; -- нет символа C
                DW Font.empty                                                   ; -- нет символа D
                DW Font.empty                                                   ; -- нет символа E
                DW Font.empty                                                   ; -- нет символа F
                DW Font.empty                                                   ; -- нет символа G
                DW Font.empty                                                   ; -- нет символа H
                DW Font.empty                                                   ; -- нет символа I
                DW Font.empty                                                   ; -- нет символа J
                DW Font.empty                                                   ; -- нет символа K
                DW Font.empty                                                   ; -- нет символа L
                DW Font.empty                                                   ; -- нет символа M
                DW Font.empty                                                   ; -- нет символа N
                DW Font.empty                                                   ; -- нет символа O

                DW Font.empty                                                   ; -- нет символа P
                DW Font.empty                                                   ; -- нет символа Q
                DW Font.empty                                                   ; -- нет символа R
                DW Font.empty                                                   ; -- нет символа S
                DW Font.empty                                                   ; -- нет символа T
                DW Font.empty                                                   ; -- нет символа U
                DW Font.empty                                                   ; -- нет символа V
                DW Font.empty                                                   ; -- нет символа W
                DW Font.empty                                                   ; -- нет символа X
                DW Font.empty                                                   ; -- нет символа Y
                DW Font.empty                                                   ; -- нет символа Z
                DW Font.empty                                                   ; -- нет символа [
                DW Font.empty                                                   ; -- нет символа косая влево
                DW Font.empty                                                   ; -- нет символа ]
                DW Font.empty                                                   ; -- нет символа очистка
                DW Font.empty                                                   ; -- нет символа _

                DW Font.empty                                                   ; -- нет символа '
                DW Font.empty                                                   ; -- нет символа a
                DW Font.empty                                                   ; -- нет символа b
                DW Font.empty                                                   ; -- нет символа c
                DW Font.empty                                                   ; -- нет символа d
                DW Font.empty                                                   ; -- нет символа e
                DW Font.empty                                                   ; -- нет символа f
                DW Font.empty                                                   ; -- нет символа g
                DW Font.empty                                                   ; -- нет символа h
                DW Font.empty                                                   ; -- нет символа i
                DW Font.empty                                                   ; -- нет символа j
                DW Font.empty                                                   ; -- нет символа k
                DW Font.empty                                                   ; -- нет символа l
                DW Font.empty                                                   ; -- нет символа m
                DW Font.empty                                                   ; -- нет символа n
                DW Font.empty                                                   ; -- нет символа o

                DW Font.empty                                                   ; -- нет символа p
                DW Font.empty                                                   ; -- нет символа q
                DW Font.empty                                                   ; -- нет символа r
                DW Font.empty                                                   ; -- нет символа s
                DW Font.empty                                                   ; -- нет символа t
                DW Font.empty                                                   ; -- нет символа u
                DW Font.empty                                                   ; -- нет символа v
                DW Font.empty                                                   ; -- нет символа w
                DW Font.empty                                                   ; -- нет символа x
                DW Font.empty                                                   ; -- нет символа y
                DW Font.empty                                                   ; -- нет символа z
                DW Font.empty                                                   ; -- нет символа {
                DW Font.empty                                                   ; -- нет символа |
                DW Font.empty                                                   ; -- нет символа }
                DW Font.empty                                                   ; -- нет символа ~
                DW Font.empty                                                   ; -- нет символа ¿

                DW Font.ru_0                                                    ; -- А
                DW Font.ru_1                                                    ; -- Б
                DW Font.ru_2                                                    ; -- В
                DW Font.ru_3                                                    ; -- Г
                DW Font.ru_4                                                    ; -- Д
                DW Font.ru_5                                                    ; -- Е
                DW Font.ru_6                                                    ; -- Ё
                DW Font.ru_7                                                    ; -- Ж
                DW Font.ru_8                                                    ; -- З
                DW Font.ru_9                                                    ; -- И
                DW Font.ru_10                                                   ; -- Й
                DW Font.ru_11                                                   ; -- К
                DW Font.ru_12                                                   ; -- Л
                DW Font.ru_13                                                   ; -- М
                DW Font.ru_14                                                   ; -- Н
                DW Font.ru_15                                                   ; -- О

                DW Font.ru_16                                                   ; -- П
                DW Font.ru_17                                                   ; -- Р
                DW Font.ru_18                                                   ; -- С
                DW Font.ru_19                                                   ; -- Т
                DW Font.ru_20                                                   ; -- У
                DW Font.ru_21                                                   ; -- Ф
                DW Font.ru_22                                                   ; -- Х
                DW Font.ru_23                                                   ; -- Ц
                DW Font.ru_24                                                   ; -- Ч
                DW Font.ru_25                                                   ; -- Ш
                DW Font.ru_26                                                   ; -- Щ
                DW Font.ru_27                                                   ; -- Ъ
                DW Font.ru_28                                                   ; -- Ы
                DW Font.ru_29                                                   ; -- Ь
                DW Font.ru_30                                                   ; -- Э
                DW Font.ru_31                                                   ; -- Ю

                DW Font.ru_32                                                   ; -- Я
                DW Font.ru_low_0                                                ; -- а
                DW Font.ru_low_1                                                ; -- б
                DW Font.ru_low_2                                                ; -- в
                DW Font.ru_low_3                                                ; -- г
                DW Font.ru_low_4                                                ; -- д
                DW Font.ru_low_5                                                ; -- е
                DW Font.ru_low_6                                                ; -- ё
                DW Font.ru_low_7                                                ; -- ж
                DW Font.ru_low_8                                                ; -- з
                DW Font.ru_low_9                                                ; -- и
                DW Font.ru_low_10                                               ; -- й
                DW Font.ru_low_11                                               ; -- к
                DW Font.ru_low_12                                               ; -- л
                DW Font.ru_low_13                                               ; -- м
                DW Font.ru_low_14                                               ; -- н

                DW Font.ru_low_15                                               ; -- о
                DW Font.ru_low_16                                               ; -- п
                DW Font.ru_low_17                                               ; -- р
                DW Font.ru_low_18                                               ; -- с
                DW Font.ru_low_19                                               ; -- т
                DW Font.ru_low_20                                               ; -- у
                DW Font.ru_low_21                                               ; -- ф
                DW Font.ru_low_22                                               ; -- х
                DW Font.ru_low_23                                               ; -- ц
                DW Font.ru_low_24                                               ; -- ч
                DW Font.ru_low_25                                               ; -- ш
                DW Font.ru_low_26                                               ; -- щ
                DW Font.ru_low_27                                               ; -- ъ
                DW Font.ru_low_28                                               ; -- ы
                DW Font.ru_low_29                                               ; -- ь
                DW Font.ru_low_30                                               ; -- э

                DW Font.ru_low_31                                               ; -- ю
                DW Font.ru_low_32                                               ; -- я
                DW Font.ru_low_33                                               ; -- ѣ
                DW Font.ru_low_34                                               ; -- ї
                DW Font.ru_low_35                                               ; -- ѥ
Font:
.empty          FONT_NOT_SPRITE 1                                               ; нет символа
.space          FONT_NOT_SPRITE 4                                               ; пробел
.exclamation    FONT 10, 0, 0, 0, 0,  5,  9, "Sym/font_sym_0.bin"               ; !
.question       FONT 10, 0, 0, 0, 0,  8,  9, "Sym/font_sym_1.bin"               ; ? 
.colon          FONT  6, 0, 0, 0, 0,  4,  6, "Sym/font_sym_2.bin"               ; :
.semicolon      FONT  7, 0, 0, 0, 0,  4,  6, "Sym/font_sym_3.bin"               ; ;
.comma          FONT  4, 0, 0, 0, 0,  5,  2, "Sym/font_sym_4.bin"               ; ,
.dot            FONT  3, 0, 0, 0, 0,  4,  2, "Sym/font_sym_5.bin"               ; .
.minus          FONT  3, 0, 0, 0, 0,  5,  4, "Sym/font_sym_6.bin"               ; -

.zero           FONT 10, 0, 0, 0, 0,  9,  9, "Num/font_num_0.bin"               ; 0
.one            FONT 10, 0, 0, 0, 0,  7,  9, "Num/font_num_1.bin"               ; 1
.two            FONT 10, 0, 0, 0, 0,  8,  9, "Num/font_num_2.bin"               ; 2
.three          FONT 10, 0, 0, 0, 0,  8,  9, "Num/font_num_3.bin"               ; 3
.four           FONT 10, 0, 0, 0, 0,  8,  9, "Num/font_num_4.bin"               ; 4
.five           FONT 10, 0, 0, 0, 0,  8,  9, "Num/font_num_5.bin"               ; 5
.six            FONT 10, 0, 0, 0, 0,  8,  9, "Num/font_num_6.bin"               ; 6
.seven          FONT 10, 0, 0, 0, 0,  8,  9, "Num/font_num_7.bin"               ; 7
.eight          FONT 10, 0, 0, 0, 0,  8,  9, "Num/font_num_8.bin"               ; 8
.nine           FONT 10, 0, 0, 0, 0,  8,  9, "Num/font_num_9.bin"               ; 9

.ru_0           FONT 10, 0, 0, 0, 0, 11,  9, "Ru/font_0.bin"                    ; А
.ru_1           FONT 10, 0, 0, 0, 0,  9,  9, "Ru/font_1.bin"                    ; Б
.ru_2           FONT 10, 0, 0, 0, 0,  9,  9, "Ru/font_2.bin"                    ; В
.ru_3           FONT 10, 0, 0, 0, 0,  9,  9, "Ru/font_3.bin"                    ; Г
.ru_4           FONT 12, 0, 0, 0, 0, 10,  9, "Ru/font_4.bin"                    ; Д
.ru_5           FONT 11, 0, 0, 0, 0,  9,  9, "Ru/font_5.bin"                    ; Е
.ru_6           FONT 14, 0, 0, 0, 0,  9, 12, "Ru/font_6.bin"                    ; Ё
.ru_7           FONT 10, 0, 0, 0, 0, 15,  9, "Ru/font_7.bin"                    ; Ж
.ru_8           FONT 10, 0, 0, 0, 0, 10,  9, "Ru/font_8.bin"                    ; З
.ru_9           FONT 10, 0, 0, 0, 0, 11,  9, "Ru/font_9.bin"                    ; И
.ru_10          FONT 13, 0, 0, 0, 0, 11, 12, "Ru/font_10.bin"                   ; Й
.ru_11          FONT 10, 0, 0, 0, 0, 11,  9, "Ru/font_11.bin"                   ; К
.ru_12          FONT 10, 0, 0, 0, 0, 10,  9, "Ru/font_12.bin"                   ; Л
.ru_13          FONT 10, 0, 0, 0, 0, 14,  9, "Ru/font_13.bin"                   ; М
.ru_14          FONT 10, 0, 0, 0, 0, 11,  9, "Ru/font_14.bin"                   ; Н
.ru_15          FONT 10, 0, 0, 0, 0, 10,  9, "Ru/font_15.bin"                   ; О

.ru_16          FONT 10, 0, 0, 0, 0, 11,  9, "Ru/font_16.bin"                   ; П
.ru_17          FONT 10, 0, 0, 0, 0, 10,  9, "Ru/font_17.bin"                   ; Р
.ru_18          FONT 10, 0, 0, 0, 0, 10,  9, "Ru/font_18.bin"                   ; С
.ru_19          FONT 10, 0, 0, 0, 0, 13,  9, "Ru/font_19.bin"                   ; Т
.ru_20          FONT 12, 0, 0, 0, 0, 12, 11, "Ru/font_20.bin"                   ; У
.ru_21          FONT 11, 0, 0, 0, 0, 13,  9, "Ru/font_21.bin"                   ; Ф
.ru_22          FONT 10, 0, 0, 0, 0, 11,  9, "Ru/font_22.bin"                   ; Х
.ru_23          FONT 14, 0, 0, 0, 0, 12,  9, "Ru/font_23.bin"                   ; Ц
.ru_24          FONT 10, 0, 0, 0, 0, 10,  9, "Ru/font_24.bin"                   ; Ч
.ru_25          FONT 10, 0, 0, 0, 0, 15,  9, "Ru/font_25.bin"                   ; Ш
.ru_26          FONT 14, 0, 0, 0, 0, 15,  9, "Ru/font_26.bin"                   ; Щ
.ru_27          FONT 10, 0, 0, 0, 0,  9,  9, "Ru/font_27.bin"                   ; Ъ
.ru_28          FONT 10, 0, 0, 0, 0, 13,  9, "Ru/font_28.bin"                   ; Ы
.ru_29          FONT 10, 0, 0, 0, 0,  9,  9, "Ru/font_29.bin"                   ; Ь
.ru_30          FONT 10, 0, 0, 0, 0, 10,  9, "Ru/font_30.bin"                   ; Э
.ru_31          FONT 10, 0, 0, 0, 0, 14,  9, "Ru/font_31.bin"                   ; Ю

.ru_32          FONT 10, 0, 0, 0, 0, 14,  9, "Ru/font_32.bin"                   ; Я
.ru_low_0       FONT  8, 0, 0, 0, 0,  9,  7, "Ru/font_low_0.bin"                ; а
.ru_low_1       FONT  8, 0, 0, 0, 0,  9,  7, "Ru/font_low_1.bin"                ; б
.ru_low_2       FONT  8, 0, 0, 0, 0,  8,  7, "Ru/font_low_2.bin"                ; в
.ru_low_3       FONT  8, 0, 0, 0, 0,  8,  7, "Ru/font_low_3.bin"                ; г
.ru_low_4       FONT 11, 0, 0, 0, 0,  9,  7, "Ru/font_low_4.bin"                ; д
.ru_low_5       FONT  8, 0, 0, 0, 0,  7,  7, "Ru/font_low_5.bin"                ; е
.ru_low_6       FONT 11, 0, 0, 0, 0,  7, 10, "Ru/font_low_6.bin"                ; ё
.ru_low_7       FONT  8, 0, 0, 0, 0, 13,  7, "Ru/font_low_7.bin"                ; ж
.ru_low_8       FONT  9, 0, 0, 0, 0, 10,  7, "Ru/font_low_8.bin"                ; з
.ru_low_9       FONT  8, 0, 0, 0, 0,  9,  7, "Ru/font_low_9.bin"                ; и
.ru_low_10      FONT 11, 0, 0, 0, 0,  9, 10, "Ru/font_low_10.bin"               ; й
.ru_low_11      FONT  8, 0, 0, 0, 0,  9,  7, "Ru/font_low_11.bin"               ; к
.ru_low_12      FONT  8, 0, 0, 0, 0,  9,  7, "Ru/font_low_12.bin"               ; л
.ru_low_13      FONT  8, 0, 0, 0, 0, 11,  7, "Ru/font_low_13.bin"               ; м
.ru_low_14      FONT  8, 0, 0, 0, 0,  9,  7, "Ru/font_low_14.bin"               ; н

.ru_low_15      FONT  9, 0, 0, 0, 0,  8,  7, "Ru/font_low_15.bin"               ; о
.ru_low_16      FONT  8, 0, 0, 0, 0,  9,  7, "Ru/font_low_16.bin"               ; п
.ru_low_17      FONT 12, 0, 0, 0, 0,  7,  7, "Ru/font_low_17.bin"               ; р
.ru_low_18      FONT  8, 0, 0, 0, 0,  7,  7, "Ru/font_low_18.bin"               ; с
.ru_low_19      FONT  8, 0, 0, 0, 0, 10,  7, "Ru/font_low_19.bin"               ; т
.ru_low_20      FONT 11, 0, 0, 0, 0,  8, 10, "Ru/font_low_20.bin"               ; у
.ru_low_21      FONT 13, 0, 0, 0, 0, 10,  8, "Ru/font_low_21.bin"               ; ф
.ru_low_22      FONT 13, 0, 0, 0, 0, 11,  9, "Ru/font_low_22.bin"               ; х
.ru_low_23      FONT 12, 0, 0, 0, 0, 10,  7, "Ru/font_low_23.bin"               ; ц
.ru_low_24      FONT  8, 0, 0, 0, 0,  8,  7, "Ru/font_low_24.bin"               ; ч
.ru_low_25      FONT  8, 0, 0, 0, 0, 11,  7, "Ru/font_low_25.bin"               ; ш
.ru_low_26      FONT 12, 0, 0, 0, 0, 11,  7, "Ru/font_low_26.bin"               ; щ
.ru_low_27      FONT  8, 0, 0, 0, 0,  8,  7, "Ru/font_low_27.bin"               ; ъ
.ru_low_28      FONT  8, 0, 0, 0, 0, 11,  7, "Ru/font_low_28.bin"               ; ы
.ru_low_29      FONT  8, 0, 0, 0, 0,  8,  7, "Ru/font_low_29.bin"               ; ь
.ru_low_30      FONT  8, 0, 0, 0, 0,  9,  7, "Ru/font_low_30.bin"               ; э
 
.ru_low_31      FONT  9, 0, 0, 0, 0, 11,  7, "Ru/font_low_31.bin"               ; ю
.ru_low_32      FONT  8, 0, 0, 0, 0, 12,  7, "Ru/font_low_32.bin"               ; я
.ru_low_33      FONT 12, 0, 0, 0, 0, 10, 11, "Ru/font_low_33.bin"               ; ѣ
.ru_low_34      FONT 11, 0, 0, 0, 0,  7, 10, "Ru/font_low_34.bin"               ; ї
.ru_low_35      FONT  8, 0, 0, 0, 0, 11,  7, "Ru/font_low_35.bin"               ; ѥ
Size            EQU $
                COMPRESSED_ASSET \
                "Builder/Assets/Graphics/Compressed/Font/Ru.pack", \
                "Builder/Assets/Graphics/Compressed/Font/Ru.pack.ar"
                endmodule
                endmodule

                endif ; ~ _GRAPHICS_FONT_PACK_RU_INCLUDE_
