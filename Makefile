TARGET := iphone:clang:latest:11.0
INSTALL_TARGET_PROCESSES = bypassfn

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = bypassfn

bypassfn_FILES = main.m FNAppDelegate.m FNRootViewController.m
bypassfn_FRAMEWORKS = UIKit CoreGraphics
bypassfn_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/application.mk
