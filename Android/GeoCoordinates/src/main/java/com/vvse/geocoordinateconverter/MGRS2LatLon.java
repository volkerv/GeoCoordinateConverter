package com.vvse.geocoordinateconverter;

import android.util.Log;

import java.util.Locale;

class MGRS2LatLon extends UTM2LatLon
{
    private final static int[] SET_ORIGIN_COLUMN_LETTERS = {'A', 'J', 'S', 'A', 'J', 'S'};
    private final static int[] SET_ORIGIN_ROW_LETTERS = {'A', 'F', 'A', 'F', 'A', 'F'};
    private final static int NUM_100K_SETS = 6;

    double[] convertMGRSToLatLong( String mgrsString )
    {
        mgrsString = mgrsString.replaceAll( "\\s+", "" ).toUpperCase( );  // remove whitespace
        int length = mgrsString.length( );

        int utmZoneCharIdx = Character.isDigit( mgrsString.charAt( 1 ) ) ? 2 : 1;
        int utmZoneNumber = Integer.parseInt( mgrsString.substring( 0, utmZoneCharIdx ) );
        char utmZoneChar = mgrsString.charAt( utmZoneCharIdx );

        char eastingID = mgrsString.charAt( utmZoneCharIdx + 1 );
        char northingID = mgrsString.charAt( utmZoneCharIdx + 2 );

        int set = get100kSetForZone( utmZoneNumber );

        double east100k = getEastingFromChar( eastingID, set );
        double north100k = getNorthingFromChar( northingID, set );

        // We have a bug where the northing may be 2000000 too low.
        // How do we know when to roll over?

        while ( north100k < getMinNorthing( utmZoneChar ) )
        {
            north100k += 2000000;
        }

        // calculate the char index for easting/northing separator
        int i = utmZoneCharIdx + 3;
        int remainder = length - i;

        if ( remainder % 2 != 0 )
        {
            // error
            Log.e( "LunaSolCal", "Unexpected remainder " );
        }

        int sep = remainder / 2;

        double sepEasting = 0f;
        double sepNorthing = 0f;

        if ( sep > 0 )
        {
            double accuracyBonus = 100000f / Math.pow( 10, sep );
            String sepEastingString = mgrsString.substring( i, i + sep );
            sepEasting = Double.parseDouble( sepEastingString ) * accuracyBonus;
            String sepNorthingString = mgrsString.substring( i + sep );
            sepNorthing = Double.parseDouble( sepNorthingString ) * accuracyBonus;
        }

        easting = sepEasting + east100k;
        northing = sepNorthing + north100k;

        return new UTM2LatLon( ).convertUTMToLatLong(
                String.format( Locale.getDefault( ), "%d %c %d %d",
                        utmZoneNumber, utmZoneChar, (int) easting, (int) northing ) );
    }

    private int get100kSetForZone( int i )
    {
        int set = i % NUM_100K_SETS;
        if ( set == 0 )
        {
            set = NUM_100K_SETS;
        }
        return set;
    }

    private double getEastingFromChar( char e, int set )
    {
        int baseCol[] = SET_ORIGIN_COLUMN_LETTERS;
        int curCol = baseCol[ set - 1 ];
        float eastingValue = 100000f;
        boolean rewindMarker = false;

        while ( curCol != e )
        {
            curCol++;
            if ( curCol == 'I' )
            {
                curCol++;
            }

            if ( curCol == 'O' )
            {
                curCol++;
            }

            if ( curCol > 'Z' )
            {
                if ( rewindMarker )
                {
                    throw new NumberFormatException( "Bad character: " + e );
                }

                curCol = 'A';
                rewindMarker = true;
            }

            eastingValue += 100000f;
        }

        return eastingValue;
    }

    private float getNorthingFromChar( char n, int set )
    {
        if ( n > 'V' )
        {
            throw new NumberFormatException( "MGRSPoint given invalid Northing " + n );
        }

        int baseRow[] = SET_ORIGIN_ROW_LETTERS;
        // rowOrigin is the letter at the origin of the set for the
        // column
        int curRow = baseRow[ set - 1 ];
        float northingValue = 0f;
        boolean rewindMarker = false;

        while ( curRow != n )
        {
            curRow++;

            if ( curRow == 'I' )
            {
                curRow++;
            }

            if ( curRow == 'O' )
            {
                curRow++;
            }

            // fixing a bug making whole application hang in this loop
            // when 'n' is a wrong character
            if ( curRow > 'V' )
            {
                if ( rewindMarker )
                { // making sure that this loop ends
                    throw new NumberFormatException( "Bad character: " + n );
                }

                curRow = 'A';
                rewindMarker = true;
            }
            northingValue += 100000f;
        }

        return northingValue;
    }

    private double getMinNorthing( char zoneLetter ) throws NumberFormatException
    {
        double northing;
        switch( zoneLetter )
        {
            case 'C':
                northing = 1100000.0f;
                break;
            case 'D':
                northing = 2000000.0f;
                break;
            case 'E':
                northing = 2800000.0f;
                break;
            case 'F':
                northing = 3700000.0f;
                break;
            case 'G':
                northing = 4600000.0f;
                break;
            case 'H':
                northing = 5500000.0f;
                break;
            case 'J':
                northing = 6400000.0f;
                break;
            case 'K':
                northing = 7300000.0f;
                break;
            case 'L':
                northing = 8200000.0f;
                break;
            case 'M':
                northing = 9100000.0f;
                break;
            case 'N':
                northing = 0.0f;
                break;
            case 'P':
                northing = 800000.0f;
                break;
            case 'Q':
                northing = 1700000.0f;
                break;
            case 'R':
                northing = 2600000.0f;
                break;
            case 'S':
                northing = 3500000.0f;
                break;
            case 'T':
                northing = 4400000.0f;
                break;
            case 'U':
                northing = 5300000.0f;
                break;
            case 'V':
                northing = 6200000.0f;
                break;
            case 'W':
                northing = 7000000.0f;
                break;
            case 'X':
                northing = 7900000.0f;
                break;
            default:
                northing = -1.0f;
        }

        if ( northing >= 0.0 )
        {
            return northing;
        }
        else
        {
            throw new NumberFormatException( "Invalid zone letter: " + zoneLetter );
        }

    }
}
