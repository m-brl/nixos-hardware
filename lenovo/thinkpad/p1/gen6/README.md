# Lenovo ThinkPad P1 Gen 6

https://psref.lenovo.com/Product/ThinkPad/ThinkPad_P1_Gen_6

Tested on a P1 Gen 6 (21FV) with an Intel Core i7-13700H (Raptor Lake) and an
NVIDIA RTX 2000 Ada Generation Laptop GPU (Ada Lovelace) discrete GPU.

Every P1 Gen 6 pairs a 13th-gen Core i7/i9 H (Intel Iris Xe) with one of these
NVIDIA discrete GPUs; there is no iGPU-only configuration:

- RTX 2000 / 3500 / 4000 / 5000 Ada Generation Laptop GPU (Ada Lovelace)
- GeForce RTX 4060 / 4080 / 4090 Laptop GPU (Ada Lovelace)
- RTX A1000 Laptop GPU (Ampere)

Profiles:

- `lenovo-thinkpad-p1-gen6` — Raptor Lake base without any NVIDIA driver
  configuration; use it to handle (or disable) the discrete GPU yourself.
- `lenovo-thinkpad-p1-gen6-nvidia` — adds the NVIDIA driver with PRIME
  **offload**, for any of the GPUs above. Run a program on the discrete GPU
  with `nvidia-offload <command>`.

## Hybrid vs. discrete graphics

PRIME offload requires the firmware to expose the Intel iGPU, i.e. the
*Hybrid Graphics* setting in the BIOS (Config → Display → Graphics Device).
When the BIOS is set to *Discrete Graphics*, the iGPU (`00:02.0`) disappears
from the PCI bus and PRIME must be disabled:

```nix
hardware.nvidia.prime.offload.enable = false;
```

## Power management

The `-nvidia` profile enables PRIME **offload** but does not turn on fine-grained
runtime power management, so the discrete GPU stays powered even when idle —
noticeable battery drain on a laptop. That setting is experimental and depends on
the GPU + firmware supporting PCIe Runtime D3 (RTD3), so it is left to the user.
If your unit supports it, let the dGPU suspend when unused by adding to your own
configuration:

```nix
hardware.nvidia.powerManagement.finegrained = true;
```

## Tested Hardware

```shell
lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation Raptor Lake-P 6p+8e cores Host Bridge/DRAM Controller [8086:a706]
00:01.0 PCI bridge [0604]: Intel Corporation Raptor Lake PCI Express 5.0 Graphics Port (PEG010) [8086:a70d]
00:02.0 VGA compatible controller [0300]: Intel Corporation Raptor Lake-P [Iris Xe Graphics] [8086:a7a0] (rev 04)
00:04.0 Signal processing controller [1180]: Intel Corporation Raptor Lake Dynamic Platform and Thermal Framework Processor Participant [8086:a71d]
00:06.0 PCI bridge [0604]: Intel Corporation Raptor Lake PCI Express 4.0 Graphics Port [8086:a74d]
00:06.2 PCI bridge [0604]: Intel Corporation Device [8086:a73d]
00:08.0 System peripheral [0880]: Intel Corporation GNA Scoring Accelerator module [8086:a74f]
00:14.0 USB controller [0c03]: Intel Corporation Alder Lake PCH USB 3.2 xHCI Host Controller [8086:51ed] (rev 01)
00:14.2 RAM memory [0500]: Intel Corporation Alder Lake PCH Shared SRAM [8086:51ef] (rev 01)
00:14.3 Network controller [0280]: Intel Corporation Raptor Lake PCH CNVi WiFi [8086:51f1] (rev 01)
00:15.0 Serial bus controller [0c80]: Intel Corporation Alder Lake PCH Serial IO I2C Controller #0 [8086:51e8] (rev 01)
00:15.3 Serial bus controller [0c80]: Intel Corporation Alder Lake PCH Serial IO I2C Controller #3 [8086:51eb] (rev 01)
00:16.0 Communication controller [0780]: Intel Corporation Alder Lake PCH HECI Controller [8086:51e0] (rev 01)
00:1c.0 PCI bridge [0604]: Intel Corporation Device [8086:51b8] (rev 01)
00:1c.7 PCI bridge [0604]: Intel Corporation Alder Lake PCH-P PCI Express Root Port #9 [8086:51bf] (rev 01)
00:1d.0 PCI bridge [0604]: Intel Corporation Alder Lake PCI Express Root Port #9 [8086:51b0] (rev 01)
00:1f.0 ISA bridge [0601]: Intel Corporation Raptor Lake LPC/eSPI Controller [8086:519d] (rev 01)
00:1f.3 Multimedia audio controller [0401]: Intel Corporation Raptor Lake-P/U/H cAVS [8086:51ca] (rev 01)
00:1f.4 SMBus [0c05]: Intel Corporation Alder Lake PCH-P SMBus Host Controller [8086:51a3] (rev 01)
00:1f.5 Serial bus controller [0c80]: Intel Corporation Alder Lake-P PCH SPI Controller [8086:51a4] (rev 01)
01:00.0 VGA compatible controller [0300]: NVIDIA Corporation AD107GLM [RTX 2000 Ada Generation Laptop GPU] [10de:28b8] (rev a1)
01:00.1 Audio device [0403]: NVIDIA Corporation AD107 High Definition Audio Controller [10de:22be] (rev a1)
06:00.0 Non-Volatile memory controller [0108]: SK hynix Platinum P41/PC801 NVMe Solid State Drive [1c5c:1959]
07:00.0 Non-Volatile memory controller [0108]: Micron/Crucial Technology P5 Plus NVMe PCIe SSD [c0a9:5407]
08:00.0 Cellular controller/modem [0d40]: Intel Corporation XMM7560 LTE Advanced Pro Modem [8086:7560] (rev 01)
0a:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS5261 PCIe SD Express Card Reader controller [10ec:5261] (rev 01)
20:00.0 PCI bridge [0604]: Intel Corporation Thunderbolt 4 Bridge [Maple Ridge 4C 2020] [8086:1136] (rev 02)
21:00.0 PCI bridge [0604]: Intel Corporation Thunderbolt 4 Bridge [Maple Ridge 4C 2020] [8086:1136] (rev 02)
21:01.0 PCI bridge [0604]: Intel Corporation Thunderbolt 4 Bridge [Maple Ridge 4C 2020] [8086:1136] (rev 02)
21:02.0 PCI bridge [0604]: Intel Corporation Thunderbolt 4 Bridge [Maple Ridge 4C 2020] [8086:1136] (rev 02)
21:03.0 PCI bridge [0604]: Intel Corporation Thunderbolt 4 Bridge [Maple Ridge 4C 2020] [8086:1136] (rev 02)
22:00.0 USB controller [0c03]: Intel Corporation Thunderbolt 4 NHI [Maple Ridge 4C 2020] [8086:1137]
48:00.0 USB controller [0c03]: Intel Corporation Thunderbolt 4 USB Controller [Maple Ridge 4C 2020] [8086:1138]

nix-info -m
 - system: `"x86_64-linux"`
 - host os: `Linux 7.2.9, NixOS, 26.11 (Zokor), 26.11.20261011.7fd4004`
 - multi-user?: `yes`
 - sandbox: `yes`
 - version: `nix-env (Nix) 2.34.8`
 - nixpkgs: `/nix/store/r5l65vg4gi4dnx54zkwagfb8jmlqniy5-source`

```
