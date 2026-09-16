# Driver & Module Plan - PRJ-08-ELEVATOR

> This section documents the full driver/module inventory required to implement
> the spec, including modules that are implied by the requirements but not
> explicitly named in the layer diagram (§9.1) or module table (§9.3).

---

## MCAL (register-level — only layer allowed to touch hardware, NFR-08): "how do I even talk to this chip"
| Driver | Functions | Why | Name | Done |
|---|---|---|---|---|
| `dio.c/h` | `DIO_Init(port,pin,dir)`, `DIO_Write`, `DIO_Read` | Controls motor direction pins for cabin up/down movement and door opening/closing | Asmaa Naguib |  done  |
| `pwm.c/h` | `PWM_Init()`, `PWM_SetDutyCycle(channel, duty)` | Manages elevator motor speed profiles for smooth acceleration, cruising, and deceleration | Asmaa Naguib|  done  |
| `adc.c/h` | `ADC_Init`, `ADC_Read(channel)` | Reads analog floor position indicators and the Load Cell sensor for passenger weight monitoring  | Menna Allah | done   |
| `exti.c/h` | `EXTI_Init()`, minimal ISR stubs for safety/emergency | Handles emergency stop and door safety mechanisms with strict, low-latency interrupt handling | Menna Allah | done  |
| `spi.c/h` (74HC165) | `SPI_Init`, `SPI_Transfer(byte)` | Reads cabin and floor call buttons using parallel-in/serial-out shift registers | Eman | done |
| `I2S.c`  | `I2S_Init`, `I2C_SendStart` |  used as the communication layer to control an I2C-based LCD module (e.g., via PCF8574 I/O expander) by sending initialization commands and character data over the bus.  |  Eman | done|
| `spi.c/h` (74HC595) | `SPI_Init`, `SPI_Transfer(byte)` | Drives floor number 7-segment displays using serial-in/parallel-out shift registers | Maryam Salah |  done   | 
| `usart.c/h` | `USART_Init`, `USART_SendByte/String`, RX/TX | Transmits real-time status and telemetry reports to the building-management console | Maryam Salah |  done   |

---

## HAL (peripheral abstractions — no bit-banging outside this layer : "what does this specific accessory do")

| Module | Functions | Why | Name | Done |
|---|---|---|---|---|
| `keypad.c/h` | `Keypad_Init()`, `Keypad_GetPressedKey()` | Scans the cabin and floor call buttons using the 74HC165 shift register driver | Maryam Salah|  done   |
| `motor_ctrl.c/h` | `Motor_MoveUp()`, `Motor_MoveDown()`, `Motor_Stop()`, `Motor_SetSpeed(speed)` | Directs elevator car movement, direction, and speed profiles using DIO and PWM | Asmaa Naguib | done  |
| `door_ctrl.c/h` | `Door_Open()`, `Door_Close()`, `Door_CheckSafety()` | Manages cabin door automation and emergency safety mechanisms via EXTI | Asmaa Naguib | done    |
| `sensor_mgr.c/h` | `Sensor_GetFloorPosition()`, `Sensor_GetWeight()` | Evaluates analog floor indicators and Load Cell weight limits using the ADC driver | |    |
| `display.c/h` | `Display_SetFloor(floorNum)` | Drives the floor number 7-segment displays using the 74HC595 shift register ||    |
| `comm_mgr.c/h` | `Comm_SendTelemetry(msg)`, `Comm_ReceiveCommand()` | Handles real-time communication and reports with the building-management console via USART | Menna Allah |  done   |

---

## APP (application layer — project-specific business logic and elevator state machine)

| Module | Functions | Why | Name | Done |
|---|---|---|---|---|
| `elevator_app.c/h` | `Elevator_Init()`, `Elevator_Run()` | Manages the main elevator control loop, floor requests queue, and state transitions (idle, moving, doors open) | Asmaa Naguib |     |
| `dispatch.c/h` | `Dispatch_UpdateQueue()`, `Dispatch_GetNextFloor()` | Implements the scheduling and dispatch algorithm to route the elevator cabin efficiently based on cabin and floor calls |Menna Alla  |      |

---

## LIB (library / services — general utilities used across the entire project)

| Module | Functions | Why | Name | Done |
|---|---|---|---|---|
| `std_types.h` | Standard data type definitions (`u8`, `u16`, `u32`, etc.) | Provides fixed-width integer types and standard macros used across all layers for portability | Maryam Salah|    |
| `ring_buffer.c/h` | `Buffer_Init()`, `Buffer_Enqueue()`, `Buffer_Dequeue()` | Provides circular buffer implementations required for safe asynchronous data handling in UART and communication modules | Eman | Done |
