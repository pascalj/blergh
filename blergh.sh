#!/bin/sh

BASE_PATH=~/podcasts
STREAMRIPPER=`which streamripper`
PODCAST_DIR=
OUTPATH=
RECORD=1
HOST=
NAME=
DURATION=
URL=

loadConfig () {
  CONFIG_FILE=$1
  [ -f $CONFIG_FILE ] || fail "Could not find config file \"$CONFIG_FILE\""
  . $1
}

readArguments() {
  while getopts :b:c:d:gh:s: opt; do
    case "$opt" in
      b) BASE_PATH=$OPTARG;;
      c) loadConfig $OPTARG;;
      d) PODCAST_DIR=$OPTARG;;
      g) RECORD=0;;
      h) HOST=$OPTARG;;
      s) STREAMRIPPER=$OPTARG;;
      ?) echo "Invalid option \"$OPTARG\"" >&2 && exit 1
    esac
  done

  shift $((OPTIND - 1))
  NAME=$1
  DURATION=$2
  URL=$3
  [ -z $PODCAST_DIR ] && PODCAST_DIR="$BASE_PATH/$NAME"
  OUTPATH=$PODCAST_DIR/`date +%s`.mp3
}

record() {
  if [ $RECORD != "1" ]; then
    return
  fi
  mkdir -p "$PODCAST_DIR" || fail "Cannot create output directory"
  $STREAMRIPPER "$URL" -s -A -a $OUTPATH -l `expr $DURATION "*" 60` --quiet
}

generateXML() {
  header='<?xml version="1.0" encoding="UTF-8"?>
  <rss version="2.0" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" xmlns:media="http://search.yahoo.com/mrss/">
  <channel>
  <title>%s</title>
  <description></description>
  <itunes:title>%s</itunes:title>
  <itunes:description></itunes:description>
  <link>%s</link>
  %s
  <itunes:author>Blergh</itunes:author>'
  footer='</channel>
  </rss> '

  item='<item>
  <title>%s vom %s</title>
  <description>%s vom %s</description>
  <pubDate>%s</pubDate>
  <link>%s</link>
  <guid>%s</guid>
  <itunes:duration>%s</itunes:duration>
  <enclosure url="%s" type="audio/mpeg"/>
  %s
  </item>'
  image=''
  if [ -f "$PODCAST_DIR.png" ]
  then
    image="<itunes:image href=\"$HOST/$NAME.png\" />"
  fi
  if [ -f "$PODCAST_DIR.jpg" ]
  then
    image="<itunes:image href=\"$HOST/$NAME.jpg\" />"
  fi
  printf "$header" "$NAME" "$NAME" "$HOST" "$image" > $BASE_PATH/$NAME.xml
  listEpisodes | extractDate | while read episodeDate
  do
    humanDate=`date -j -r $episodeDate +%d.%m.`
    rfcDate=`date -j -r $episodeDate +"%a, %d %b %Y %T %z"`
    guid="$HOST/$NAME/$episodeDate"
    url="$HOST/$NAME/$episodeDate.mp3"
    printf "$item" "$NAME" "$humanDate" "$NAME" "$humanDate" "$rfcDate" "$guid" "$guid" "$DURATION" "$url" "$image" >> $BASE_PATH/$NAME.xml
  done
  printf "$footer\n" >> "$BASE_PATH/$NAME.xml"
}

listEpisodes() {
  find $PODCAST_DIR -name "*.mp3" | sort -r
}

extractDate() {
  sed -e "s/.*\/\([0-9]*\)\.mp3/\\1/g"
}

validateSettings() {
  [ -x "$STREAMRIPPER" ] || fail "Could not find executable streamripper at '$STREAMRIPPER'"
  [ "" = "$NAME" ] && usage
  [ "" = "$URL" ] && usage
  [ "" = "$DURATION" ] && usage
}

usage() {
  echo "Usage:\n"
  echo "blergh  [  ‐b base_path ] [ ‐c config ] [ ‐d podcasts_dir ] [ ‐g ] [ ‐h
       host ] [ ‐s streamripper ] name duration url"
  exit 1
}

blergh() {
  readArguments $*
  validateSettings
  record
  generateXML
}

fail() {
  echo $1 >&2 && exit 1
}

blergh $*
