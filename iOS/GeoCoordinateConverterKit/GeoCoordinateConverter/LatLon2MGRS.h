//
//  LatLon2MGRS.h
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
#import "LatLon2UTM.h"

@interface LatLon2MGRS : LatLon2UTM {
    
    NSArray *digraphArrayE;
}

- (NSString *) convertToMGRSFromLatitude:(double) latitude Longitude:(double) longitude;

@end
