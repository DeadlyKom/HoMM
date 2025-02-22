
                ifndef _KERNEL_TR_DOS_
                define _KERNEL_TR_DOS_
TRDOS:
.Initialize     EQU Bootloader.TRDOS.Initialize
.Jump3D13       EQU Bootloader.TRDOS.Jump3D13

                endif ; ~_KERNEL_TR_DOS_
