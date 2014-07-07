package com.vvse.geocoordinateconverter;

public class LatLon2UTM
{
    private double k0 = 0.9996;

    private double a;
    private double b;
    private double f;
    private double e;

    private double equatorialRadius = 6378137;
    double flattening = 298.2572236;;
    
    private double esq;
    private double e0sq;
    
    protected char[] digraphArrayN;
    
    protected int longitudeZoneValue;
    protected int latitudeZoneValue;
    protected double eastingValue;
    protected double northingValue;
    
    
    public LatLon2UTM( )
    {
        a = equatorialRadius;
        f = 1 / flattening;
        b = a * (1 - f);   // polar radius
        e = Math.sqrt(1 - Math.pow(b, 2) / Math.pow(a, 2));
        
        esq = (1 - (b / a) * (b / a));
        e0sq = e * e / (1 - Math.pow(e, 2));

        digraphArrayN = new char[] {
     		'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
        };
    }
    
    public String convertLatLonToUTM( double latitude, double longitude )
    {
        verifyLatLon( latitude, longitude );
        convert( latitude, longitude );

        return String.format( "%d%c %d %d",
                longitudeZoneValue,
                digraphArrayN[latitudeZoneValue],
                (int)Math.round( eastingValue ),
                (int)Math.round( northingValue ) );
    }
    
    protected void convert( double latitude, double longitude ) 
    {
        double latRad = latitude * Math.PI / 180.0;
        double utmz = 1 + Math.floor((longitude + 180) / 6); // utm zone
        double zcm = 3 + 6 * (utmz - 1) - 180; // central meridian of a zone
        double latz = 0; // zone A-B for below 80S
        
        // convert latitude to latitude zone
        if (latitude > -80 && latitude < 72) 
        {
            latz = Math.floor((latitude + 80) / 8) + 2; // zones C-W
        }
        else 
        {
            if (latitude > 72 && latitude < 84) 
            {
                latz = 21; // zone X
            }
            else 
            {
                if (latitude > 84) 
                {
                    latz = 23; // zones Y-Z
                }
            }
        }
        
        double N = a / Math.sqrt(1 - Math.pow(e * Math.sin(latRad), 2));
        double T = Math.pow(Math.tan(latRad), 2);
        double C = e0sq * Math.pow(Math.cos(latRad), 2);
        double A = (longitude - zcm) * Math.PI / 180.0 * Math.cos(latRad);
        
        // calculate M (USGS style)
        double M = latRad * (1.0 - esq * (1.0 / 4.0 + esq * (3.0 / 64.0 + 5.0 * esq / 256.0)));
        M = M - Math.sin(2.0 * latRad) * (esq * (3.0 / 8.0 + esq * (3.0 / 32.0 + 45.0 * esq / 1024.0)));
        M = M + Math.sin(4.0 * latRad) * (esq * esq * (15.0 / 256.0 + esq * 45.0 / 1024.0));
        M = M - Math.sin(6.0 * latRad) * (esq * esq * esq * (35.0 / 3072.0));
        M = M * a; //Arc length along standard meridian
        
        // calculate easting
        double x = k0 * N * A * (1.0 + A * A * ((1.0 - T + C) / 6.0 + A * A * (5.0 - 18.0 * T + T * T + 72.0 * C - 58.0 * e0sq) / 120.0)); //Easting relative to CM
        x = x + 500000; // standard easting
        
        // calculate northing
        double y = k0 * (M + N * Math.tan(latRad) * (A * A * (1.0 / 2.0 + A * A * ((5.0 - T + 9.0 * C + 4.0 * C * C) / 24.0 + A * A * (61.0 - 58.0 * T + T * T + 600.0 * C - 330.0 * e0sq) / 720.0)))); // from the equator
        
        if (y < 0) 
        {
            y = 10000000 + y; // add in false northing if south of the equator
        }
        
        longitudeZoneValue = (int) utmz;
        latitudeZoneValue = (int) latz;
        eastingValue = x;
        northingValue = y;
    }
    
    protected void verifyLatLon( double latitude, double longitude ) 
    {
        if (latitude < -90.0 || latitude > 90.0 || longitude < -180.0
                || longitude >= 180.0)
        {
            throw new IllegalArgumentException(
                    "Legal ranges: latitude [-90,90], longitude [-180,180).");
        }
    }

}