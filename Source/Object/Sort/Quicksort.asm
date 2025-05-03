
                ifndef _OBJECT_SORT_QUICKSORT_
                define _OBJECT_SORT_QUICKSORT_
; -----------------------------------------
; сортировка
; In:
;   C - количествой элементов в массиве (обязательно > 0)
; Out:
; Corrupt:
; Note:
;   устойчив к прерыванию
; -----------------------------------------
Quicksort:      LD A, C
                DEC A
                JR Z, .Exit

                ; -----------------------------------------
                ; инициализация
                ; -----------------------------------------
.Offset         EQU $+1
                LD HL, Adr.SortBuffer
                LD B, #01                                                       ; текущий элемент
                LD A, B
                INC A
                EX AF, AF'

                ; -----------------------------------------
                ; s     = C  - размер массива
                ; i     = B  - текущий элемент
                ; j     = A' - следующий элемент
                ; a[]   = HL - указатель на массив
                ;
                ; while (i < s)
                ; {
                ;     if (a[i-1] <= a[i])
                ;     {
                ;         i=j;
                ;         j++;
                ;     }
                ;     else
                ;     {
                ;         ex a[i], a[i-1];
                ;         if (--i == 0)
                ;         {
                ;             i=j;
                ;             j++;
                ;         }
                ;     }
                ; }
                ; -----------------------------------------

.Loop           ; чтение адреса элемента [i-1]
                LD E, (HL)
                INC L
                LD D, (HL)
                INC L
                PUSH DE

                ; чтение адреса элемента [i]
                LD E, (HL)
                INC L
                LD D, (HL)
                PUSH DE

                ; -----------------------------------------
                ; проверка [i] >= [i-1]
                ; -----------------------------------------
                EXX
                
                ; чтение значения элемента [i]
                POP HL
                LD E, (HL)
                INC L
                LD D, (HL)

                ; чтение значения элемента [i-1]
                POP HL
                LD A, (HL)
                INC L
                LD H, (HL)
                LD L, A

                OR A
                EX DE, HL
                SBC HL, DE
                EXX
                JR NC, .Next    ; переход, если [i] >= [i-1]

                ; -----------------------------------------
                ; меняем местами адреса
                ; -----------------------------------------
                DEC L
                DEC L
                DEC L
                LD A, (HL)
                LD (HL), E
                INC L
                LD E, (HL)
                LD (HL), D
                INC L
                LD (HL), A
                INC L
                LD (HL), E
                DEC L
                DEC L
                DEC L

                ; назад на 1 элемент
                DEC L
                DEC L

                ; i--; if (i == 0)
                DJNZ .Loop

.Next           ; i = j, j++
                EX AF, AF'
                LD B, A
                INC A
                EX AF, AF'

                ; расчёт адреса по индексу
                LD HL, .Offset
                LD A, B
                DEC A
                ADD A, A
                ADD A, (HL)
                LD L, A
                LD H, HIGH Adr.SortBuffer

                ; i < size
                LD A, B
                CP C
                JP C, .Loop

.Exit           ; корректировка количество элементов в массиве
                ; несортированные + сортированные
                LD HL, .Offset
                LD A, (HL)
                SRL A
                ADD A, C
                LD C, A

                RET

                endif ; ~_OBJECT_SORT_QUICKSORT_
