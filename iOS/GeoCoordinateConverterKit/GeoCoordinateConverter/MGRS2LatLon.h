//
//  MGRS2LatLon.h
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
#import "UTM2LatLon.h"

@interface MGRS2LatLon : UTM2LatLon {
    
    NSMutableArray *SET_ORIGIN_COLUMN_LETTERS;
    NSMutableArray *SET_ORIGIN_ROW_LETTERS;
}

- (BOOL) convertMGRS:(NSString *) mgrsString ToLatitude:(double*) outLatitude Longitude:(double*) outLongitude;

@end
