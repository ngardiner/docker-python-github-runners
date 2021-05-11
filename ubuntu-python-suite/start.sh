#!/bin/bash

TOKEN=`curl -s -u $USER:$PAT -X POST \
	    -H "Accept: application/vnd.github.v3+json" \
     https://api.github.com/repos/$USER/$REPO/actions/runners/registration-token -o - | jq -r .token`

# Verify the installed Python version
#/home/docker/info.py

# Install and init the Github Runner
cd /home/docker/actions-runner

./config.sh --unattended --url https://github.com/$USER/$REPO --token ${TOKEN} --name `hostname -s` --labels python${PYTHON_VERSION}

cleanup() {
	    echo "Removing runner..."
	    TOKEN=`curl -s -u $USER:$PAT -X POST \
	     -H "Accept: application/vnd.github.v3+json" \
	     https://api.github.com/repos/$USER/$REPO/actions/runners/registration-token -o - | jq -r .token`

	    ./config.sh remove --unattended --token ${TOKEN}
	}

trap 'cleanup; exit 0' EXIT
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh --once & wait $!
