---
mode: agent
description: Check the system, install AVR-GCC on C:\ if missing, add it to PATH, write a recursive AVR_NTI Makefile, then run make and verify the HEX/BIN output.
---

<!-- Author: Ahmed Ellamie | ahmed.ellamiee@gmail.com -->

# /AVRINIT

Set up this machine and the `AVR_NTI` project for AVR firmware builds.

## Goal

- Confirm the OS and that the AVR toolchain works
- Install AVR-GCC on the C partition when it is missing
- Add the toolchain to PATH so anyone can run `avr-gcc` and `make`
- Keep layers `LIB`, `MCAL`, `HAL`, `Logic`, plus `main.c`
- Write a Makefile that searches every folder in this project and links all `.c` files
- Run make and prove `build/program.hex` and `build/program.bin` exist

## Required workflow

1. Run `tools/avr-init.ps1` with ExecutionPolicy Bypass. Do not only describe the steps.
2. If `avr-gcc` is missing, the script installs the toolchain to `C:\avr-gcc` and adds `C:\avr-gcc\bin` to the user PATH.
3. If WinAVR or another AVR toolchain is already on C:, reuse it and only fix PATH.
4. Refresh `Makefile` from `tools/Makefile.template` so it discovers sources under `.`, `LIB`, `MCAL`, `HAL`, `Logic`, and nested folders.
5. Run `make clean all` and confirm the HEX/BIN files.

## Rules

- Default MCU is `atmega32`, `F_CPU=8000000UL`.
- Makefile recipes must use tabs.
- Do not hardcode WinAVR paths in the Makefile.
- Put Ahmed Ellamie / ahmed.ellamiee@gmail.com on files you create or change.

## Final response

Report toolchain location, PATH changes, Makefile status, HEX/BIN paths, and whether a VS Code restart is needed.
