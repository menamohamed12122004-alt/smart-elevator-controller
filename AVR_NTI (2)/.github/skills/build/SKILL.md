---
name: build
description: Check the AVR_NTI codebase, files, and AVR toolchain, repair a broken Makefile, then build and verify program.hex/program.bin. Use when the user runs /build, asks to build the AVR project, or wants the firmware HEX/BIN verified.
disable-model-invocation: true
---

<!-- Author: Ahmed Ellamie | ahmed.ellamiee@gmail.com -->

# /build

Build and verify this `AVR_NTI` firmware.

## Do this now

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "tools/avr-build.ps1"
```

Follow the workflow in the course skill at `.cursor/skills/build/SKILL.md` if this folder is opened from the G9 workspace.
