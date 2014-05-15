#!/bin/bash

curl http://ws.audioscrobbler.com/2.0/\?method\=user.getinfo\&user\=GustavoKatel\&api_key\=8a40f5950e301d95268f45c640cdd654\&format\=json 2> /dev/null | grep -o "playcount\":\"[0-9]\+\"" | grep -o "[0-9]\+"
