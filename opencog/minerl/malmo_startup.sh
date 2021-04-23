#!/bin/bash
/dockerstartup/vnc_startup.sh echo "Starting Malmo Minecraft Mod"
cd /home/opencog
# Launch minecraft (which may take several minutes first time)
python3 -c "import malmo.minecraftbootstrap;malmo.minecraftbootstrap.launch_minecraft()"
echo "Starting jupyter"
jupyter lab --ip 0.0.0.0 --no-browser
