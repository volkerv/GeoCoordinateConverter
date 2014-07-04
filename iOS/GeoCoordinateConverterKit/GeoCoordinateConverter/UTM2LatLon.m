//
//  UTM2LatLon.m
//  GeoCoordinateConverter
//
//  Created by Volker Voecking on 22.05.14.
//  Copyright (c) 2014 VVSE. All rights reserved.
//
//  It is appreciated but not required that you give credit to Volker Voecking,
//  as the original author of this code. You can give credit in a blog post, a tweet or on
//  a info page of your app. Also, the original author appreciates letting him know if you use this code.
//
//  This code is licensed under the BSD license that is available at:
//  http://www.opensource.org/licenses/bsd-license.php
//

#import "UTM2LatLon.h"

@implementation UTM2LatLon

- (id) init {
    
    self = [super init];
    if ( self != nil ) {
        
        southernHemisphere = @"ACDEFGHJKLM";

        k = 1.0;
        k0 = 0.9996;

        equatorialRadius = 6378137.0;
        flattening = 298.2572236;
        
        a = equatorialRadius;
        f = 1 / flattening;
        b = a * (1 - f);   // polar radius
        e = sqrt(1 - pow(b, 2) / pow(a, 2));
    }
    
    return self;
}

- (NSString *) getHemisphereFromZone:(NSString*) latZone {
    
    NSString *hemisphere = @"N";
    
    NSRange range = [southernHemisphere rangeOfString:latZone];
    if ( range.location != NSNotFound ) {
        
        hemisphere = @"S";
    }
    
    return hemisphere;
}

- (BOOL) convertUTM:(NSString*) utmString ToLatitude:(double*)outLatitude Longitude:(double*)outLongitude {
    
    NSString *latZone;
    NSArray *utm = [utmString componentsSeparatedByString:@" "];
    if ( utm.count == 4 ) {
        
        zone = [(NSString *) [utm objectAtIndex:0] intValue];
        latZone = (NSString *) [utm objectAtIndex:1];
        easting = [(NSString *) [utm objectAtIndex:2] doubleValue];
        northing = [(NSString *) [utm objectAtIndex:3] doubleValue];
    }
    else {
    
        if ( utm.count == 3 ) {
            
            int utmZoneCharIdx = isnumber( [utmString characterAtIndex:1] ) ? 2 : 1;
            zone = [[(NSString *) [utm objectAtIndex:0] substringToIndex:utmZoneCharIdx] intValue];
            latZone = [(NSString *) [utm objectAtIndex:0] substringFromIndex:utmZoneCharIdx];
            
            easting = [(NSString *) [utm objectAtIndex:1] doubleValue];
            northing = [(NSString *) [utm objectAtIndex:2] doubleValue];
        }
        else {
            
            [NSException raise:NSInvalidArgumentException format:@"Valid UTM string format: <zone><latitude band> <easting> <northing>"];
        }
    }
    
    NSString *hemisphere = [self getHemisphereFromZone:latZone];
    BOOL southern = ( [hemisphere compare:@"S"] == NSOrderedSame );
    
    double esq = (1 - (b / a) * (b / a));
    double e0sq = e * e / (1.0 - pow(e, 2));
    double zcm = 3 + 6 * (zone - 1) - 180;                         // Central meridian of zone
    double e1 = (1.0 - sqrt(1 - pow(e, 2))) / (1.0 + sqrt(1 - pow(e, 2)));
    double M = 0;
    
    if (!southern) {

        M = northing / k0;    // Arc length along standard meridian.
    }
    else {
        
        M = (northing - 10000000.0) / k0;
    }
    
    double mu = M / (a * (1.0 - esq * (1.0 / 4.0 + esq * (3.0 / 64.0 + 5.0 * esq / 256.0))));
    double phi1 = mu + e1 * (3.0 / 2.0 - 27.0 * e1 * e1 / 32.0) * sin(2.0 * mu) + e1 * e1 * (21.0 / 16.0 - 55.0 * e1 * e1 / 32.0) * sin(4.0 * mu);   //Footprint Latitude
    phi1 = phi1 + e1 * e1 * e1 * (sin(6.0 * mu) * 151.0 / 96.0 + e1 * sin(8.0 * mu) * 1097.0 / 512.0);
    double C1 = e0sq * pow(cos(phi1), 2);
    double T1 = pow(tan(phi1), 2);
    double N1 = a / sqrt(1.0 - pow(e * sin(phi1), 2));
    double R1 = N1 * (1.0 - pow(e, 2)) / (1.0 - pow(e * sin(phi1), 2));
    double D = (easting - 500000.0) / (N1 * k0);
    double phi = (D * D) * (1.0 / 2.0 - D * D * (5.0 + 3.0 * T1 + 10.0 * C1 - 4.0 * C1 * C1 - 9.0 * e0sq) / 24.0);
    phi = phi + pow(D, 6) * (61.0 + 90.0 * T1 + 298.0 * C1 + 45.0 * T1 * T1 - 252.0 * e0sq - 3.0 * C1 * C1) / 720.0;
    phi = phi1 - (N1 * tan(phi1) / R1) * phi;
    
    double latitude = floor(1000000.0 * phi / (M_PI / 180.0)) / 1000000.0;
    double longitude = D * (1.0 + D * D * ((-1.0 - 2.0 * T1 - C1) / 6.0 + D * D * (5.0 - 2.0 * C1 + 28.0 * T1 - 3.0 * C1 * C1 + 8.0 * e0sq + 24.0 * T1 * T1) / 120.0)) / cos(phi1);
    longitude = zcm + longitude / (M_PI / 180.0);
    
    *outLatitude = latitude;
    *outLongitude = longitude;
    
    return true;
}

@end
