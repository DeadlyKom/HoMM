
                ifndef _GRAPHICS_FONT_PACK_RU_INCLUDE_
                define _GRAPHICS_FONT_PACK_RU_INCLUDE_

                module Pack
                module Ru

                ORG #0000
Begin:          EQU $

                ; таблица символов
                DW Font.space                                                   ; -- space
                DW Font.empty                                                   ; -- !
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
                DW Font.empty                                                   ; -- ,
                DW Font.empty                                                   ; -- -
                DW Font.empty                                                   ; -- .
                DW Font.empty                                                   ; -- нет символа /

                DW Font.empty                                                   ; -- 0
                DW Font.empty                                                   ; -- 1
                DW Font.empty                                                   ; -- 2
                DW Font.empty                                                   ; -- 3
                DW Font.empty                                                   ; -- 4
                DW Font.empty                                                   ; -- 5
                DW Font.empty                                                   ; -- 6
                DW Font.empty                                                   ; -- 7
                DW Font.empty                                                   ; -- 8
                DW Font.empty                                                   ; -- 9
                DW Font.empty                                                   ; -- :
                DW Font.empty                                                   ; -- ;
                DW Font.empty                                                   ; -- нет символа <
                DW Font.empty                                                   ; -- нет символа =
                DW Font.empty                                                   ; -- нет символа >
                DW Font.empty                                                   ; -- ?

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
                DW Font.empty                                                   ; -- Б
                DW Font.empty                                                   ; -- В
                DW Font.empty                                                   ; -- Г
                DW Font.empty                                                   ; -- Д
                DW Font.empty                                                   ; -- Е
                DW Font.empty                                                   ; -- Ё
                DW Font.empty                                                   ; -- Ж
                DW Font.empty                                                   ; -- З
                DW Font.empty                                                   ; -- И
                DW Font.empty                                                   ; -- Й
                DW Font.empty                                                   ; -- К
                DW Font.empty                                                   ; -- Л
                DW Font.empty                                                   ; -- М
                DW Font.empty                                                   ; -- Н
                DW Font.empty                                                   ; -- О

                DW Font.empty                                                   ; -- П
                DW Font.empty                                                   ; -- Р
                DW Font.empty                                                   ; -- С
                DW Font.empty                                                   ; -- Т
                DW Font.empty                                                   ; -- У
                DW Font.empty                                                   ; -- Ф
                DW Font.empty                                                   ; -- Х
                DW Font.empty                                                   ; -- Ц
                DW Font.empty                                                   ; -- Ч
                DW Font.empty                                                   ; -- Ш
                DW Font.empty                                                   ; -- Щ
                DW Font.empty                                                   ; -- Ъ
                DW Font.empty                                                   ; -- Ы
                DW Font.empty                                                   ; -- Ь
                DW Font.empty                                                   ; -- Э
                DW Font.empty                                                   ; -- Ю

                DW Font.empty                                                   ; -- Я
                DW Font.empty                                                   ; -- а
                DW Font.empty                                                   ; -- б
                DW Font.empty                                                   ; -- в
                DW Font.empty                                                   ; -- г
                DW Font.empty                                                   ; -- д
                DW Font.empty                                                   ; -- е
                DW Font.empty                                                   ; -- ё
                DW Font.empty                                                   ; -- ж
                DW Font.empty                                                   ; -- з
                DW Font.empty                                                   ; -- и
                DW Font.empty                                                   ; -- й
                DW Font.empty                                                   ; -- к
                DW Font.empty                                                   ; -- л
                DW Font.empty                                                   ; -- м
                DW Font.empty                                                   ; -- н

                DW Font.empty                                                   ; -- о
                DW Font.empty                                                   ; -- п
                DW Font.empty                                                   ; -- р
                DW Font.empty                                                   ; -- с
                DW Font.empty                                                   ; -- т
                DW Font.empty                                                   ; -- у
                DW Font.empty                                                   ; -- ф
                DW Font.empty                                                   ; -- х
                DW Font.empty                                                   ; -- ц
                DW Font.empty                                                   ; -- ч
                DW Font.empty                                                   ; -- ш
                DW Font.empty                                                   ; -- щ
                DW Font.empty                                                   ; -- ъ
                DW Font.empty                                                   ; -- ы
                DW Font.empty                                                   ; -- ь
                DW Font.empty                                                   ; -- э

                DW Font.empty                                                   ; -- ю
                DW Font.empty                                                   ; -- я
                DW Font.empty                                                   ; -- ѣ
                DW Font.empty                                                   ; -- ї
                DW Font.empty                                                   ; -- ѥ
Font:
.empty          FONT_NOT_SPRITE 0, 1, 0                                         ; нет символа
.space          FONT_NOT_SPRITE 0, 4, 0                                         ; пробел
; .exclamation    incbin "Font sym_0.bin"                                         ; !
; .question       incbin "Font sym_1.bin"                                         ; ? 
; .colon          incbin "Font sym_2.bin"                                         ; :
; .semicolon      incbin "Font sym_3.bin"                                         ; ;
; .comma          incbin "Font sym_4.bin"                                         ; ,
; .dot            incbin "Font sym_5.bin"                                         ; .
; .minus          incbin "Font sym_6.bin"                                         ; -

; .zero           incbin "Font num_0.bin"                                         ; 0
; .one            incbin "Font num_1.bin"                                         ; 1
; .two            incbin "Font num_2.bin"                                         ; 2
; .three          incbin "Font num_3.bin"                                         ; 3
; .four           incbin "Font num_4.bin"                                         ; 4
; .five           incbin "Font num_5.bin"                                         ; 5
; .six            incbin "Font num_6.bin"                                         ; 6
; .seven          incbin "Font num_7.bin"                                         ; 7
; .eight          incbin "Font num_8.bin"                                         ; 8
; .nine           incbin "Font num_9.bin"                                         ; 9

.ru_0           FONT 0, 0, 0, 0, 11, 9, "Ru/font_0.bin"                         ; А
; .ru_1           incbin "Font ru_1.bin"                                          ; Б
; .ru_2           incbin "Font ru_2.bin"                                          ; В
; .ru_3           incbin "Font ru_3.bin"                                          ; Г
; .ru_4           incbin "Font ru_4.bin"                                          ; Д
; .ru_5           incbin "Font ru_5.bin"                                          ; Е
; .ru_6           incbin "Font ru_6.bin"                                          ; Ё
; .ru_7           incbin "Font ru_7.bin"                                          ; Ж
; .ru_8           incbin "Font ru_8.bin"                                          ; З
; .ru_9           incbin "Font ru_9.bin"                                          ; И
; .ru_10          incbin "Font ru_10.bin"                                         ; Й
; .ru_11          incbin "Font ru_11.bin"                                         ; К
; .ru_12          incbin "Font ru_12.bin"                                         ; Л
; .ru_13          incbin "Font ru_13.bin"                                         ; М
; .ru_14          incbin "Font ru_14.bin"                                         ; Н
; .ru_15          incbin "Font ru_15.bin"                                         ; О

; .ru_16          incbin "Font ru_16.bin"                                         ; П
; .ru_17          incbin "Font ru_17.bin"                                         ; Р
; .ru_18          incbin "Font ru_18.bin"                                         ; С
; .ru_19          incbin "Font ru_19.bin"                                         ; Т
; .ru_20          incbin "Font ru_20.bin"                                         ; У
; .ru_21          incbin "Font ru_21.bin"                                         ; Ф
; .ru_22          incbin "Font ru_22.bin"                                         ; Х
; .ru_23          incbin "Font ru_23.bin"                                         ; Ц
; .ru_24          incbin "Font ru_24.bin"                                         ; Ч
; .ru_25          incbin "Font ru_25.bin"                                         ; Ш
; .ru_26          incbin "Font ru_26.bin"                                         ; Щ
; .ru_27          incbin "Font ru_27.bin"                                         ; Ъ
; .ru_28          incbin "Font ru_28.bin"                                         ; Ы
; .ru_29          incbin "Font ru_29.bin"                                         ; Ь
; .ru_30          incbin "Font ru_30.bin"                                         ; Э
; .ru_31          incbin "Font ru_31.bin"                                         ; Ю

; .ru_32          incbin "Font ru_32.bin"                                         ; Я
; .ru_low_0       incbin "Font ru_low_0.bin"                                      ; а
; .ru_low_1       incbin "Font ru_low_1.bin"                                      ; б
; .ru_low_2       incbin "Font ru_low_2.bin"                                      ; в
; .ru_low_3       incbin "Font ru_low_3.bin"                                      ; г
; .ru_low_4       incbin "Font ru_low_4.bin"                                      ; д
; .ru_low_5       incbin "Font ru_low_5.bin"                                      ; е
; .ru_low_6       incbin "Font ru_low_6.bin"                                      ; ё
; .ru_low_7       incbin "Font ru_low_7.bin"                                      ; ж
; .ru_low_8       incbin "Font ru_low_8.bin"                                      ; з
; .ru_low_9       incbin "Font ru_low_9.bin"                                      ; и
; .ru_low_10      incbin "Font ru_low_10.bin"                                     ; й
; .ru_low_11      incbin "Font ru_low_11.bin"                                     ; к
; .ru_low_12      incbin "Font ru_low_12.bin"                                     ; л
; .ru_low_13      incbin "Font ru_low_13.bin"                                     ; м
; .ru_low_14      incbin "Font ru_low_14.bin"                                     ; н

; .ru_low_15      incbin "Font ru_low_15.bin"                                     ; о
; .ru_low_16      incbin "Font ru_low_16.bin"                                     ; п
; .ru_low_17      incbin "Font ru_low_17.bin"                                     ; р
; .ru_low_18      incbin "Font ru_low_18.bin"                                     ; с
; .ru_low_19      incbin "Font ru_low_19.bin"                                     ; т
; .ru_low_20      incbin "Font ru_low_20.bin"                                     ; у
; .ru_low_21      incbin "Font ru_low_21.bin"                                     ; ф
; .ru_low_22      incbin "Font ru_low_22.bin"                                     ; х
; .ru_low_23      incbin "Font ru_low_23.bin"                                     ; ц
; .ru_low_24      incbin "Font ru_low_24.bin"                                     ; ч
; .ru_low_25      incbin "Font ru_low_25.bin"                                     ; ш
; .ru_low_26      incbin "Font ru_low_26.bin"                                     ; щ
; .ru_low_27      incbin "Font ru_low_27.bin"                                     ; ъ
; .ru_low_28      incbin "Font ru_low_28.bin"                                     ; ы
; .ru_low_29      incbin "Font ru_low_29.bin"                                     ; ь
; .ru_low_30      incbin "Font ru_low_30.bin"                                     ; э
 
; .ru_low_31      incbin "Font ru_low_31.bin"                                     ; ю
; .ru_low_32      incbin "Font ru_low_32.bin"                                     ; я
; .ru_low_33      incbin "Font ru_low_33.bin"                                     ; ѣ
; .ru_low_34      incbin "Font ru_low_34.bin"                                     ; ї
; .ru_low_35      incbin "Font ru_low_35.bin"                                     ; ѥ
Size            EQU $
                COMPRESSED_ASSET \
                "Builder/Assets/Graphics/Compressed/Font/Ru.pack", \
                "Builder/Assets/Graphics/Compressed/Font/Ru.pack.ar"
                endmodule
                endmodule

                endif ; ~ _GRAPHICS_FONT_PACK_RU_INCLUDE_
