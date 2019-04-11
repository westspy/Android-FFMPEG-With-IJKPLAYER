#! /usr/bin/env bash
#
# Copyright (C) 2014 Miguel Botón <waninkoko@gmail.com>
# Copyright (C) 2014 Zhang Rui <bbcallen@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#--------------------
set -e

if [ -z "$ANDROID_NDK" ]; then
    echo "You must define ANDROID_NDK before starting."
    echo "They must point to your NDK directories.\n"
    exit 1
fi

#--------------------
# common defines
FF_ARCH=$1
if [ -z "$FF_ARCH" ]; then
    echo "You must specific an architecture 'arm, armv7a, x86, ...'.\n"
    exit 1
fi


FF_BUILD_ROOT=`pwd`
FF_ANDROID_PLATFORM=android-9


FF_BUILD_NAME=
FF_SOURCE=
FF_CROSS_PREFIX=

FF_CFG_FLAGS=
FF_PLATFORM_CFG_FLAGS=

FF_EXTRA_CFLAGS=
FF_EXTRA_LDFLAGS=



#--------------------
echo ""
echo "--------------------"
echo "[*] make NDK standalone toolchain"
echo "--------------------"
. ./tools/do-detect-env.sh
FF_MAKE_TOOLCHAIN_FLAGS=$IJK_MAKE_TOOLCHAIN_FLAGS
FF_MAKE_FLAGS=$IJK_MAKE_FLAG
FF_GCC_VER=$IJK_GCC_VER
FF_GCC_64_VER=$IJK_GCC_64_VER


#----- armv7a begin -----
if [ "$FF_ARCH" = "armv7a" ]; then
    FF_BUILD_NAME=x264-armv7a
    FF_SOURCE=$FF_BUILD_ROOT/$FF_BUILD_NAME
	
    FF_CROSS_PREFIX=arm-linux-androideabi
	FF_TOOLCHAIN_NAME=${FF_CROSS_PREFIX}-${FF_GCC_VER}

    FF_PLATFORM_CFG_FLAGS="--host=arm-linux-androideabi"
    
    FF_EXTRA_CFLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16 -mthumb -D__ANDROID__ -D__ARM_ARCH_7__ -D__ARM_ARCH_7A__ -D__ARM_ARCH_7R__ -D__ARM_ARCH_7M__ -D__ARM_ARCH_7S__"  
		FF_EXTRA_LDFLAGS="-nostdlib"
    

elif [ "$FF_ARCH" = "armv5" ]; then
    FF_BUILD_NAME=x264-armv5
    FF_SOURCE=$FF_BUILD_ROOT/$FF_BUILD_NAME
	
    FF_CROSS_PREFIX=arm-linux-androideabi
	FF_TOOLCHAIN_NAME=${FF_CROSS_PREFIX}-${FF_GCC_VER}

   FF_PLATFORM_CFG_FLAGS="--host=arm-linux-androideabi"
    
    FF_EXTRA_CFLAGS="-march=armv5te -mtune=arm9tdmi -msoft-float -D__ANDROID__ -D__ARM_ARCH_5TE__ -D__ARM_ARCH_5TEJ__"  
		FF_EXTRA_LDFLAGS="-nostdlib"
		
		FF_CFG_FLAGS="$FF_CFG_FLAGS --disable-asm"

elif [ "$FF_ARCH" = "x86" ]; then
    FF_BUILD_NAME=x264-x86
    FF_SOURCE=$FF_BUILD_ROOT/$FF_BUILD_NAME
	
    FF_CROSS_PREFIX=i686-linux-android
	FF_TOOLCHAIN_NAME=x86-${FF_GCC_VER}

    FF_PLATFORM_CFG_FLAGS="--host=i686-linux-android"
    
    FF_EXTRA_CFLAGS="-march=atom -msse3 -ffast-math -mfpmath=sse -D__ANDROID__ -D__i686__"  
		FF_EXTRA_LDFLAGS="-nostdlib"

    #FF_CFG_FLAGS="$FF_CFG_FLAGS --disable-asm"

elif [ "$FF_ARCH" = "x86_64" ]; then
    FF_ANDROID_PLATFORM=android-21

    FF_BUILD_NAME=x264-x86_64
    FF_SOURCE=$FF_BUILD_ROOT/$FF_BUILD_NAME

    FF_CROSS_PREFIX=x86_64-linux-android
    FF_TOOLCHAIN_NAME=${FF_CROSS_PREFIX}-${FF_GCC_64_VER}

    FF_PLATFORM_CFG_FLAGS="--host=x86_64-linux-android"
    
    FF_EXTRA_CFLAGS="-D__ANDROID__ -D__x86_64__"  
		FF_EXTRA_LDFLAGS="-nostdlib"

elif [ "$FF_ARCH" = "arm64" ]; then
    FF_ANDROID_PLATFORM=android-21

    FF_BUILD_NAME=x264-arm64
    FF_SOURCE=$FF_BUILD_ROOT/$FF_BUILD_NAME

    FF_CROSS_PREFIX=aarch64-linux-android
    FF_TOOLCHAIN_NAME=${FF_CROSS_PREFIX}-${FF_GCC_64_VER}

    FF_PLATFORM_CFG_FLAGS="--host=aarch64-linux-android"
    
    FF_EXTRA_CFLAGS="-march=armv8-a -D__ANDROID__ -D__ARM_ARCH_8__ -D__ARM_ARCH_8A__"  
		FF_EXTRA_LDFLAGS="-nostdlib"

else
    echo "unknown architecture $FF_ARCH";
    exit 1
fi

FF_TOOLCHAIN_PATH=$FF_BUILD_ROOT/build/$FF_BUILD_NAME/toolchain

FF_SYSROOT=$FF_TOOLCHAIN_PATH/sysroot
FF_PREFIX=$FF_BUILD_ROOT/build/$FF_BUILD_NAME/output

mkdir -p $FF_PREFIX
# mkdir -p $FF_SYSROOT


#--------------------
echo ""
echo "--------------------"
echo "[*] make NDK standalone toolchain"
echo "--------------------"
. ./tools/do-detect-env.sh
FF_MAKE_TOOLCHAIN_FLAGS=$IJK_MAKE_TOOLCHAIN_FLAGS
FF_MAKE_FLAGS=$IJK_MAKE_FLAG


FF_MAKE_TOOLCHAIN_FLAGS="$FF_MAKE_TOOLCHAIN_FLAGS --install-dir=$FF_TOOLCHAIN_PATH"
FF_TOOLCHAIN_TOUCH="$FF_TOOLCHAIN_PATH/touch"
if [ ! -f "$FF_TOOLCHAIN_TOUCH" ]; then
    $ANDROID_NDK/build/tools/make-standalone-toolchain.sh \
        $FF_MAKE_TOOLCHAIN_FLAGS \
        --platform=$FF_ANDROID_PLATFORM \
        --toolchain=$FF_TOOLCHAIN_NAME
    touch $FF_TOOLCHAIN_TOUCH;
fi


#--------------------
echo ""
echo "--------------------"
echo "[*] check x264 env"
echo "--------------------"
export PATH=$FF_TOOLCHAIN_PATH/bin:$PATH

export COMMON_FF_CFG_FLAGS=

FF_CFG_FLAGS="$FF_CFG_FLAGS $COMMON_FF_CFG_FLAGS"

echo "$FF_CFG_FLAGS"
#--------------------
# Standard options:
#FF_CFG_FLAGS="$FF_CFG_FLAGS --extra-cflags=\"$FF_EXTRA_CFLAGS\""
#FF_CFG_FLAGS="$FF_CFG_FLAGS --extra-ldflags=$FF_EXTRA_LDFLAGS"
FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-pic --enable-static --enable-strip --disable-cli --disable-win32thread --disable-avs"
FF_CFG_FLAGS="$FF_CFG_FLAGS --disable-swscale --disable-lavf --disable-ffms --disable-gpac --disable-lsmash"

FF_CFG_FLAGS="$FF_CFG_FLAGS --prefix=$FF_PREFIX"
FF_CFG_FLAGS="$FF_CFG_FLAGS --cross-prefix=${FF_CROSS_PREFIX}-"
FF_CFG_FLAGS="$FF_CFG_FLAGS $FF_PLATFORM_CFG_FLAGS"

#--------------------
echo ""
echo "--------------------"
echo "[*] configurate x264"
echo "--------------------"
cd $FF_SOURCE
#if [ -f "./Makefile" ]; then
#    echo 'reuse configure'
#else
    echo "./configure $FF_CFG_FLAGS --extra-cflags=\"$FF_CFLAGS $FF_EXTRA_CFLAGS\" --extra-ldflags=\"$FF_EXTRA_LDFLAGS\" "
    ./configure $FF_CFG_FLAGS \
         --extra-cflags="$FF_CFLAGS $FF_EXTRA_CFLAGS" \
        --extra-ldflags="$FF_EXTRA_LDFLAGS"
#fi

#--------------------
echo ""
echo "--------------------"
echo "[*] compile x264"
echo "--------------------"
make clean
make STRIP= $FF_MAKE_FLAGS
make install

#--------------------
echo ""
echo "------------x264--------"
echo "[*] link x264"
echo "--------------------"
