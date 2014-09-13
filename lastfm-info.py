#!/usr/bin/python

import sys, argparse
import lastfmapi as lastfm

API_KEY = "8a40f5950e301d95268f45c640cdd654"

class LastFMInfo:

    pattern2tag = {
        "%a": u"artist",
        "%t": u"title",
        "%b": u"album",
        "%c": u"playcount",
        "%C": u"totalplaycount",
        "%g": u"genre",
        "%p": u"position",
        "%P": u"percent",
        "%l": u"time",
        "%i": u"arturl",
        "%f": u"location",
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
                res = res.replace(k, self.metadata[tag].decode("utf-8"))

        return res

    def getMetadata(self):
        res = self.api.user_getRecentTracks(limit=1, user=self.username, extended=1)
        self.metadata = {}
        if len(res["recenttracks"]["track"])==0:
            return
        self.metadata["album"]=res["recenttracks"]["track"][0]["album"]["#text"].encode("utf-8")
        self.metadata["artist"]=res["recenttracks"]["track"][0]["artist"]["name"].encode("utf-8")
        self.metadata["title"]=res["recenttracks"]["track"][0]["name"].encode("utf-8")

        self.metadata["mbid"]=res["recenttracks"]["track"][0]["mbid"].encode("utf-8")

        res = self.api.track_getInfo(track=self.metadata["title"], artist=self.metadata["artist"], username=self.username)

        try:
            self.metadata["playcount"]=res["track"]["userplaycount"].encode("utf-8")
            self.metadata["arturl"]=res["track"]["album"]["image"][1]["#text"].encode("utf-8")
        except:
            pass

        res = self.api.user_getInfo(user=self.username)

        self.metadata["totalplaycount"]=res["user"]["playcount"].encode("utf-8")

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
