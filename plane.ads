with door; use door;
with fuel; use fuel;
with speed; use speed;

package plane with SPARK_Mode is

   type Altitude is range 0..12000; --Altitite is in meters
   
   type PlaneMode is (landing, takeOff, normal, standBy);
   type LandingGear is (lowered, unlowered);
   type Engine is(on, off);
   type Towing is(on, off);
   
   curr_Plane_mode : PlaneMode := normal;
   curr_land_gear : LandingGear := unlowered;
   curr_Engine : Engine := on;
   curr_tow :Towing := off;
   curr_Altitute : Altitude := 11000;
   curr_Fuel : PlaneFuelTank := (status => Sufficient, warning => off);
   curr_speed :Speedometer := (current_speed => 885);
  
   --Invariants
   function ALtitudeInvariant(curr: in Altitude) return Boolean is 
     (curr <= Altitude'Last and curr >=Altitude'First);
   
   --Check Doors returns Boolean if they are closed and locked
   function TakeOffModeDoorCheck (curr_Plane_mode : PlaneMode) return Boolean with
     Global => (Input => doorsLockedAndClosed),
   --  Pre'Class => This.current_planeMode = takeOff and doorsLockedAndClosed = True,
      Pre => (doorsLockedAndClosed = False or curr_Plane_mode /= takeOff) and (doorsLockedAndClosed = True or curr_Plane_mode = takeOff),
     Contract_Cases => (doorsLockedAndClosed = False and curr_Plane_mode = takeOff  => TakeOffModeDoorCheck'Result = False,
                        doorsLockedAndClosed = True and curr_Plane_mode = takeOff=> TakeOffModeDoorCheck'Result = True,
                        curr_Plane_mode /= takeOff => TakeOffModeDoorCheck'Result = False);
   
   --Does not allow plane to take off if doors are not closed and locked
   procedure TakeOffDoors(curr_Plane_mode : in out PlaneMode) with 
     Global => (Input => doorsLockedAndClosed),
     Pre => curr_Plane_mode = takeOff;
   
   --Does not allow plane to take off if fuel is bellow minimum
   procedure TakeOffModeFuel (curr_Plane_mode :  in out PlaneMode; curr_Fuel : in PlaneFuelTank) with
     Pre => curr_Fuel.status = Low or curr_Plane_mode = takeOff,
     Post => curr_Fuel.status /= Low or curr_Plane_mode /= takeOff;
   
   -- If during flight plane has low fuel it wil turn the warning light on
   procedure WarniningDuringFlight(curr_Plane_mode : in PlaneMode; curr_Fuel : in out PlaneFuelTank) with
     Pre =>(curr_Fuel.status /= Low or curr_Fuel.warning = on) and curr_Fuel.FuelInvariant,
     Post => (curr_Fuel.status /= Low or curr_Fuel.warning = on) and curr_Fuel.FuelInvariant;
   
   
   
end plane;
