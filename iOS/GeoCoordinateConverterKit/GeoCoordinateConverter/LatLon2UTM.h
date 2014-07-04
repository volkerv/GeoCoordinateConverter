//
//  LatLon2UTM.h
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

#import <Foundation/Foundation.h>

@interface LatLon2UTM : NSObject {
    
    double k;
    double k0;
    
    double a;
    double b;
    double f;
    double e;
    double e0;
    double equatorialRadius;
    double flattening;
    
    double esq;
    double e0sq;
    
    int longitudeZoneValue;
    int latitudeZoneValue;
    double eastingValue;
    double northingValue;
    
    NSArray *digraphArrayN;
}

- (void) convertFromLatitude:(double) latitude Longitude:(double) longitude;
- (NSString *) convertToUTMFromLatitude:(double) latitude Longitutde:(double) longitude;

- (void) verifyLatitude:(double) latitude Longitude:(double) longitude;
@end
