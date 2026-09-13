---
mode: agent
description: Check the AVR_NTI codebase, files, and AVR toolchain, repair the Makefile if needed, then build and verify program.hex and program.bin.
---

<!-- Author: Ahmed Ellamie | ahmed.ellamiee@gmail.com -->

# /build

Build the current `AVR_NTI` project and verify the firmware output.

## Goal

- Check `main.c`, `LIB`, `MCAL`, `HAL`, `Logic`, and every `.c` file
- Confirm `avr-gcc`, `avr-objcopy`, and `make` are on PATH
- Repair a missing or broken Makefile
- Run make and verify `build/program.hex` and `build/program.bin`

## Required workflow

1. Run `tools/avr-build.ps1` with ExecutionPolicy Bypass. Do not only describe the steps.
2. If the toolchain is missing, stop and tell the user to run `/AVRINIT`.
3. If the Makefile is missing, uses spaces in recipes, or does not search/link all project folders, restore it from `tools/Makefile.template`.
4. Run `make clean all`.
5. If compile/link fails, fix the source or Makefile and rebuild until it succeeds.

## Rules

- Build only this AVR project. Do not compile the PC C lessons.
- Makefile recipes must use tabs.
- Put Ahmed Ellamie / ahmed.ellamiee@gmail.com on files you create or change.

## Final response

Report the `.c` files found, toolchain status, whether the Makefile was repaired, and the HEX/BIN paths.
