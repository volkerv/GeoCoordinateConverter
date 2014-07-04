//
//  GeoCoordinateConverter.m
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

#import "GeoCoordinateConverter.h"

@implementation GeoCoordinateConverter

+ (GeoCoordinateConverter *) sharedConverter {
    
    static GeoCoordinateConverter *sharedConverter;
    
    @synchronized(self) {
        
        if (!sharedConverter) {
            
            sharedConverter = [[GeoCoordinateConverter alloc] init];
        }
        
        return sharedConverter;
    }
}

- (id) init {
    
    self = [super init];
    if ( self != nil ) {
        
        utm2latlon = [[UTM2LatLon alloc] init];
        latlon2UTM = [[LatLon2UTM alloc] init];
        latlon2MGRS = [[LatLon2MGRS alloc] init];
        mgrs2latlon = [[MGRS2LatLon alloc] init];
    }
    
    return self;
}

- (void) utm:(NSString*) UTM ToLatitude:(double*) outLatitude Longitude:(double *) outLongitude {
    
    [utm2latlon convertUTM:UTM ToLatitude:outLatitude Longitude:outLongitude];
}

- (NSString *) utmFromLatitude:(double) latitude Longitude:(double) longitude {
    
    return [latlon2UTM convertToUTMFromLatitude:latitude Longitutde:longitude];
}

- (void) mgrs:(NSString*) MGRS ToLatitude:(double*) outLatitude Longitude:(double *) outLongitude {
    
    [mgrs2latlon convertMGRS:MGRS ToLatitude:outLatitude Longitude:outLongitude];
}

- (NSString *) mgrsFromLatitude:(double) latitude Longitude:(double) longitude {
    
    return [latlon2MGRS convertToMGRSFromLatitude:latitude Longitude:longitude];
}


@end
