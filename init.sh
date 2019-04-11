#! /usr/bin/env bash

basepath=$(cd `dirname $0`; pwd)

git clone https://github.com/Bilibili/ijkplayer.git ijkplayer-android
cd ijkplayer-android
git checkout -B latest k0.8.8
if [ ! $? = 0 ]; then
	exit 1
fi

./init-android.sh
if [ ! $? = 0 ]; then
	exit 1
fi

#https
./init-android-openssl.sh 
if [ ! $? = 0 ]; then
	exit 1
fi

cd ..
cp -f -r ./patch/init-x264.sh ./ijkplayer-android/
if [ ! $? = 0 ]; then
	exit 1
fi

chmod 777 ./ijkplayer-android/init-x264.sh

cd ijkplayer-android
sh init-x264.sh 
if [ ! $? = 0 ]; then
	exit 1
fi


cd ..
sh do-patch.sh ./ijkplayer-android
if [ ! $? = 0 ]; then
	exit 1
fi

cd ijkplayer-android/config
rm module.sh
ln -s module-default.sh module.sh