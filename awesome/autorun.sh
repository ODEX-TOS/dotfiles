#!/usr/bin/env bash

function run {
  if ! pgrep -f $1 ;
  then
    $@&
  fi
}


setxkbmap  $(cat /etc/vconsole.conf | cut -d= -f2 | cut -d- -f1)

run st
