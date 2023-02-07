#!/bin/bash
# Example of Dudette's Daily offer sniping bot
# It will check if the last offer uploaded on Dexie has a price of 0.5 xch, which should be the last offer upload by Dudette, if not the last it will still snipe any offer at 0.5 xch
# Replace Fingerprint with yours
# Setup the Fee
# have this script run in the chia venv with wallet synced

COLLECTION=col1d3xv8sehzp9y23lm4w9mgewe55kqk6zhct5l34u0eq8jpllcsw4s9acv87
FINGERPRINT=
FEE=0.0005

while :
do
  dexie=$(curl -s 'https://api.dexie.space/v1/offers?offered='$COLLECTION'&status=0&sort=date_found&compact=true&page_size=1')
  if [ "$(echo $dexie | jq -r '.count')" == 1 ] && [ "$(echo $dexie | jq -r '.offers | .[].price')" == "0.5" ]
  then
    offer_id=$(echo $dexie | jq -r '.offers | .[].id')
    offer=$(curl -s 'https://api.dexie.space/v1/offers/'$offer_id'' | jq -r '.offer.offer')
    echo "offer found : $offer_id"
    echo "offer txt : $offer"
    yes | chia wallet take_offer -f $FINGERPRINT -m $FEE $offer
    break
  else
    echo "no offer yet"
    sleep 15
  fi
done
echo "Script ended"
