
                ifndef _GRAPHICS_FONT_PACK_RU_INCLUDE_
                define _GRAPHICS_FONT_PACK_RU_INCLUDE_

                module Pack
                module Ru

                ORG #0000
Begin:          EQU $

                ; таблица символов
                FONT_OFFSET Font.space                                          ; -- space
                FONT_OFFSET Font.exclamation                                    ; -- !
                FONT_OFFSET Font.empty                                          ; -- нет символа "
                FONT_OFFSET Font.empty                                          ; -- нет символа #
                FONT_OFFSET Font.empty                                          ; -- нет символа $
                FONT_OFFSET Font.empty                                          ; -- нет символа %
                FONT_OFFSET Font.empty                                          ; -- нет символа &
                FONT_OFFSET Font.empty                                          ; -- нет символа '
                FONT_OFFSET Font.empty                                          ; -- нет символа (
                FONT_OFFSET Font.empty                                          ; -- нет символа )
                FONT_OFFSET Font.empty                                          ; -- нет символа *
                FONT_OFFSET Font.empty                                          ; -- нет символа +
                FONT_OFFSET Font.comma                                          ; -- ,
                FONT_OFFSET Font.minus                                          ; -- -
                FONT_OFFSET Font.dot                                            ; -- .
                FONT_OFFSET Font.empty                                          ; -- нет символа /

                FONT_OFFSET Font.zero                                           ; -- 0
                FONT_OFFSET Font.one                                            ; -- 1
                FONT_OFFSET Font.two                                            ; -- 2
                FONT_OFFSET Font.three                                          ; -- 3
                FONT_OFFSET Font.four                                           ; -- 4
                FONT_OFFSET Font.five                                           ; -- 5
                FONT_OFFSET Font.six                                            ; -- 6
                FONT_OFFSET Font.seven                                          ; -- 7
                FONT_OFFSET Font.eight                                          ; -- 8
                FONT_OFFSET Font.nine                                           ; -- 9
                FONT_OFFSET Font.colon                                          ; -- :
                FONT_OFFSET Font.semicolon                                      ; -- ;
                FONT_OFFSET Font.empty                                          ; -- нет символа <
                FONT_OFFSET Font.empty                                          ; -- нет символа =
                FONT_OFFSET Font.empty                                          ; -- нет символа >
                FONT_OFFSET Font.question                                       ; -- ?

                FONT_OFFSET Font.empty                                          ; -- нет символа ¡
                FONT_OFFSET Font.empty                                          ; -- нет символа A
                FONT_OFFSET Font.empty                                          ; -- нет символа B
                FONT_OFFSET Font.empty                                          ; -- нет символа C
                FONT_OFFSET Font.empty                                          ; -- нет символа D
                FONT_OFFSET Font.empty                                          ; -- нет символа E
                FONT_OFFSET Font.empty                                          ; -- нет символа F
                FONT_OFFSET Font.empty                                          ; -- нет символа G
                FONT_OFFSET Font.empty                                          ; -- нет символа H
                FONT_OFFSET Font.empty                                          ; -- нет символа I
                FONT_OFFSET Font.empty                                          ; -- нет символа J
                FONT_OFFSET Font.empty                                          ; -- нет символа K
                FONT_OFFSET Font.empty                                          ; -- нет символа L
                FONT_OFFSET Font.empty                                          ; -- нет символа M
                FONT_OFFSET Font.empty                                          ; -- нет символа N
                FONT_OFFSET Font.empty                                          ; -- нет символа O

                FONT_OFFSET Font.empty                                          ; -- нет символа P
                FONT_OFFSET Font.empty                                          ; -- нет символа Q
                FONT_OFFSET Font.empty                                          ; -- нет символа R
                FONT_OFFSET Font.empty                                          ; -- нет символа S
                FONT_OFFSET Font.empty                                          ; -- нет символа T
                FONT_OFFSET Font.empty                                          ; -- нет символа U
                FONT_OFFSET Font.empty                                          ; -- нет символа V
                FONT_OFFSET Font.empty                                          ; -- нет символа W
                FONT_OFFSET Font.empty                                          ; -- нет символа X
                FONT_OFFSET Font.empty                                          ; -- нет символа Y
                FONT_OFFSET Font.empty                                          ; -- нет символа Z
                FONT_OFFSET Font.empty                                          ; -- нет символа [
                FONT_OFFSET Font.empty                                          ; -- нет символа косая влево
                FONT_OFFSET Font.empty                                          ; -- нет символа ]
                FONT_OFFSET Font.empty                                          ; -- нет символа очистка
                FONT_OFFSET Font.empty                                          ; -- нет символа _

                FONT_OFFSET Font.empty                                          ; -- нет символа '
                FONT_OFFSET Font.empty                                          ; -- нет символа a
                FONT_OFFSET Font.empty                                          ; -- нет символа b
                FONT_OFFSET Font.empty                                          ; -- нет символа c
                FONT_OFFSET Font.empty                                          ; -- нет символа d
                FONT_OFFSET Font.empty                                          ; -- нет символа e
                FONT_OFFSET Font.empty                                          ; -- нет символа f
                FONT_OFFSET Font.empty                                          ; -- нет символа g
                FONT_OFFSET Font.empty                                          ; -- нет символа h
                FONT_OFFSET Font.empty                                          ; -- нет символа i
                FONT_OFFSET Font.empty                                          ; -- нет символа j
                FONT_OFFSET Font.empty                                          ; -- нет символа k
                FONT_OFFSET Font.empty                                          ; -- нет символа l
                FONT_OFFSET Font.empty                                          ; -- нет символа m
                FONT_OFFSET Font.empty                                          ; -- нет символа n
                FONT_OFFSET Font.empty                                          ; -- нет символа o

                FONT_OFFSET Font.empty                                          ; -- нет символа p
                FONT_OFFSET Font.empty                                          ; -- нет символа q
                FONT_OFFSET Font.empty                                          ; -- нет символа r
                FONT_OFFSET Font.empty                                          ; -- нет символа s
                FONT_OFFSET Font.empty                                          ; -- нет символа t
                FONT_OFFSET Font.empty                                          ; -- нет символа u
                FONT_OFFSET Font.empty                                          ; -- нет символа v
                FONT_OFFSET Font.empty                                          ; -- нет символа w
                FONT_OFFSET Font.empty                                          ; -- нет символа x
                FONT_OFFSET Font.empty                                          ; -- нет символа y
                FONT_OFFSET Font.empty                                          ; -- нет символа z
                FONT_OFFSET Font.empty                                          ; -- нет символа {
                FONT_OFFSET Font.empty                                          ; -- нет символа |
                FONT_OFFSET Font.empty                                          ; -- нет символа }
                FONT_OFFSET Font.empty                                          ; -- нет символа ~
                FONT_OFFSET Font.empty                                          ; -- нет символа ¿

                FONT_OFFSET Font.ru_0                                           ; -- А
                FONT_OFFSET Font.ru_1                                           ; -- Б
                FONT_OFFSET Font.ru_2                                           ; -- В
                FONT_OFFSET Font.ru_3                                           ; -- Г
                FONT_OFFSET Font.ru_4                                           ; -- Д
                FONT_OFFSET Font.ru_5                                           ; -- Е
                FONT_OFFSET Font.ru_6                                           ; -- Ё
                FONT_OFFSET Font.ru_7                                           ; -- Ж
                FONT_OFFSET Font.ru_8                                           ; -- З
                FONT_OFFSET Font.ru_9                                           ; -- И
                FONT_OFFSET Font.ru_10                                          ; -- Й
                FONT_OFFSET Font.ru_11                                          ; -- К
                FONT_OFFSET Font.ru_12                                          ; -- Л
                FONT_OFFSET Font.ru_13                                          ; -- М
                FONT_OFFSET Font.ru_14                                          ; -- Н
                FONT_OFFSET Font.ru_15                                          ; -- О

                FONT_OFFSET Font.ru_16                                          ; -- П
                FONT_OFFSET Font.ru_17                                          ; -- Р
                FONT_OFFSET Font.ru_18                                          ; -- С
                FONT_OFFSET Font.ru_19                                          ; -- Т
                FONT_OFFSET Font.ru_20                                          ; -- У
                FONT_OFFSET Font.ru_21                                          ; -- Ф
                FONT_OFFSET Font.ru_22                                          ; -- Х
                FONT_OFFSET Font.ru_23                                          ; -- Ц
                FONT_OFFSET Font.ru_24                                          ; -- Ч
                FONT_OFFSET Font.ru_25                                          ; -- Ш
                FONT_OFFSET Font.ru_26                                          ; -- Щ
                FONT_OFFSET Font.ru_27                                          ; -- Ъ
                FONT_OFFSET Font.ru_28                                          ; -- Ы
                FONT_OFFSET Font.ru_29                                          ; -- Ь
                FONT_OFFSET Font.ru_30                                          ; -- Э
                FONT_OFFSET Font.ru_31                                          ; -- Ю

                FONT_OFFSET Font.ru_32                                          ; -- Я
                FONT_OFFSET Font.ru_low_0                                       ; -- а
                FONT_OFFSET Font.ru_low_1                                       ; -- б
                FONT_OFFSET Font.ru_low_2                                       ; -- в
                FONT_OFFSET Font.ru_low_3                                       ; -- г
                FONT_OFFSET Font.ru_low_4                                       ; -- д
                FONT_OFFSET Font.ru_low_5                                       ; -- е
                FONT_OFFSET Font.ru_low_6                                       ; -- ё
                FONT_OFFSET Font.ru_low_7                                       ; -- ж
                FONT_OFFSET Font.ru_low_8                                       ; -- з
                FONT_OFFSET Font.ru_low_9                                       ; -- и
                FONT_OFFSET Font.ru_low_10                                      ; -- й
                FONT_OFFSET Font.ru_low_11                                      ; -- к
                FONT_OFFSET Font.ru_low_12                                      ; -- л
                FONT_OFFSET Font.ru_low_13                                      ; -- м
                FONT_OFFSET Font.ru_low_14                                      ; -- н

                FONT_OFFSET Font.ru_low_15                                      ; -- о
                FONT_OFFSET Font.ru_low_16                                      ; -- п
                FONT_OFFSET Font.ru_low_17                                      ; -- р
                FONT_OFFSET Font.ru_low_18                                      ; -- с
                FONT_OFFSET Font.ru_low_19                                      ; -- т
                FONT_OFFSET Font.ru_low_20                                      ; -- у
                FONT_OFFSET Font.ru_low_21                                      ; -- ф
                FONT_OFFSET Font.ru_low_22                                      ; -- х
                FONT_OFFSET Font.ru_low_23                                      ; -- ц
                FONT_OFFSET Font.ru_low_24                                      ; -- ч
                FONT_OFFSET Font.ru_low_25                                      ; -- ш
                FONT_OFFSET Font.ru_low_26                                      ; -- щ
                FONT_OFFSET Font.ru_low_27                                      ; -- ъ
                FONT_OFFSET Font.ru_low_28                                      ; -- ы
                FONT_OFFSET Font.ru_low_29                                      ; -- ь
                FONT_OFFSET Font.ru_low_30                                      ; -- э

                FONT_OFFSET Font.ru_low_31                                      ; -- ю
                FONT_OFFSET Font.ru_low_32                                      ; -- я
                FONT_OFFSET Font.ru_low_33                                      ; -- ѣ
                FONT_OFFSET Font.ru_low_34                                      ; -- ї
                FONT_OFFSET Font.ru_low_35                                      ; -- ѥ
Font:
.empty          FONT_NOT_SPRITE 1                                               ; нет символа
.space          FONT_NOT_SPRITE 4                                               ; пробел
.exclamation    FONT 10, 0, 0, 0, 0,  4,  8, "Sym/font_sym_0.bin"               ; !
.question       FONT 10, 0, 0, 0, 0,  7,  8, "Sym/font_sym_1.bin"               ; ? 
.colon          FONT  6, 0, 0, 0, 0,  3,  5, "Sym/font_sym_2.bin"               ; :
.semicolon      FONT  7, 0, 0, 0, 0,  3,  5, "Sym/font_sym_3.bin"               ; ;
.comma          FONT  4, 0, 0, 0, 0,  4,  1, "Sym/font_sym_4.bin"               ; ,
.dot            FONT  3, 0, 0, 0, 0,  3,  1, "Sym/font_sym_5.bin"               ; .
.minus          FONT  3, 0, 0, 0, 0,  4,  3, "Sym/font_sym_6.bin"               ; -

.zero           FONT 10, 0, 0, 0, 0,  8,  8, "Num/font_num_0.bin"               ; 0
.one            FONT 10, 0, 0, 0, 0,  6,  8, "Num/font_num_1.bin"               ; 1
.two            FONT 10, 0, 0, 0, 0,  7,  8, "Num/font_num_2.bin"               ; 2
.three          FONT 10, 0, 0, 0, 0,  7,  8, "Num/font_num_3.bin"               ; 3
.four           FONT 10, 0, 0, 0, 0,  7,  8, "Num/font_num_4.bin"               ; 4
.five           FONT 10, 0, 0, 0, 0,  7,  8, "Num/font_num_5.bin"               ; 5
.six            FONT 10, 0, 0, 0, 0,  7,  8, "Num/font_num_6.bin"               ; 6
.seven          FONT 10, 0, 0, 0, 0,  7,  8, "Num/font_num_7.bin"               ; 7
.eight          FONT 10, 0, 0, 0, 0,  7,  8, "Num/font_num_8.bin"               ; 8
.nine           FONT 10, 0, 0, 0, 0,  7,  8, "Num/font_num_9.bin"               ; 9

.ru_0           FONT 10, 0, 0, 0, 0, 10,  8, "Ru/font_0.bin"                    ; А
.ru_1           FONT 10, 0, 0, 0, 0,  8,  8, "Ru/font_1.bin"                    ; Б
.ru_2           FONT 10, 0, 0, 0, 0,  8,  8, "Ru/font_2.bin"                    ; В
.ru_3           FONT 10, 0, 0, 0, 0,  8,  8, "Ru/font_3.bin"                    ; Г
.ru_4           FONT 12, 0, 0, 0, 0,  9,  8, "Ru/font_4.bin"                    ; Д
.ru_5           FONT 11, 0, 0, 0, 0,  8,  8, "Ru/font_5.bin"                    ; Е
.ru_6           FONT 14, 0, 0, 0, 0,  8, 11, "Ru/font_6.bin"                    ; Ё
.ru_7           FONT 10, 0, 0, 0, 0, 14,  8, "Ru/font_7.bin"                    ; Ж
.ru_8           FONT 10, 0, 0, 0, 0,  9,  8, "Ru/font_8.bin"                    ; З
.ru_9           FONT 10, 0, 0, 0, 0, 10,  8, "Ru/font_9.bin"                    ; И
.ru_10          FONT 13, 0, 0, 0, 0, 10, 11, "Ru/font_10.bin"                   ; Й
.ru_11          FONT 10, 0, 0, 0, 0, 10,  8, "Ru/font_11.bin"                   ; К
.ru_12          FONT 10, 0, 0, 0, 0,  9,  8, "Ru/font_12.bin"                   ; Л
.ru_13          FONT 10, 0, 0, 0, 0, 13,  8, "Ru/font_13.bin"                   ; М
.ru_14          FONT 10, 0, 0, 0, 0, 10,  8, "Ru/font_14.bin"                   ; Н
.ru_15          FONT 10, 0, 0, 0, 0,  9,  8, "Ru/font_15.bin"                   ; О

.ru_16          FONT 10, 0, 0, 0, 0, 10,  8, "Ru/font_16.bin"                   ; П
.ru_17          FONT 10, 0, 0, 0, 0,  9,  8, "Ru/font_17.bin"                   ; Р
.ru_18          FONT 10, 0, 0, 0, 0,  9,  8, "Ru/font_18.bin"                   ; С
.ru_19          FONT 10, 0, 0, 0, 0, 12,  8, "Ru/font_19.bin"                   ; Т
.ru_20          FONT 12, 0, 0, 0, 0, 11, 10, "Ru/font_20.bin"                   ; У
.ru_21          FONT 11, 0, 0, 0, 0, 12,  8, "Ru/font_21.bin"                   ; Ф
.ru_22          FONT 10, 0, 0, 0, 0, 10,  8, "Ru/font_22.bin"                   ; Х
.ru_23          FONT 14, 0, 0, 0, 0, 11,  8, "Ru/font_23.bin"                   ; Ц
.ru_24          FONT 10, 0, 0, 0, 0,  9,  8, "Ru/font_24.bin"                   ; Ч
.ru_25          FONT 10, 0, 0, 0, 0, 14,  8, "Ru/font_25.bin"                   ; Ш
.ru_26          FONT 14, 0, 0, 0, 0, 14,  8, "Ru/font_26.bin"                   ; Щ
.ru_27          FONT 10, 0, 0, 0, 0,  8,  8, "Ru/font_27.bin"                   ; Ъ
.ru_28          FONT 10, 0, 0, 0, 0, 12,  8, "Ru/font_28.bin"                   ; Ы
.ru_29          FONT 10, 0, 0, 0, 0,  8,  8, "Ru/font_29.bin"                   ; Ь
.ru_30          FONT 10, 0, 0, 0, 0,  9,  8, "Ru/font_30.bin"                   ; Э
.ru_31          FONT 10, 0, 0, 0, 0, 13,  8, "Ru/font_31.bin"                   ; Ю

.ru_32          FONT 10, 0, 0, 0, 0, 13,  8, "Ru/font_32.bin"                   ; Я
.ru_low_0       FONT  8, 0, 0, 0, 0,  8,  6, "Ru/font_low_0.bin"                ; а
.ru_low_1       FONT  8, 0, 0, 0, 0,  8,  6, "Ru/font_low_1.bin"                ; б
.ru_low_2       FONT  8, 0, 0, 0, 0,  7,  6, "Ru/font_low_2.bin"                ; в
.ru_low_3       FONT  8, 0, 0, 0, 0,  7,  6, "Ru/font_low_3.bin"                ; г
.ru_low_4       FONT 11, 0, 0, 0, 0,  8,  6, "Ru/font_low_4.bin"                ; д
.ru_low_5       FONT  8, 0, 0, 0, 0,  6,  6, "Ru/font_low_5.bin"                ; е
.ru_low_6       FONT 11, 0, 0, 0, 0,  6,  9, "Ru/font_low_6.bin"                ; ё
.ru_low_7       FONT  8, 0, 0, 0, 0, 12,  6, "Ru/font_low_7.bin"                ; ж
.ru_low_8       FONT  9, 0, 0, 0, 0,  9,  6, "Ru/font_low_8.bin"                ; з
.ru_low_9       FONT  8, 0, 0, 0, 0,  8,  6, "Ru/font_low_9.bin"                ; и
.ru_low_10      FONT 11, 0, 0, 0, 0,  8,  9, "Ru/font_low_10.bin"               ; й
.ru_low_11      FONT  8, 0, 0, 0, 0,  8,  6, "Ru/font_low_11.bin"               ; к
.ru_low_12      FONT  8, 0, 0, 0, 0,  8,  6, "Ru/font_low_12.bin"               ; л
.ru_low_13      FONT  8, 0, 0, 0, 0, 10,  6, "Ru/font_low_13.bin"               ; м
.ru_low_14      FONT  8, 0, 0, 0, 0,  8,  6, "Ru/font_low_14.bin"               ; н

.ru_low_15      FONT  9, 0, 0, 0, 0,  7,  6, "Ru/font_low_15.bin"               ; о
.ru_low_16      FONT  8, 0, 0, 0, 0,  8,  6, "Ru/font_low_16.bin"               ; п
.ru_low_17      FONT 12, 0, 0, 0, 0,  6,  6, "Ru/font_low_17.bin"               ; р
.ru_low_18      FONT  8, 0, 0, 0, 0,  6,  6, "Ru/font_low_18.bin"               ; с
.ru_low_19      FONT  8, 0, 0, 0, 0,  9,  6, "Ru/font_low_19.bin"               ; т
.ru_low_20      FONT 11, 0, 0, 0, 0,  7,  8, "Ru/font_low_20.bin"               ; у
.ru_low_21      FONT 13, 0, 0, 0, 0,  9,  7, "Ru/font_low_21.bin"               ; ф
.ru_low_22      FONT 13, 0, 0, 0, 0, 10,  8, "Ru/font_low_22.bin"               ; х
.ru_low_23      FONT 12, 0, 0, 0, 0,  9,  6, "Ru/font_low_23.bin"               ; ц
.ru_low_24      FONT  8, 0, 0, 0, 0,  7,  6, "Ru/font_low_24.bin"               ; ч
.ru_low_25      FONT  8, 0, 0, 0, 0, 10,  6, "Ru/font_low_25.bin"               ; ш
.ru_low_26      FONT 12, 0, 0, 0, 0, 10,  6, "Ru/font_low_26.bin"               ; щ
.ru_low_27      FONT  8, 0, 0, 0, 0,  7,  6, "Ru/font_low_27.bin"               ; ъ
.ru_low_28      FONT  8, 0, 0, 0, 0, 10,  6, "Ru/font_low_28.bin"               ; ы
.ru_low_29      FONT  8, 0, 0, 0, 0,  7,  6, "Ru/font_low_29.bin"               ; ь
.ru_low_30      FONT  8, 0, 0, 0, 0,  8,  6, "Ru/font_low_30.bin"               ; э
 
.ru_low_31      FONT  9, 0, 0, 0, 0, 10,  6, "Ru/font_low_31.bin"               ; ю
.ru_low_32      FONT  8, 0, 0, 0, 0, 11,  6, "Ru/font_low_32.bin"               ; я
.ru_low_33      FONT 12, 0, 0, 0, 0,  9, 10, "Ru/font_low_33.bin"               ; ѣ
.ru_low_34      FONT 11, 0, 0, 0, 0,  6,  9, "Ru/font_low_34.bin"               ; ї
.ru_low_35      FONT  8, 0, 0, 0, 0, 10,  6, "Ru/font_low_35.bin"               ; ѥ
Size            EQU $
                COMPRESSED_ASSET \
                "Builder/Assets/Graphics/Compressed/Font/Ru.pack", \
                "Builder/Assets/Graphics/Compressed/Font/Ru.pack.ar"
                endmodule
                endmodule

                endif ; ~ _GRAPHICS_FONT_PACK_RU_INCLUDE_
