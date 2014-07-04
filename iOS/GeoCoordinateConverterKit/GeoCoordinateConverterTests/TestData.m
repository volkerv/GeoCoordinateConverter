//
//  LatLon2UTMTestData.m
//  GeoCoordinateConverter
//
//  Created by Volker Voecking on 30.06.14.
//  Copyright (c) 2014 VVSE. All rights reserved.
//

#import "TestData.h"

@implementation TestData

-(id) initWithName:(NSString*) name Latiude:(double)latitude Longitude:(double)longitude UTM:(NSString *)utm MGRS:(NSString *)mgrs {
    
    self = [super init];
    
    if ( self != nil ) {
    
        self.name = name;
        self.latitude = latitude;
        self.longitude = longitude;
        self.utm = utm;
        self.mgrs = mgrs;
    }
    
    return self;
}

@end
