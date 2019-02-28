#!/bin/bash
#eegloo
#Version 4

Start() {
  mplayer sound/bruitage/teleport.mp3  > /dev/null 2>&1
  Instant
  Horloge
  News
  Tech
  Play
  Play
  Play
}

    # Détermine le moment de la journee
Instant() {

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

    # Refresh and display informations
Refresh() {
  clear
  Meteo
  cowsay -f tux " $moment "
}

    # Détermine le dernier podcast d'information via un flux rss/xml
    # Lit la premiere minute, uniquement le sommaire , les titres du journal
News () {
  Refresh

  actuPod=$(curl -s $url | grep -m 1 "guid" | sed 's/<guid >\|<\/guid>//g') > /dev/null
  mplayer -endpos 00:01:15 $actuPod > /dev/null 2>&1
}

    ## choose random mp3 file in folder and play it (less than 15sec)
Pub () {
      adv=`(shuf -n1 < <(find ./sound/pub -maxdepth 1 -type f -exec realpath {} \;))`
      mplayer $adv > /dev/null 2>&1
}

    ## choose random mp3 music file in folder and play it (less than 2min)
Zik () {
      sound=`(shuf -n1 < <(find ./sound/zik -maxdepth 1 -type f -exec realpath {} \;))`
      mplayer -endpos 00:01:52 $sound > /dev/null 2>&1
}

    # Horloge parlante ! $pico2wave passe le txt en .wav $mplayer diffuse le son
    # Installer le paquet libttspico-utils
Horloge () {
  D=$(date +%d)
  pico2wave -l fr-FR -w Heure.wav "bonjour , il est $H heures $M . Nous sommes le $D"
  mplayer Heure.wav > /dev/null 2>&1
  rm Heure.wav
}

    # NoComment...
Meteo() {
  curl 'http://wttr.in/paris?0&lang=fr'
}

    # list differentes sources/links des podcast high Tech
Tech() {
  touch ghost.i

  curl -s http://www.rfi.fr/emission/nouvelles-technologies/podcast | grep mp3 | sed 's/<enclosure url="\|" type="audio\/mpeg"><\/enclosure>//g' >> ghost.i
  curl -s http://radiofrance-podcast.net/podcast09/rss_12737.xml | grep "guid" | sed 's/<guid >\|<\/guid>//g' >> ghost.i
  curl -s http://radiofrance-podcast.net/podcast09/rss_16589.xml | grep "guid" | sed 's/<guid >\|<\/guid>//g' >> ghost.i
  curl -s http://radiofrance-podcast.net/podcast09/rss_18098.xml | grep "guid" | sed 's/<guid >\|<\/guid>//g' >> ghost.i
  curl -s  http://radiofrance-podcast.net/podcast09/rss_12625.xml | grep "guid" | sed 's/<guid >\|<\/guid>//g' >> ghost.i
  curl -s http://radiofrance-podcast.net/podcast09/rss_18998.xml | grep "guid" | sed 's/<guid >\|<\/guid>//g' >> ghost.i
  sed -i 's/ //g' ghost.i

}> /dev/null 2>&1

    # Lecture aleatoire d un podcast
RandomPod() {
  Podnb=$(wc -l ghost.i | cut -d ' ' -f1)
  Rdmnb=$(( $RANDOM % $Podnb ))
  PodRdm=$(sed -n "$Rdmnb p" ghost.i)

  mplayer $PodRdm
} > /dev/null 2>&1

    # Random playing process
Play () {
  moment="PUB"
  Refresh
  Pub
  moment="MUSIQUE"
  Refresh
  Zik
  moment="SCIENCE PODCAST"
  Refresh
  RandomPod
}
    # Exit process
Close() {
  rm ghost.i
  clear
  echo "Bye"
  exit
}

Start
Close
