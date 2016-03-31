NAME
       blergh − generate podcasts with streamripper


SYNOPSIS
       blergh  [  ‐b base_path ] [ ‐c config ] [ ‐d podcasts_dir ] [ ‐g ] [ ‐h
       host ] [ ‐s streamripper ] name duration url

DESCRIPTION
       blergh records podcasts and generate the  XML  file  for  the  recorded
       episodes.  It can be used in conjuction with cron(1) to start a record‐
       ing regularly. The resulting XML files then need to  be  serverd  by  a
       simple HTTP server.


OPTIONS
       ‐b base_path
              Use  BASE_PATH  as the working directory. All files and directo‐
              ries will be created here. Default: ~/podcasts

       ‐c config
              Load the config file before  executing.  The  variables  defined
              there will overwrite the defaults.

       ‐d podcast_dir
              Sets   the   directory   for   the   current  podcast.  Default:
              base_path/name

       ‐g     Don’t record, just generate the XML files. Useful for  when  you
              deleted files.

       ‐h host
              Set  host  as  the  hostname the will be prefixed in the podcast
              feed. Example: ‐h http://example.com/audio/

       ‐S streamripper
              Set the path to streamripper.  blergh will try to find it  using
              which(1)

AUTHOR
       Pascal Jungblut <oss@pascalj.de>



Pascal Jungblut                   2016‐03‐31                         blergh(1)
