# Shamelessly stolen from https://github.com/elihwyma/Pogo/blob/main/Makefile
TARGET_CODESIGN = $(shell which ldid)

APP_TMP         = $(TMPDIR)/bypassfn
APP_STAGE_DIR   = $(APP_TMP)/stage
APP_APP_DIR     = $(APP_TMP)/Build/Products/Release-iphoneos/bypassfn.app

package:
    @set -o pipefail; \
        xcodebuild -quiet -jobs $(shell sysctl -n hw.ncpu) -project 'bypassfn.xcodeproj' -scheme bypassfn -configuration Release -arch arm64 -sdk iphoneos -derivedDataPath $(APP_TMP) \
        CODE_SIGNING_ALLOWED=NO DSTROOT=$(APP_TMP)/install ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES=NO
    @rm -rf Payload
    
    @rm -rf $(APP_STAGE_DIR)/
    @mkdir -p $(APP_STAGE_DIR)/Payload $(APP_STAGE_DIR)/JailedPayload $(APP_STAGE_DIR)/TSPayload
    @mv $(APP_APP_DIR) $(APP_STAGE_DIR)/Payload/bypassfn.app
    
    @cp -r $(APP_STAGE_DIR)/Payload/bypassfn.app $(APP_STAGE_DIR)/JailedPayload/bypassfnJailed.app
    
    @rm -rf $(APP_STAGE_DIR)/Payload/bypassfn.app/_CodeSignature
    
    @cp -r $(APP_STAGE_DIR)/Payload/Santander.app $(APP_STAGE_DIR)/TSPayload/bypassfnTS.app
    @$(TARGET_CODESIGN) -Sentitlements-TS.plist $(APP_STAGE_DIR)/TSPayload/bypassfnTS.app/

    chmod 6755 $(APP_STAGE_DIR)/TSPayload/bypassfnTS.app/
    
    @ln -sf $(APP_STAGE_DIR)/Payload Payload
    @ln -sf $(APP_STAGE_DIR)/JailedPayload JailedPayload
    @ln -sf $(APP_STAGE_DIR)/TSPayload TSPayload
    
    @rm -rf build
    @mkdir -p build

    @zip -r9 build/bypassfn.ipa Payload
    @rm -rf Payload
    @mv TSPayload Payload
    
    @zip -r9 build/bypassfn.tipa Payload
    @rm -rf Payload
    @mv JailedPayload Payload
