
                ifndef _ASSETS_MANAGER_INITIALIZE_
                define _ASSETS_MANAGER_INITIALIZE_

                module AssetsManager
; -----------------------------------------
; инициализация ресурс менеджера
; In:
; Out:
; Corrupt:
; Note:
;   - код для встраивания (не вызова)
; -----------------------------------------
Initialize:     ; загрузка данных с диска о ресурсах
                LD HL, Adr.ExtraBuffer                                          ; адреса загрузки
                LD DE, (TRDOS.CUR_SEC)                                          ; позиция головки дисковода из системной переменн
                LD BC, (Assets.Sector << 8) | TRDOS.RD_SECTORS                  ; регистр B содержит кол-во секторов
                                                                                ; регистр С — номер подпрограммы #05 (чтение секторов)
                CALL TRDOS.EXE_CMD                                              ; переход в TR-DOS

                ; очистка массива ассетов
                LD HL, Adr.AssetsTable
                LD DE, Adr.AssetsTable+1
                LD BC, Size.AssetsTable-1
                LD (HL), ASSETS_EMPTY_ELEMENT
                LDIR

                LD IX, Adr.AssetsTable
                LD HL, Adr.ExtraBuffer
                LD DE, (TRDOS.CUR_SEC)                                          ; позиция головки дисковода из системной переменн
                                                                                ; E - номер сектора, D - номер трека
                ; приведение к линейному адресу в секторах
                LD A, D
                RLCA
                RLCA
                RLCA
                RLCA
                LD D, A
                XOR E
                AND #F0
                XOR E
                LD E, A
                LD A, #0F
                AND D
                LD D, A
                PUSH DE

                LD B, Assets.Num

.Loop           ; сброс адреса расположения ресурса
                LD A, ASSETS_EMPTY_ELEMENT
                LD (IX + FAssets.Address.Page), A
                LD (IX + FAssets.Address.Adr.Low), A
                LD (IX + FAssets.Address.Adr.High), A

                ; чтение размера блока (в секторах) и флаг
                LD A, (HL)
                INC HL

                ; сохранение размер ресурса на диске (в секторах)
                SRL A
                LD (IX + FAssets.Location.Size), A

                ; сохранение флага ресурса и реального размера блока (в байтах)
                SBC A, A
                XOR (HL)
                AND %00000001
                XOR (HL)
                LD (IX + FAssets.Flags), A
                INC HL
                LD A, (HL)
                INC HL
                LD (IX + FAssets.Size), A

                ; сохранение физического расположения ресурса на диске 
                EX (SP), HL
                LD (IX + FAssets.Location.Sector), HL

                ; расчёт положения следующего ресурса
                LD A, L
                ADD A, (IX + FAssets.Location.Size)
                LD L, A
                ADC A, H
                SUB L
                LD H, A

                EX (SP), HL
                
                ; следующий элемент
                LD DE, FAssets
                ADD IX, DE

                DJNZ .Loop
                POP AF                                                          ; освобожение 2х байт на вершине стека

                display " - Assets manager initialize:\t\t\t\t\t\t= busy [ ", /D, $-Initialize, " byte(s) ]"
                endmodule

                endif ; ~ _ASSETS_MANAGER_INITIALIZE_
