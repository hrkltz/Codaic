# Codaic / iOS

## Add Python To iOS App

Source 1: https://github.com/beeware/Python-Apple-support/blob/main/USAGE.md
Source 2: https://docs.python.org/3/using/ios.html#adding-python-to-an-ios-project

1. Download [Python-3.13-iOS-support.b6.tar.gz](https://github.com/beeware/Python-Apple-support/releases/download/3.13-b6/Python-3.13-iOS-support.b6.tar.gz)
2. Put it inside the Support folder
3. Targets -> Codaic -> General
3.1. Python.xcframework: Embed&Sign
4. Add Bridging-Header.h: #import <Python/Python.h>
5. Targets -> Codaic -> Build Settings (Note: Select All)
5.1. "Objective-C Bridging-Header" == "Codaic/Bridging-Header.h"
5.2. "User Script Sandboxing" == "No"
5.3. "Enable Testability" == "Yes"
5.4. "Header Search Path" == "$(BUILT_PRODUCTS_DIR)/Python.framework/Headers"
6. Targets -> Codaic -> Build Phases
5.1. Add "New Run Script Phase"
5.2. Past following content:
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

Run python:
```Swift
guard let pythonPath = Bundle.main.path(forResource: "python/lib/python3.13", ofType: nil) else { return }
guard let libDynloadPath = Bundle.main.path(forResource: "python/lib/python3.13/lib-dynload", ofType: nil) else { return }
setenv("PYTHONPATH", [pythonPath, libDynloadPath].compactMap { $0 }.joined(separator: ":"), 1)

Py_Initialize()
PyRun_SimpleString("""print(3*5)""")
```