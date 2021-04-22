with door; use door;
with fuel; use fuel;
with speed; use speed;
with altitude; use altitude;

package plane with SPARK_Mode is
   
   type PlaneMode is (takeoffLanding, normal, standBy);
   type LandingGear is (lowered, unlowered);
   type Engine is(on, off);
   type Towing is(on, off);
   
   curr_Plane_mode : PlaneMode := normal;
   curr_land_gear : LandingGear := unlowered;
   curr_Engine : Engine := on;
   curr_tow :Towing := off;
   curr_Fuel : PlaneFuelTank := (status => Sufficient, warning => off);
   curr_speed :Speedometer := (currentSpeedType => normal);
   curr_altitude : Altitudometer := (currentAltitudeType => normal, lowerLandingGear => notFine);
   
   --Invariant
    function EngineTowInvariant return Boolean is
     (curr_Engine = on or curr_tow = on);
   
   function EngineInvariant return Boolean is
     ((curr_Engine = on and (curr_Plane_mode = takeoffLanding or curr_Plane_mode = normal)) or curr_tow = on);
   
   function FlyModeDoors return Boolean is
      (doorsLockedAndClosed = True and curr_Plane_mode = normal);
   
   --Check Doors returns Boolean if they are closed and locked
   function TakeOffModeDoorCheck (curr_Plane_mode : PlaneMode) return Boolean with
     Global => (Input => doorsLockedAndClosed),
   --  Pre'Class => This.current_planeMode = takeoffLanding and doorsLockedAndClosed = True,
      Pre => (doorsLockedAndClosed = False or curr_Plane_mode /= takeoffLanding) and (doorsLockedAndClosed = True or curr_Plane_mode = takeoffLanding),
     Contract_Cases => (doorsLockedAndClosed = False and curr_Plane_mode = takeoffLanding  => TakeOffModeDoorCheck'Result = False,
                        doorsLockedAndClosed = True and curr_Plane_mode = takeoffLanding=> TakeOffModeDoorCheck'Result = True,
                        curr_Plane_mode /= takeoffLanding => TakeOffModeDoorCheck'Result = False);
   
   --Does not allow plane to take off if doors are not closed and locked
   procedure TakeOffDoors(curr_Plane_mode : out PlaneMode) with 
     Global => (Input => DoorsLockedAndClosed),
     Pre => DoorsLockedAndClosed = False or DoorsLockedAndClosed = True,
     Post => (curr_Plane_mode /= takeoffLanding) or DoorsLockedAndClosed = True;
   
   --Does not allow plane to take off if fuel is bellow minimum
   procedure TakeOffModeFuel (curr_Plane_mode :  in out PlaneMode; curr_Fuel : in PlaneFuelTank) with
     Pre => curr_Fuel.status = Low or curr_Plane_mode = takeoffLanding,
     Post => curr_Fuel.status /= Low or curr_Plane_mode /= takeoffLanding;
   
   -- If during flight plane has low fuel it wil turn the warning light on
   procedure WarniningDuringFlight(curr_Plane_mode : in PlaneMode; curr_Fuel : in out PlaneFuelTank) with
     Pre =>(curr_Fuel.status /= Low or curr_Fuel.warning = on) and curr_Fuel.FuelInvariant,
     Post => (curr_Fuel.status /= Low or curr_Fuel.warning = on) and curr_Fuel.FuelInvariant;
   
   --Extended--Checks other limits as well 
   procedure NormalFlightSpeedAltitude (curr_Plane_mode : out PlaneMode; curr_speed: in Speedometer; curr_altitude :  in Altitudometer);
   
   procedure LandingGearEnabaler (curr_Plane_mode : in PlaneMode; curr_altitude : in Altitudometer; curr_land_gear : out LandingGear) with
     Pre => (curr_Plane_mode = takeoffLanding and curr_altitude.lowerLandingGear = fine) or (curr_Plane_mode /= takeoffLanding and curr_altitude.lowerLandingGear /= fine),
     Post =>(curr_Plane_mode /= takeoffLanding and curr_altitude.lowerLandingGear /= Fine) or curr_land_gear = lowered;
   
   procedure TowingMode (curr_Engine : out Engine; curr_tow : in Towing; curr_Plane_mode : PlaneMode) with
     Pre =>curr_Plane_mode = standBy and EngineTowInvariant,
     Post => EngineTowInvariant and ((curr_tow = off) or (curr_Engine = off));
   
   --Methods to get the program working
   procedure PowerOnMode(curr_Engine : in out Engine) with
     Pre => EngineInvariant,
     Post => EngineInvariant and  curr_Engine = on;
   
   procedure PowerOffMode(curr_Engine :  in out Engine) with
     Pre => EngineInvariant,
       Post => EngineInvariant and curr_Engine = off;
end plane;
