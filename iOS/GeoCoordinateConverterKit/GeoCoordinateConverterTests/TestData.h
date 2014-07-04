//
//  LatLon2UTMTestData.h
//  GeoCoordinateConverter
//
//  Created by Volker Voecking on 30.06.14.
//  Copyright (c) 2014 VVSE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestData : NSObject

@property double latitude;
@property double longitude;
@property (strong) NSString *utm;
@property (strong) NSString *mgrs;
@property (strong) NSString *name;


-(id) initWithName:(NSString*) name Latiude:(double)latitude Longitude:(double)longitude UTM:(NSString *)utm MGRS:(NSString *)mgrs;
@end
