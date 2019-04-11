#! /usr/bin/env bash

basepath=$(cd `dirname $0`; pwd)

cd ijkplayer-android/android

./compile-ijk.sh all
