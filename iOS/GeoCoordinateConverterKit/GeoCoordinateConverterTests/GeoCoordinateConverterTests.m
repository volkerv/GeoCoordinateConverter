//
//  GeoCoordinateConverterTests.m
//  GeoCoordinateConverterTests
//
//  Created by Volker Voecking on 29.06.14.
//  Copyright (c) 2014 VVSE. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GeoCoordinateConverter.h"
#import "TestData.h"

@interface GeoCoordinateConverterTests : XCTestCase {
    
    NSArray *testCities;
}

@end

@implementation GeoCoordinateConverterTests

- (void)setUp
{
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.

    testCities = [[NSArray alloc] initWithObjects:
                  [[TestData alloc] initWithName:@"Berlin" Latiude:52.520007 Longitude:13.404954 UTM:@"33U 391776 5820073" MGRS:@"33UUU 91776 20073"],
                  [[TestData alloc] initWithName:@"London" Latiude:51.507351 Longitude:-0.127758 UTM:@"30U 699319 5710158" MGRS:@"30UXC 99319 10158"],
                  [[TestData alloc] initWithName:@"New York" Latiude:40.712784 Longitude:-74.005941 UTM:@"18T 583964 4507349" MGRS:@"18TWL 83964 07349"],
                  [[TestData alloc] initWithName:@"San Francisco" Latiude:37.774929 Longitude:-122.419416 UTM:@"10S 551129 4181002" MGRS:@"10SEG 51129 81002"],
                  [[TestData alloc] initWithName:@"Sydney" Latiude:-33.867487 Longitude:151.20699 UTM:@"56H 334152 6251090" MGRS:@"56HLH 34152 51090"],
                  [[TestData alloc] initWithName:@"Buenos Aires" Latiude:-34.603723 Longitude:-58.381593 UTM:@"21H 373318 6170034" MGRS:@"21HUB 73318 70034"],
                  [[TestData alloc] initWithName:@"Johannesburg" Latiude:-26.204103 Longitude:28.047305 UTM:@"35J 604634 7101290" MGRS:@"35JPM 04634 01290"],
                  [[TestData alloc] initWithName:@"Kopenhagen" Latiude:55.676097 Longitude:12.568337 UTM:@"33U 347093 6172711" MGRS:@"33UUB 47093 72711"],
                  [[TestData alloc] initWithName:@"Oslo" Latiude:59.913869 Longitude:10.752245 UTM:@"32V 597983 6643116" MGRS:@"32VNM 97983 43116"],
                  nil];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInvalidLatitude
{
    GeoCoordinateConverter *converter = [GeoCoordinateConverter sharedConverter];
    
    XCTAssertThrowsSpecificNamed( [converter utmFromLatitude:-91 Longitude:0], NSException, NSInvalidArgumentException, @"expected NSInvalidArgumentException" );
    XCTAssertThrowsSpecificNamed( [converter utmFromLatitude:91 Longitude:0], NSException, NSInvalidArgumentException, @"expected NSInvalidArgumentException" );
    XCTAssertNoThrowSpecificNamed( [converter utmFromLatitude:-90 Longitude:0], NSException, NSInvalidArgumentException, @"did not expect NSInvalidArgumentException" );
    XCTAssertNoThrowSpecificNamed( [converter utmFromLatitude:90 Longitude:0], NSException, NSInvalidArgumentException, @"did not expect NSInvalidArgumentException" );
}

- (void)testLatLon2UTM
{
    GeoCoordinateConverter *converter = [GeoCoordinateConverter sharedConverter];
    
    for (TestData *city in testCities)
    {
        XCTAssertEqualObjects( city.utm,  [converter utmFromLatitude:city.latitude Longitude:city.longitude], @"%@", city.name );
    }
}

- (void)testUTM2LatLon
{
    for (TestData *city in testCities)
    {
        GeoCoordinateConverter *converter = [GeoCoordinateConverter sharedConverter];
        double latitude, longitude;
        [converter utm:city.utm ToLatitude:&latitude Longitude:&longitude];
        
        XCTAssertEqualWithAccuracy(latitude, city.latitude, 0.0001, @"%@ - Latitude", city.name);
        XCTAssertEqualWithAccuracy(longitude, city.longitude, 0.0001, @"%@ - Longitude", city.name);
    }
}

- (void)testLatLon2MGRS
{
    GeoCoordinateConverter *converter = [GeoCoordinateConverter sharedConverter];
    
    for (TestData *city in testCities)
    {
        XCTAssertEqualObjects( city.mgrs,  [converter mgrsFromLatitude:city.latitude Longitude:city.longitude], @"%@", city.name );
    }
}

-(void)testMGRS2LatLon
{
    for (TestData *city in testCities)
    {
        GeoCoordinateConverter *converter = [GeoCoordinateConverter sharedConverter];
        double latitude, longitude;
        [converter mgrs:city.mgrs ToLatitude:&latitude Longitude:&longitude];
        
        XCTAssertEqualWithAccuracy(latitude, city.latitude, 0.0001, @"%@ - Latitude", city.name);
        XCTAssertEqualWithAccuracy(longitude, city.longitude, 0.0001, @"%@ - Longitude", city.name);
    }
}

- (void)testInvalidLongitude
{
    GeoCoordinateConverter *converter = [GeoCoordinateConverter sharedConverter];
    
    XCTAssertThrowsSpecificNamed( [converter utmFromLatitude:0 Longitude:-181], NSException, NSInvalidArgumentException, @"expected NSInvalidArgumentException" );
    XCTAssertThrowsSpecificNamed( [converter utmFromLatitude:0 Longitude:181], NSException, NSInvalidArgumentException, @"expected NSInvalidArgumentException" );
    XCTAssertNoThrowSpecificNamed( [converter utmFromLatitude:0 Longitude:-180], NSException, NSInvalidArgumentException, @"did not expect NSInvalidArgumentException" );
    XCTAssertNoThrowSpecificNamed( [converter utmFromLatitude:0 Longitude:180], NSException, NSInvalidArgumentException, @"did not expect NSInvalidArgumentException" );
    
    XCTAssertThrowsSpecificNamed( [converter mgrsFromLatitude:0 Longitude:-181], NSException, NSInvalidArgumentException, @"expected NSInvalidArgumentException" );
    XCTAssertThrowsSpecificNamed( [converter mgrsFromLatitude:0 Longitude:181], NSException, NSInvalidArgumentException, @"expected NSInvalidArgumentException" );
    XCTAssertNoThrowSpecificNamed( [converter mgrsFromLatitude:0 Longitude:-180], NSException, NSInvalidArgumentException, @"did not expect NSInvalidArgumentException" );
    XCTAssertNoThrowSpecificNamed( [converter mgrsFromLatitude:0 Longitude:180], NSException, NSInvalidArgumentException, @"did not expect NSInvalidArgumentException" );
}

- (void)testInvalidUTMString
{
    GeoCoordinateConverter *converter = [GeoCoordinateConverter sharedConverter];
    double latitude, longitude;
    
    XCTAssertThrowsSpecificNamed( [converter utm:@"30U699319 5710158" ToLatitude:&latitude Longitude:&longitude], NSException, NSInvalidArgumentException, @"expected NSInvalidArgumentException" );
    XCTAssertThrowsSpecificNamed( [converter utm:@"30U 6993195710158" ToLatitude:&latitude Longitude:&longitude], NSException, NSInvalidArgumentException, @"expected NSInvalidArgumentException" );
    XCTAssertThrowsSpecificNamed( [converter utm:@"30U6993195710158" ToLatitude:&latitude Longitude:&longitude], NSException, NSInvalidArgumentException, @"expected NSInvalidArgumentException" );
    XCTAssertNoThrowSpecificNamed( [converter utm:@"30U 699319 5710158" ToLatitude:&latitude Longitude:&longitude], NSException, NSInvalidArgumentException, @"did not expect NSInvalidArgumentException" );
}

@end
