
                ifndef _KERNEL_MEMORY_
                define _KERNEL_MEMORY_
Memcpy:
.FastLDIR       EQU Bootloader.KernelMinimal.Memcpy.FastLDIR                    ; копирование данных
.Sprite         EQU Kernel.Memcpy.Sprite                                        ; копирование спрайта во временный буфер
.FromPage       EQU Kernel.Memcpy.FromPage                                      ; копирование данных из страницы находясь в иной страничке

.BetweenPages   EQU Kernel.Memcpy.BetweenPages                                  ; копирование большого блока между страничками, через буфер
SafeFill:                                                                       ; заполнение блока памяти
.Screen         EQU Bootloader.KernelMinimal.Memset.SafeFill_Screen
.b4096          EQU Bootloader.KernelMinimal.Memset.SafeFill_4096
.b2048          EQU Bootloader.KernelMinimal.Memset.SafeFill_2048
.b1024          EQU Bootloader.KernelMinimal.Memset.SafeFill_1024
.b768           EQU Bootloader.KernelMinimal.Memset.SafeFill_768
.b512           EQU Bootloader.KernelMinimal.Memset.SafeFill_512
.b256           EQU Bootloader.KernelMinimal.Memset.SafeFill_256
.b192           EQU Bootloader.KernelMinimal.Memset.SafeFill_192
.b176           EQU Bootloader.KernelMinimal.Memset.SafeFill_176
.b128           EQU Bootloader.KernelMinimal.Memset.SafeFill_128
.b64            EQU Bootloader.KernelMinimal.Memset.SafeFill_64
.b32            EQU Bootloader.KernelMinimal.Memset.SafeFill_32

                endif ; ~_KERNEL_MEMORY_
