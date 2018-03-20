package com.vvse.geocoordinateconverter.test;

class TestData
{
    double latitude;
    double longitude;
    String utm;
    String mgrs;
    String name;

    TestData( String name, double latitude, double longitude, String utm, String mgrs )
    {
        this.name = name;
        this.latitude = latitude;
        this.longitude = longitude;
        this.utm = utm;
        this.mgrs = mgrs;
    }
}
