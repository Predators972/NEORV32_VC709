#!/usr/bin/env python3
import numpy as np
import subprocess
import re
import sys

output_dir = sys.argv[1] if len(sys.argv) > 1 else "../../src/"

fs = 8000
duration = 1
t = np.linspace(0, duration, int(fs * duration), endpoint=False)

# Generate YES signal - 150 Hz
frequency_yes = 150
yes_signal = np.sin(2 * np.pi * frequency_yes * t)
yes_signal = yes_signal + 0.1 * np.random.randn(len(t))
yes_normalized = np.uint8((yes_signal + 1) / 2 * 255)
yes_normalized.tofile('yes.dat')

# Generate NO signal - 250 Hz
frequency_no = 250
no_signal = np.sin(2 * np.pi * frequency_no * t)
no_signal = no_signal + 0.1 * np.random.randn(len(t))
no_normalized = np.uint8((no_signal + 1) / 2 * 255)
no_normalized.tofile('no.dat')

# Generate header files with xxd
subprocess.run(['xxd', '-i', 'yes.dat', f'{output_dir}yes.h'], check=True)
subprocess.run(['xxd', '-i', 'no.dat', f'{output_dir}no.h'], check=True)

# Optimize yes.h
with open(f'{output_dir}yes.h', 'r') as f:
    content = f.read()
content = re.sub(
    r'unsigned char yes_dat\[\]',
    'const unsigned char yes_dat[] __attribute__((section(".rodata")))',
    content
)
with open(f'{output_dir}yes.h', 'w') as f:
    f.write(content)

# Optimize no.h
with open(f'{output_dir}no.h', 'r') as f:
    content = f.read()
content = re.sub(
    r'unsigned char no_dat\[\]',
    'const unsigned char no_dat[] __attribute__((section(".rodata")))',
    content
)
with open(f'{output_dir}no.h', 'w') as f:
    f.write(content)

print(f"Done: yes.dat, no.dat in ./ and yes.h, no.h created in {output_dir}")