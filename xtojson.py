# Description: Converts .Xresources colours to JSON for use in Windows Terminal.
# Usage: python xtojson.py .Xresources

import sys

if len(sys.argv) != 2:
    print('Error: Invalid arguments')
    exit()

try:
    inFile = open(sys.argv[1], 'r').read()
except IOError:
    print('Error: Cannot read file')

colors = {
    'background': '',
    'foreground': '',
    'color0': '',
    'color1': '',
    'color2': '',
    'color3': '',
    'color4': '',
    'color5': '',
    'color6': '',
    'color7': '',
    'color8': '',
    'color9': '',
    'color10': '',
    'color11': '',
    'color12': '',
    'color13': '',
    'color14': '',
    'color15': ''
}

for line in inFile.splitlines():
    for color in colors:
        line = line.replace(' ', '')
        if line.startswith('*.' + color + ':'):
            colors[color] = line.replace('*.' + color + ':#', '')

print('{')
print('\t"name": "NAME",')
print('\t"background": "#' + colors['background'] + '",')
print('\t"foreground": "#' + colors['foreground'] + '",')
print('\t"black": "#' + colors['color0'] + '",')
print('\t"red": "#' + colors['color1'] + '",')
print('\t"green": "#' + colors['color2'] + '",')
print('\t"yellow": "#' + colors['color3'] + '",')
print('\t"blue": "#' + colors['color4'] + '",')
print('\t"purple": "#' + colors['color5'] + '",')
print('\t"cyan": "#' + colors['color6'] + '",')
print('\t"white": "#' + colors['color7'] + '",')
print('\t"brightBlack": "#' + colors['color8'] + '",')
print('\t"brightRed": "#' + colors['color9'] + '",')
print('\t"brightGreen": "#' + colors['color10'] + '",')
print('\t"brightYellow": "#' + colors['color11'] + '",')
print('\t"brightBlue": "#' + colors['color12'] + '",')
print('\t"brightBurple": "#' + colors['color13'] + '",')
print('\t"brightCyan": "#' + colors['color14'] + '",')
print('\t"brightWhite": "#' + colors['color15'])
print('}')