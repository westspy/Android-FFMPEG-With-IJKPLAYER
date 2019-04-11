LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE:=ffmpeg_pie
LOCAL_SRC_FILES:=ffmpeg_exec.c
LOCAL_C_INCLUDES:= $(LOCAL_PATH)/include
LOCAL_LDLIBS += -L$(SYSROOT)/usr/lib -llog
LOCAL_SHARED_LIBRARIES := ijkffmpeg
LOCAL_CFLAGS += -pie -fPIE
LOCAL_LDFLAGS += -pie -fPIE

include $(BUILD_EXECUTABLE)


include $(CLEAR_VARS)
LOCAL_MODULE:=ffmpeg_pic
LOCAL_SRC_FILES:=ffmpeg_exec.c
LOCAL_C_INCLUDES:= $(LOCAL_PATH)/include
LOCAL_LDLIBS += -L$(SYSROOT)/usr/lib -llog
LOCAL_SHARED_LIBRARIES := ijkffmpeg

include $(BUILD_EXECUTABLE)