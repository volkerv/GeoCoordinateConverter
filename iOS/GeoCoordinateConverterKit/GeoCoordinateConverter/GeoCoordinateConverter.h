//
//  GeoCoordinateConverter.h
//  GeoCoordinateConverter
//
//  Created by Volker Voecking on 29.06.14.
//  Copyright (c) 2014 VVSE. All rights reserved.
//
//  It is appreciated but not required that you give credit to Volker Voecking,
//  as the original author of this code. You can give credit in a blog post, a tweet or on
//  a info page of your app. Also, the original author appreciates letting him know if you use this code.
//
//  This code is licensed under the BSD license that is available at:
//  http://www.opensource.org/licenses/bsd-license.php
//


#import <Foundation/Foundation.h>
#import "UTM2LatLon.h"
#import "LatLon2UTM.h"
#import "LatLon2MGRS.h"
#import "MGRS2LatLon.h"

@interface GeoCoordinateConverter : NSObject {
    
    UTM2LatLon *utm2latlon;
    LatLon2UTM *latlon2UTM;
    LatLon2MGRS *latlon2MGRS;
    MGRS2LatLon *mgrs2latlon;
}

+ (GeoCoordinateConverter *)sharedConverter;

- (void) utm:(NSString*) UTM ToLatitude:(double*) outLatitude Longitude:(double *) outLongitude;
- (NSString *) utmFromLatitude:(double) latitude Longitude:(double) longitude;
- (void) mgrs:(NSString*) MGRS ToLatitude:(double*) outLatitude Longitude:(double *) outLongitude;
- (NSString *) mgrsFromLatitude:(double) latitude Longitude:(double) longitude;

@end

