//
//  MGRS2LatLon.m
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

#import "MGRS2LatLon.h"
#import "math.h"

@implementation MGRS2LatLon

const int NUM_100K_SETS = 6;

- (id) init {
    
    self = [super init];
    if ( self != nil ) {
        
        char socl[] = { 'A', 'J', 'S', 'A', 'J', 'S' };
        SET_ORIGIN_COLUMN_LETTERS = [[NSMutableArray alloc] initWithCapacity:6];
        for (int i = 0; i < 6; i++ ) {
            
            [SET_ORIGIN_COLUMN_LETTERS addObject:[NSNumber numberWithChar:socl[i]]];
        }
        
        char sorl[] = { 'A', 'F', 'A', 'F', 'A', 'F' };
        SET_ORIGIN_ROW_LETTERS = [[NSMutableArray alloc] initWithCapacity:6];
        for (int i = 0; i < 6; i++ ) {
            
            [SET_ORIGIN_ROW_LETTERS addObject:[NSNumber numberWithChar:sorl[i]]];
        }
    }
    
    return self;
}

- (BOOL) convertMGRS:(NSString *) mgrsString ToLatitude:(double*) outLatitude Longitude:(double*) outLongitude {
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    mgrsString = [[regex stringByReplacingMatchesInString:mgrsString
                                                  options:0
                                                    range:NSMakeRange(0, mgrsString.length)
                                             withTemplate:@""] uppercaseString];
    
    int length = (int)mgrsString.length;

    int utmZoneCharIdx = isnumber( [mgrsString characterAtIndex:1] ) ? 2 : 1;
    int utmZoneNumber = [[mgrsString substringToIndex:utmZoneCharIdx] intValue];
    char utmZoneChar = [mgrsString characterAtIndex:utmZoneCharIdx];
    
    char eastingID = [mgrsString characterAtIndex:utmZoneCharIdx + 1 ];
    char northingID = [mgrsString characterAtIndex:utmZoneCharIdx + 2 ];
    
    int set = [self get100kSetForZone:utmZoneNumber];
    
    double east100k = [self getEastingFromChar:eastingID Set:set];
    double north100k = [self getNorthingFromChar:northingID Set:set];
    
    // We have a bug where the northing may be 2000000 too low.
    // How do we know when to roll over?
    while (north100k < [self getMinNorthingForZone:utmZoneChar] ) {
        
        north100k += 2000000;
    }
    
    // calculate the char index for easting/northing separator
    int i = utmZoneCharIdx + 3;
    int remainder = length - i;
    
    if (remainder % 2 != 0) {
        
        [NSException raise:NSInvalidArgumentException format:@"Valid MGRS string format: <zone><latitude band> <easting> <northing>"];
    }
    
    int sep = remainder / 2;
    
    double sepEasting = 0.0;
    double sepNorthing = 0.0;
    
    if ( sep > 0 ) {
        
        double accuracyBonus = 100000.0 / (double) pow( 10, sep );
        NSString *sepEastingString = [mgrsString substringWithRange:NSMakeRange( i, sep )];
        sepEasting = [sepEastingString doubleValue] * accuracyBonus;
        NSString *sepNorthingString = [mgrsString substringFromIndex:( i + sep )];
        sepNorthing = [sepNorthingString doubleValue] * accuracyBonus;
    }
    
    easting = sepEasting + east100k;
    northing = sepNorthing + north100k;
    
    return [self convertUTM:[NSString stringWithFormat:@"%d %c %d %d", utmZoneNumber, utmZoneChar, (int)easting, (int)northing]
                 ToLatitude:outLatitude
                  Longitude:outLongitude];
}

- (int) get100kSetForZone:(int) i {
    
    int set = i % NUM_100K_SETS;
    if (set == 0)
    {
        set = NUM_100K_SETS;
    }
    
    return set;
}

- (double) getEastingFromChar:(char) eastingChar Set:(int) set {
    
    NSArray *baseCol = SET_ORIGIN_COLUMN_LETTERS;
    int curCol = [(NSNumber *)[baseCol objectAtIndex:(set - 1)] intValue];
    float eastingValue = 100000.0;
    BOOL rewindMarker = NO;
    
    while (curCol != eastingChar) {
        
        curCol++;
        if (curCol == 'I') {
            
            curCol++;
        }
        
        if (curCol == 'O') {
            
            curCol++;
        }
        
        if (curCol > 'Z') {
            
            if (rewindMarker) {
                
                [NSException raise:@"BadCharacterException" format:@"Bad character: %c", eastingChar];
            }
            
            curCol = 'A';
            rewindMarker = true;
        }
        
        eastingValue += 100000.0;
    }
    
    return eastingValue;
}

- (double) getNorthingFromChar:(char) n Set:(int) set {

    if (n > 'V') {
        
        [NSException raise:@"NumberFormatException" format:@"MGRSPoint given invalid Northing: %c", n];
    }
    
    NSArray *baseRow = SET_ORIGIN_ROW_LETTERS;
    // rowOrigin is the letter at the origin of the set for the column
    int curRow = [(NSNumber *)[baseRow objectAtIndex:(set - 1)] intValue];
    double northingValue = 0.0;
    BOOL rewindMarker = NO;
    
    while (curRow != n) {
        
        curRow++;
        
        if (curRow == 'I') {
            
            curRow++;
        }
        
        if (curRow == 'O') {
            
            curRow++;
        }
        
        // fixing a bug making whole application hang in this loop when 'n' is a wrong character
        if (curRow > 'V') {
            
            if (rewindMarker) {
                // making sure that this loop ends
                [NSException raise:@"BadCharacterException" format:@"Bad character: %c", n];
            }
            
            curRow = 'A';
            rewindMarker = true;
        }
        northingValue += 100000.0;
    }
    
    return northingValue;
}

- (double) getMinNorthingForZone:(char) zoneLetter {
    
    double n;
    switch (zoneLetter) {
        case 'C':
            n = 1100000.0f;
            break;
        case 'D':
            n = 2000000.0f;
            break;
        case 'E':
            n = 2800000.0f;
            break;
        case 'F':
            n = 3700000.0f;
            break;
        case 'G':
            n = 4600000.0f;
            break;
        case 'H':
            n = 5500000.0f;
            break;
        case 'J':
            n = 6400000.0f;
            break;
        case 'K':
            n = 7300000.0f;
            break;
        case 'L':
            n = 8200000.0f;
            break;
        case 'M':
            n = 9100000.0f;
            break;
        case 'N':
            n = 0.0f;
            break;
        case 'P':
            n = 800000.0f;
            break;
        case 'Q':
            n = 1700000.0f;
            break;
        case 'R':
            n = 2600000.0f;
            break;
        case 'S':
            n = 3500000.0f;
            break;
        case 'T':
            n = 4400000.0f;
            break;
        case 'U':
            n = 5300000.0f;
            break;
        case 'V':
            n = 6200000.0f;
            break;
        case 'W':
            n = 7000000.0f;
            break;
        case 'X':
            n = 7900000.0f;
            break;
        default:
            n = -1.0f;
    }
    
    if (n >= 0.0) {
        
        return n;
    }
    else {
        
        [NSException raise:@"NumberFormatException" format:@"Invalid zone letter: %c", zoneLetter];
    }
    
    return -1;
}

@end
