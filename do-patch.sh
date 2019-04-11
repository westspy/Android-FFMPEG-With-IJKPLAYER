#! /usr/bin/env bash


TO_DIR=$1

if [ "$#" = '0' ]; then
	echo 'please select a path'
	exit 1
fi

patch_file () {
	
	PATCH_FILE=./patch/$2
	TARGET_FILE=$TO_DIR/$1
	BACKUP_FILE=$TO_DIR/$3
	echo "---patching $TARGET_FILE with $PATCH_FILE"
	
	if test -f $BACKUP_FILE
	then
	echo ">>>Patch detected,skip patch!"
	return 0;
	fi
	
	cp -f -r $TARGET_FILE $BACKUP_FILE
	if [ ! $? = 0 ]; then
			exit 1
	fi
	
	patch -N $TARGET_FILE $PATCH_FILE
	if [ ! $? = 0 ]; then
			exit 1
	fi
}

mk_backup_dir () {
	mkdir -p $TO_DIR/android/contrib/backup/ffmpeg-$1
	if [ ! $? = 0 ]; then
		exit 1
	fi
	mkdir -p $TO_DIR/android/contrib/backup/x264-$1
	if [ ! $? = 0 ]; then
		exit 1
	fi
}

mk_backup_dir armv5
mk_backup_dir armv7a
mk_backup_dir arm64
mk_backup_dir x86
mk_backup_dir x86_64

echo "patch libx264.c"
patch_file android/contrib/ffmpeg-armv5/libavcodec/libx264.c libx264.patch android/contrib/backup/ffmpeg-armv5/libx264.c
patch_file android/contrib/ffmpeg-armv7a/libavcodec/libx264.c libx264.patch android/contrib/backup/ffmpeg-armv7a/libx264.c
patch_file android/contrib/ffmpeg-arm64/libavcodec/libx264.c libx264.patch  android/contrib/backup/ffmpeg-arm64/libx264.c
patch_file android/contrib/ffmpeg-x86/libavcodec/libx264.c libx264.patch    android/contrib/backup/ffmpeg-x86/libx264.c
patch_file android/contrib/ffmpeg-x86_64/libavcodec/libx264.c libx264.patch  android/contrib/backup/ffmpeg-x86_64/libx264.c
echo "patch libx264.c done"

echo "patch ffmpeg.c"
patch_file android/contrib/ffmpeg-armv5/fftools/ffmpeg.c ffmpeg.patch android/contrib/backup/ffmpeg-armv5/ffmpeg.c
patch_file android/contrib/ffmpeg-armv7a/fftools/ffmpeg.c ffmpeg.patch android/contrib/backup/ffmpeg-armv7a/ffmpeg.c
patch_file android/contrib/ffmpeg-arm64/fftools/ffmpeg.c ffmpeg.patch android/contrib/backup/ffmpeg-arm64/ffmpeg.c
patch_file android/contrib/ffmpeg-x86/fftools/ffmpeg.c ffmpeg.patch android/contrib/backup/ffmpeg-x86/ffmpeg.c
patch_file android/contrib/ffmpeg-x86_64/fftools/ffmpeg.c ffmpeg.patch android/contrib/backup/ffmpeg-x86_64/ffmpeg.c
echo "patch ffmpeg.c done"

echo "patch x264 configure"
patch_file android/contrib/x264-armv5/configure x264_configure.patch android/contrib/backup/x264-armv5/configure
patch_file android/contrib/x264-armv7a/configure x264_configure.patch android/contrib/backup/x264-armv7a/configure
patch_file android/contrib/x264-arm64/configure x264_configure.patch android/contrib/backup/x264-arm64/configure
patch_file android/contrib/x264-x86/configure x264_configure.patch android/contrib/backup/x264-x86/configure
patch_file android/contrib/x264-x86_64/configure x264_configure.patch android/contrib/backup/x264-x86_64/configure
echo "patch x264 configure done"

echo "patch module-default.sh"
patch_file config/module-default.sh module-default.patch config/module-default.sh.bak
echo "patch module-default.sh done"

echo "patch do-compile-ffmpeg.sh"
patch_file android/contrib/tools/do-compile-ffmpeg.sh  do-compile-ffmpeg.patch android/contrib/tools/do-compile-ffmpeg.sh.bak
echo "patch do-compile-ffmpeg.sh done"

cp -f -r ./patch/ffmpeg $TO_DIR/ijkmedia/
if [ ! $? = 0 ]; then
	exit 1
fi

echo "patch x264 shell"
cp -f ./patch/compile-x264.sh $TO_DIR/android/contrib/
if [ ! $? = 0 ]; then
	exit 1
fi

chmod 777 $TO_DIR/android/contrib/compile-x264.sh

cp -f ./patch/do-compile-x264.sh $TO_DIR/android/contrib/tools/
if [ ! $? = 0 ]; then
	exit 1
fi

chmod 777 $TO_DIR/android/contrib/tools/do-compile-x264.sh
echo "patch x264 shell done"

echo 'patch all done!'
