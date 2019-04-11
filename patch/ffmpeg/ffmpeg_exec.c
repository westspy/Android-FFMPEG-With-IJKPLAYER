/*
 * Copyright (C) 2009 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
#include <jni.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <android/log.h>
#include <unistd.h>
#include <sys/inotify.h>
#include <sys/prctl.h>
#include <sys/wait.h>
#include <sys/socket.h>  
#include <arpa/inet.h>
#include <netdb.h> 
#include <sys/un.h>

extern int ffmpeg_exec(int argc, char **argv);

int main(int argc, char* argv[])
{
   return ffmpeg_exec(argc, argv);
}
