#!/bin/bash
#eegloo
#Version 4

H=$(date +%H)
M=$(date +%M)

start()
{
  clear
  Instant
  News
  tech
}

    #horloge parlante ! $pico2wave passe le txt en .wav $mplayer diffuse le son
horloge ()
{
  pico2wave -l fr-FR -w Heure.wav "bonjour , il est $H heures $M !";
  mplayer Heure.wav > /dev/null 2>&1
  rm Heure.wav
}

    #determine le dernier podcast via un flux rss et lit la premiere minute
News()
{
  cowsay -f tux " Bulletin du $moment "
  meteo
  horloge

  actuPod=$(curl -s $url | grep -m 1 "guid" | sed 's/<guid >\|<\/guid>//g') > /dev/null
  #mplayer -endpos 00:01:15 $actuPod > /dev/null 2>&1
}

tech()
{
  touch ghost.i

  curl -s http://www.rfi.fr/emission/nouvelles-technologies/podcast | grep mp3 | sed 's/<enclosure url="\|" type="audio\/mpeg"><\/enclosure>//g' >> ghost.i
  curl -s http://radiofrance-podcast.net/podcast09/rss_12737.xml | grep "guid" | sed 's/<guid >\|<\/guid>//g' >> ghost.i
  curl -s http://radiofrance-podcast.net/podcast09/rss_16589.xml | grep "guid" | sed 's/<guid >\|<\/guid>//g' >> ghost.i
  curl -s http://radiofrance-podcast.net/podcast09/rss_18098.xml | grep "guid" | sed 's/<guid >\|<\/guid>//g' >> ghost.i
  curl -s  http://radiofrance-podcast.net/podcast09/rss_12625.xml | grep "guid" | sed 's/<guid >\|<\/guid>//g' >> ghost.i
  sed -i 's/ //g' ghost.i
  randomPod

}> /dev/null 2>&1

randomPod()
{
  Podnb=$(wc -l ghost.i | cut -d ' ' -f1)
  Rdmnb=$(( $RANDOM % $Podnb ))
  PodRdm=$(sed -n "$Rdmnb p" ghost.i)

  echo PodRdm "99999999999999999999999999999999999"
  mplayer $PodRdm

}

    #Determine le moment de la journee
Instant()
{
  if ((H<=13))
    then
    moment="matin"
    url="http://radiofrance-podcast.net/podcast09/rss_12559.xml"
    elif ((H<19))
      then
        moment="midi"
        url="http://radiofrance-podcast.net/podcast09/rss_11673.xml"
    else
      moment="soir"
      url="http://radiofrance-podcast.net/podcast09/rss_11736.xml"
  fi
}
    #noComment...
meteo()
{
  curl 'http://wttr.in/paris?0&lang=fr'
}

start