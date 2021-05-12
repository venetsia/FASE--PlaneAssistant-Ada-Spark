with door; use door;
with fuel; use fuel;
with speed; use speed;
with altitude; use altitude;

package plane with SPARK_Mode is
   
   Ready_TakeOff : Boolean;
   Landing : Boolean;
   DoorsOK : Boolean;
   
   type Plane_Mode is (takeoff_Landing, normal, standBy);
   type Landing_Gear is (lowered, unlowered);
   type Engine is(on, off);
   type Towing is(on, off);
   type Warning_Limit_Light is(on, off);
   
   curr_Plane_mode : Plane_Mode := normal;
   curr_land_gear : Landing_Gear := unlowered;
   curr_Engine : Engine := on;
   curr_tow :Towing := off;
   curr_Fuel : Plane_Fuel_Tank := (status => Sufficient, warning => off);
   curr_speed :Speedometer := (current_Speed_Type => normal);
   curr_altitude : Altitudometer := (current_Altitude_Type => normal, lower_Landing_Gear => notFine);
   curr_warning_limit: Warning_Limit_Light := off;
   
   --Invariant
    function Engine_Tow_Invariant return Boolean is
     (curr_Engine = on or curr_tow = on);
   
   function Engine_Invariant return Boolean is
     (curr_Engine = on and ((curr_Plane_mode = takeoff_Landing or curr_Plane_mode = normal) or curr_tow = on));
   
   function Fly_Mode_Doors return Boolean is
      (Is_Ct_Ext_Lock_Close = True and curr_Plane_mode = normal);
   
   --Check Doors returns Boolean if they are closed and locked
   --function TakeOff_Door_Check (curr_Plane_mode : Plane_Mode) return Boolean with
    -- Global => (Input => Is_Ct_Ext_Lock_Close),
   --  Pre'Class => This.current_Plane_Mode = takeoff_Landing and Is_Ct_Ext_Lock_Close = True,
    --  Pre => (Is_Ct_Ext_Lock_Close = False or curr_Plane_mode /= takeoff_Landing) and (Is_Ct_Ext_Lock_Close = True or curr_Plane_mode = takeoff_Landing),
    -- Contract_Cases => (Is_Ct_Ext_Lock_Close = False and curr_Plane_mode = takeoff_Landing  => TakeOff_Door_Check'Result = False,
                       -- Is_Ct_Ext_Lock_Close = True and curr_Plane_mode = takeoff_Landing=> TakeOff_Door_Check'Result = True,
                      --  curr_Plane_mode /= takeoff_Landing => TakeOff_Door_Check'Result = False);
   
   --Does not allow plane to take off if doors are not closed and locked
   procedure TakeOff_Doors(curr_Plane_mode : in Plane_Mode) with 
     Global => (Input => (Is_Ct_Ext_Lock_Close, Util_Doors_Locked_Closed), Output => DoorsOK),
     Pre => curr_Plane_mode = standBy,
     Post => DoorsOK = False or DoorsOK = True;
   
   --Does not allow plane to take off if fuel is bellow minimum
   procedure TakeOff_Fuel (curr_Plane_mode :  in out Plane_Mode; curr_Fuel : in  Plane_Fuel_Tank) with
    -- Pre => curr_Fuel.status /= Low or curr_Fuel.status = Low ,
     Post => ((curr_Fuel.status /= Low or curr_Fuel.warning = on) or curr_Plane_mode /= takeoff_Landing);
   
   -- If during flight plane has low fuel it wil turn the warning light on
   procedure Warnining_During_Flight(curr_Plane_mode : in Plane_Mode; curr_Fuel : in out Plane_Fuel_Tank) with
     Pre =>((curr_Fuel.status /= Low and curr_Plane_mode = normal) or ( curr_Plane_mode = normal and curr_Fuel.status = Low)) and curr_Fuel.Fuel_Invariant,
     Post => (curr_Fuel.status /= Low or curr_Fuel.warning = on) and curr_Fuel.Fuel_Invariant;
     
   --Returns True if everything is normal for fligh
   function Normal_Flight_Speed_Altitude (curr_Plane_mode : in Plane_Mode; curr_speed: in Speedometer; curr_altitude :  in Altitudometer) return Boolean with
    Pre => curr_altitude.lower_Landing_Gear = notFine  and Fly_Mode_Doors,
     Contract_Cases => (Fly_Mode_Doors and (curr_speed.current_Speed_Type = normal and curr_altitude.current_Altitude_Type = normal and curr_Plane_mode = normal) => Normal_Flight_Speed_Altitude'Result = True,
                       curr_speed.current_Speed_Type /= normal or curr_altitude.current_Altitude_Type /= normal or curr_Plane_mode /= normal => Normal_Flight_Speed_Altitude'Result = False);
  
   --Extended--Checks other limits as well 
   procedure Flight_Speed_Altitude (curr_Plane_mode : out Plane_Mode; curr_speed: in Speedometer; curr_altitude :  in Altitudometer);
     
   procedure Landing_Gear_Enabaler (curr_Plane_mode : in Plane_Mode; curr_altitude : in Altitudometer; curr_land_gear : in out Landing_Gear) with
     Pre => (curr_Plane_mode = takeoff_Landing),--and curr_altitude.lower_Landing_Gear = fine) or (curr_Plane_mode = takeoff_Landing and curr_altitude.lower_Landing_Gear /= fine),
     Post =>(curr_Plane_mode = takeoff_Landing and curr_land_gear /= lowered) or (curr_Plane_mode = takeoff_Landing and curr_land_gear = lowered);
   
   procedure Towing_Mode (curr_Engine : out Engine; curr_tow : in Towing; curr_Plane_mode : Plane_Mode) with
     Pre =>curr_Plane_mode = standBy and Engine_Tow_Invariant,
     Post => Engine_Tow_Invariant;
   
   --Methods to get the program working
   procedure Power_On_Mode(curr_Engine : in out Engine) with
     Pre => (Engine_Invariant and Engine_Tow_Invariant) and curr_Plane_mode = standby,
     Post => (Engine_Invariant and Engine_Tow_Invariant)  and ((curr_Engine = on and curr_Plane_mode = standby) or (curr_Engine = off and curr_Plane_mode = standby));
   
   procedure Power_Off_Mode(curr_Engine :  in out Engine) with
     Pre => Engine_Invariant and curr_Plane_mode = standBy,
     Post => Engine_Invariant and (curr_Engine = off and curr_Plane_mode = standBy);
   
   procedure Close_Lock_All_Doors;
   
   procedure Open_Unlock_External_Cockpit_Doors with
   Pre => (Cockpit_Door.lock = Locked and Cockpit_Door.status = Closed) and (External_Doors.lock = Locked and External_Doors.status = Closed),
   Post =>  (Cockpit_Door.lock = Unlocked and Cockpit_Door.status = Open) and External_Doors.lock = Unlocked and External_Doors.status = Open;
   
   --Perform takeoff checks
   procedure Ready_To_TakeOff(curr_Plane_mode :  in out Plane_Mode; curr_Fuel : in  Plane_Fuel_Tank) with
     Global =>(Input => (Is_Ct_Ext_Lock_Close, Util_Doors_Locked_Closed), Output => (Ready_TakeOff, DoorsOK)),
     Pre=>curr_Plane_mode = standBy;
    -- Post => curr_Plane_mode = takeoff_Landing or curr_Plane_mode /= takeoff_Landing;
   
   procedure Warning_Limit_Light_On_OFF(curr_Plane_mode: in Plane_Mode; curr_speed : in Speedometer; curr_altitude : in Altitudometer; curr_warning_limit : out Warning_Limit_Light) with
     Post =>((curr_Plane_mode = normal and curr_speed.current_Speed_Type = normal and curr_altitude.current_Altitude_Type = normal) or curr_warning_limit = on) or 
     ((curr_Plane_mode = standby and curr_speed.current_Speed_Type = standby and curr_altitude.current_Altitude_Type = standby) or curr_warning_limit = on) or 
   ((curr_Plane_mode = takeoff_Landing and curr_speed.current_Speed_Type = takeoff_Landing and curr_altitude.current_Altitude_Type = takeoff_Landing) or curr_warning_limit = on);
   

   
  end plane;
