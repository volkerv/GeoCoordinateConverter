GeoCoordinateConverter
======================

Convert between different representations of WGS-84 based geographic coordinates


Supported representations:

* Latitude/Longitude 
* UTM
* MGRS

<br/>  

  
##iOS


#### How to include it?
Copy the `GeoCoordinateConverter` folder into your project and drag the files right into your application. 

#### How to you use it?
You use the functionality through the GeoCoordinateConverter class which provides four conversion methods:

`- (void) utm:(NSString*) UTM ToLatitude:(double*) outLatitude Longitude:(double *) outLongitude;`  
`- (NSString *) utmFromLatitude:(double) latitude Longitude:(double) longitude;`  
`- (void) mgrs:(NSString*) MGRS ToLatitude:(double*) outLatitude Longitude:(double *) outLongitude;`  
`- (NSString *) mgrsFromLatitude:(double) latitude Longitude:(double) longitude;` 

e.g.:

	double latitude = 51.507351; 
	double longitude = -0.127758;

    GeoCoordinateConverter *converter = [GeoCoordinateConverter sharedConverter];
    NSString *utm = [converter utmFromLatitude:latitude Longitude:longitude];


UTM coordinate strings are expected to be in this format:  
`<zone><latitude band> <easting> <northing>` (e.g.: 30U 699319 5710158)

MGRS coordinate strings are expected to be in this format:  
`<zone><latitude band> <easting> <northing>` (e.g.: 30UXC 99319 10158)  

