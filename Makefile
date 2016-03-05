ARCHS = armv7 arm64
TARGET = :clang
THEOS_PACKAGE_DIR_NAME = debs

include theos/makefiles/common.mk

TWEAK_NAME = InstaMute
InstaMute_FILES = Tweak.xm InstaHelper.xm
InstaBetter_LDFLAGS += -Wl,-segalign,4000
InstaMute_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Instagram"
SUBPROJECTS += instamuteprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
