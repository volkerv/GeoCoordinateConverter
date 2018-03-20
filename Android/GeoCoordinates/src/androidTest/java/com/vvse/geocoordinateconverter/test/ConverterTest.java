package com.vvse.geocoordinateconverter.test;

import com.vvse.geocoordinateconverter.GeoCoordinateConverter;

import org.junit.Before;
import org.junit.Test;

import junit.framework.Assert;

public class ConverterTest
{
    private TestData[] testData;

    @Before
    public void setUp( ) throws Exception
    {
        testData = new TestData[]{
                new TestData( "Berlin", 52.520007, 13.404954, "33U 391776 5820073", "33UUU 91776 20073" ),
                new TestData( "London", 51.507351, -0.127758, "30U 699319 5710158", "30UXC 99319 10158" ),
                new TestData( "New York", 40.712784, -74.005941, "18T 583964 4507349", "18TWL 83964 07349" ),
                new TestData( "San Francisco", 37.774929, -122.419416, "10S 551129 4181002", "10SEG 51129 81002" ),
                new TestData( "Sydney", -33.867487, 151.20699, "56H 334152 6251090", "56HLH 34152 51090" ),
                new TestData( "Buenos Aires", -34.603723, -58.381593, "21H 373318 6170034", "21HUB 73318 70034" ),
                new TestData( "Johannesburg", -26.204103, 28.047305, "35J 604634 7101290", "35JPM 04634 01290" ),
                new TestData( "Kopenhagen", 55.676097, 12.568337, "33U 347093 6172711", "33UUB 47093 72711" ),
                new TestData( "Oslo", 59.913869, 10.752245, "32V 597983 6643116", "32VNM 97983 43116" ),
                new TestData( "Indian Ocean", -16.70462, 71.97212, "42K 816973 8150756", "42KZG 16973 50756" ),
        };
    }

    @Test
    public void testUtm2LatLon( )
    {
        for( TestData city : testData )
        {
            GeoCoordinateConverter converter = GeoCoordinateConverter.getInstance( );
            double[] result = converter.utm2LatLon( city.utm );

            double latitude = result[ 0 ];
            double longitude = result[ 1 ];

            Assert.assertEquals( city.name, latitude, city.latitude, 0.0001 );
            Assert.assertEquals( city.name, longitude, city.longitude, 0.0001 );
        }
    }

    @Test
    public void testLatLon2UTM( )
    {
        for( TestData city : testData )
        {
            GeoCoordinateConverter converter = GeoCoordinateConverter.getInstance( );

            String utm = converter.latLon2UTM( city.latitude, city.longitude );
            Assert.assertEquals( city.name, utm, city.utm );
        }
    }

    @Test
    public void testMgrs2LatLon( )
    {
        for( TestData city : testData )
        {
            GeoCoordinateConverter converter = GeoCoordinateConverter.getInstance( );
            double[] result = converter.mgrs2LatLon( city.mgrs );

            double latitude = result[ 0 ];
            double longitude = result[ 1 ];

            Assert.assertEquals( city.name, latitude, city.latitude, 0.0001 );
            Assert.assertEquals( city.name, longitude, city.longitude, 0.0001 );
        }
    }

    @Test
    public void testLatLon2MGRS( )
    {
        for( TestData city : testData )
        {
            GeoCoordinateConverter converter = GeoCoordinateConverter.getInstance( );

            String mgrs = converter.latLon2MGRS( city.latitude, city.longitude );
            Assert.assertEquals( city.name, mgrs, city.mgrs );
        }
    }

    @Test
    public void testInvalidLatitude( )
    {
        GeoCoordinateConverter converter = GeoCoordinateConverter.getInstance( );

        try
        {
            converter.latLon2UTM( -91, 0 );
            Assert.fail( );
        }
        catch( IllegalArgumentException ignored )
        {
        }

        try
        {
            converter.latLon2UTM( 91, 0 );
            Assert.fail( );
        }
        catch( IllegalArgumentException ignored )
        {
        }

        try
        {
            converter.latLon2MGRS( -91, 0 );
            Assert.fail( );
        }
        catch( IllegalArgumentException ignored )
        {
        }

        try
        {
            converter.latLon2MGRS( 91, 0 );
            Assert.fail( );
        }
        catch( IllegalArgumentException ignored )
        {
        }

        try
        {
            converter.latLon2UTM( -90, 0 );
            converter.latLon2UTM( 90, 0 );

            converter.latLon2MGRS( -90, 0 );
            converter.latLon2MGRS( 90, 0 );
        }
        catch( IllegalArgumentException ex )
        {
            Assert.fail( );
        }
    }

    @Test
    public void testInvalidLongitude( )
    {
        GeoCoordinateConverter converter = GeoCoordinateConverter.getInstance( );

        try
        {
            converter.latLon2UTM( 0, -180 );
        }
        catch( IllegalArgumentException ignored )
        {
            Assert.fail( );
        }

        try
        {
            converter.latLon2UTM( 0, 180 );
            Assert.fail( );
        }
        catch( IllegalArgumentException ignored )
        {
        }

        try
        {
            converter.latLon2MGRS( 0, -180 );
        }
        catch( IllegalArgumentException ignored )
        {
            Assert.fail( );
        }

        try
        {
            converter.latLon2MGRS( 0, 180 );
            Assert.fail( );
        }
        catch( IllegalArgumentException ignored )
        {
        }

        try
        {
            converter.latLon2UTM( 0, 179 );
            converter.latLon2UTM( 0, 179 );

            converter.latLon2MGRS( 0, 179 );
            converter.latLon2MGRS( 0, 179 );
        }
        catch( IllegalArgumentException ex )
        {
            Assert.fail( );
        }
    }

    @Test
    public void testInvalidUTMString( )
    {
        GeoCoordinateConverter converter = GeoCoordinateConverter.getInstance( );

        try
        {
            @SuppressWarnings( "unused" )
            double[] result = converter.utm2LatLon( "30U 6993195710158" );
            Assert.fail( );
        }
        catch( IllegalArgumentException ignored )
        {
        }

        try
        {
            @SuppressWarnings( "unused" )
            double[] result = converter.utm2LatLon( "30U699319 5710158" );
            Assert.fail( );
        }
        catch( IllegalArgumentException ignored )
        {
        }

        try
        {
            @SuppressWarnings( "unused" )
            double[] result = converter.utm2LatLon( "30U6993195710158" );
            Assert.fail( );
        }
        catch( IllegalArgumentException ignored )
        {
        }


        try
        {
            @SuppressWarnings( "unused" )
            double[] result = converter.utm2LatLon( "30U 699319 5710158" );
        }
        catch( IllegalArgumentException ex )
        {
            Assert.fail( );
        }
    }
}
