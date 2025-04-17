# Codaic / iOS / Codaic.Python

## Add Python To iOS App

Source 1: https://github.com/beeware/Python-Apple-support/blob/main/USAGE.md
Source 2: https://docs.python.org/3/using/ios.html#adding-python-to-an-ios-project

1. Download [Python-3.13-iOS-support.b6.tar.gz](https://github.com/beeware/Python-Apple-support/releases/download/3.13-b6/Python-3.13-iOS-support.b6.tar.gz)
2. Put it inside the Support folder
3. Targets -> Codaic -> General
    1. Python.xcframework: Embed&Sign
4. Add Bridging-Header.h: #import <Python/Python.h>
5. Targets -> Codaic -> Build Settings (Note: Select All)
    1. "Objective-C Bridging-Header" == "Codaic/Bridging-Header.h"
    2. "User Script Sandboxing" == "No"
    3. "Enable Testability" == "Yes"
    4. "Header Search Path" == "$(BUILT_PRODUCTS_DIR)/Python.framework/Headers"
6. Targets -> Codaic -> Build Phases
    1. Add "New Run Script Phase"
    2. Past following content:
```bash
set -e 

mkdir -p "$CODESIGNING_FOLDER_PATH/python/lib"
if [ "$EFFECTIVE_PLATFORM_NAME" = "-iphonesimulator" ]; then
    echo "Installing Python modules for iOS Simulator"
    cp -r "$PROJECT_DIR/Support/Python.xcframework/ios-arm64_x86_64-simulator/lib/" "$CODESIGNING_FOLDER_PATH/python/lib/"
else
    echo "Installing Python modules for iOS Device"
    cp -r "$PROJECT_DIR/Support/Python.xcframework/ios-arm64/lib/" "$CODESIGNING_FOLDER_PATH/python/lib/"
fi
```

7. After adding `import random` the first time there was this error appearing: `Codaic.app/python/lib/python3.13/lib-dynload/math.cpython-313-iphoneos.so' not valid for use in process: mapped file has no cdhash, completely unsigned? Code has to be at least ad-hoc signed.)`
    1. Targets -> Codaic -> Build Phases
    2. Add "New Run Script Phase"
    3. Past following content:

```bash
# Sign all .so files in the app bundle
APP_BUNDLE_PATH="${TARGET_BUILD_DIR}/${CONTENTS_FOLDER_PATH}"

find "$APP_BUNDLE_PATH/python" -name "*.so" -exec codesign --force --sign "$CODE_SIGN_IDENTITY" {} \;
```

Run python:
```Swift
guard let pythonPath = Bundle.main.path(forResource: "python/lib/python3.13", ofType: nil) else { return }
guard let libDynloadPath = Bundle.main.path(forResource: "python/lib/python3.13/lib-dynload", ofType: nil) else { return }
setenv("PYTHONPATH", [pythonPath, libDynloadPath].compactMap { $0 }.joined(separator: ":"), 1)

Py_Initialize()
PyRun_SimpleString("""print(3*5)""")
```

## WebServer

[readium/GCDWebServer](https://github.com/readium/GCDWebServer) | 10.12.2024 | 12
[Telegraph](https://github.com/Building42/Telegraph) | 01.04.2024 | 820
[yene/GCDWebServer](https://github.com/yene/GCDWebServer) | 26.12.2023 | 34
[Embassy](https://github.com/envoy/Embassy) | 30.01.2023 | 604
[swifter](https://github.com/httpswift/swifter) | 26.09.2020 | 3900
[GCDWebServer](https://github.com/swisspol/GCDWebServer) | 15.03.2020 | 6500
[Ambassador](https://github.com/envoy/Ambassador) | 11.10.2018 | 187

In case of rejection other solutions:
- Let the phone connect as a client to a remote server which host the UI
- Use TCP or Bluetooth as a connection

Note: Codea Air Code (VS Code Extension) + Codea is technical doing exactly the same.