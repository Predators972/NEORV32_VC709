#!/usr/bin/env python3
import subprocess
import re
import os
import sys

output_dir = sys.argv[1] if len(sys.argv) > 1 else "../../src/"

# Generate header files with xxd from existing .dat files
subprocess.run(['xxd', '-i', 'yes.dat', f'{output_dir}yes.h'], check=True)
subprocess.run(['xxd', '-i', 'no.dat', f'{output_dir}no.h'], check=True)

# Optimize yes.h
with open(f'{output_dir}yes.h', 'r') as f:
    content = f.read()

if '__attribute__((section(".rodata")))' not in content:
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

if '__attribute__((section(".rodata")))' not in content:
    content = re.sub(
        r'unsigned char no_dat\[\]',
        'const unsigned char no_dat[] __attribute__((section(".rodata")))',
        content
    )
    with open(f'{output_dir}no.h', 'w') as f:
        f.write(content)

print(f"Done: yes.h and no.h created in {output_dir}")