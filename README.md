# Odin
### A simple CLI based Operating System built for research and development purposes

## ⚠️ Disclaimer
**This project is strictly built for only R&D purposes, the author is not responsible for any misuse of the project or damages to any system**

## Features supported:
- Real mode & protected mode
- Memory management
- Keyboard support
- Simple command line interface
- Multi-threading
- FAT16 file system

## Software requirements:
- gcc
- nasm
- bochs

## Hardware requirements:
- 64-bit machine
- 1GB RAM
- 1GB HDD
- Intel Pentium Dual Core (or newer)

## How to run:

### Building the system
    ./build.sh
### Running the OS file
    bochs

**Note:** If the system doesn't boot right after entering the above command, enter "**c**" on the _bochs console_ and hit the _return key_. This happens sometimes when bochs prompts users to choose whether or not to continue the boot process.
