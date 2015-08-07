include theos/makefiles/common.mk

BUNDLE_NAME = InstaMutePrefs
InstaMutePrefs_FILES = InstaMutePrefs.mm
InstaMutePrefs_INSTALL_PATH = /Library/PreferenceBundles
InstaMutePrefs_FRAMEWORKS = UIKit
InstaMutePrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/InstaMutePrefs.plist$(ECHO_END)
