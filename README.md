# Project 08 — Smart Elevator Controller

> Part of the **Embedded Systems Projects Book** — see the
> [book README](../README.md) for the shared platform baseline, layer rules and
> common rubric. Everything in this file is *in addition to* those rules.

---

## 1. Project Identity

| Field | Value |
|-------|-------|
| **Project code** | `PRJ-08-ELEVATOR` |
| **Team size** | 4 students (recommended) |
| **Team names**|
 Mariam Salah hamadto hagag 
 Menna Muhammed Ibrahim 
 Eman Elsayed Ali Ahmed
 Asmaa Salama |

| **Build window** | Days 13 – 15 (Sep 13 – Sep 17, 2026) |
| **Demo & submission** |Sep 30, 2026 |
| **Dominant skill** | LOOK dispatch algorithm, three-device SPI bus, motion profiling |
| **MCU** | ATmega32A @ 8 MHz |
| **Simulator** | SimulIDE 1.x |

---

## 2. Description

### In one sentence

**You are building the controller for a lift in a four-floor building.**

### What the circuit looks like

```
      floor 3   [^]           <- hall buttons on each floor
      floor 2   [^][v]
      floor 1   [^][v]
      ground    [v]

      inside the car:  [G] [1] [2] [3]   + door open / close
```

Ten call buttons in total, read through a 74HC165 shift register. A motor moves
the car, another moves the door. Sensors tell you where the car is, whether the
door is blocked, and whether the car is overloaded. There is also a fire-service
switch.

### The one thing you actually have to get right: which floor next?

Ten buttons can be pressed in any order, at any time. The controller has to
decide where to go.

**The beginner's answer is first-come, first-served.** Here is why it is bad.
Your car is at the ground floor:

```
   Somebody on floor 3 presses first.
   Then somebody on floor 1 presses.

   First-come-first-served:   G -> 3 -> 1        (you drive past floor 1, twice)
   What a real lift does:     G -> 1 -> 3        (you pick them up on the way)
```

With more passengers it gets much worse — the car yo-yos up and down the shaft
while people wait, and everybody's journey gets longer.

**The LOOK algorithm** is the fix, and it is two sentences:

> Keep travelling in the direction you are already going, for as long as there is
> any call ahead of you in that direction.
> When there is none, turn around if there are calls behind you; otherwise stop
> and wait.

That is it. The skill is implementing it as **bitmap arithmetic** — the calls are
bits in a word, and "is there a call above me?" is a shift and a mask — rather
than a long chain of `if (floor == 1) ... else if (floor == 2) ...`.

### The second thing: stopping level with the floor

You cannot slam the hoist motor from full speed to zero when you reach a floor.
The stop has to be a profile:

```
   full speed  ->  slowdown zone  ->  creep  ->  stop in the levelling window
```

The levelling window is a few centimetres wide. Getting the car to stop **level
with the floor, repeatably, arriving from both directions** is the single hardest
thing in this project. A car that stops 8 cm high is a trip hazard, and in a real
building it is a failed inspection.

### The third thing: three chips on one SPI bus

Two devices share the same three SPI wires, pulling in opposite directions: a
74HC165 that reads all sixteen buttons **in** on `MISO`, and a 74HC595 that
drives the floor display **out** on `MOSI`. Each has its own strobe, and **only
one may be clocking the bus at a time** — if both do, you get silent data
corruption on each: a button press that never registers, and a floor display
showing a digit built from half-shifted data.

### Safety runs through all of it

- The door **reverses** if something blocks it.
- An **overloaded** car will not move.
- The **emergency stop** cuts both motors from the interrupt.
- **Fire service** recall overrides and cancels every call in the system.

None of these are optional features. A lift that answers calls beautifully but
closes its door on somebody has failed.

### The rest of it

- The **LCD** shows the floor, the direction and the door state.
- The **serial link** streams the car state and every call.
- The **74HC595** drives the floor and direction display over SPI.
> **Note on saving.** There is no non-volatile memory in this project — SimulIDE
> has no part that could provide it. Trip counts, run hours and the car position
> all start fresh on each power-up, which is why the car **homes** at boot
> instead of trusting a stored position. See the book README, §4.

---

## 3. Objectives

1. Implement the LOOK dispatch algorithm over a call bitmap and prove it against
   a scripted call sequence.
2. Drive a three-device SPI bus with independent selects and no interference.
3. Read 16 buttons through a 74HC165 and drive a display through a 74HC595.
4. Build a trapezoidal motion profile with slowdown, creep and levelling zones.
5. Implement door control with an obstruction safety edge that reverses the door.
6. Implement an overload inhibit that prevents departure without stranding
   passengers.
7. Implement a fire-service recall mode with the correct override precedence.

---

## 4. Learning Outcomes

| ID | Outcome |
|----|---------|
| LO-1 | State the LOOK algorithm precisely and implement it as bitmap arithmetic, not as a chain of `if`s |
| LO-2 | Explain why FCFS dispatch is unacceptable and quantify the difference in journey time |
| LO-3 | Sequence three SPI slaves with different strobe semantics (CS-low, load-pulse, latch-pulse) |
| LO-4 | Read a 74HC165 chain: pulse `PL` low, then clock 16 bits in |
| LO-5 | Design a trapezoidal speed profile and compute stopping distance from deceleration rate |
| LO-6 | Implement door reversal so that the safety edge always wins over the close command |
| LO-7 | Order safety overrides (E-stop > fire > overload > normal) and defend the ordering |

---

## 5. Estimated Duration

| Phase | Hours | Course day |
|-------|:-----:|-----------|
| Requirements analysis & pin freeze | 4 | Day 11 |
| LOOK algorithm & FSM design on paper | 6 | Day 11 |
| SPI bus with three devices, 165/595 | 7 | Day 12 |
| Motion profile, levelling, door FSM | 8 | Day 13 |
| Dispatch, overload, fire service, UART | 6 | Day 14 |
| Testing (scripted call sequences) | 6 | Day 15 |
| Documentation, report, video | 4 | Day 15 + evening |
| **Total** | **41 h** | |

> This is the heaviest project in the book. If you are two students rather than
> three, drop the fire-service mode (FR-16) after telling the instructor, and
> say so in your report.

---

## 6. Hardware Components

| # | Component | Qty | SimulIDE part | Purpose |
|---|-----------|:---:|---------------|---------|
| 1 | ATmega32A | 1 | `atmega32` | Controller |
| 2 | Potentiometer 10 kΩ | 1 | `Potentiometer` | Car position in the shaft |
| 3 | Potentiometer 10 kΩ | 1 | `Potentiometer` | Car load (0 – 1000 kg) |
| 4 | Potentiometer 10 kΩ | 1 | `Potentiometer` | Hoist motor current |
| 5 | Potentiometer 10 kΩ | 1 | `Potentiometer` | Door position (0 – 100 %) |
| 6 | 74HC165 shift register | 2 | `Shift Reg.` | 16 button inputs, chained |
| 7 | 74HC595 shift register | 1 | `Shift Reg.` | 7-segment floor display |
| 8 | Push button | 12 | `Push` | 6 hall calls, 4 car calls, door open, door close |
| 9 | Switch (SPST) | 2 | `Switch` | Emergency alarm, fire service |
| 10 | 7-segment, common cathode | 1 | `7Segment` | Floor indicator |
| 11 | LED (green) | 2 | `Led` | Up / down direction arrows |
| 12 | LED (red) | 1 | `Led` | Overload |
| 13 | LED / motor | 1 | `DC Motor` | Hoist (PWM + direction) |
| 14 | LED / motor | 1 | `DC Motor` | Door (PWM + direction) |
| 15 | Switch (SPST, **NC**) | 1 | `Switch` | Emergency stop |
| 16 | Switch (SPST) | 1 | `Switch` | Door safety edge / light curtain |
| 17 | Buzzer | 1 | `Buzzer` | Arrival gong, alarms |
| 18 | 16×2 LCD + PCF8574 | 1 | `Lcd` + `I2CToParallel` | Service display |
| 20 | Serial terminal | 1 | `SerialPort` | Building-management console |

---

## 7. Pin Map

| Signal | Pin | Port bit | Direction | Notes |
|--------|-----|----------|-----------|-------|
| Car position | 40 | `PA0` / ADC0 | Analog in | 0 – 1023 → 0 – 1000 cm |
| Car load | 39 | `PA1` / ADC1 | Analog in | 0 – 1023 → 0 – 1000 kg |
| Hoist current | 38 | `PA2` / ADC2 | Analog in | 0 – 1023 → 0 – 20.0 A |
| Door position | 37 | `PA3` / ADC3 | Analog in | 0 = closed, 100 = open |
| Hoist UP | 1 | `PB0` | Out | H-bridge direction |
| Hoist DOWN | 2 | `PB1` | Out | H-bridge direction |
| Door OPEN | 3 | `PB2` | Out | Door motor direction |
| Door CLOSE | 4 | `PB3` | Out | Door motor direction |
| 74HC165 `SH/LD` | 5 | `PB4` | Out | Low samples the buttons, high shifts |
| SPI `MOSI` | 6 | `PB5` | Out | → 74HC595 `DS` |
| SPI `MISO` | 7 | `PB6` | In | ← 74HC165 `Q7` |
| SPI `SCK` | 8 | `PB7` | Out | Shared by all three |
| I2C `SCL` | 22 | `PC0` | Out | 4.7 kΩ pull-up |
| I2C `SDA` | 23 | `PC1` | Bidir | 4.7 kΩ pull-up |
| 74HC165 `PL` (load) | 24 | `PC2` | Out | Active-low pulse before reading |
| 74HC595 `RCLK` (latch) | 25 | `PC3` | Out | Rising edge latches |
| UP arrow LED | 26 | `PC4` | Out | |
| DOWN arrow LED | 27 | `PC5` | Out | |
| CPU-load test pin | 28 | `PC6` | Out | Timing measurement |
| Overload LED | 29 | `PC7` | Out | Red |
| USART `RXD` | 14 | `PD0` | In | 9600 8N1 |
| USART `TXD` | 15 | `PD1` | Out | 9600 8N1 |
| **Emergency stop** | 16 | `PD2` / INT0 | In, pull-up | **NC contact**, rising edge = trip |
| Door safety edge | 17 | `PD3` / INT1 | In, pull-up | Falling edge = obstruction |
| Door PWM | 18 | `PD4` / OC1B | PWM out | Door motor speed |
| Hoist PWM | 19 | `PD5` / OC1A | PWM out | Hoist motor speed |
| Fire-service switch | 20 | `PD6` | In, pull-up | Low = fire mode |
| Buzzer / gong | 21 | `PD7` / OC2 | Out | Arrival chime, alarms |

> `PC2` – `PC7` carry both shift-register strobes and the direction arrows:
> **clear the `JTAGEN` fuse** or neither the buttons nor the floor display will
> work.

### 74HC165 input map (16 bits, first byte = bits 15…8)

| Bit | Input | Bit | Input |
|:---:|-------|:---:|-------|
| 0 | Car call G | 8 | Hall UP G |
| 1 | Car call 1 | 9 | Hall UP 1 |
| 2 | Car call 2 | 10 | Hall DOWN 1 |
| 3 | Car call 3 | 11 | Hall UP 2 |
| 4 | Door OPEN button | 12 | Hall DOWN 2 |
| 5 | Door CLOSE button | 13 | Hall DOWN 3 |
| 6 | Emergency alarm button | 14 | spare |
| 7 | Independent-service switch | 15 | spare |

### Emergency stop wiring

Identical to Project 06: a **normally closed** contact so a broken wire trips
the elevator. Re-derive the argument in your own report; do not just cite it.

---

## 8. Peripherals Used

| Peripheral | Configuration | Role |
|------------|---------------|------|
| **GPIO** | `PB0..PB3`, `PC2..PC5`, `PC7` out; safety inputs in + pull-up | Motors, strobes, indicators |
| **ADC** | Single conversion, prescaler 64, AVCC ref | Position, load, current, door |
| **Timer0** | CTC, prescaler 1024, `OCR0 = 77` | 10 ms system tick |
| **Timer1** | Fast PWM mode 14, `ICR1 = 799`, prescaler 1 → 10 kHz | `OC1A` hoist, `OC1B` door |
| **Timer2** | Fast PWM, OC2 | Gong and alarm tones |
| **INT0** | Rising edge | Emergency stop |
| **INT1** | Falling edge | Door safety edge |
| **USART** | 9600 8N1, RX interrupt | Building-management console |
| **SPI** | Master, Mode 0, f/16 | 74HC165 in + 74HC595 out |
| **I2C (TWI)** | Master, 100 kHz | PCF8574 → LCD |

### PWM derivation

```
Fast PWM mode 14, TOP = ICR1 = 799, prescaler 1
f_pwm = 8 000 000 / 800 = 10 000 Hz
duty  = OCR1x / 800, 800 steps
```

10 kHz is a compromise: high enough that the hoist motor is quiet-ish, low
enough that a simulated H-bridge follows it. Justify it against Project 06's
20 kHz choice — a hoist motor is far larger and slower than a small DC motor.

---

## 9. Software Architecture

### 9.1 Layer view

```
┌───────────────────────────────────────────────────────────────────┐
│ APP                                                               │
│ ┌──────────┐ ┌─────────┐ ┌────────┐ ┌────────┐ ┌───────┐ ┌──────┐ │
│ │ car_fsm  │ │dispatch │ │ motion │ │door_fsm│ │safety │ │consle│ │
│ │          │ │ (LOOK)  │ │profile │ │        │ │       │ │      │ │
│ └────┬─────┘ └────┬────┘ └───┬────┘ └───┬────┘ └───┬───┘ └──┬───┘ │
│      └────────────┴──── scheduler (10 ms) ─────────┴────────┘     │
├───────────────────────────────────────────────────────────────────┤
│ HAL                                                               │
│  calls165.c  seg595.c  hoist.c  door.c  position.c  loadcell.c    │
│  lcd_i2c.c  shiftreg.c  gong.c                                  │
├───────────────────────────────────────────────────────────────────┤
│ MCAL                                                              │
│  dio.c  adc.c  timer.c  pwm.c  exti.c  usart.c  spi.c  i2c.c      │
├───────────────────────────────────────────────────────────────────┤
│ LIB    STD_TYPES.h  BIT_MATH.h  ring_buffer.c                     │
└───────────────────────────────────────────────────────────────────┘
```

### 9.2 The LOOK dispatcher

Calls live in three bitmaps, one bit per floor:

```c
#define FLOOR_COUNT 4u

typedef struct {
    uint8_t carCall;      /* bit n = someone inside pressed floor n     */
    uint8_t hallUp;       /* bit n = someone at floor n wants to go up  */
    uint8_t hallDown;     /* bit n = someone at floor n wants to go down*/
} Calls_t;
```

The whole algorithm is four helpers plus one decision:

```c
/* Any call strictly above the current floor, in any category? */
static uint8_t callsAbove(const Calls_t *c, uint8_t f)
{
    uint8_t mask = (uint8_t)(0xFFu << (f + 1u)) & FLOOR_MASK;
    return (uint8_t)((c->carCall | c->hallUp | c->hallDown) & mask);
}

/* Any call strictly below? */
static uint8_t callsBelow(const Calls_t *c, uint8_t f)
{
    uint8_t mask = (uint8_t)((1u << f) - 1u);
    return (uint8_t)((c->carCall | c->hallUp | c->hallDown) & mask);
}

/* Should we stop at floor f while travelling in direction d? */
static uint8_t shouldStop(const Calls_t *c, uint8_t f, Dir_t d)
{
    if (c->carCall & (1u << f))                   return 1;
    if (d == DIR_UP   && (c->hallUp   & (1u << f))) return 1;
    if (d == DIR_DOWN && (c->hallDown & (1u << f))) return 1;
    /* opposite-direction hall call: serve it only if it is the last call
       in this direction — this is the subtle part of LOOK */
    if (d == DIR_UP   && (c->hallDown & (1u << f)) && !callsAbove(c, f)) return 1;
    if (d == DIR_DOWN && (c->hallUp   & (1u << f)) && !callsBelow(c, f)) return 1;
    return 0;
}

Dir_t DSP_NextDirection(const Calls_t *c, uint8_t f, Dir_t current)
{
    if (current == DIR_UP)   { if (callsAbove(c, f)) return DIR_UP;
                               if (callsBelow(c, f)) return DIR_DOWN; }
    if (current == DIR_DOWN) { if (callsBelow(c, f)) return DIR_DOWN;
                               if (callsAbove(c, f)) return DIR_UP;   }
    if (callsAbove(c, f)) return DIR_UP;
    if (callsBelow(c, f)) return DIR_DOWN;
    return DIR_NONE;
}
```

**The subtle case is the opposite-direction hall call.** A car travelling up
does *not* stop for a down-call at floor 2 if someone is waiting at floor 3 — it
serves floor 3 first, then comes back down and picks up floor 2 in the correct
direction. Implementing that correctly is what separates a working elevator from
a plausible one, and TC-27 tests exactly this.

### 9.3 Three-device SPI arbitration

| Device | Select | Strobe semantics | Direction |
|--------|--------|------------------|-----------|
| 74HC165 (×2) | `PC2` **pulsed low** *before* clocking | Pulse, then clock 16 bits | Read only |
| 74HC595 | `PC3` **pulsed high** *after* clocking | Clock 8 bits, then pulse | Write only |

```c
typedef enum { SPI_BUTTONS = 0, SPI_DISPLAY }            SpiDev_t;

void SPI_Acquire(SpiDev_t d);   /* deassert all selects, then set up for d  */
void SPI_Release(void);         /* deassert, bus idle                       */
```

Rules:
1. `PB4` must be **high** whenever the 165 or the 595 is being clocked —
   otherwise the 595 sees stray clocks and shows a corrupted digit.
2. The 165's `PL` pulse must complete before the first `SCK` edge.
3. The 595's latch pulse must come after the eighth `SCK` edge.
4. A display refresh spans several ticks; button reading must wait, but never for
   more than two ticks (buttons at 20 Hz is the minimum acceptable rate).

### 9.4 The motion profile

```
   speed
     ▲
100% ┤        ┌──────────────────┐
     │       /                    \
 30% ┤      /                      \────┐   ← slowdown zone
 15% ┤     /                             \  ← creep zone
  0% ┼────┘                               \────────▶ position
     └──────────────────────────────────────
      start   accel    constant   slowdown  creep  level
```

| Zone | Distance from target | Duty | Purpose |
|------|---------------------|:----:|---------|
| Accelerate | first 40 cm from start | ramp 0 → 100 % over 1 s | Comfort |
| Constant | > 60 cm remaining | 100 % | Travel |
| Slowdown | 15 – 60 cm remaining | 30 % | Approach |
| Creep | 3 – 15 cm remaining | 15 % | Fine approach |
| Level | ≤ 3 cm | 0 %, brake | Stop |

Floors are at 0, 300, 600 and 900 cm. Levelling accuracy must be ±3 cm from
**both** directions — the asymmetry caused by gravity assisting a downward move
is the interesting part.

### 9.5 Module responsibilities

| Module | Owns | Public API (suggested) |
|--------|------|------------------------|
| `car_fsm` | Elevator state, sequencing | `FSM_Init`, `FSM_Run`, `FSM_GetState` |
| `dispatch` | Call bitmaps, LOOK decision | `DSP_AddCall`, `DSP_ClearFloor`, `DSP_NextDirection`, `DSP_ShouldStop` |
| `motion` | Speed profile, levelling | `MOT_GoTo`, `MOT_Step`, `MOT_AtTarget`, `MOT_Stop` |
| `door_fsm` | Door open/close/reverse, dwell | `DOR_Open`, `DOR_Close`, `DOR_Run`, `DOR_IsClosed` |
| `safety` | E-stop, overload, overtravel, current | `SAF_Evaluate`, `SAF_Active` |
| `calls165` | 16-bit button read + debounce + edges | `BTN_Scan`, `BTN_Pressed(n)` |
| `seg595` | Floor digit + direction | `SEG_Show(floor, dir)` |
| `position` | ADC → cm, floor detection | `POS_Cm`, `POS_NearestFloor`, `POS_InLevelZone` |
| `hoist` | **Only** writer of `OC1A` and hoist direction | `HST_SetDuty`, `HST_SetDir`, `HST_Brake` |
| `door` | **Only** writer of `OC1B` and door direction | `DRV_SetDuty`, `DRV_SetDir` |
| `faultlog` | Fixed 16-entry ring in RAM | `FLG_Append`, `FLG_Dump` |

### 9.6 Concurrency contract

- `ISR(INT0_vect)` — E-stop — clears `OCR1A`, `OCR1B` and all four direction
  pins, then sets a flag. Documented layer-rule exception.
- `ISR(INT1_vect)` — safety edge — sets a flag only; the door reversal is run by
  `door_fsm` on the next tick (≤ 10 ms, fast enough).
- Only `hoist.c` and `door.c` write their respective PWM and direction outputs.
- Call bitmaps are modified only by `dispatch.c`; `car_fsm` asks, it does not
  poke.

---

## 10. Data Dictionary (required data)

### 10.1 Runtime data — `DD-01 CarData_t`

```c
#define FLOOR_COUNT 4u
#define FLOOR_MASK  0x0Fu

typedef struct {
    uint16_t positionCm;      /* 0..1000                                 */
    uint8_t  currentFloor;    /* 0..3, nearest                           */
    uint8_t  targetFloor;     /* 0..3                                    */
    uint8_t  doorPct;         /* 0 = closed, 100 = open                  */
    uint16_t loadKg;          /* 0..1000                                 */
    uint16_t currentmA;       /* hoist current                           */
    Calls_t  calls;
    uint8_t  dir;             /* Dir_t, current travel direction         */
    uint8_t  lastDir;         /* for LOOK continuation                   */
    uint8_t  state;           /* CarState_t                              */
    uint8_t  doorState;       /* DoorState_t                             */
    uint8_t  hoistDuty;       /* 0..100 %                                */
    uint8_t  overload    : 1;
    uint8_t  fireService : 1;
    uint8_t  independent : 1;
    uint8_t  estop       : 1;
    uint8_t  obstruction : 1;
    uint8_t  levelled    : 1;
    uint8_t  reserved    : 2;
    uint8_t  activeFault;     /* Fault_t                                 */
    uint16_t doorDwellTicks;  /* countdown                               */
    uint32_t tripCount;       /* lifetime journeys                       */
    uint32_t doorCycles;      /* lifetime door cycles                    */
    uint32_t upTimeSec;
} CarData_t;
```

### 10.2 Runtime configuration — `DD-02 LiftCfg_t`

```c
#define LFT_MAGIC   0x4C46u      /* 'L','F'                              */
#define LFT_VERSION 0x01u

typedef struct {
    uint16_t magic;
    uint8_t  version;
    uint16_t floorCm[FLOOR_COUNT];  /* 0, 300, 600, 900 — calibratable   */
    uint8_t  levelToleranceCm;      /* ±3                                */
    uint8_t  creepZoneCm;           /* 15                                */
    uint8_t  slowZoneCm;            /* 60                                */
    uint8_t  creepDutyPct;          /* 15                                */
    uint8_t  slowDutyPct;           /* 30                                */
    uint8_t  fullDutyPct;           /* 100                               */
    uint16_t doorDwellSec;          /* 5                                 */
    uint16_t doorHoldSec;           /* 15, when Door-Open is held        */
    uint16_t doorTimeoutSec;        /* 10, travel limit                  */
    uint16_t ratedLoadKg;           /* 800                               */
    uint16_t overloadKg;            /* 900                               */
    uint16_t travelTimeoutSec;      /* 30, floor-to-floor limit          */
    uint16_t hoistOverCurrentmA;    /* 15000                             */
    uint8_t  homeFloor;             /* 0 (G) — parking floor             */
    uint8_t  fireFloor;             /* 0 (G) — recall floor              */
    uint16_t parkDelaySec;          /* 300, before homing                */
    uint32_t tripCount;
    uint32_t doorCycles;
    uint8_t  faultHead;
    uint8_t  checksum;
} LiftCfg_t;                        /* 52 bytes                          */
```

### 10.3 Enumerations — `DD-03`

```c
typedef enum { CS_INIT = 0, CS_HOMING, CS_IDLE, CS_DOOR_OPENING,
               CS_DOOR_OPEN, CS_DOOR_CLOSING, CS_STARTING,
               CS_MOVING, CS_SLOWING, CS_LEVELLING, CS_ARRIVED,
               CS_OVERLOAD, CS_FIRE_RECALL, CS_FIRE_HOLD,
               CS_FAULT, CS_ESTOP }                        CarState_t;

typedef enum { DS_CLOSED = 0, DS_OPENING, DS_OPEN, DS_CLOSING,
               DS_REVERSING, DS_JAMMED }                   DoorState_t;

typedef enum { DIR_NONE = 0, DIR_UP, DIR_DOWN }            Dir_t;

typedef enum { FLT_NONE = 0, FLT_ESTOP, FLT_OVERTRAVEL, FLT_TRAVEL_TIMEOUT,
               FLT_DOOR_TIMEOUT, FLT_OVERCURRENT, FLT_POSITION_SENSOR,
               FLT_LEVEL_FAIL, FLT_DOOR_JAM }              Fault_t;
```

### 10.4 Fault record — `DD-04 FaultRec_t`

```c
typedef struct {
    uint8_t  fault;
    uint32_t timeSec;
    uint16_t positionCm;
    uint8_t  floor;
    uint8_t  state;
    uint16_t loadKg;
    uint8_t  csum;
} FaultRec_t;                 /* 12 bytes                                */
```

### 10.5 Derived constants — `DD-05`

| Constant | Value | Meaning |
|----------|-------|---------|
| `PWM_TOP` | 799 | 10 kHz, 800 steps |
| `SHAFT_CM` | 1000 | Full travel |
| `POS_SCALE` | `(raw * 1000) / 1023` | ADC → cm |
| `LEVEL_TOL_CM` | 3 | Levelling window |
| `CREEP_CM` | 15 | Creep zone |
| `SLOW_CM` | 60 | Slowdown zone |
| `ACCEL_TICKS` | 100 | 1 s ramp to full duty |
| `DOOR_DWELL_TICKS` | 500 | 5 s open dwell |
| `DOOR_HOLD_TICKS` | 1500 | 15 s with Door-Open held |
| `DOOR_TIMEOUT_TICKS` | 1000 | 10 s door travel limit |
| `TRAVEL_TIMEOUT_TICKS` | 3000 | 30 s floor-to-floor limit |
| `REOPEN_TICKS` | 300 | 3 s re-dwell after an obstruction |
| `PARK_DELAY_TICKS` | 30000 | 300 s idle before homing |
| `BTN_SCAN_HZ` | 20 | 74HC165 read rate |
| `GONG_TICKS` | 50 | 500 ms arrival chime |

---

## 11. System Specifications

### 11.1 Shaft geometry

| Floor | Label | Position | Hall buttons |
|:-----:|:-----:|---------:|--------------|
| 0 | G | 0 cm | UP |
| 1 | 1 | 300 cm | UP, DOWN |
| 2 | 2 | 600 cm | UP, DOWN |
| 3 | 3 | 900 cm | DOWN |

The floor positions are **calibratable** (`floorCm[]`, set over the console) — a real
installation never has perfectly even floor spacing.

### 11.2 Motion

| Parameter | Value |
|-----------|-------|
| Travel range | 0 – 1000 cm (over-travel limits at −5 and 1005) |
| Full speed duty | 100 % |
| Slowdown duty | 30 % |
| Creep duty | 15 % |
| Levelling tolerance | ±3 cm, both directions |
| Acceleration ramp | 1 s to full duty |
| Floor-to-floor timeout | 30 s |

### 11.3 Door

| Parameter | Value |
|-----------|-------|
| Open / close travel time | 2 – 3 s |
| Dwell open (normal) | 5 s |
| Dwell extended (Door-Open held) | 15 s |
| Dwell after obstruction | 3 s |
| Door travel timeout | 10 s → `FLT_DOOR_TIMEOUT` |
| Consecutive reversals before jam | 3 → `DS_JAMMED` |

### 11.4 Load

| Band | Range | Behaviour |
|------|-------|-----------|
| Normal | 0 – 800 kg | Full service |
| Rated | 800 kg | Nominal |
| **Overload** | > 900 kg | Departure inhibited, door held open, buzzer |

The car **must not** move while overloaded, but it **must** allow the doors to
open so passengers can get out. An overload that traps people is a defect.

### 11.5 Safety precedence

| Rank | Condition | Effect |
|:----:|-----------|--------|
| 1 | **Emergency stop** | Hoist and door PWM to 0 within 1 ms, all direction pins low, latched |
| 2 | **Over-travel** | Position outside −5…1005 cm → immediate stop, latched fault |
| 3 | **Door open while moving** | Immediate stop, latched fault — this must never happen |
| 4 | **Fire service** | Cancel every call, recall to `fireFloor`, hold doors open |
| 5 | **Door safety edge** | Reverse the door, extend the dwell |
| 6 | **Overload** | Inhibit departure, hold the door open, sound the buzzer |
| 7 | Normal dispatch | LOOK |

You must be able to demonstrate that rank *n* wins over rank *n+1* for at least
three adjacent pairs.

---

## 12. Inputs & Outputs

### 12.1 Inputs

| ID | Name | Channel | Type | Sample rate |
|----|------|---------|------|-------------|
| IN-1 | Car position | ADC0 | Analog | 50 Hz |
| IN-2 | Car load | ADC1 | Analog | 5 Hz |
| IN-3 | Hoist current | ADC2 | Analog | 20 Hz |
| IN-4 | Door position | ADC3 | Analog | 20 Hz |
| IN-5 | 16 buttons | SPI + `PC2` | 74HC165 | 20 Hz |
| IN-6 | Emergency stop | `PD2`/INT0 | Digital, edge | Interrupt |
| IN-7 | Door safety edge | `PD3`/INT1 | Digital, edge | Interrupt |
| IN-8 | Fire service | `PD6` | Digital, polled | 10 Hz |
| IN-9 | Console | USART RX | ASCII line | Interrupt |

### 12.2 Outputs

| ID | Name | Pin | Type | Meaning |
|----|------|-----|------|---------|
| OUT-1 | Hoist PWM | `PD5`/OC1A | 10 kHz PWM | Speed |
| OUT-2 | Hoist direction | `PB0`, `PB1` | Digital | Up / down |
| OUT-3 | Door PWM | `PD4`/OC1B | 10 kHz PWM | Door speed |
| OUT-4 | Door direction | `PB2`, `PB3` | Digital | Open / close |
| OUT-5 | Floor display | SPI + `PC3` | 74HC595 → 7-seg | Current floor |
| OUT-6 | Direction arrows | `PC4`, `PC5` | Digital | Travel direction |
| OUT-7 | Overload LED | `PC7` | Digital | |
| OUT-8 | Gong / buzzer | `PD7`/OC2 | PWM tone | Arrival, overload, alarm |
| OUT-9 | LCD | I2C | 16×2 text | Service display |
| OUT-10 | Telemetry | USART TX | ASCII | 2 s frame + events |

---

## 13. Functional Requirements

### FR-01 — Button acquisition via 74HC165

The system **shall** read all sixteen buttons every **50 ms** through the
chained 74HC165 pair.

**Acceptance criteria**
- `PL` is pulsed low for ≥ 1 µs before the first `SCK` edge.
- Exactly 16 bits are clocked in; the mapping matches §7.
- Each input is debounced for 50 ms and produces one edge event per press.
- `PB4` (`SH/LD`) returns high immediately after sampling — verified on the scope.
- A button held down does not repeatedly re-register a call.

### FR-02 — Position measurement

The system **shall** sample ADC0 every **20 ms** and publish the car position in
centimetres.

**Acceptance criteria**
- `positionCm = raw × 1000 / 1023` with a `uint32_t` intermediate.
- Median-of-3 filtered; resolution ≤ 1 cm.
- `currentFloor` is the nearest floor from `floorCm[]`.
- ADC0 pinned at 0 or 1023 for 2 s raises `FLT_POSITION_SENSOR` and stops the
  car — a broken position sensor must never let the car keep moving.

### FR-03 — Call registration

Pressing any car or hall button **shall** set the corresponding bit in the
matching bitmap.

**Acceptance criteria**
- A car call for the current floor with the door closed opens the door instead
  of registering.
- A hall call at the current floor in the current direction opens the door.
- Duplicate presses do not stack or clear.
- Registering a call is refused in fire service and while in `CS_ESTOP`.
- The `CALLS?` command reports all three bitmaps in hex.

### FR-04 — LOOK dispatch

The next direction and each stop decision **shall** follow the LOOK algorithm of
§9.2.

**Acceptance criteria**
- Travelling up, the car serves every up-call and car-call above it before
  reversing.
- Travelling up, it **does not** stop for a down-call at an intermediate floor
  when a call exists above it.
- Travelling up with no calls above, it **does** serve a down-call at the
  highest called floor and then reverses.
- With no calls, direction becomes `DIR_NONE` and the car is idle.
- The scripted sequence of TC-27 produces exactly the documented stop order.

### FR-05 — Trapezoidal motion profile

The hoist **shall** follow the profile of §9.4.

**Acceptance criteria**
- Duty ramps 0 → full over 1 s at departure; no step change.
- Duty drops to `slowDutyPct` at `slowZoneCm` from the target.
- Duty drops to `creepDutyPct` at `creepZoneCm`.
- Duty is 0 and the brake applied within `levelToleranceCm`.
- The transitions are computed from the *remaining distance*, not from elapsed
  time — a time-based profile fails as soon as the load changes.

### FR-06 — Levelling accuracy

The car **shall** stop within **±3 cm** of the target floor position from both
directions.

**Acceptance criteria**
- Ten arrivals from above and ten from below, all within ±3 cm.
- If the car overshoots the window, it re-levels at creep speed in the opposite
  direction — but no more than **twice**, after which `FLT_LEVEL_FAIL` is raised.
- The final position is reported in the arrival event.

### FR-07 — Door sequence

On arrival the door **shall** open, dwell, and close automatically.

**Acceptance criteria**
- Open and close are driven by `OC1B` with direction pins, never by a bare GPIO
  toggle.
- Dwell is `doorDwellSec` (5 s), extended to `doorHoldSec` (15 s) while the
  Door-Open button is held.
- The Door-Close button ends the dwell early.
- `doorCycles` increments per full cycle.
- **The car cannot move until `doorPct == 0`.** Verified in TC-33.

### FR-08 — Door obstruction reversal

An obstruction detected on `INT1` while closing **shall** reverse the door to
fully open.

**Acceptance criteria**
- Reversal begins within 20 ms of the edge.
- The dwell restarts at `REOPEN_TICKS` (3 s).
- **The close command can never win over the safety edge** — this is the single
  most important door requirement.
- Three consecutive reversals put the door in `DS_JAMMED`: door held open, gong
  pattern, `FLT_DOOR_JAM` logged, car out of service until acknowledged.

### FR-09 — Door travel timeout

A door that does not reach its commanded end position within `doorTimeoutSec`
(10 s) **shall** raise `FLT_DOOR_TIMEOUT`.

**Acceptance criteria**
- The door motor stops; the door is driven open as the fail-safe.
- The car does not depart.
- The fault is latched and logged.

### FR-10 — Overload inhibition

A load above `overloadKg` (900 kg) **shall** prevent departure.

**Acceptance criteria**
- The car does **not** move; the door is held open; the overload LED lights; the
  buzzer sounds an intermittent tone.
- The LCD shows `OVERLOAD 940kg`.
- Existing calls are **retained**, not cancelled.
- Reducing the load below 850 kg (hysteresis) resumes normal service within 1 s.
- Overload never prevents the door from opening.

### FR-11 — Emergency stop

A rising edge on `INT0` **shall** stop everything within **1 ms**.

**Acceptance criteria**
- The ISR sets `OCR1A = 0`, `OCR1B = 0`, clears `PB0`…`PB3`, sets a flag.
- Measured edge-to-PWM-low ≤ 1 ms.
- Opening the E-stop wire trips identically to pressing the button (NC design).
- `CS_ESTOP` is latched; recovery requires the contact closed **and** an
  explicit reset.
- All calls are cancelled on E-stop.

### FR-12 — Over-travel protection

A position outside −5 … 1005 cm **shall** raise `FLT_OVERTRAVEL`.

**Acceptance criteria**
- The hoist stops immediately.
- The fault is latched with the position snapshot.
- Recovery requires an acknowledgement and a manual `HOME` command.

### FR-13 — Travel timeout

Failing to reach the target within `travelTimeoutSec` (30 s) **shall** raise
`FLT_TRAVEL_TIMEOUT`.

**Acceptance criteria**
- Catches a jammed car, a slipping rope or a failed motor.
- The hoist stops; the fault latches; the door is **not** opened between floors.

### FR-14 — Hoist over-current

Hoist current above `hoistOverCurrentmA` (15.0 A) for 500 ms **shall** raise
`FLT_OVERCURRENT`.

**Acceptance criteria**
- A 200 ms inrush spike at departure does **not** trip.
- A sustained overload trips within 600 ms.

### FR-15 — Door-open-while-moving interlock

If `doorPct > 5` while the hoist duty is non-zero, the system **shall** stop
immediately and latch a fault.

**Acceptance criteria**
- Checked every 10 ms.
- This condition should be unreachable by design — the requirement exists as a
  belt-and-braces check. Your report must explain why a defensive check for an
  "impossible" state is good practice in safety software.

### FR-16 — Fire service recall

Closing the fire-service switch **shall** cancel every call and recall the car
to `fireFloor`.

**Acceptance criteria**
- All three call bitmaps are cleared immediately.
- The car finishes levelling at the nearest floor if moving away, then travels
  to the fire floor.
- On arrival the door opens and is **held open** indefinitely.
- No hall or car call is accepted while fire service is active.
- The LCD shows `FIRE SERVICE`; `!EVT,FIRE,RECALL` is logged.
- Fire service outranks overload and the normal dispatch, but **not** the
  emergency stop.

### FR-17 — Automatic parking

After `parkDelaySec` (300 s) idle away from the home floor, the car **shall**
return to `homeFloor`.

**Acceptance criteria**
- The timer resets on any call.
- Parking is abandoned instantly if a call arrives mid-journey — the new call is
  served first.
- Parking is disabled in fire service and while faulted.

### FR-18 — Floor display and arrival gong

The 74HC595 **shall** show the current floor; the arrows **shall** show travel
direction; a gong **shall** sound on arrival.

**Acceptance criteria**
- The display refreshes every 100 ms with no flicker.
- The digit shows the floor being *approached* once past the slowdown point, not
  the floor left behind.
- The gong is one tone on an up-arrival, two on a down-arrival (a real
  convention).
- `PB4` is high while the 595 is clocked.

### FR-19 — LCD service display

The LCD **shall** refresh every **250 ms**:

```
Line 1: FL2 ^  P:612cm
Line 2: LD:420 D:0 MOV
```

**Acceptance criteria**
- Second page (console `PAGE 1`) shows call bitmaps, trip count and door cycles.
- Faults replace line 2 with `!FLT DOOR TIMEOUT` alternating every 1.5 s.
- Only changed characters are rewritten.

### FR-20 — Statistics and fault log

The system **shall** maintain trip count, door cycles and a 16-entry fault ring in RAM.

**Acceptance criteria**
- Counters written every 10 trips or every 5 min, whichever comes first.
- Fault records are written immediately on the fault.
- `TRIPS?` and `FAULTS?` dump them.
- All are readable over the console at any time.

### FR-21 — Telemetry and console

The system **shall** transmit the frame of §18.1 every **2 s** and accept the
commands of §18.2.

**Acceptance criteria**
- `CALL <floor> <UP|DOWN|CAR>` injects a call, so the whole test plan can be
  scripted from the terminal.
- No command can move the car with the doors open or bypass a latched fault.
- Parser robustness per the book standard.

---

## 14. Non-Functional Requirements

| ID | Requirement |
|----|-------------|
| **NFR-01** | Compiles with `avr-gcc -std=c99 -Wall -Wextra -Os`, zero warnings. |
| **NFR-02** | No blocking delay > 10 ms in the super-loop; `_delay_ms` only in `*_Init()`. |
| **NFR-03** | The car cannot move unless `doorPct == 0` — enforced in `hoist.c` itself, not only in the FSM. |
| **NFR-04** | The safety edge always wins over any close command, in every code path. |
| **NFR-05** | Safety precedence follows §11.5 exactly. |
| **NFR-06** | E-stop path from edge to both PWM outputs low ≤ 1 ms, independent of the scheduler. |
| **NFR-07** | The LOOK decision is bitmap arithmetic; a chain of per-floor `if`s is not accepted. |
| **NFR-08** | Three SPI devices are never selected simultaneously; `PB4` is high whenever the 165 or 595 is clocked. |
| **NFR-09** | No floating-point arithmetic. |
| **NFR-10** | Layer rule respected, with the documented `INT0` exception. |
| **NFR-11** | Only `hoist.c` writes `OC1A`/hoist direction; only `door.c` writes `OC1B`/door direction. |
| **NFR-12** | ISRs ≤ 10 lines. |
| **NFR-13** | Tick jitter ≤ ±1 ms; CPU load ≤ 60 %, measured on `PC6`. |
| **NFR-14** | `.data + .bss` ≤ 1 KB. |
| **NFR-15** | On any reset both motors are stopped **before** any other initialisation; the car homes only after position is validated. |
| **NFR-16** | Every wait state has a timeout. No state may block indefinitely on a sensor. |
| **NFR-17** | **No dynamic memory.** `malloc`, `calloc`, `realloc`, `free`, `alloca` and variable-length arrays are banned. Every buffer, table, queue and log is a fixed-size array whose length is a `#define` in `config.h`. Prove it: `avr-nm main.elf \| grep -i malloc` must print nothing. |
| **NFR-18** | **No recursion.** No function may call itself, directly or through any chain of calls — the call graph must be acyclic. Every search, scan, parse and traversal is written as a loop. State your worst-case stack depth in the report. |

---

## 15. Operating Modes

| State | Hoist | Door | Calls accepted | Display |
|-------|-------|------|:--------------:|---------|
| `CS_INIT` | Stopped | Closed | No | `--` |
| `CS_HOMING` | Creep to nearest floor | Closed | No | Blinking |
| `CS_IDLE` | Stopped | Closed | Yes | Floor |
| `CS_DOOR_*` | Stopped | Moving / open | Yes | Floor |
| `CS_STARTING` | Ramping | Closed | Yes | Floor |
| `CS_MOVING` | Full | Closed | Yes | Approaching floor |
| `CS_SLOWING` | Slow / creep | Closed | Yes | Target floor |
| `CS_LEVELLING` | Creep | Closed | Yes | Target floor |
| `CS_ARRIVED` | Stopped | Opening | Yes | Floor + gong |
| `CS_OVERLOAD` | **Inhibited** | Held open | Yes (retained) | Floor + `OVL` |
| `CS_FIRE_RECALL` | Travelling to fire floor | Closed | **No** | `F` |
| `CS_FIRE_HOLD` | Stopped | **Held open** | No | `F` |
| `CS_FAULT` | Stopped | Held open | No | `E` + code |
| `CS_ESTOP` | Stopped | Frozen | No | `--` |

---

## 16. System Flow

```
   ┌──────────────┐
   │  Power ON    │
   └──────┬───────┘
          ▼
   ┌─────────────────────────────────────────┐
   │ FIRST: OCR1A = OCR1B = 0, PB0..PB3 = 0  │  ← before anything else
   └──────┬──────────────────────────────────┘
          ▼
   ┌─────────────────────────────────────────┐
   │ MCAL init: ADC, T0, T1 PWM, T2, EXTI    │
   │ (INT0 armed first), USART, SPI, I2C     │
   │ Clear the 595; read the 165 once        │
   └──────┬──────────────────────────────────┘
          ▼
   ┌─────────────────────────────────────────┐  invalid ┌────────────┐
   │ Load LiftCfg_t, verify checksum         ├─────────▶│ Defaults + │
   └──────┬──────────────────────────────────┘          │ log        │
          │ valid                                       └─────┬──────┘
          ▼◀──────────────────────────────────────────────────┘
   ┌─────────────────────────────────────────┐
   │ E-stop closed?  no → CS_ESTOP           │
   │ Position valid? no → CS_FAULT           │
   │ In a level zone? no → CS_HOMING (creep) │
   │ else → CS_IDLE                          │
   └──────┬──────────────────────────────────┘
          ▼
╔═════════════════════════════════════════════════════════════╗
║              SUPER-LOOP (dispatch on 10 ms tick)            ║
║                                                             ║
║   10 ms → SAF_Evaluate(), car FSM, door FSM                 ║
║   20 ms → position ADC, door position ADC                   ║
║   20 ms → motion profile step → hoist duty                  ║
║   50 ms → 74HC165 button read + debounce + call registration║
║   50 ms → hoist current                                     ║
║  100 ms → 74HC595 floor display + arrows                    ║
║  200 ms → load cell, overload check                         ║
║  250 ms → LCD repaint                                       ║
║    1 s  → park timer, statistics, fire-switch poll          ║
║    2 s  → telemetry frame                                   ║
║  event  → fault log append, floor display refresh          ║
╚═════════════════════════════════════════════════════════════╝
```

**Ordering:** `SAF_Evaluate()` runs first in every tick. The motion step runs
*after* the FSM so a state change takes effect in the same cycle.

---

## 17. State Machine

### 17.1 Car FSM

```
                    ┌───────────┐
        power on    │  CS_INIT  │  motors stopped
       ────────────▶│           │
                    └─────┬─────┘
              not levelled│         levelled
                    ┌─────▼──────┐        │
                    │ CS_HOMING  │        │
                    └─────┬──────┘        │
                          └───────┬───────┘
                                  ▼
        ┌──────────────────────────────────────────────┐
   ┌───▶│                  CS_IDLE                     │
   │    └───────┬──────────────────────────┬───────────┘
   │            │ call at this floor       │ call elsewhere
   │            ▼                          ▼
   │   ┌─────────────────┐        ┌────────────────┐
   │   │ CS_DOOR_OPENING │        │  CS_STARTING   │ ramp
   │   └────────┬────────┘        └───────┬────────┘
   │            ▼                         ▼
   │   ┌─────────────────┐        ┌────────────────┐
   │   │  CS_DOOR_OPEN   │        │   CS_MOVING    │ full speed
   │   │  dwell 5 s      │        └───────┬────────┘
   │   └────────┬────────┘     60 cm to go│
   │            ▼                         ▼
   │   ┌─────────────────┐        ┌────────────────┐
   │   │ CS_DOOR_CLOSING │        │  CS_SLOWING    │ 30 % → 15 %
   │   └────────┬────────┘        └───────┬────────┘
   │            │                 3 cm    ▼
   │            │                 ┌────────────────┐
   │            │                 │ CS_LEVELLING   │
   │            │                 └───────┬────────┘
   │            │                         ▼
   │            │                 ┌────────────────┐
   │            │                 │  CS_ARRIVED    │ gong
   │            │                 └───────┬────────┘
   │            │                         └──▶ CS_DOOR_OPENING
   │            ▼
   └────────────┘ (door closed → next LOOK decision)

   Overrides, from ANY state:
     INT0 rising            ──▶ CS_ESTOP        (rank 1, latched)
     over-travel / fault    ──▶ CS_FAULT        (rank 2/3, latched)
     fire switch closed     ──▶ CS_FIRE_RECALL  (rank 4)
     load > overloadKg      ──▶ CS_OVERLOAD     (rank 6, at a floor only)
```

### 17.2 Door FSM

```
        ┌────────────┐  open cmd   ┌─────────────┐
        │ DS_CLOSED  ├────────────▶│ DS_OPENING  │
        └─────▲──────┘             └──────┬──────┘
              │                      100 %│
              │ 0 %                       ▼
        ┌─────┴──────┐             ┌─────────────┐
        │ DS_CLOSING │◀────────────┤  DS_OPEN    │ dwell
        └─────┬──────┘  dwell over └─────────────┘
              │                           ▲
    safety    │                           │ fully open
    edge      ▼                           │
        ┌──────────────┐                  │
        │ DS_REVERSING ├──────────────────┘
        └──────┬───────┘
               │ 3rd consecutive reversal
               ▼
        ┌──────────────┐
        │  DS_JAMMED   │  held open, out of service
        └──────────────┘
```

### 17.3 Car transition table

| # | From | Event / guard | To | Actions |
|---|------|---------------|----|---------|
| T1 | `CS_INIT` | E-stop closed ∧ position valid ∧ levelled | `CS_IDLE` | Log `!EVT,BOOT` |
| T2 | `CS_INIT` | Not levelled | `CS_HOMING` | Creep down to the nearest floor |
| T3 | `CS_HOMING` | In a level zone | `CS_IDLE` | Stop, brake |
| T4 | `CS_IDLE` | Call at the current floor | `CS_DOOR_OPENING` | Clear that call bit |
| T5 | `CS_IDLE` | `DSP_NextDirection() != NONE` | `CS_STARTING` | Set direction, `tripCount++` |
| T6 | `CS_STARTING` | Ramp complete (1 s) | `CS_MOVING` | Full duty |
| T7 | `CS_MOVING` | Remaining ≤ `slowZoneCm` ∧ `shouldStop()` | `CS_SLOWING` | Duty → 30 % |
| T8 | `CS_MOVING` | Passing a floor with no stop needed | `CS_MOVING` | Update the display only |
| T9 | `CS_SLOWING` | Remaining ≤ `creepZoneCm` | `CS_SLOWING` | Duty → 15 % |
| T10 | `CS_SLOWING` | Remaining ≤ `levelToleranceCm` | `CS_LEVELLING` | Duty 0, brake |
| T11 | `CS_LEVELLING` | Settled within tolerance | `CS_ARRIVED` | Gong, clear call bits for this floor |
| T12 | `CS_LEVELLING` | Outside tolerance, ≤ 2 corrections | `CS_LEVELLING` | Creep the other way |
| T13 | `CS_LEVELLING` | 3rd correction needed | `CS_FAULT` | `FLT_LEVEL_FAIL` |
| T14 | `CS_ARRIVED` | Entry | `CS_DOOR_OPENING` | Command the door open |
| T15 | `CS_DOOR_OPEN` | Dwell expired ∧ no Door-Open held | `CS_DOOR_CLOSING` | |
| T16 | `CS_DOOR_CLOSING` | `doorPct == 0` | `CS_IDLE` | Next LOOK decision |
| T17 | any moving state | Travel timer > `travelTimeoutSec` | `CS_FAULT` | `FLT_TRAVEL_TIMEOUT` |
| T18 | any | Position outside limits | `CS_FAULT` | `FLT_OVERTRAVEL` |
| T19 | any moving state | `doorPct > 5` | `CS_FAULT` | Immediate stop, `FLT_DOOR_JAM` class |
| T20 | any | `INT0` rising | `CS_ESTOP` | ISR stop, cancel all calls, latch |
| T21 | `CS_ESTOP` | Contact closed ∧ reset | `CS_INIT` | Re-home |
| T22 | any | Fire switch closed | `CS_FIRE_RECALL` | Clear all calls, target `fireFloor` |
| T23 | `CS_FIRE_RECALL` | Arrived at the fire floor | `CS_FIRE_HOLD` | Door open, held |
| T24 | `CS_FIRE_HOLD` | Fire switch opened | `CS_IDLE` | Resume normal service |
| T25 | `CS_IDLE` ∨ `CS_DOOR_OPEN` | Load > `overloadKg` | `CS_OVERLOAD` | Inhibit departure, hold door, buzzer |
| T26 | `CS_OVERLOAD` | Load < 850 kg | previous state | Resume, calls retained |
| T27 | `CS_IDLE` | Idle > `parkDelaySec` ∧ not at home | `CS_STARTING` | Target `homeFloor` |
| T28 | `CS_FAULT` | Acknowledged ∧ cause cleared | `CS_INIT` | Re-home |

---

## 18. UART Protocol

**Link:** 9600 8N1. Device sends `\r\n`; accepts `\r`, `\n`, `\r\n`.

### 18.1 Telemetry frame (every **2 s**)

```
$EL,F=2,P=612,D=UP,DR=0,LD=420,I=6200,CC=4,HU=8,HD=2,ST=MOV,FT=0,TR=1204,DC=2408,UP=7200*3F
```

| Field | Meaning |
|-------|---------|
| `F` | Current floor 0 – 3 |
| `P` | Position in cm |
| `D` | Direction `UP` \| `DN` \| `--` |
| `DR` | Door open percentage |
| `LD` | Load kg |
| `I` | Hoist current mA |
| `CC` / `HU` / `HD` | Car-call / hall-up / hall-down bitmaps, hex |
| `ST` | State name |
| `FT` | Active fault code |
| `TR` / `DC` | Lifetime trips / door cycles |
| `UP` | Uptime s |
| `*3F` | XOR checksum between `$` and `*` |

### 18.2 Command set

| Command | Response | Effect |
|---------|----------|--------|
| `STATUS` | telemetry frame | Immediate report |
| `CALL <f> CAR` | `OK` / `ERR ARG` | Inject a car call |
| `CALL <f> UP` | `OK` / `ERR ARG` | Inject a hall up-call |
| `CALL <f> DOWN` | `OK` / `ERR ARG` | Inject a hall down-call |
| `CALLS?` | `CC=4,HU=8,HD=2` | All three bitmaps |
| `CANCEL` | `OK` | Clear every call |
| `POS?` | `POS=612,F=2` | |
| `DOOR OPEN` / `DOOR CLOSE` | `OK` / `ERR MODE` | Only at a floor, doors permitted |
| `HOME` | `OK` | Send the car to `homeFloor` |
| `FIRE ON` / `FIRE OFF` | `OK` | Software fire-service (for testing) |
| `CFG?` | `CFG=0,300,600,900,3,15,60,15,30,100,5,15,10,800,900,30` | All parameters |
| `SET FLOOR <n> <cm>` | `OK` / `ERR RANGE` | Calibrate a floor position |
| `SET LEVELTOL <n>` | `OK` / `ERR RANGE` | 1 – 10 cm |
| `SET SLOWZONE <n>` | `OK` / `ERR RANGE` | 20 – 150 cm |
| `SET CREEPZONE <n>` | `OK` / `ERR RANGE` | 5 – 40 cm, < `SLOWZONE` |
| `SET DWELL <n>` | `OK` / `ERR RANGE` | 2 – 30 s |
| `SET OVERLOAD <n>` | `OK` / `ERR RANGE` | 200 – 2000 kg |
| `SET PARKDELAY <n>` | `OK` / `ERR RANGE` | 0 – 3600 s, 0 disables |
| `ACK` | `OK` / `ERR ACTIVE` | Acknowledge the latched fault |
| `FAULT?` | `FAULT=4,DOOR_TIMEOUT` | |
| `FAULTS?` | 16 log lines | |
| `TRIPS?` | `TRIPS=1204,DC=2408` | |
| `PAGE <0-1>` | `OK` | LCD page |
| `HELP` | command list | |

### 18.3 Asynchronous events

```
!EVT,BOOT
!EVT,CALL,CAR,2
!EVT,CALL,HALL,1,UP
!EVT,DEPART,0,UP
!EVT,PASS,1,UP
!EVT,ARRIVE,2,P=601
!EVT,DOOR,OPEN
!EVT,DOOR,OBSTRUCT,1
!EVT,DOOR,JAM
!EVT,DOOR,CLOSED
!EVT,LOOK,REVERSE,DOWN
!EVT,OVERLOAD,940
!EVT,OVERLOAD,CLR
!EVT,FIRE,RECALL
!EVT,FIRE,HOLD,0
!EVT,ESTOP,OPEN
!EVT,FAULT,TRAVEL_TIMEOUT,P=450
!EVT,PARK,HOME
!EVT,ACK,OK
```

---

## 19. Task Scheduling

| ID | Task | Period | Offset | Budget | Work |
|----|------|:------:|:------:|:------:|------|
| T-1 | `Task_Safety` | 10 ms | 0 | 250 µs | `SAF_Evaluate` — **runs first** |
| T-2 | `Task_CarFSM` | 10 ms | 0 | 300 µs | Car `switch` |
| T-3 | `Task_DoorFSM` | 10 ms | 0 | 200 µs | Door `switch` |
| T-4 | `Task_Position` | 20 ms | 1 | 500 µs | ADC0 + ADC3, filtering |
| T-5 | `Task_Motion` | 20 ms | 1 | 300 µs | Profile step → `hoist` |
| T-6 | `Task_Buttons` | 50 ms | 2 | 600 µs | 74HC165 read + debounce + calls |
| T-7 | `Task_Current` | 50 ms | 4 | 250 µs | ADC2 + over-current |
| T-8 | `Task_Display` | 100 ms | 3 | 400 µs | 74HC595 + arrows |
| T-9 | `Task_Load` | 200 ms | 5 | 250 µs | ADC1 + overload |
| T-10 | `Task_LCD` | 250 ms | 6 | 4 ms | Repaint |
| T-11 | `Task_1Hz` | 1 s | 7 | 500 µs | Park timer, fire switch, statistics |
| T-12 | `Task_Report` | 2 s | 8 | 2 ms | Telemetry frame |
| T-13 | `Task_Console` | 20 ms | 9 | 500 µs | Parse one line |

**SPI contention:** T-6 (165) and T-8 (595) both want the bus.
T-14 owns it for the duration of a multi-step write; T-6 and T-8 skip at most
one cycle. Show that a skipped button read still meets the 20 Hz minimum.

---

## 20. Testing Requirements

Scripted call sequences via the `CALL` command make this plan repeatable.

| ID | Test | Method | Pass criterion |
|----|------|--------|----------------|
| TC-01 | Safe state on reset | Reset while moving | Both PWM 0, all direction pins low ≤ 1 ms |
| TC-02 | Cold boot | Power on | Defaults, no crash |
| TC-03 | Live config change | `SET DWELL 8`, call the car | Door holds for the new dwell |
| TC-04 | Corrupted config | Flip a byte | Defaults loaded |
| TC-05 | Homing | Start the car between floors | Creeps to the nearest floor, `CS_IDLE` |
| TC-06 | Position scaling | Pot at 0 / 50 / 100 % | 0, 500 ±5, 1000 cm |
| TC-07 | Position sensor fault | Pin ADC0 at 1023 for 3 s | `FLT_POSITION_SENSOR`, car stops |
| TC-08 | **165 read** | Press each of the 12 buttons | Correct bit, correct mapping |
| TC-09 | 165 load pulse | Scope `PC2` vs `SCK` | `PL` low ≥ 1 µs before the first clock |
| TC-10 | **Display not disturbed** | Scope `RCLK` during a button read | No latch edge during the read |
| TC-11 | 595 latch | Scope `PC3` vs `SCK` | Latch after the 8th clock |
| TC-12 | **Two-device isolation** | Force a button read and a display update to collide | No corruption on either device |
| TC-13 | Button debounce | Chatter a button 20 ms | No call registered |
| TC-14 | Duplicate press | Press a car call 5× | One call bit, no stacking |
| TC-15 | Same-floor call | At floor 1, press car-call 1 | Door opens, no journey |
| TC-16 | PWM frequency | Scope `PD5` | 10 kHz ±1 % |
| TC-17 | Departure ramp | Depart from G | Duty ramps 0 → 100 % over 1 s |
| TC-18 | Slowdown point | Travel G → 3 | Duty drops to 30 % at 60 cm remaining |
| TC-19 | Creep point | Same journey | Duty drops to 15 % at 15 cm remaining |
| TC-20 | **Levelling from above** | 10 arrivals descending | All within ±3 cm |
| TC-21 | **Levelling from below** | 10 arrivals ascending | All within ±3 cm |
| TC-22 | Re-levelling | Force a 5 cm overshoot | Corrects at creep speed |
| TC-23 | Level fail | Force repeated overshoot | `FLT_LEVEL_FAIL` after 2 corrections |
| TC-24 | **LOOK — up sweep** | At G, call CAR 1, CAR 3, CAR 2 | Stops in order 1, 2, 3 |
| TC-25 | **LOOK — reversal** | At 3, call CAR 0, then CAR 2 | Stops 2 then 0 |
| TC-26 | **LOOK — skips opposite call** | Going up from G, hall-DOWN 2 and CAR 3 | Passes 2, serves 3, then returns for 2 |
| TC-27 | **LOOK — last-call exception** | Going up from G, only hall-DOWN 2 | Serves 2 (it is the last call ahead) |
| TC-28 | LOOK — idle | Clear all calls | Direction becomes `--`, car idle |
| TC-29 | Bitmap implementation | Code inspection | Bitmask arithmetic, not per-floor `if` chains |
| TC-30 | Door open / close | Arrive at a floor | Opens, dwells 5 s, closes |
| TC-31 | Door hold | Hold Door-Open | Dwell extends to 15 s |
| TC-32 | Door close early | Press Door-Close during the dwell | Closes immediately |
| TC-33 | **No move with door open** | Force a call while the door is 50 % open | Car does not move until `doorPct == 0` |
| TC-34 | **Obstruction reversal** | Trigger `INT1` while closing | Reverses within 20 ms, re-dwells 3 s |
| TC-35 | **Safety edge always wins** | Hold Door-Close and trigger the edge | Door reverses |
| TC-36 | Door jam | Obstruct 3 consecutive closes | `DS_JAMMED`, out of service, logged |
| TC-37 | Door timeout | Block the door mid-travel for 12 s | `FLT_DOOR_TIMEOUT`, door driven open |
| TC-38 | **Overload inhibit** | Load 950 kg, call another floor | Car does not move, door held open, buzzer |
| TC-39 | Overload retains calls | Clear the overload | Pending calls are still served |
| TC-40 | Overload allows exit | Overloaded at a floor | Door still opens |
| TC-41 | Overload hysteresis | Reduce to 870 kg | Still inhibited; clears below 850 |
| TC-42 | **E-stop latency** | Scope `PD2` edge vs both PWM pins | ≤ 1 ms |
| TC-43 | **E-stop broken wire** | Disconnect the E-stop wire | Trips identically |
| TC-44 | E-stop cancels calls | Register calls, then E-stop | All bitmaps cleared |
| TC-45 | E-stop recovery | Close the contact, reset | Re-homes, then `CS_IDLE` |
| TC-46 | Over-travel | Drive the position pot past 1005 cm | `FLT_OVERTRAVEL`, immediate stop |
| TC-47 | Travel timeout | Freeze the position pot mid-journey | `FLT_TRAVEL_TIMEOUT` at 30 s |
| TC-48 | Hoist inrush | 16 A for 200 ms at departure | **No** trip |
| TC-49 | Hoist over-current | 16 A for 1 s | `FLT_OVERCURRENT` within 600 ms |
| TC-50 | **Fire recall** | Close the fire switch while at floor 3 | All calls cleared, travels to G, door held open |
| TC-51 | Fire ignores calls | Press buttons during fire service | No call registered |
| TC-52 | Fire vs. overload | Overloaded, then fire service | Fire wins; the car recalls |
| TC-53 | E-stop vs. fire | Fire active, then E-stop | E-stop wins |
| TC-54 | Fire exit | Open the fire switch | Normal service resumes |
| TC-55 | Auto-park | `SET PARKDELAY 20`, idle at floor 3 | Returns to G after 20 s |
| TC-56 | Park abandoned | Call floor 2 mid-park journey | Serves 2 first |
| TC-57 | Arrival gong | Arrive up, then down | One tone then two |
| TC-58 | Display approach floor | Travel G → 3 | Digit shows the approaching floor past the slowdown point |
| TC-59 | Display flicker | Watch 60 s | None |
| TC-60 | Statistics | 12 trips, `TRIPS?` | Count correct |
| TC-61 | Fault log | Cause 4 faults, `FAULTS?` | 4 records with snapshots |
| TC-62 | Fault latch | Fault, then clear the cause | Stays in `CS_FAULT` until acknowledged |
| TC-63 | Telemetry cadence | Capture 60 s | 30 frames ±1, checksums valid |
| TC-64 | Console robustness | `FOO`, 40 chars, `CALL 9 UP` | `ERR CMD`, `ERR LONG`, `ERR ARG` |
| TC-65 | LCD flicker | Watch 60 s | None |
| TC-66 | Tick jitter | Scope tick pin | 10 ms ±1 ms |
| TC-67 | CPU load | `PC6` duty | ≤ 60 % |
| TC-68 | RAM budget | `avr-size -C` | ≤ 1024 B |
| TC-69 | **Soak** | 20 min of random scripted calls, obstructions and load changes | No hang, no missed call, car always level on arrival |
| TC-70 | **No heap linked** | `avr-nm main.elf \| grep -i malloc` | Prints nothing |
| TC-71 | **No recursion** | Inspect the call graph; state the deepest chain | Acyclic, depth stated in the report |

---

## 21. Bonus Features

Maximum **+20**; final score capped at 100.

| # | Feature | Marks | Requirement |
|---|---------|:-----:|-------------|
| B1 | Two-car group control | +20 | Two `Car_t` instances share a hall-call pool; the nearer suitable car answers, with the assignment rule documented |
| B2 | LOOK vs FCFS comparison | +10 | Implement both, run the same 20-call script, report total journey time and mean wait for each |
| B3 | Independent service | +10 | Bit 7 of the 165 puts the car under car-call-only control with manual door close |
| B4 | Energy-aware parking | +10 | Park at the statistically busiest floor rather than G, derived from a per-floor call histogram held in RAM since boot |
| B5 | True cooperative scheduler | +15 | Task table with period/offset/order guarantees and SPI arbitration, overrun counter over UART |
| B6 | Watchdog recovery | +10 | WDT 250 ms; motors safe, fault latch preserved, `MCUCSR` logged |
| B7 | Scrolling LCD messages | +10 | Announce `GOING UP` / floor names as scrolling text without blocking |
| B8 | Load-based dispatch | +10 | A car above `ratedLoadKg` stops accepting new hall calls until it lightens |

---

## 22. Deliverables

| # | Item | Detail |
|---|------|--------|
| 1 | Source code | Layered per §9.1; single writers for hoist and door |
| 2 | `Simulation/elevator.sim1` | Runs unmodified; position, load and door pots adjustable |
| 3 | `Docs/dispatch_algorithm.md` | LOOK stated precisely, the opposite-call exception explained, worked traces for TC-24…28 |
| 4 | `Docs/safety_precedence.md` | The §11.5 table with a justification per rank and the three demonstrated pairs |
| 5 | `Docs/flowchart.png` | Matches §16 |
| 6 | `Docs/state_machine.png` | **Both** FSMs of §17 with transition tables |
| 7 | `Docs/test_report.md` | All 71 `TC` rows with evidence |
| 8 | Final report | 15 – 20 pages incl. motion-profile derivation and SPI arbitration design |
| 9 | Demo video | 5 – 10 min: LOOK sweep with the opposite-call case, levelling from both directions, door reversal, overload, fire recall, E-stop |
| 10 | Live defence | Any member, any file |

---

## 23. Evaluation Rubric

| Item | Marks | Full-mark criteria |
|------|:-----:|--------------------|
| GPIO | 5 | Motor and strobe control correct; no direction conflict |
| ADC | 10 | Four channels at four rates; position accurate to 1 cm |
| Timer | 10 | 10 kHz dual PWM **and** a stable 10 ms tick |
| Interrupts | 5 | E-stop ≤ 1 ms fail-safe; safety edge reversal ≤ 20 ms |
| USART | 10 | 2 s frame, scriptable `CALL`, events, robust parser |
| SPI | 10 | **Two** devices arbitrated with no interference, in both directions |
| I2C | 10 | LCD service display, both pages, flicker-free |
| Application logic | 20 | LOOK correct including the opposite-call exception; levelling ±3 cm both ways |
| Architecture | 10 | Bitmap dispatch; single writers; safety evaluated first; layer rule |
| Testing | 10 | 69 cases including TC-12, TC-20/21, TC-26/27 and TC-35 |
| Documentation & demo | 10 | Dispatch and safety-precedence documents present; live LOOK trace |
| **Total** | **100** | Bonus up to +20, capped at 100 |

---

*Prepared by Ahmed Ellamie | ahmed.ellamiee@gmail.com*
??? ??????? ?? ????? ???? ??? ?????? ????? ???? ???????.
