#!/bin/bash

#===============================================================================
#
#         FILE:  brute.sh
#
#        USAGE:  sudo ./brute.sh [drive uuid] [crunch arguments]
#
#  DESCRIPTION:  Brute forces HFS+ encrypted drives.
#
#      OPTIONS:  -h, help
#
# REQUIREMENTS:  crunch, parallel
#         BUGS:  ---
#        NOTES:  Only runs os OSX/MacOS.
#       AUTHOR:  Evan Wieland
#      COMPANY:  bitsmithy.io
#      CREATED:  1/3/2021 03:50 PM CT
#===============================================================================

# Usage help
usage(){
   echo -e "Usage: $ sudo $1 [drive uuid] [crunch arguments]"
}

# Check for help
if [[ " $@ " =~ " help " || " $@ " =~ " -h " ]]; then
   usage
   exit 0
fi

# Check if drive is mounted
if [[ $(diskutil list) != *$1* ]]; then
 echo "The drive UUID is incorrect. Please verify the UUID and try again."
 exit 2
fi

# Require root
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "$0 is not running as root. Try using sudo."
    usage
    exit 2
fi

# Check for arguments
if [ $# -lt 2 ]; then
  echo 1>&2 "$0: not enough arguments"
  usage
  exit 2
fi

# Assign arguments and export for GNU Parallel
export drive=$1

# Attempt unlocking the drive with the password
cast(){
  read -r word

  # Print attempt # and word to terminal 
  echo "[$1] $word"

  # Attempt unlock
  diskutil coreStorage unlockVolume "$drive" -passphrase "$word" &>/dev/null
  
  # Flag match and exit
  if [ $? -eq 0 ]; then
    echo "[MATCH] $word"
    exit 0
  fi

  # Throw error to tell parallel to continue
  exit 1
}

# Export function for GNU Parallel
export -f cast

# Declare to the user that the password has been found
notice(){
  password=$1

  # Print password to terminal
  echo "************************"
  echo "Password: $password"
  echo "************************"

  # Play chime to alert user
  afplay /System/Library/Sounds/Ping.aiff

  # Launch alert showing password
  title="Password found!"
  message="The password is:\n$password"
  
  osascript -e "display alert \"$title\" message \"$message\"" >/dev/null
}

# Look for the found password flag
scan(){
  while read data; do
    # Find the password via the [MATCH] flag
    match_line=$(grep -Fiw [MATCH])
    match=${match_line//\[MATCH\] /}
    if [[ $match ]]; then
      # Send off notice to user 
      notice $match
    else
      echo "Password was unable to be found."
    fi
  done
}

# Begin...
crunch ${@: 2} -u | parallel --pipe -j20 -N1 -k --halt now,success=1 cast {#} | tee /dev/tty | scan