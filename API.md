
# Codaic / API

This document describes the main API functions available in Codaic for node programming, hardware access, and software integration.

---

## General APIs

```Lua
-- Read input from a node port
local data = System.Input(inputPortIndex)

-- Write output to a node port
System.Output(outputPortIndex, data)
```

### JSON Data Handling

```Lua
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

### Slot Read/Write

```Lua
-- Write to a slot
System.SlotWrite("my-slot", "42")

-- Read from a slot
local mySlotDataJson = System.SlotRead("my-slot")
```

---

## Hardware APIs

### Accelerometer

```Lua
-- Activate the accelerometer at a given frequency (Hz)
System.AccelerometerActivate(freqHz)

-- Read current accelerometer data (returns a table)
local accelerometerDataJson = System.AccelerometerRead()
local accelerometerData = cjson.decode(accelerometerDataJson)
-- accelerometerData.X
-- accelerometerData.Y
-- accelerometerData.Z
```

### GPS

```Lua
-- Activate the GPS receiver
System.GPSOn()

-- Read current gps data
local gpsDataJson = System.GPSRead()
local gpsData = cjson.decode(gpsDataJson)
-- gpsData.Latitude
-- gpsData.Longitude
-- gpsData.Altitude
-- gpsData.Speed
-- gpsData.Course
-- gpsData.HorizontalAccuracy
-- gpsData.VerticalAccuracy
```

### Gyroscope

```Lua
-- Activate the gyroscope at a given frequency (Hz)
System.GyroscopeActivate(freqHz)

-- Read current gyroscope data (returns a table)
local gyroscopeDataJson = System.GyroscopeRead()
local gyroscopeData = cjson.decode(gyroscopeDataJson)
-- gyroscopeData.X
-- gyroscopeData.Y
-- gyroscopeData.Z
```

### Magnetometer

```Lua
-- Activate the magnetometer at a given frequency (Hz)
System.MagnetometerActivate(freqHz)

-- Read current magnetometer data (returns a table)
local magnometerDataJson = System.MagnetometerRead()
local magnometerData = cjson.decode(magnometerDataJson)
-- magnometerData.X
-- magnometerData.Y
-- magnometerData.Z
```

### Torch

```Lua
-- Activate the torch light
System.TorchOn()

-- Deactivate the torch light
System.TorchOff()
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
