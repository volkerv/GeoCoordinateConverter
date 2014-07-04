//
//  LatLon2UTM.m
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

#import "LatLon2UTM.h"
#import "math.h"

@implementation LatLon2UTM

- (id) init {
    
    self = [super init];
    if ( self != nil ) {

        k = 1;
        k0 = 0.9996;
        
        equatorialRadius = 6378137.0;
        flattening = 298.2572236;
        
        a = equatorialRadius;
        f = 1 / flattening;
        b = a * (1 - f);   // polar radius
        e = sqrt(1 - pow(b, 2) / pow(a, 2));
        e0 = e / sqrt(1 - pow(e, 1));
        
        esq = (1 - (b / a) * (b / a));
        e0sq = e * e / (1 - pow(e, 2));

        digraphArrayN = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"J", @"K", @"L", @"M", @"N", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", nil];
    }
    
    return self;
}

- (NSString *) convertToUTMFromLatitude:(double) latitude Longitutde:(double) longitude {
    
    [self verifyLatitude:latitude Longitude:longitude];
    [self convertFromLatitude:latitude Longitude:longitude];

    return [NSString stringWithFormat:@"%d%@ %d %d",
            longitudeZoneValue,
            (NSString *)[digraphArrayN objectAtIndex:latitudeZoneValue],
            (int)round(eastingValue),
            (int)round(northingValue)];
}

- (void) convertFromLatitude:(double) latitude Longitude:(double) longitude {
    
    double latRad = latitude * M_PI / 180.0;
    double utmz = 1 + floor((longitude + 180) / 6); // utm zone
    double zcm = 3 + 6 * (utmz - 1) - 180; // central meridian of a zone
    double latz = 0; // zone A-B for below 80S
    
    // convert latitude to latitude zone
    if (latitude > -80 && latitude < 72) {
        
        latz = floor((latitude + 80) / 8) + 2; // zones C-W
    }
    else {
        
        if (latitude > 72 && latitude < 84) {
            
            latz = 21; // zone X
        }
        else {
            
            if (latitude > 84) {
                
                latz = 23; // zones Y-Z
            }
        }
    }
    
    double N = a / sqrt(1 - pow(e * sin(latRad), 2));
    double T = pow(tan(latRad), 2);
    double C = e0sq * pow(cos(latRad), 2);
    double A = (longitude - zcm) * M_PI / 180.0 * cos(latRad);
    
    // calculate M (USGS style)
    double M = latRad * (1.0 - esq * (1.0 / 4.0 + esq * (3.0 / 64.0 + 5.0 * esq / 256.0)));
    M = M - sin(2.0 * latRad) * (esq * (3.0 / 8.0 + esq * (3.0 / 32.0 + 45.0 * esq / 1024.0)));
    M = M + sin(4.0 * latRad) * (esq * esq * (15.0 / 256.0 + esq * 45.0 / 1024.0));
    M = M - sin(6.0 * latRad) * (esq * esq * esq * (35.0 / 3072.0));
    M = M * a; //Arc length along standard meridian
    
    // calculate easting
    double x = k0 * N * A * (1.0 + A * A * ((1.0 - T + C) / 6.0 + A * A * (5.0 - 18.0 * T + T * T + 72.0 * C - 58.0 * e0sq) / 120.0)); //Easting relative to CM
    x = x + 500000; // standard easting
    
    // calculate northing
    double y = k0 * (M + N * tan(latRad) * (A * A * (1.0 / 2.0 + A * A * ((5.0 - T + 9.0 * C + 4.0 * C * C) / 24.0 + A * A * (61.0 - 58.0 * T + T * T + 600.0 * C - 330.0 * e0sq) / 720.0)))); // from the equator
    
    if (y < 0) {
        
        y = 10000000 + y; // add in false northing if south of the equator
    }
    
    longitudeZoneValue = (int)utmz;
    latitudeZoneValue = latz;
    eastingValue = x;
    northingValue = y;
}

-(void) verifyLatitude:(double) latitude Longitude:(double) longitude {
    
    if (latitude < -90.0 || latitude > 90.0 ) {
        
        [NSException raise:NSInvalidArgumentException format:@"Latitude must be between -90 and 90 degrees."];
    }
    
    if ( longitude < -180.0 || longitude > 180.0 ) {
        
        [NSException raise:NSInvalidArgumentException format:@"Longitude must be between -180 and 180 degrees."];
    }
}

@end
