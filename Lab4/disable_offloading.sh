#!/bin/bash

intf0="$1"

TOE_OPTIONS="rx tx sg tso ufo gso gro lro rxvlan txvlan txhash rxhash"

for TOE_OPTION in $TOE_OPTIONS; do
    /sbin/ethtool --offload $intf0 "$TOE_OPTION" off &>/dev/null
done