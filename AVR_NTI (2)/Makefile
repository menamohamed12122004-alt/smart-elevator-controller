# --- AVR Project Makefile (Manual Sources & Windows Compatible) ---

MCU      ?= atmega32
F_CPU    ?= 8000000UL
TARGET   ?= program

BUILD_DIR := build

CC      := avr-gcc
OBJCOPY := avr-objcopy
OBJDUMP := avr-objdump
SIZE    := avr-size

CFLAGS  := -mmcu=$(MCU) -DF_CPU=$(F_CPU) -Os -Wall -std=gnu99 -ffunction-sections -fdata-sections
LDFLAGS := -mmcu=$(MCU) -Wl,--gc-sections -Wl,-Map=$(BUILD_DIR)/$(TARGET).map

<<<<<<< HEAD
SRCS = main.c \
       MCAL/GPIO/GPIO.c \
       MCAL/GPIO/dio.c \
       MCAL/SPI/SPI.c \
       MCAL/ADC/ADC.c \
       MCAL/UART/UART.c \
       MCAL/TIMER/timer.c \
	   MCAL/INTERRUPT/INTERRUPT.c \
       MCAL/TIMER/pwm.c
=======
# Search the whole project: root + 4 directory levels (LIB/MCAL/HAL/Logic and nested drivers).
SRCS := $(wildcard *.c)
SRCS += $(wildcard */*.c)
SRCS += $(wildcard */*/*.c)
SRCS += $(wildcard */*/*/*.c)
SRCS += $(wildcard */*/*/*/*.c)
SRCS := $(filter-out $(BUILD_DIR)/% MCAL/EXTI/EXTI.c,$(SRCS))
>>>>>>> 0e6b039 (Update AVR project to use GCC 15.2.0 and optimize memory layout)

HDRS = LIB/std_types.h \
       LIB/bit_math.h \
       MCAL/GPIO/GPIO_interface.h \
       MCAL/GPIO/dio_interface.h \
       MCAL/SPI/SPI_interface.h \
       MCAL/ADC/ADC_interface.h \
       MCAL/UART/UART_interface.h \
       MCAL/TIMER/timer_interface.h \
	   MCAL/TIMER/pwm_interface.h


OBJS     := $(patsubst %.c,$(BUILD_DIR)/%.o,$(SRCS))
PREPROCS := $(patsubst %.c,$(BUILD_DIR)/%.i,$(SRCS))
ASMS     := $(patsubst %.c,$(BUILD_DIR)/%.s,$(SRCS))

INC_DIRS := $(sort . LIB MCAL/GPIO MCAL/DIO MCAL/SPI MCAL/ADC MCAL/UART MCAL/TIMER $(dir $(SRCS)) $(dir $(HDRS)))
INCLUDES := $(addprefix -I,$(INC_DIRS))

<<<<<<< HEAD
=======
# Keep directory creation compatible with the Windows command shell.
>>>>>>> 0e6b039 (Update AVR project to use GCC 15.2.0 and optimize memory layout)
.PHONY: all clean size verify

all: $(PREPROCS) $(ASMS) $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin size

$(BUILD_DIR)/%.i: %.c
	@if not exist "$(dir $@)" mkdir "$(dir $@)"
	$(CC) $(CFLAGS) $(INCLUDES) -E $< -o $@

$(BUILD_DIR)/%.s: %.c
	@if not exist "$(dir $@)" mkdir "$(dir $@)"
	$(CC) $(CFLAGS) $(INCLUDES) -S $< -o $@

$(BUILD_DIR)/%.o: %.c
	@if not exist "$(dir $@)" mkdir "$(dir $@)"
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJS)
	@if not exist "$(BUILD_DIR)" mkdir "$(BUILD_DIR)"
	$(CC) $(LDFLAGS) $(OBJS) -o $@

$(BUILD_DIR)/$(TARGET).hex: $(BUILD_DIR)/$(TARGET).elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@
	@echo HEX ready: $@

$(BUILD_DIR)/$(TARGET).bin: $(BUILD_DIR)/$(TARGET).elf
	$(OBJCOPY) -O binary -R .eeprom $< $@
	@echo BIN ready: $@

size: $(BUILD_DIR)/$(TARGET).elf
	$(SIZE) $<

verify: all
	@echo BUILD_OK MCU=$(MCU) F_CPU=$(F_CPU) SRCS=$(SRCS)

clean:
<<<<<<< HEAD
	rm -rf $(BUILD_DIR)
	@echo Cleaned $(BUILD_DIR)
=======
	@if exist "$(BUILD_DIR)" rmdir /s /q "$(BUILD_DIR)"
	@echo Cleaned $(BUILD_DIR)
>>>>>>> 0e6b039 (Update AVR project to use GCC 15.2.0 and optimize memory layout)
