//
//  LatLon2MGRS.m
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

#import "LatLon2MGRS.h"

@implementation LatLon2MGRS

- (id) init {
    
    self = [super init];
    if ( self != nil ) {

        digraphArrayE = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"J", @"K", @"L", @"M", @"N", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    }
    
    return self;
}

- (NSString *) convertToMGRSFromLatitude:(double) latitude Longitude:(double) longitude {
    
    [self verifyLatitude:latitude Longitude:longitude];
    [self convertFromLatitude:latitude Longitude:longitude];
    
    NSString *digraph = [self calcDigraph];
    NSString *eastingStr = [self formatIngValue:eastingValue];
    NSString *northingStr = [self formatIngValue:northingValue];

    return [NSString stringWithFormat:@"%d%@%@ %@ %@",
            longitudeZoneValue,
            (NSString *)[digraphArrayN objectAtIndex:latitudeZoneValue],
            digraph,
            eastingStr,
            northingStr];
}

-(NSString *) calcDigraph {

    int letter = floor((longitudeZoneValue - 1) * 8 + (eastingValue) / 100000.0);
    letter = letter - 24 * floor(letter / 24.0) - 1;

    NSString *digraph = (NSString *)[digraphArrayE objectAtIndex:letter];
    
    letter = floor(northingValue / 100000.0);
    if (longitudeZoneValue / 2.0 == floor(longitudeZoneValue / 2.0)) {
        
        letter = letter + 5;
    }
    
    letter = letter - 20 * floor(letter / 20.0);
    
    return  [digraph stringByAppendingString:(NSString *)[digraphArrayN objectAtIndex:letter]];
}

-(NSString *) formatIngValue:(double) value {
    
    NSString *str = [NSString stringWithFormat:@"%d", (int)round(value-100000*floor(value/100000))];
    
    if (str.length < 5) {
        
        str = [NSString stringWithFormat:@"00000%@", str];
    }
    
    return [str substringFromIndex:(str.length - 5)];
}

@end
