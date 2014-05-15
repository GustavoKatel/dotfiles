#!/bin/bash

a=`clementine-info %a | sed "s/ /+/g"`; t=`clementine-info %t | sed "s/ /+/g"`; curl http://ws.audioscrobbler.com/2.0/\?method\=track.getInfo\&username\=GustavoKatel\&api_key\=8a40f5950e301d95268f45c640cdd654\&format\=json\&track\=$t\&artist\=$a\&autocorrect\=1 2> /dev/null | grep -o "userplaycount\":\"[0-9]\+\"" | grep -o "[0-9]\+"
