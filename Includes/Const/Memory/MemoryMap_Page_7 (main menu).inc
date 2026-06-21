
                ifndef _CONST_MEMORY_MAP_PAGE_7_MAIN_MENU_
                define _CONST_MEMORY_MAP_PAGE_7_MAIN_MENU_
                
                ;   +-------+------------------------------------------+-------+
                ;   | #С000 |                             ShadowScreen | #1B00 |
                ;   +-------+------------------------------------------+-------+
                ;   | #DB00 |                               ForceTable | #0200 | ; таблица величины силы: F(r) = K_GRAV / (r + 1)
                ;   +-------+------------------------------------------+-------+
                ;   | #DD00 |                            ParticleArray | #0A00 | ; массив частиц
                ;   +-------+------------------------------------------+-------+
                ;   | #E700 |                                 свободно | #1900 | ; свободно
                ;   +-------+------------------------------------------+-------+

                module Page
ForceTable      EQU PAGE_7

                endmodule

                module Size
ForceTable      EQU #0200                                                       ; размер таблицы величины силы
ParticleArray   EQU FTargetParticle * MAX_TARGET_PARTICLE                       ; размер массива частиц
                endmodule

                module Adr
ForceTable      EQU #DB00                                                       ; адрес таблица величины силы
ParticleArray   EQU #DD00                                                       ; адрес массив частиц
                endmodule

                endif ; ~_CONST_MEMORY_MAP_PAGE_7_MAIN_MENU_
