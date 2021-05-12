package altitude with SPARK_Mode is 

   type Altitude is range 0..30; -- meters
   type Altitude_Type is (normal, takeoff_Landing, standby);
   type Is_Landing_Gear is (fine, notFine);
   
   type Altitudometer is tagged record
      current_Altitude_Type : Altitude_Type;
      lower_Landing_Gear :Is_Landing_Gear;
   end record; 
   
   current_altitude: Altitude;
   
  function Altitude_Invariant return Boolean is
     (current_altitude >= Altitude'First and current_altitude <= Altitude'Last);
   
  procedure Accelerate_Altitude (current_altitude  : in out Altitude; This : in out Altitudometer) with
     Pre'Class => (Altitude_Invariant and  current_altitude < Altitude'Last),
     Post => (Altitude_Invariant and (current_altitude = current_altitude'Old + 1 or
             current_altitude = Altitude'Last));
   procedure Decrease_Altitude (current_altitude : in out Altitude; This : in out Altitudometer) with
     Pre'Class => (Altitude_Invariant and  current_altitude > Altitude'First),
     Post => Altitude_Invariant and (current_altitude = current_altitude'Old- 1 or
                                      current_altitude = current_altitude'Old);
   
   procedure Assign_Altutude_Mode(This : in out Altitudometer)  with
     Pre'Class =>Altitude_Invariant,
     Post => Altitude_Invariant;
   
   procedure Check_Altitude_For_Landing_Gear (This : in out Altitudometer; current_altitude :in Altitude) with 
     Pre'Class =>Altitude_Invariant,
     Post => Altitude_Invariant and ((current_altitude > 10) or (This.lower_Landing_Gear = fine));
     
end altitude;
