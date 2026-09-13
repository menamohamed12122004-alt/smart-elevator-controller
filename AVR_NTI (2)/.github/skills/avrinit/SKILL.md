---
name: avrinit
description: Check the Windows system, install AVR-GCC on C:\ if missing, add it to PATH, create a recursive AVR Makefile for AVR_NTI (MCAL/HAL/Logic), then run make and verify program.hex/program.bin. Use when the user runs /AVRINIT, /avrinit, or asks to initialize the AVR toolchain or AVR_NTI project.
disable-model-invocation: true
---

<!-- Author: Ahmed Ellamie | ahmed.ellamiee@gmail.com -->

# /AVRINIT

Initialize this `AVR_NTI` layered AVR project on the current machine.

## Do this now

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "tools/avr-init.ps1"
```

Follow the workflow in the course skill at `.cursor/skills/avrinit/SKILL.md` if this folder is opened from the G9 workspace.
