package altitude with SPARK_Mode is 

   type Altitude is range 0..12000; -- meters
   type AltitudeType is (normal, takeoffLanding, standby);
   type IsLandingGear is (fine, notFine);
   
   type Altitudometer is tagged record
      currentAltitudeType : AltitudeType;
      lowerLandingGear :IsLandingGear;
   end record; 
   
   current_altitude: Altitude;
   
  function AltitudeInvariant return Boolean is
     (current_altitude >= Altitude'First and current_altitude <= Altitude'Last);
   
  procedure accelerateAltitude (current_altitude : in out Altitude) with
     Pre => (AltitudeInvariant and  current_altitude < Altitude'Last),
     Post => AltitudeInvariant and (current_altitude = current_altitude'Old + 1 or
             current_altitude = Altitude'Last);
  
   procedure decreaseAltitude (current_altitude : in out Altitude) with
     Pre => (AltitudeInvariant and  current_altitude > Altitude'First),
     Post => AltitudeInvariant and (current_altitude = current_altitude'Old- 1 or
                                      current_altitude = current_altitude'Old);
   
   procedure AssignAltutudeMode(This : in out Altitudometer)  with
     Pre'Class =>AltitudeInvariant,
     Post => AltitudeInvariant and (This.currentAltitudeType = standBy or This.currentAltitudeType = takeoffLanding or This.currentAltitudeType = normal);
   
   procedure CheckAltitudeForLandingGear (This :in out Altitudometer) with 
     Pre'Class =>AltitudeInvariant,
     Post => (current_altitude > 25) or (This.lowerLandingGear = fine);
     
end altitude;
