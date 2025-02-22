
                ifndef _KERNEL_ASSETS_MANAGER_
                define _KERNEL_ASSETS_MANAGER_
AssetsManager
.Load               EQU Bootloader.KernelMinimal.AssetsManager.Load             ; загрузка ресурса
.Mark               EQU Bootloader.KernelMinimal.AssetsManager.Mark             ; отметить занятую область данными в доступной ОЗУ
.MarkAsUnclaimed    EQU Bootloader.KernelMinimal.AssetsManager.MarkAsUnclaimed  ; пометить как невостребованный ресурс
.Mark.Force         EQU Bootloader.KernelMinimal.AssetsManager.Mark.Loop        ; отметить занятую область данными в доступной ОЗУ          (принудительно)
.Release            EQU Bootloader.KernelMinimal.AssetsManager.Release          ; освободить ранее занятую область данными в доступной ОЗУ
.Release.Force      EQU Bootloader.KernelMinimal.AssetsManager.Release.Loop     ; освободить ранее занятую область данными в доступной ОЗУ  (принудительно)
.ReleaseAsset       EQU Bootloader.KernelMinimal.AssetsManager.ReleaseAsset     ; освободить ранее загруженный ресурс
.Allocation         EQU Bootloader.KernelMinimal.AssetsManager.Allocation       ; распределение ресурса
.TryToFree          EQU Bootloader.KernelMinimal.AssetsManager.TryToFree        ; попытка освободить память под ресурс
.CalcSecToDisk      EQU Bootloader.KernelMinimal.AssetsManager.CalcSecToDisk    ; преобразование линейного адреса к позиции на диске
.CalcSizeToBlock    EQU Bootloader.KernelMinimal.AssetsManager.CalcSizeToBlock  ; преобразование размера ресурса в блоки по 256 байт
.CalcAvailableMem   EQU Bootloader.KernelMinimal.AssetsManager.CalcAvailableMem ; преобразование линейного адреса в расположение и номер бита

                endif ; ~_KERNEL_ASSETS_MANAGER_
