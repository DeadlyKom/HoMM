
                ifndef _CONFIG_ZX_SPECTRUM_BASIC_
                define _CONFIG_ZX_SPECTRUM_BASIC_

                module BASIC
LD_BYTES        EQU #0556                                                       ; 
ROM_FONT_ADR    EQU #3D00                                                       ; адрес ASCII fonts
ERR_NR          EQU #5C3A                                                       ; рег IY
FLAGS           EQU #5C3B                                                       ; различные флаги для управления системой BASIC
ERR_SP          EQU #5C3D                                                       ; адрес элемента в стеке машины для использования в качестве возврата ошибки
BORDCR          EQU #5C48                                                       ; цвет бордюра * 8, также содержит атрибуты, обычно используемые для нижней половины экрана.
ATTR_P          EQU #5C8D
ATTR_T          EQU #5C8F

                endmodule

                endif ; ~_CONFIG_ZX_SPECTRUM_BASIC_
