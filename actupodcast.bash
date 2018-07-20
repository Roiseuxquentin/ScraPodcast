#!/bin/bash
#eegloo
#Version 4

start()
{
  Instant
  Horloge
  News
  Tech
  RandomPod
  RandomPod
  Close
}

    #Determine le moment de la journee
Instant()
{

  H=$(date +%-H)
  M=$(date +%M)

  if (( $H < 13 ))
    then
    moment="Bulletin du  matin"
    url="http://radiofrance-podcast.net/podcast09/rss_12559.xml"
    elif (( $H < 19 ))
      then
        moment="Bulletin du  midi"
        url="http://radiofrance-podcast.net/podcast09/rss_11673.xml"
    else
      moment="Bulletin du  soir"
      url="http://radiofrance-podcast.net/podcast09/rss_11736.xml"
  fi
}

    #determine le dernier podcast via un flux rss et lit la premiere minute
News()
{
  Refresh

  actuPod=$(curl -s $url | grep -m 1 "guid" | sed 's/<guid >\|<\/guid>//g') > /dev/null
  mplayer -endpos 00:01:15 $actuPod > /dev/null 2>&1

  moment="La Science Aleatoire"
  Refresh
}

Refresh()
{
  clear
  Meteo
  cowsay -f tux " $moment "
}

    #Horloge parlante ! $pico2wave passe le txt en .wav $mplayer diffuse le son
Horloge ()
{
  D=$(date +%d)
  pico2wave -l fr-FR -w Heure.wav "bonjour , il est $H heures $M . Nous sommes le $D"
  mplayer Heure.wav > /dev/null 2>&1
  rm Heure.wav
}

    #noComment...
Meteo()
{
  curl 'http://wttr.in/paris?0&lang=fr'
}

    #list differentes sources/links des podcast high Tech
Tech()
{
  touch ghost.i

  curl -s http://www.rfi.fr/emission/nouvelles-technologies/podcast | grep mp3 | sed 's/<enclosure url="\|" type="audio\/mpeg"><\/enclosure>//g' >> ghost.i
  curl -s http://radiofrance-podcast.net/podcast09/rss_12737.xml | grep "guid" | sed 's/<guid >\|<\/guid>//g' >> ghost.i
  curl -s http://radiofrance-podcast.net/podcast09/rss_16589.xml | grep "guid" | sed 's/<guid >\|<\/guid>//g' >> ghost.i
  curl -s http://radiofrance-podcast.net/podcast09/rss_18098.xml | grep "guid" | sed 's/<guid >\|<\/guid>//g' >> ghost.i
  curl -s  http://radiofrance-podcast.net/podcast09/rss_12625.xml | grep "guid" | sed 's/<guid >\|<\/guid>//g' >> ghost.i
  curl -s http://radiofrance-podcast.net/podcast09/rss_18998.xml | grep "guid" | sed 's/<guid >\|<\/guid>//g' >> ghost.i
  sed -i 's/ //g' ghost.i

  RandomPod

}> /dev/null 2>&1

    #Lecture aleatoire d un podcast
RandomPod()
{
  Podnb=$(wc -l ghost.i | cut -d ' ' -f1)
  Rdmnb=$(( $RANDOM % $Podnb ))
  PodRdm=$(sed -n "$Rdmnb p" ghost.i)

  echo PodRdm "99999999999999999999999999999999999"
  mplayer $PodRdm

}> /dev/null 2>&1

Close()
{
  rm ghost.i
  clear
  echo "Bye"
  exit
}

start