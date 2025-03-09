
                ifndef _GRAPHICS_TILE_ARRAY_ADR_TILE_SPRITE_GRASS_SAND_
                define _GRAPHICS_TILE_ARRAY_ADR_TILE_SPRITE_GRASS_SAND_
ArrayBegin      EQU $

                DW Grass_Sand.Forest_1_0                                        ; #00 - лес 1 (вверх)
                DW Grass_Sand.GGGS                                              ; #01 - трава "левый-верхний"
                DW Grass_Sand.GGSS                                              ; #02 - трава "верхний"
                DW Grass_Sand.GGSG                                              ; #03 - трава "правый-верхний"
                DW Grass_Sand.SSSG                                              ; #04 - песок "левый-верхний"
                DW Grass_Sand.SSGS                                              ; #05 - песок "правый-верхний"
                DW #0000                                                        ; #06
                DW #0000                                                        ; #07
                DW #0000                                                        ; #08
                DW #0000                                                        ; #09
                DW #0000                                                        ; #0A
                DW #0000                                                        ; #0B
                DW #0000                                                        ; #0C
                DW #0000                                                        ; #0D
                DW #0000                                                        ; #0E
                DW #0000                                                        ; #0F
                DW Grass_Sand.Forest_1_1                                        ; #10 - лес 1 (низ)
                DW Grass_Sand.GSGS                                              ; #11 - трава "левый"
                DW Grass_Sand.Sand                                              ; #12 - песок
                DW Grass_Sand.SGSG                                              ; #13 - трава "правый"
                DW Grass_Sand.SGSS                                              ; #14 - песок "левый-нижний"
                DW Grass_Sand.GSSS                                              ; #15 - песок "правый-нижний"
                DW #0000                                                        ; #16
                DW #0000                                                        ; #17
                DW #0000                                                        ; #18
                DW #0000                                                        ; #19
                DW #0000                                                        ; #1A
                DW #0000                                                        ; #1B
                DW #0000                                                        ; #1C
                DW #0000                                                        ; #1D
                DW #0000                                                        ; #1E
                DW #0000                                                        ; #1F
                DW Grass_Sand.Forest_0                                          ; #20 - лес 0
                DW Grass_Sand.GSGG                                              ; #21 - трава "левый-нижний"
                DW Grass_Sand.SSGG                                              ; #22 - трава "нижний"
                DW Grass_Sand.SGGG                                              ; #23 - трава "правый-нижний"
                DW Grass_Sand.Grass                                             ; #24 - трава
                DW #0000                                                        ; #25
                DW #0000                                                        ; #26
                DW #0000                                                        ; #27
                DW #0000                                                        ; #28
                DW #0000                                                        ; #29
                DW #0000                                                        ; #2A
                DW #0000                                                        ; #2B
                DW #0000                                                        ; #2C
                DW #0000                                                        ; #2D
                DW #0000                                                        ; #2E
                DW #0000                                                        ; #2F
ArraySize       EQU $-ArrayBegin

                DS 256 - ArraySize, #00

                endif ; ~ _GRAPHICS_TILE_ARRAY_ADR_TILE_SPRITE_GRASS_SAND_
