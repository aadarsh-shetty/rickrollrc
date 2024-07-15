#!/bin/zsh
# Rick Astley in your Terminal.
# By Serene and Justine Tunney <3
# Modified for MacOS 14.5 by Aadarsh S

version='1.2'
rick='https://raw.githubusercontent.com/aadarsh-shetty/rickrollrc/master'
video="$rick/astley80.full.bz2"
audio_raw="$rick/roll.s16"
audpid=0
NEVER_GONNA='curl -# -L https://bit.ly/4cCuqBG | zsh'
MAKE_YOU_CRY="$HOME/.zshrc"
red='\x1b[38;5;9m'
yell='\x1b[38;5;216m'
green='\x1b[38;5;10m'
purp='\x1b[38;5;171m'
echo -en '\x1b[s'  # Save cursor.

function has {
  command -v $1 >/dev/null 2>&1
}
function cleanup {
  (( audpid > 1 )) && kill $audpid 2>/dev/null
}
function quit {
  echo -e "\x1b[2J \x1b[0H ${purp}<3 \x1b[?25h \x1b[u \x1b[m"
}

function usage {
  echo -en "${green}Rick Astley performs ♪ Never Gonna Give You Up ♪ on STDOUT."
  echo -e "  ${purp}[v$version]"
  echo -e "${yell}Usage: ./roll.sh [OPTIONS...]"
  echo -e "${purp}OPTIONS : ${yell}"
  echo -e " help   - Show this message."
  echo -e " inject - Append to ${purp}${USER}${yell}'s zshrc. (Recommended :D)"
}

for arg in "$@"; do
  if [[ "$arg" == "help"* || "$arg" == "-h"* || "$arg" == "--h"* ]]; then
    usage && exit
  elif [[ "$arg" == "inject" ]]; then
    echo -en "${red}[Inject] "
    echo $NEVER_GONNA >> $MAKE_YOU_CRY
    echo -e "${green}Appended to $MAKE_YOU_CRY. <3"
    echo -en "${yell}If you've astley overdosed, "
    echo -e "delete the line ${purp}\"$NEVER_GONNA\"${yell}."
    exit
  else
    echo -e "${red}Unrecognized option: \"$arg\""
    usage && exit
  fi
done

trap "cleanup" INT
trap "quit" EXIT

# Bean streaming
function obtainium {
  if has curl; then curl -s $1
  else echo "Cannot has internets. :(" && exit
  fi
}

echo -en "\x1b[?25l \x1b[2J \x1b[H"  # Hide cursor, clear screen.

# Fetching video...
tmpvideofile=$(mktemp)
tmpaudiofile=$(mktemp)

obtainium $video | bunzip2 -q > $tmpvideofile
obtainium $audio_raw > $tmpaudiofile

python3 <<EOF
import sys
import time
import os

fps = 25
time_per_frame = 1.0 / fps
buf = ''
frame = 0
next_frame = 0
begin = time.time()
try:
    os.system('afplay $tmpaudiofile &')
    with open('$tmpvideofile', 'r') as f:
        for i, line in enumerate(f):
            if i % 32 == 0:
                frame += 1
                sys.stdout.write(buf)
                buf = ''
                elapsed = time.time() - begin
                repose = (frame * time_per_frame) - elapsed
                if repose > 0.0:
                    time.sleep(repose)
                next_frame = elapsed / time_per_frame
            if frame >= next_frame:
                buf += line
except KeyboardInterrupt:
    pass
EOF

rm $tmpvideofile,$tmpvideofile