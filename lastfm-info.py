#!/usr/bin/python

import sys, argparse
import lastfmapi as lastfm

API_KEY = "API_KEY_HERE"

class LastFMInfo:

    pattern2tag = {
        "%a": "artist",
        "%t": "title",
        "%b": "album",
        "%c": "playcount",
        "%C": "totalplaycount",
        "%g": "genre",
        "%p": "position",
        "%P": "percent",
        "%l": "time",
        "%i": "arturl",
        "%f": "location",
    }

    def __init__(self):
        self.api = lastfm.LastFmApi(API_KEY)

    def process(self, username, pattern):
        self.username = username
        self.pattern = pattern

        self.getMetadata()

        res = self.pattern

        for k in self.pattern2tag:
            # check tag existence
            tag = self.pattern2tag[k]
            if tag in self.metadata:
                res = res.replace(k, unicode(self.metadata[tag]))

        return res

    def getMetadata(self):
        res = self.api.user_getRecentTracks(limit=1, user=self.username, extended=1)
        self.metadata = {}
        self.metadata["album"]=res["recenttracks"]["track"][0]["album"]["#text"]
        self.metadata["artist"]=res["recenttracks"]["track"][0]["artist"]["name"]
        self.metadata["title"]=res["recenttracks"]["track"][0]["name"]

        self.metadata["mbid"]=res["recenttracks"]["track"][0]["mbid"]

        res = self.api.track_getInfo(mbid=self.metadata["mbid"], username=self.username)

        self.metadata["playcount"]=res["track"]["userplaycount"]

        self.metadata["arturl"]=res["track"]["album"]["image"][1]["#text"]

        res = self.api.user_getInfo(user=self.username)

        self.metadata["totalplaycount"]=res["user"]["playcount"]

        # print self.metadata["totalplaycount"]
        # print res

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Get track info from LastFM")
    parser.add_argument("--max-length", help="Truncate the info to 'max-length' characters", default=0)
    parser.add_argument("username", help="User to collect data from", nargs=1)
    parser.add_argument("pattern", help="Pattern to be processed with the metatags", nargs='?', default="%t - %a")

    args = parser.parse_args()

    username = args.username[0]
    pattern = args.pattern.decode("utf-8")
    max_length = args.max_length

    app = LastFMInfo()
    res = app.process(username, pattern).encode("utf-8")

    if max_length > 0:
        res = res[:max_length]

    sys.stdout.write(res)
