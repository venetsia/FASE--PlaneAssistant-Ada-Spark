with Ada.Text_IO; use Ada.Text_IO;

package body plane with SPARK_Mode is

 -- function TakeOff_Door_Check (curr_Plane_mode : Plane_Mode) return Boolean is       
  -- begin 
  --    if Is_Ct_Ext_Lock_Close = True and curr_Plane_mode = takeoff_Landing
  --    then
  --       return True;
  --    else
  --       return False;
  --    end if;
  -- end TakeOff_Door_Check; 
   
   procedure TakeOff_Doors(curr_Plane_mode : in Plane_Mode) is 
   begin
      if curr_Plane_mode = standBy and (Is_Ct_Ext_Lock_Close = False  and Util_Doors_Locked_Closed = False) then
         DoorsOK := False;
         --Put_Line("Cannot take off! Doors Locked and Closed: " & DoorsLockedAndClosed'Image & ". Please close and lock doors");
      else 
         DoorsOK := True; 
      end if;
   end TakeOff_Doors;
   
   procedure TakeOff_Fuel (curr_Plane_mode :  in out Plane_Mode; curr_Fuel : in  Plane_Fuel_Tank) is       
   begin 
      if curr_Fuel.status /= Low then 
         curr_Plane_mode := takeoff_Landing;
       --  curr_Fuel.warning := off;
      end if;
      if curr_Fuel.status = Low then 
         curr_Plane_mode := standBy; 
        -- curr_Fuel.warning := on;
       --  Put_Line("Fuel: " & curr_Fuel.status'Image & ". Cannot take of while low on fuel");
      end if;
   end TakeOff_Fuel; 
   
   procedure Warnining_During_Flight (curr_Plane_mode : in Plane_Mode; curr_Fuel : in  out Plane_Fuel_Tank) is       
   begin 
      if  curr_Plane_mode = normal and curr_Fuel.status = Low then curr_Fuel.warning := on;
      end if;
      if curr_Plane_mode = normal and curr_Fuel.status /= Low then curr_Fuel.warning := off;
      end if;
   end Warnining_During_Flight; 
  
   function Normal_Flight_Speed_Altitude (curr_Plane_mode : in Plane_Mode; curr_speed: in Speedometer; curr_altitude : in Altitudometer) return Boolean is
   begin
      if curr_speed.current_Speed_Type /= normal or curr_altitude.current_Altitude_Type /= normal or curr_Plane_mode /= normal
      then
         return False;
      else 
         return True;
      end if;
   end Normal_Flight_Speed_Altitude;
   
    procedure Flight_Speed_Altitude (curr_Plane_mode : out Plane_Mode; curr_speed: in Speedometer; curr_altitude : in Altitudometer) is
   begin
      if curr_speed.current_Speed_Type = normal and curr_altitude.current_Altitude_Type = normal
      then
         curr_Plane_mode := normal;
      else if curr_speed.current_Speed_Type = takeoff_Landing and curr_altitude.current_Altitude_Type = takeoff_Landing then
            curr_Plane_mode := takeoff_Landing;
         else
            curr_Plane_mode := standBy;
         end if;
      end if;
   end Flight_Speed_Altitude;
   
   procedure Landing_Gear_Enabaler (curr_Plane_mode : in Plane_Mode; curr_altitude : in Altitudometer; curr_land_gear : in out Landing_Gear) is
   begin      
      if curr_Plane_mode = takeoff_Landing and curr_altitude.lower_Landing_Gear = fine 
      then curr_land_gear := lowered;
      end if;
      if curr_Plane_mode = takeoff_Landing and curr_altitude.lower_Landing_Gear = notFine then
          curr_land_gear := unlowered;
      end if;
   end Landing_Gear_Enabaler;
   
   procedure Towing_Mode (curr_Engine : out Engine; curr_tow : in Towing; curr_Plane_mode : Plane_Mode) is
   begin
      if curr_tow = on then curr_Engine := off;
         else curr_Engine := on;
      end if;
   end Towing_Mode;
   
   procedure Power_On_Mode(curr_Engine : in out Engine) is
   begin
      if curr_Engine = off then
         curr_Engine := on; Put_Line("Engine is "& curr_Engine'Image);
     else
         curr_Engine := on; Put_Line("Engine is "& curr_Engine'Image);
      end if;
      Towing_Mode(curr_Engine,curr_tow, curr_Plane_mode);
   end Power_On_Mode;
   
   procedure Power_Off_Mode(curr_Engine : in  out Engine) is
   begin
      if curr_Engine = on then
         curr_Engine := off; Put_Line("Engine is "& curr_Engine'Image);
      else
         curr_Engine := off; Put_Line("Engine is "& curr_Engine'Image);
      end if;
   end Power_Off_Mode;
   
   procedure Close_Lock_All_Doors is
   begin
      close_External_Cockpit_Doors;
      Lock_All_Doors;
      Is_Lock_External_Cockpit;
      Passanger_Utility_Doors_Lock;
   end Close_Lock_All_Doors;
   
   procedure Open_Unlock_External_Cockpit_Doors is
   begin
      Unlock_External_Cockpit_Doors;
      open_External_Cockpit_Doors;
   end Open_Unlock_External_Cockpit_Doors;
   
   procedure Ready_To_TakeOff(curr_Plane_mode :  in out Plane_Mode; curr_Fuel : in Plane_Fuel_Tank) is
   begin
      TakeOff_Doors(curr_Plane_mode);
      TakeOff_Fuel(curr_Plane_mode, curr_Fuel);
      if (DoorsOK = True and (curr_Fuel.status = Sufficient and curr_Fuel.warning = off)) then
         Ready_TakeOff := True;
      else
         Ready_TakeOff := False;
      end if;
   end Ready_To_TakeOff;
   
   procedure Warning_Limit_Light_On_OFF(curr_Plane_mode : in Plane_Mode; curr_speed : in Speedometer; curr_altitude : in Altitudometer; curr_warning_limit :  out Warning_Limit_Light) is
   begin
      
      if (curr_Plane_mode = normal and curr_speed.current_Speed_Type = normal and curr_altitude.current_Altitude_Type = normal)
      then 
          curr_warning_limit := off;
      elsif (curr_Plane_mode = standby and curr_speed.current_Speed_Type = standby and curr_altitude.current_Altitude_Type = standby) 
         then
            curr_warning_limit := off;
      elsif (curr_Plane_mode = takeoff_Landing and curr_speed.current_Speed_Type = takeoff_Landing and curr_altitude.current_Altitude_Type = takeoff_Landing) 
         then
            curr_warning_limit := off;
      else curr_warning_limit := on;
      end if;
   end Warning_Limit_Light_On_OFF;
   
end plane;
