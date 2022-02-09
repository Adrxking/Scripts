<?php
/////////////////////////////////////////
// DISTANCE CALCULATOR WITH LAT AND LONG
/////////////////////////////////////////


function distance_calculator($lat1, $long1, $lat2, $long2, $unit)
{
    if (($lat1 == $lat2) && ($long1 == $long2)) {
        return 0;
    } else {
        $theta = $long1 - $long2;
        $dist = sin(deg2rad($lat1)) * sin(deg2rad($lat2)) +  cos(deg2rad($lat1)) * cos(deg2rad($lat2)) * cos(deg2rad($theta));
        $dist = acos($dist);
        $dist = rad2deg($dist);
        $miles = $dist * 60 * 1.1515;
        $unit = strtoupper($unit);

        if ($unit == "K") {
            return ($miles * 1.609344);
        } else if ($unit == "N") {
            return ($miles * 0.8684);
        } else {
            return $miles;
        }
    }
}

distance_calculator($Latitud1, $Longitud1, $Latitud2, $Longitud2, 'K')
?>