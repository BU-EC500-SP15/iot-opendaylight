# Compass
Compass lets you find other device locations in real time using iBeacons, Cisco CMX, GPS and OpenDaylight



## Requirements
* Xcode 6.2
* iOS 8.0+



### User Registration
*Note: A single device cannot be registered with multiple UserIDs. However, one UserID may register multiple devices.*



#### Signup Process
1. User succesfully creates a username called `newUserId` *(for example)* using `LoginViewController`

2. A container with `"resourceID":"newUserID"` is created under `InCSE1/UserAE/` 

3. A container with `"resourceID":"deviceMACAddress"` is created under `InCSE1/UserAE/newUserID/` and `InCSE1/LocationAE/Things/`

4. Four containers with resourceIDs: `LocBeacon`, `LocCMX`, `LocGPS`, and `AccuracyFlag` are created under `InCSE1/LocationAE/Things/deviceMACAddress/`



### Updating Location Data
#### Prioritization
1. `LocBeacon` content instances describe the device's [Estimote Indoor SDK](https://github.com/Estimote/iOS-Indoor-SDK) map position 
  * `(x,y,σ) and Map ID`
  
2. `LocCMX` content instances describe the device's CMX floor map position 
  * `(X,Y) and Map ID`
  
3. `LocGPS` content instances describe the device's Latitude and Longitude position 
  * `(Lat,Long)`
  


#### iBeacons
Compass uses Estimote's `BeaconManager` to monitor beacon ranges and indoor location positions.

  * While app is in foreground
    * Uses the `ESTBeaconManagerDelegate` method `didRangeBeacons` to determine if a device is in range of a iBeacon
    * Uses the `ESTIndoorLocationManagerDelegate` method `didUpdatePosition:inLocation` to determine the position of the device inside the indoor map
  
  * While app is in background
    * Uses the `ESTBeaconManagerDelegate` methods `didEnterRegion` and `didExitRegion` to determine if a device is near a beacon region in order to reduce power consumption


#### CMX
Compass uses the CMX plugin to `POST` updated coordinate positions on indoor map images provided by CMX API.


#### GPS
Compass uses the iOS `CLLocationManager` to monitor the `Current Location` (latitude, longitude) of the device.

  * While app is in foreground
    * Desired accuracy is set to `kCLLocationAccuracyBest` to provide better location detection
  
  * While app is in background
    * Desired accuracy is set to `kCLLocationAccuracyHundredMeters` to reduce strain on iOS



### MBSwiftPostman
This class's functions are triggered when a device's position is updated using RESTful commands `POST` and `PUT` . 

* Creating/POSTs new content instances for each `Loc` container
* Updating/PUTs a new flag label for the  `AccuracyFlag` container



### Accuracy Flag
An `AccuracyFlag` container is created with it's `labels` attribute set to a 3-bit binary number in order to prioritize location accuracy for each `UUID` or `deviceMACAddress` container under `InCSE1/LocationAE/Things/`.

* If labels[:1] == 1, then the `LocBeacon` container has the most accurate device position
* If labels[:2] == 01, then the `LocCMX` container has the most accurate device position
* If labels[:3] == 001, then `LocGPS` container has the most accuracte device position
* Else, the device's position could not be found


###### AccuracyFlag Example
1. *A device's GPS location is recorded*

  * `MBSwiftPostman` updates (`PUT`) the device's `UUID` container `label` attribute to `001`.
  * `MBSwiftPostman` creates (`POST`) a new content instance with the device's latitude and longitude under `LocGPS`.

2. *The device is queried by another user*

  * The search function `GET`s the device's `UUID` container and parses the `label` attribute
  * The `label` is returned to the `getMostAccurateLocation` function and the switch `case 001:` is invoked
  * The latest content instance in `LocGPS` is retrieved and passed to a displaying function for the map view
  * This process is continuously repeated to monitor the queried device's position

3. *The device enters an iBeacon indoor location.* 

  * `MBSwiftPostman` updates (`PUT`) the device's `UUID` container `label` attribute to `101`.
  * `MBSwiftPostman` creates (`POST`) a new content instance with the device's indoor position under `LocBeacon`. 
  * The search function `GET`s the device's `UUID` container and parses the changed `label` attribute
  * The `label` is returned to the `getMostAccurateLocation` function and the switch `case 1xx:` is invoked
  * The latest content instance in `LocBeacon` is retrieved and passed to a displaying function for the indoor map view
  * This process is continuously repeated to monitor the queried device's position . . .

