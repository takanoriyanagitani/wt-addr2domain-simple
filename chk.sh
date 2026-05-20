#!/bin/sh

examples(){
  echo hi@example.com
  echo hello@example.com
}

examples |
  while read line; do
    echo input: "${line}"
    printf 'output: '
    node addr2domain.mjs "${line}"
    echo
  done
