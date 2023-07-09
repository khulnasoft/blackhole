#!/bin/sh

products="
alternates/fakenews
alternates/fakenews-gambling
alternates/fakenews-gambling-porn
alternates/fakenews-gambling-porn-social
alternates/fakenews-gambling-social
alternates/fakenews-porn
alternates/fakenews-porn-social
alternates/fakenews-social
alternates/gambling
alternates/gambling-porn
alternates/gambling-porn-social
alternates/gambling-social
alternates/porn
alternates/porn-social
alternates/social
"

lists="
data/Adguard-cname
data/Badd-Boyz-Hosts
data/KADblackhole
data/MetaMask
data/StevenBlack
data/URLHaus
data/UncheckyAds
data/adaway.org
data/add.2o7Net
data/add.Dead
data/add.Risk
data/add.Spam
data/blackholeVN
data/minecraft-blackhole
data/mvps.org
data/shady-blackhole
data/someonewhocares.org
data/tiuxo
data/yoyo.org
extensions/fakenews
extensions/gambling
extensions/porn/brijrajparmar27
extensions/porn/clefspeare13
extensions/porn/sinfonietta
extensions/porn/sinfonietta-snuff
extensions/porn/tiuxo
extensions/social/sinfonietta
extensions/social/tiuxo
"

IFS='
'

for item in $lists; do
  echo -n "" > $item/stats.out

  for HASH_DATE in $(git log --reverse --format="%t,%as" -- $item);  do
    # echo $item $HASH_DATE
    IFS=" "
    split=(${HASH_DATE//,/ })
    git checkout ${split[0]} ${item}/blackhole 1> /dev/null 2> /dev/null
    domains=$(rh -q -m $item/blackhole)
    echo  $item ${split[1]} ${domains}
    echo ${split[1]},${domains} >> ${item}/stats.out
    IFS='
'
  done
  git checkout HEAD^ ${item}/blackhole 1> /dev/null 2> /dev/null
done
