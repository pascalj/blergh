#!/bin/sh

BASE_PATH=~/podcasts
STREAMRIPPER=`which streamripper`
OUTPATH=$BASE_PATH/$NAME-`date +%s`.mp3
NAME=
DURATION=
URL=

loadConfig () {
        CONFIG_FILE=$1
        if [ ! -f $CONFIG_FILE ]
        then
                echo "Could not find config file \"$CONFIG_FILE\"" >&2
                exit 1
        fi
        . $1
}

readArguments() {
        while getopts :c: opt; do
                case "$opt" in
                        c) loadConfig $OPTARG;;
                        ?) echo "Invalid option \"$OPTARG\"" >&2 && exit 1
                esac
        done

        shift $((OPTIND - 1))
        NAME=$1
        DURATION=$2
        URL=$3
}

record() {
        $STREAMRIPPER "$URL" -s -A -a $OUTPATH -l $DURATION --quiet  
}

generateXML() {
        header='
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" xmlns:media="http://search.yahoo.com/mrss/">
  <channel>
    <title>%s</title>
    <description></description>
    <itunes:title>%s</itunes:title>
    <itunes:description></itunes:description>
    <link>%s</link>
    <itunes:author>Blergh</itunes:author>
'
        footer='
  </channel>
</rss>
'

        item='
<item>
        <title>%s vom %s</title>
        <description>%s vom %s</description>
        <pubDate>%s</pubDate>
        <link>%s/%s/%s</link>
        <guid>%s/%s/%s</guid>
        <itunes:duration>%s</itunes:duration>
        <enclosure url="%s/%s" length="%s" type="audio/mpeg"/>
</item>
'
}

blergh() {
        readArguments
        # record
        # generateXML
}

blergh
