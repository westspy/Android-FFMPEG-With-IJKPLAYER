# Android-FFMPEG-With-IJKPLAYER
executable FFMPEG with ijkplayer

在ijkplayer的基础上编译可运行的ffmpeg，和ijkplayer公用一个ffmpeg库.

目前支持最新ijkplayer 0.8.8.

编译步骤：
0.下载ndk14（只能用ndk10~ndk14）

1.运行init.sh

2.如果想支持x264和openssl请先运行compile-x264.sh,compile-openssl.sh

3.运行compile-ffmpeg.sh

4.运行compile-ijk.sh

5.最后生成ffmpeg_pic,ffmpeg_pie, libijkplayer.so, libijksdl.so, libijkffmpeg.so.
