
                ifndef _MODULE_SESSION_INTERRUPT_
                define _MODULE_SESSION_INTERRUPT_
; -----------------------------------------
; обработчик прерывания во время загрузки сессии
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   модуль Progress уже должен быть загружен и инициализирован;
;   вызов выполняется напрямую, без повторного обращения к менеджеру ассетов
; -----------------------------------------
Interrupt:      ; обновление на каждом четвёртом прерывании
                LD A, (TickCounterRef)
                AND #03
                RET NZ                                                          ; выход, если номер прерывания не кратен четырём

                SET_MODULE_PAGE_Progress                                        ; включить страницу модуля "Progress"
                LD HL, (Kernel.Modules.Progress.Address)                        ; адрес диспетчера загруженного модуля
                LD A, Progress.Tick                                             ; идентификатор функции тика
                PUSH AF                                                         ; идентификатор для диспетчера функций
                JP (HL)                                                         ; прямой вызов без менеджера ассетов

                endif ; ~ _MODULE_SESSION_INTERRUPT_
