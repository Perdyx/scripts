# Description: Converts .Xresources colours to JSON for use in Windows Terminal.
# Usage: python xtowin.py .Xresources [hyper_js, windows_terminal]

import sys

if len(sys.argv) != 3:
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

outFmt = str(sys.argv[2])
if outFmt == 'hyper_js':
    print("foregroundColor: '#" + colors['foreground'] + "',")
    print("backgroundColor: '#" + colors['background'] + "',\n")

    print('colors: {')
    print('  "black": "#' + colors['color0'] + '",')
    print('  "red": "#' + colors['color1'] + '",')
    print('  "green": "#' + colors['color2'] + '",')
    print('  "yellow": "#' + colors['color3'] + '",')
    print('  "blue": "#' + colors['color4'] + '",')
    print('  "purple": "#' + colors['color5'] + '",')
    print('  "cyan": "#' + colors['color6'] + '",')
    print('  "white": "#' + colors['color7'] + '",')
    print('  "lightBlack": "#' + colors['color8'] + '",')
    print('  "lightRed": "#' + colors['color9'] + '",')
    print('  "lightGreen": "#' + colors['color10'] + '",')
    print('  "lightYellow": "#' + colors['color11'] + '",')
    print('  "lightBlue": "#' + colors['color12'] + '",')
    print('  "lightPurple": "#' + colors['color13'] + '",')
    print('  "lightCyan": "#' + colors['color14'] + '",')
    print('  "lightWhite": "#' + colors['color15'] + '"')
    print('},')
elif outFmt == 'windows_terminal':
    print('{')
    print('\t"name": "theme",')
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
    print('\t"brightPurple": "#' + colors['color13'] + '",')
    print('\t"brightCyan": "#' + colors['color14'] + '",')
    print('\t"brightWhite": "#' + colors['color15'] + '"')
    print('}')
else:
    print('Error: Invalid output format [hyper_js, windows_terminal]')
