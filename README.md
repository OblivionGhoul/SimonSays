# Simon Says Game Implementation in SystemVerilog

This project implements the classic Simon Says game using SystemVerilog. The design features a Finite State Machine (FSM) to control the game's logic, a tone generator for sound feedback, a random sequence generator, and modules to control LEDs and a 7-segment display.

## Game Overview
- Displays a sequence of LED flashes and tones.
- Allows the player to repeat the sequence using buttons.
- Increases the sequence length for each successful round.
- Provides visual and auditory feedback for success or failure.

## Module Descriptions

### `fsm.sv`
- Manages the game’s state transitions.
- Outputs the current LED, tone frequency, and feedback signals.
- Handles player input and sequence validation.

### `Random_Sequence_Generator.sv`
- Generates a randomized 2-bit sequence for LED control.
- Uses a linear feedback shift register (LFSR) for randomness.

### `Tone_Generator.sv`
- Produces sound signals based on the specified frequency.
- Toggles sound output at the correct timing using the system clock.

### `LED_and_Display_Control.sv`
- Manages LED displays for sequence feedback.
- Controls the 7-segment display to show the player's score or a "You Lose" message.

### `top_level.sv`
- Integrates all modules into a single design.
- Connects FSM, random sequence generator, tone generator, and display controls.
- Interfaces with the hardware inputs (buttons, clock, reset) and outputs (LEDs, sound, 7-segment display).