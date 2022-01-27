<?php
////////////////////////////////////////
/// GET CURRENT DATE
////////////////////////////////////////
date("d/m/Y"); // 26/01/2022
date("d.m.Y"); // 26.01.2022
date("d-m-Y"); // 26-01-2022
date("l"); // Wednesday

$Object = new DateTime();  
$Object->setTimezone(new DateTimeZone('Europe/Madrid'));

$DateAndTime = $Object->format("d-m-Y"); // 26-01-2022
$DateAndTimeTimestamp = $Object->format("U"); // UNIX Timestamp

////////////////////////////////////////
/// GET CURRENT TIME
////////////////////////////////////////
date_default_timezone_set("Europe/Madrid");
date("h:i:sa") // 21:58:16pm

////////////////////////////////////////
/// TRANSFORM DATE TO TIMESTAMP
////////////////////////////////////////
# From 26/01/2022 to UNIX
$finTimestamp = DateTime::createFromFormat("d/m/Y", $finTemporada);
$finTimestamp = $finTimestamp->format("U");

?>