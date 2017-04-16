set -e

if uname -a | grep armv7l ; then
  CPU=arm
elif uname -a | grep x86_64 ; then
  CPU=x86_64
else
  echo "No valid CPU detected"
  exit 1
fi
