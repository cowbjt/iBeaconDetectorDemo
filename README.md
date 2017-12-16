# TL;DR
> `A iBeacon Detector`

![ibeacon senario](https://docs-assets.developer.apple.com/published/1b05f56180/6644bab4-c328-45b7-9020-2eb4ba8dadcc.png)

# Intro

## iBeacon
- A `protocol` developed by Apple
- A Bluetooth low energy (BLE) device as `Beacon`
- Beacon `broadcasts` information

## iDevices of iBeacon supported
- `iPhone4S` or later
- 3rd generation `iPad` or later
- iPad Mini or later
- 5th generation `iPod` touch or later

## BLE Advertising Packet

<table border="1" style="text-align:center;">
    <tr>
        <td rowspan="2">Preamble<br>1Byte</td>
        <td rowspan="2">Address<br>4Bytes</td>
        <td colspan="2">Protocol Data Unit<br><=39Bytes</td>
        <td rowspan="2">CRC<br>3Bytes</td>
    </tr>
    <tr>
        <td>Header<br>2Bytes</td>
        <td>Payload<br>0 ~ 37Bytes</td>
    </tr>
</table>

## Payload

<table border="1" style="text-align:center;">
    <tr style="border-bottom:2px solid;"> <!-- background:#cccccc -->
        <th>Field</th>
        <th>Size</th>
    </tr>
    <tr>
        <th>UUID</th>
        <td>16 bytes</td>
    </tr>
    <tr>
        <th>Major</th>
        <td>2 bytes</td>
    </tr>
    <tr>
        <th>Minor</th>
        <td>2 bytes</td>
    </tr>
</table>

## Example

<table border="1" style="text-align:center;">
    <tr style="border-bottom:2px solid;"> <!-- background:#cccccc -->
        <th colspan="2">Store Location</th>
        <th>San Francisco</th>
        <th>Paris</th>
        <th>London</th>
    </tr>
    <tr>
        <th colspan="2">UUID</th>
        <td colspan="3">D9B9EC1F-3925-43D0-80A9-1E39D4CEA95C</td>
    </tr>
    <tr>
        <th colspan="2">Major</th>
        <td>1</td>
        <td>2</td>
        <td>3</td>
    </tr>
    <tr>
        <th rowspan="3">Minor</th>
        <th>Clothing</th>
        <td>10</td>
        <td>10</td>
        <td>10</td>
    </tr>
    <tr>
        <th>Housewares</th>
        <td>20</td>
        <td>20</td>
        <td>20</td>
    </tr>
    <tr>
        <th>Automotive</th>
        <td>30</td>
        <td>30</td>
        <td>30</td>
    </tr>
</table>

# Programing

## Privacy Permission Settings

- NSLocationAlwaysUsageDescription

## Check Feature And Request Authorization

```swift
func checkAvailable() -> Bool {
    if !CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
        return false
    }
    if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways {
        locationManager.requestAlwaysAuthorization()
    }

    return true
}
```

## Start Monitor

```swift
guard let beaconUuid = UUID(uuidString: defaultUuid) else {
    throw AppError(msg: "Invalid UUID")
}

let r = CLBeaconRegion(proximityUUID: beaconUuid, identifier: beaconId)
r.notifyOnExit = true
r.notifyOnEntry = true
r.notifyEntryStateOnDisplay = true

locationManager.startMonitoring(for: r)
```

## Range Beacons

```swift
if !CLLocationManager.isRangingAvailable() {
    return
}
locationManager.startRangingBeacons(in: region)
```

## CLLocationManagerDelegate

```swift

locationManager.delegate = self

func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
    if beacons.count == 0 {
        return
    }

    // parse the nearest one
    parseBeacon(beacons[0], in: region)
}
```

## Beacon Information

```swift
class CLBeacon : NSObject, NSCopying, NSSecureCoding {
    var proximityUUID: UUID { get }
    var major: NSNumber { get }
    var minor: NSNumber { get }
    var proximity: CLProximity { get }
    var accuracy: CLLocationAccuracy { get }
    var rssi: Int { get }
}
```

# Reference
1. [Determining the Proximity to an iBeacon](https://developer.apple.com/documentation/corelocation/determining_the_proximity_to_an_ibeacon)
1. [Turning an iOS Device into an iBeacon](https://developer.apple.com/documentation/corelocation/turning_an_ios_device_into_an_ibeacon)
