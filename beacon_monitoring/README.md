 # beacon_monitoring

A Flutter plugin for monitoring beacons in the mobile platform. Supports iOS and Android.

# Usage

## Installation

Add `beacon_monitoring` as a dependency to your pubspec.yaml:

```yaml
dependencies:
  beacon_monitoring: latest
```

## Description
The beacon monitoring plugin can execute monitoring as a foreground and background. The approach to 
implementing this method is a little different. The main difference belongs to the ways how we want to use it.

Foreground monitoring we can do by intercept event populate by stream like below:
```dart
monitoring().listen((event) {
    print("Monitoring stream received: $event");  
});
``` 

Background monitoring needs an implementation of the callback method and pass it as an argument to startBackgroundMonitoring method as below:
```dart
void backgroundMonitoringCallback(MonitoringResult result) {
    print('Background monitoring received: $result');
}

startBackgroundMonitoring(backgroundMonitoringCallback);
```

You can find full code with usage examples for the foreground and background in the project example.

## How to usage
The first thing you should do is to register the regions. The region is represented by beacon's identifier and its ids (ids is optional).

Let's assume that we have two iBeacons:
```
iBeacon one: UUID: 400CD186-C779-024B-2F19-89DCF74987E9
iBeacon two: UUID: D66BA202-6589-677F-C735-17E3856F065C
```

Registering the beacons in our plugin can be done as presented below:
```dart
import 'package:beacon_monitoring/beacon_monitoring.dart';

void activateBeacon() async{
    // now we define our region
    Region regionOne = Region(
        identifier: '400CD186-C779-024B-2F19-89DCF74987E9');
    Region regionTwo = Region(
        identifier: 'D66BA202-6589-677F-C735-17E3856F065C');
    
    List<Region> regions = [regionOne, regionTwo];
    
    // register defined regions
    await registerAllRegions(regions);
...
}
```

Now we have to implement callback where we handle all events from beacons.
```dart
// beacons are handled by this method
static void handleEventCallback(MonitoringResult result) {
    print(result.type);
}
```

Then call `startBackgroundMonitoring` method where we pass our callback:
```dart
import 'package:beacon_monitoring/beacon_monitoring.dart';

startBackgroundMonitoring(handleEventCallback);
```

The whole example code:
```dart
import 'package:beacon_monitoring/beacon_monitoring.dart';

void activateBeacon() async{
    // now we define our region
    Region regionOne = Region(
        identifier: '400CD186-C779-024B-2F19-89DCF74987E9');
    Region regionTwo = Region(
        identifier: 'D66BA202-6589-677F-C735-17E3856F065C');
    
    List<Region> regions = [regionOne, regionTwo];
    
    // register defined regions
    await registerAllRegions(regions);
    
    // here we define a method which handles the beacon's event
    startBackgroundMonitoring(handleEventCallback);
}

// beacons are handled by this method
static void handleEventCallback(MonitoringResult result) {
    print('$result');
}
```

From now on, each event related with registered beacon will be handled by `handleEventCallback` method.
if we come into a range of a beacon, the method `handleEventCallback` will be invoked with data in MonitoringResult.

## Additional info

The plugin to work requires Bluetooth and Location to be enabled. The plugin delivers methods for handling this case.
Bluetooth can be checked using `isBluetoothEnabled()` method and turn on by `openBluetoothSettings()` method for Android and `openApplicationSettings()` for iOS.
Location can be checked using `isLocationEnabled()` method and turn on by `openLocationSettings()` method for Android and `openApplicationSettings()` for iOS.
Similar approach can be used to location. Plugin has `checkLocationPermission()`, `requestLocationPermission()` and `openLocationSettings()`.

Example:
```dart
import 'package:beacon_monitoring/beacon_monitoring.dart';
import 'dart:io' show Platform;

final bluetoothEnabled = await isBluetoothEnabled();
final locationEnabled = await isLocationEnabled();
final locationPermission = await checkLocationPermission();

/// If you are using a process in the background, you should check the permission of `LocationPermission.always` instead of `LocationPermissions.whileInUse`.
if (locationPermission != LocationPermission.whileInUse) {
    await requestLocationPermission();
}

if (Platform.isAndroid) {
    if(!bluetoothEnalbed) openBluetoothSettings();
    if(!locationEnabled) openLocationSettings();
} else if (Platform.isIOS) {
    if(!bluetoothEnalbed || !locationEnabled) openApplicationSettings();
}
```
