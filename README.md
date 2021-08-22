# SunCalc

A Swift Package for calculation of Sun and Moon positions and phases.

This project is based on the [Java version](https://github.com/shred/commons-suncalc) written by Richard "Shred" Körber, and shared under the [Apahce License 2.0](http://www.apache.org/licenses/LICENSE-2.0).

## Accuracy
Astronomical calculations are far more complex than throwing a few numbers into an obscure formula and then getting a fully accurate result. There is always a tradeoff between accuracy and computing time.

This library has its focus on getting _acceptable_ results at low cost, so it can also run on mobile devices, or devices with a low computing power. The results have an accuracy of about a minute, which should be good enough for common applications (like sunrise/sunset timers), but is probably not sufficient for astronomical purposes.

If you are looking for the highest possible accuracy, you are looking for a different library.

## Quick start
This library consists of several models for calculation:
* SunTimes
* MoonTimes
* SunPosition
* MoonPosition
* MoonPhase
* MoonIllumination

All models are invoked using the same pattern:
```swift
let location = // Coordinates (see LocationParameter.swift)
let dateTime = // DateTime object or timestamp (see TimeParameter.swift)

let result = try SunTimes.compute()
                            .on(dateTime)
                            .at(location)
                            .execute()
                            
if let rise = result.rise, let set = result.set {
    print("Sunrise: \(rise)")
    print("Sunset: \(set)")
}
```

For more examples, please see the [ExamplesTest.swift](#) file.

## Usage
For every model, there are several parameters that can be set and used in calculation. These parameters are defined in these three files:
* [GenericParameter.swift]()
* [LocationParameter.swift]()
* [TimeParameter.swift]()
* [Twilight.swift]
* [Phase.swift]


### GenericParameter
* `copy()`: Creates a copy of the builder it is invoked on, which can then be used in another builder.

### LocationParameter
* `latitude(_ lat: Double)`: Sets the latitude (deg) only.
* `longitude(_ lng: Double)`: Sets the longitude (deg) only.
* `height(_ h: Double)`: Sets the height in meters above sea level. Sea level is used by default.
* `at(_ lat: Double, _ lng: Double)`: Sets the latitude and longitude, in degrees.
* `at(_ coords: [Double])`: Sets the latitude and longitude, in degrees. `coords` must contain two Doubles.
* `latitude(d: Double, m: Double, s: Double)`: Sets latitude in degrees, minutes, seconds and fraction of seconds.
* `longitude(d: Double, m: Double, s: Double)`: Sets longitude in degrees, minutes, seconds and fraction of seconds.
* `sameLocationAs<P: LocationParameter>(_ l: P)`: Sets the latitude, longitude, and height to the same as another Builder that also has these.

**WARNING**: Location parameters are not mandatory for any calculation, however, if omitted [Null Island](https://en.wikipedia.org/wiki/Null_Island) will be used.

**NOTE**: `height`cannot be negative. If you pass in a negative height, it is silently changed to the accepted minimum of 0 meters. For this reason, it is safe to pass coordinates from satellite-based navigation systems without range checking.

### TimeParameter
* `on(year: Int, month: Int, date: Int)`: Last midnight of the given date. Note that `month` is counted from 1 (1 = January, 2 = February, …).
* `on(year: Int, month: Int, date: Int, hour: Int, minute: Int, second: Int)`: Given date and time.
* `on(_ dateTime: DateTime)`: Given date, time, and timezone.
* `on(_ date: Date, timeZoneID: String)`: Date and time as given in a `Date`. Attempts to set timezone corresponding to `timeZoneID`.
* `on(_ date: Date, timeZone: TimeZone)`: Date and time as given in a `Date`. Sets timezone to the `TimeZone`.
* `on(_ date: Date)`: Date and time as given in a `Date`. No timezone is set.
* `plusDays(_ days: Double)`: Adds the given number of days to the current date. `days` can also be negative, of course.
* `plusDays(_ days: Int)`: Adds the given number of days to the current date. `days` can also be negative, of course.
* `now()`: The current system date and time. This is the default.
* `midnight()`: Last midnight of the current date. It just truncates the time.
* `today()`: Identical to `.now().midnight()`.
* `tomorrow()`: Identical to `today().plusDays(1)`.
* `timezone(_ tz: TimeZone)`: Sets the timezone. Setting the timezone does not change the local time. For example, 6:50 GMT will be 6:50 CET after changing timezone to CET).
* `timezone(_ id: String)`: Same as above, but accepts a `String` for your convenience.
* `localTime()`: The system's timezone. This is the default.
* `utc()`: UTC timezone. Identical to `timezone("UTC")`.
* `sameTimeAs<P: TimeParameter>(_ t: P)`: Copies the current date, time, and timezone from any other builder. Note that subsequent changes to the other object are not adopted.

**NOTE**: If no time-based parameter is given, the current date and time, and the system's time zone is used.

**NOTE**: The accuracy of the results is decreasing for dates that are far in the future, or far in the past

### Twilight
By default, [`SunTimes.swift`](#) calculates the time of the visual sunrise and sunset. This means that  the `rise` property contains the DateTime when the Sun just starts to rise above the horizon, and `set` contains the DateTime when the Sun just disappeared from the horizon. [Atmospheric refraction](https://en.wikipedia.org/wiki/Atmospheric_refraction) is taken into account.

There are other interesting [twilight](https://en.wikipedia.org/wiki/Twilight) angles available. You can set them via the `twilight()` parameter, by using one of the [`Twilight.swift`](#) constants:

| Constant       | Description | Angle of the Sun | Topocentric |
| -------------- | ----------- | ----------------:|:-----------:|
| `visual`       | The moment when the visual upper edge of the sun crosses the horizon. This is the default. | | yes |
| `visualLower`  | The moment when the visual lower edge of the sun crosses the horizon. | | yes |
| `astronomical` | [Astronomical twilight](https://en.wikipedia.org/wiki/Twilight#Astronomical_twilight) | -18° | no |
| `nautical`     | [Nautical twilight](https://en.wikipedia.org/wiki/Twilight#Nautical_twilight) | -12° | no |
| `civil`        | [Civil twilight](https://en.wikipedia.org/wiki/Twilight#Civil_twilight) | -6° | no |
| `horizon`      | The moment when the center of the sun crosses the horizon. | 0° | no |
| `goldenHour`   | Transition from daylight to [Golden Hour](https://en.wikipedia.org/wiki/Golden_hour_%28photography%29) | 6° | no |
| `blueHour`     | Transition from [Golden Hour](https://en.wikipedia.org/wiki/Golden_hour_%28photography%29) to [Blue Hour](https://en.wikipedia.org/wiki/Blue_hour) | -4° | no |
| `nightHour`   | Transition from [Blue Hour](https://en.wikipedia.org/wiki/Blue_hour) to night | -8° | no |

If you want to get the duration of a twilight, you need to calculate the times of both transitions of the twilight. For example, to get the beginning and ending of the civil twilight, you need to calculate both the `visual` and the `civil` twilight transition times.

Alternatively you can also pass any other angle (in degrees) to `twilight()`.

**NOTE**: Only `visual` and `visualLower` are topocentric. They refer to the visual edge of the Sun, take account of the `height` parameter, and compensate for atmospheric refraction. All other twilights are geocentric and heliocentric. The `height` parameter is then ignored, and atmospheric refraction is not compensated.

### Phase
By default, [`MoonPhase.swift`](#) calculates the date of the next new moon. If you want to compute the date of another phase, you can set it via the `phase()` parameter, by using one of the [`Phase.swift`](#) constants:

| Constant          | Description | Angle |
| ----------------- | ----------- | -----:|
| `newMoon`         | Moon is not illuminated (new moon). This is the default. | 0° |
| `waxingCrescent`  | Waxing crescent moon. | 45° |
| `firstQuarter`    | Half of the waxing moon is illuminated. | 90° |
| `waxingGibbous`   | Waxing gibbous moon. | 135° |
| `fullMoon`        | Moon is fully illuminated. | 180° |
| `waningGibbous`   | Waning gibbous moon. | 225° |
| `lastQuarter`     | Half of the waning moon is illuminated. | 270° |
| `waningCrescent`  | Waning crescent moon. | 315° |

Alternatively you can also pass any other angle (in degrees) to `phase()`.

## References
This libarary is based on:
* "Astronomy on the Personal Computer", 4th edition, by Oliver Montenbruck and Thomas Pfleger
* "Astronomical Algorithms" by Jean Meeus

All original formulas and calculations are implemented by Richard "Shred" Körber in the original [Java version](https://github.com/shred/commons-suncalc).

## Contribute
* Fork the [source code on GitHub](https://github.com/nikolajjensen/SunCalc). Feel free to send pull requests.
* Found a bug? Please file a bug report.

## License
_SunCalc_ is open source software. The source code is distributed under the terms of the [Apahce License 2.0](http://www.apache.org/licenses/LICENSE-2.0).
