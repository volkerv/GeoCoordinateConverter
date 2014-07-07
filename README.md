GeoCoordinateConverter
======================

Convert between different representations of WGS-84 based geographic coordinates


Supported representations:

* Latitude/Longitude 
* UTM
* MGRS

<br/>  

  
##iOS (Objective-C)


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

<br/>
##Android (Java)


#### How to include it?

If you’re using the Eclipse Development Environment with the ADT plugin version 0.9.7 or greater you can include `GeoCoordinateConverter` as a library project.  

Create a new Android project in Eclipse using the `GeoCoordinateConverterLibrary` folder as the existing source. Then, in your project properties, add the created project under the ‘Libraries’ section of the ‘Android’ category.


#### How to you use it?
You use the functionality through the GeoCoordinateConverter class which provides four conversion methods:

`public double[] utm2LatLon(String UTM)`  
`public String latLon2UTM(double latitude, double longitude)`  
`public String latLon2MGRS(double latitude, double longitude)`  
`public double[] mgrs2LatLon(String MGRS)`  

e.g.:

	double latitude = 51.507351; 
	double longitude = -0.127758;

	GeoCoordinateConverter converter = GeoCoordinateConverter.getInstance( );
	String utm = converter.latLon2UTM( city.latitude, city.longitude );

UTM coordinate strings are expected to be in this format:  
`<zone><latitude band> <easting> <northing>` (e.g.: 30U 699319 5710158)

MGRS coordinate strings are expected to be in this format:  
`<zone><latitude band> <easting> <northing>` (e.g.: 30UXC 99319 10158)  
