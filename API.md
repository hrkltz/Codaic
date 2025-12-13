
# Codaic / API

This document describes the main API functions available in Codaic for node programming, hardware access, and software integration.

---

## General APIs

```lua
-- Read input from a node port
local data = System.Input(inputPortIndex)

-- Write output to a node port
System.Output(outputPortIndex, data)
```

### JSON Data Handling

```lua
-- Decode JSON data received as a string
local in0 = System.Input(0)
local dataIn = cjson.decode(in0)

-- Encode data as JSON before sending
local dataOut = 42
local out0 = cjson.encode(dataOut)
System.Output(0, out0)
```

### Sleep/Delay

```Lua
System.Sleep(milliseconds)
```

---

## Hardware APIs

### Accelerometer

```lua
-- Activate the accelerometer at a given frequency (Hz)
System.AccelerometerActivate(freqHz)

-- Read current accelerometer data (returns a table)
local accelData = System.AccelerometerRead()
-- accelData.X, accelData.Y, accelData.Z
```

### Gyroscope

```lua
-- Activate the gyroscope at a given frequency (Hz)
System.GyroscopeActivate(freqHz)

-- Read current gyroscope data (returns a table)
local gyroData = System.GyroscopeRead()
-- gyroData.X, gyroData.Y, gyroData.Z
```

### Magnetometer

```lua
-- Activate the magnetometer at a given frequency (Hz)
System.MagnetometerActivate(freqHz)

-- Read current magnetometer data (returns a table)
local magData = System.MagnetometerRead()
-- magData.X, magData.Y, magData.Z
```

---

## Software APIs

### Display

```Lua
-- Write data to the display component on the run view
System.Display(data)
```

### Log

```Lua
-- Write a message to the log component on the run view
System.Log(message)
```

### HTTP.In

```lua
-- Receive data from the HTTP server delivered via PUT @ http://<IP>:8080/
local httpIn = System.HttpIn()
```

### HTTP.Out

```lua
-- Send data to the HTTP server which can be access via GET @ http://<IP>:8080/
System.HttpOut(data)
```
