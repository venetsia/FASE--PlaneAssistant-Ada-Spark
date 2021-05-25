with plane; use plane;
with door; use door;
with fuel; use fuel;
with speed; use speed;
with altitude; use altitude;
with Ada.Text_IO; use Ada.Text_IO;

procedure Main with SPARK_Mode is

   Landing : Boolean := False;
   Taking_Off: Boolean := True;
   curr_Plane_mode : Plane_Mode := standBy;
   curr_land_gear : Landing_Gear := lowered;
   curr_Engine : Engine := off;
   curr_tow :Towing := off;
   curr_Fuel : Plane_Fuel_Tank := (status => Low, warning => on);
   curr_speed :Speedometer := (current_Speed_Type => standby);
   curr_altitude : Altitudometer := (current_Altitude_Type => standby, lower_Landing_Gear => Fine);
   curr_warning_limit: Warning_Limit_Light := off;

   task Burn_Fuel_Task;
   task Check_Fuel_Task;
   task Taking_Off_Mode_Task;
   task Change_To_Normal_Mode_Task;
   task Landing_Mode_Task;
   task Stand_By_Mode_Task;

   procedure Print_Status is
   begin
      Ada.Text_IO.Put(ASCII.ESC & "[2J");
      Put_line("Status of Plane_Mode       : " & curr_Plane_mode'Image);
      Put_Line("Cockpit and External Doors are locked: " & Is_Ct_Ext_Lock_Close'Image);
      Put_Line("Passanger Utility Doors are locked: " & Util_Doors_Locked_Closed'Image);
      Put_Line("Landing gear: " &curr_land_gear'Image);
      Put_Line("Engine: " &curr_Engine'Image);
      Put_Line("Towing: " &curr_tow'Image);
      Put_Line("Fuel is: " &curr_Fuel.status'Image & " and warning is " &curr_Fuel.warning'Image);
      Put_Line("Curremt speed is in mode: " &curr_speed.current_Speed_Type'Image);
      Put_Line("Current altitude is in mode: " &curr_altitude.current_Altitude_Type'Image &" and lowering landing gear is: " &curr_altitude.lower_Landing_Gear'Image);
      Put_Line("Curremt LIMITS LIGHT is: " &curr_warning_limit'Image);
      Put_Line("...........................");
   end Print_Status;


   task body Burn_Fuel_Task is
   begin
      while curr_Engine = on  loop
         Burn_Fuel(curr_Fuel);
         delay 2.0;
      end loop;
   end Burn_Fuel_Task;

   task body Check_Fuel_Task is
   begin
      loop
         if curr_Engine = on  then Low_Sufficient_Fuel_Level(curr_Fuel); end if;
         delay 1.0;
      end loop;
   end Check_Fuel_Task;

   task body Taking_Off_Mode_Task is
   begin
      loop
         if curr_Plane_mode = takeoff_Landing and Landing = False then --and curr_altitude.current_Altitude_Type /= normal then
            --FUEL--                                                          --TakingOff(curr_Plane_mode, curr_altitude, curr_speed);
            Burn_Fuel(curr_Fuel);
            Low_Sufficient_Fuel_Level(curr_Fuel);
            --FUEL--
            --SPEED AND ALTITUDE--
            Warning_Limit_Light_On_OFF(curr_Plane_mode,curr_speed, curr_altitude,curr_warning_limit);
              --SPEED AND ALTITUDE--

            --ACCELARATE SPEED--
            if curr_Plane_mode = takeoff_Landing and curr_speed.current_Speed_Type = standby then
               Accelerate_Speed(current_speed, curr_speed);
               --        Put_line("Current Speed : " & current_speed'Image);
               Assign_Speed_Mode(curr_speed);
               --SPEED AND ALTITUDE--
            Warning_Limit_Light_On_OFF(curr_Plane_mode,curr_speed, curr_altitude,curr_warning_limit);
                 --SPEED AND ALTITUDE--
            end if;
            --ACCELARATE SPEED--
            if (curr_speed.current_Speed_Type = speeding and curr_Plane_mode = takeoff_Landing) and current_speed < speed.Speed'Last then
               Accelerate_Speed(current_speed, curr_speed);
               Assign_Speed_Mode(curr_speed);
               --SPEED AND ALTITUDE--
            Warning_Limit_Light_On_OFF(curr_Plane_mode,curr_speed, curr_altitude,curr_warning_limit);
              --SPEED AND ALTITUDE--
            end if;
            --ACCELARATE ALTITUDE--
            if (curr_speed.current_Speed_Type = takeoff_Landing) and (curr_altitude.current_Altitude_Type = standby or curr_altitude.current_Altitude_Type = takeoff_Landing) then
               Accelerate_Altitude(current_altitude,curr_altitude);
               Assign_Altutude_Mode(curr_altitude);
               --SPEED AND ALTITUDE--
            Warning_Limit_Light_On_OFF(curr_Plane_mode,curr_speed, curr_altitude,curr_warning_limit);
              --SPEED AND ALTITUDE--
            end if;
            --CHECK FOR LANDING GEAR--
            Landing_Gear_Enabaler(curr_Plane_mode,curr_altitude,curr_land_gear);
            Put_line("Current Speed        : " & current_speed'Image);
            Put_Line("Current status of landing gear is : "& curr_altitude.lower_Landing_Gear'Image);
            Put_Line("Current Altitude is               : "& current_altitude'Image);

         end if;
         delay 1.0;
      end loop;
   end Taking_Off_Mode_Task;


   task body Change_To_Normal_Mode_Task is
   begin
      loop
         if (curr_Plane_mode = takeoff_Landing and Landing = False) and (curr_altitude.current_Altitude_Type = normal and (curr_speed.current_Speed_Type = takeoff_Landing or curr_speed.current_Speed_Type = normal)) then
            --FUEL--
            Burn_Fuel(curr_Fuel);
            Low_Sufficient_Fuel_Level(curr_Fuel);
            --FUEL--
            --ACCELARATE SPEED--
            Accelerate_Speed(current_speed, curr_speed);
            Assign_Speed_Mode(curr_speed);
            Flight_Speed_Altitude(curr_Plane_mode,curr_speed,curr_altitude);
             --SPEED AND ALTITUDE--
            Warning_Limit_Light_On_OFF(curr_Plane_mode,curr_speed, curr_altitude,curr_warning_limit);
              --SPEED AND ALTITUDE--
            Put_line("Current Speed        : " & current_speed'Image);
           -- Put_Line("Current status of landing gear is : "& curr_altitude.lower_Landing_Gear'Image);
            Put_Line("Current Altitude is               : "& current_altitude'Image);
            if Normal_Flight_Speed_Altitude(curr_Plane_mode,curr_speed,curr_altitude) = True
            then
               Taking_Off := False;
               Put_Line("Stopped Taking Off and Flying to destination");
               delay 2.0;
               Put_Line("Passangers can now use Toilets and Cabins");
               Unlock_Passanger_Utility_Doors;
               delay 2.0;
            end if;
            Burn_Fuel(curr_Fuel);
            Low_Sufficient_Fuel_Level(curr_Fuel);
         end if;
      end loop;
   end Change_To_Normal_Mode_Task;

   task body Landing_Mode_Task is
   begin
      loop
         if (curr_Plane_mode = normal) and (curr_altitude.current_Altitude_Type = normal and curr_speed.current_Speed_Type = normal and Taking_Off = False)  then
            delay 2.0;
            Put_Line("Get ready for landing");
            delay 2.0;
            Put_Line("Passangers are not allowed to go to toilet or use cabins");
            Passanger_Utility_Doors_Lock;
            delay 5.0;
            Landing := True;
            delay 5.0;
         end if;
         if (Landing = True and Taking_Off = False and curr_Plane_mode = normal and curr_altitude.current_Altitude_Type = normal and curr_speed.current_Speed_Type = normal)
         then
               delay 2.0;
               --FUEL--
               Burn_Fuel(curr_Fuel);
               Low_Sufficient_Fuel_Level(curr_Fuel);
               --SPEED AND ALTITUDE--
               Warning_Limit_Light_On_OFF(curr_Plane_mode,curr_speed, curr_altitude,curr_warning_limit);
               --SPEED AND ALTITUDE--
               delay 5.0;
               loop
                  Decrease_Speed(current_speed,curr_speed);
                  Put_Line("Decreaing speed");
                  --SPEED AND ALTITUDE--
                  Warning_Limit_Light_On_OFF(curr_Plane_mode,curr_speed, curr_altitude,curr_warning_limit);
                  --SPEED AND ALTITUDE--
                  delay 5.0;
                  exit when curr_speed.current_Speed_Type = takeoff_Landing;
               end loop;
               if curr_speed.current_Speed_Type = takeoff_Landing then
                  --FUEL--
                  Burn_Fuel(curr_Fuel);
                  Low_Sufficient_Fuel_Level(curr_Fuel);
                  --FUEL--
                  --SPEED AND ALTITUDE--
                  Warning_Limit_Light_On_OFF(curr_Plane_mode,curr_speed, curr_altitude,curr_warning_limit);
                  --SPEED AND ALTITUDE--
                  loop
                     Put_Line("Decreaing altitude");
                     Decrease_Altitude(current_altitude, curr_altitude);
                     --SPEED AND ALTITUDE--
                     Warning_Limit_Light_On_OFF(curr_Plane_mode,curr_speed, curr_altitude,curr_warning_limit);
                     --SPEED AND ALTITUDE--
                     delay 5.0;
                     exit when curr_altitude.current_Altitude_Type = takeoff_Landing and curr_altitude.current_Altitude_Type = takeoff_Landing ;
                  end loop;
                  if curr_speed.current_Speed_Type = takeoff_Landing and curr_altitude.current_Altitude_Type = takeoff_Landing then
                     --SPEED AND ALTITUDE--
                     Warning_Limit_Light_On_OFF(curr_Plane_mode,curr_speed, curr_altitude,curr_warning_limit);
                     --SPEED AND ALTITUDE--
                     Flight_Speed_Altitude(curr_Plane_mode,curr_speed,curr_altitude);
                     delay 5.0;
                     Print_Status;
                  end if;
               end if;
               Put_Line("Fuel " & current_Fuel_Level'Image);
            end if;

      end loop;
   end Landing_Mode_Task;

   task body Stand_By_Mode_Task is
   begin
      loop
         if Landing = True and Taking_Off = False then
            if curr_speed.current_Speed_Type = takeoff_Landing and curr_altitude.current_Altitude_Type = takeoff_Landing then
               --FUEL--
               Burn_Fuel(curr_Fuel);
               Low_Sufficient_Fuel_Level(curr_Fuel);
               --FUEL--
               loop
                  Decrease_Altitude(current_altitude, curr_altitude);
                  Put_Line("Decreaing altitude--");
                  Put_Line("Current Altitude is               : "& current_altitude'Image);
                  delay 2.0;
                  Landing_Gear_Enabaler(curr_Plane_mode,curr_altitude,curr_land_gear);
                  delay 2.0;
                  Put_Line("Landing gear enable is               : "& curr_altitude.lower_Landing_Gear'Image);
                  --SPEED AND ALTITUDE--
                  Warning_Limit_Light_On_OFF(curr_Plane_mode,curr_speed, curr_altitude,curr_warning_limit);
                  --SPEED AND ALTITUDE--
                  exit when curr_altitude.current_Altitude_Type = standby;
               end loop;
               --FUEL--
               Burn_Fuel(curr_Fuel);
               Burn_Fuel(curr_Fuel);
               Burn_Fuel(curr_Fuel);
               Low_Sufficient_Fuel_Level(curr_Fuel);
               --FUEL--
               loop
                  Decrease_Speed(current_speed, curr_speed);
                  Put_Line("Decreaing speed");
                  Put_line("Current Speed        : " & current_speed'Image);
                  --SPEED AND ALTITUDE--
                  Warning_Limit_Light_On_OFF(curr_Plane_mode,curr_speed, curr_altitude,curr_warning_limit);
                  --SPEED AND ALTITUDE--
                  delay 2.0;
                  Flight_Speed_Altitude(curr_Plane_mode,curr_speed,curr_altitude);
                  exit when curr_speed.current_Speed_Type = standby and curr_Plane_mode = standby;
               end loop;
               Put_Line("Changing status mode of plane");
               --Flight_Speed_Altitude(curr_Plane_mode,curr_speed,curr_altitude);
               Landing:=False;
               delay 5.0;
            end if;
         end if;

      end loop;
   end Stand_By_Mode_Task;





begin
   while True loop
      Print_Status;
      if curr_engine = off then
         curr_tow := off;
         delay 3.0;
         Taking_Off := True;
         Put_line("Powering Plane On");
         delay 3.0;
         Power_On_Mode(curr_Engine);
         Put_Line("Fuel in liters is"& current_Fuel_Level'Image & ", which is is " & curr_Fuel.status'Image);
         delay 3.0;
         Print_Status;
         delay 3.0;
         Put_line("Closing and Locking Doors");
         Close_Lock_C_E_Doors;
         Put_Line("Fuel in liters is"& current_Fuel_Level'Image & ", which is is " & curr_Fuel.status'Image);
         delay 3.0;
         Print_Status;
         delay 3.0;
         Print_Status;
         Put_line("Checking fuel and doors     : ");
         Ready_To_TakeOff(curr_Plane_mode, curr_Fuel);
         Put_Line("Doors are closed and locked : " & Is_Ct_Ext_Lock_Close'Image);
         Put_Line("Fuel in liters is "& current_Fuel_Level'Image & ", which is is " & curr_Fuel.status'Image);
         delay 3.0;
         Print_Status;
         if Ready_TakeOff = True then
            Put_line("Switching to             : " & curr_Plane_mode'Image);
            delay 3.0;
         else
            Put_line("Fuel Status              : " & curr_Fuel.status'Image);
            Put_line("Plane Mode               : " & curr_Plane_mode'Image);
            delay 3.0;
         end if;
         if DoorsOK = False then Close_Lock_C_E_Doors;
         end if;
         if curr_Fuel.status = Low then
            Put_Line("Adding fuel");
            while current_Fuel_Level /= Fuel_Levels'Last loop
               Add_Fuel(curr_Fuel);
               Put_Line("Fuel Level            : " & curr_Fuel.status'Image);
            end loop;
         end if;
         delay 3.0;
         Ready_To_TakeOff(curr_Plane_mode, curr_Fuel);
         Print_Status;
         Put_Line("Check changes");
         delay 3.0;
         Print_Status;
         Put_Line("Fuel in liters is "& current_Fuel_Level'Image & ", which is is " & curr_Fuel.status'Image);
         delay 2.0;
      end if;
      if curr_Engine = on then
         if (curr_Plane_mode = standby and curr_Engine = on) and (curr_altitude.current_Altitude_Type = standby and curr_speed.current_Speed_Type = standby) then
            Put_Line("Is Plane in landing mode?:" & Landing'Image);
            delay 2.0;
            if Landing = False
            then
               Unlock_Passanger_Utility_Doors;
               Put_Line("Unlocking passanger utility doors...");
               delay 2.0;
               Put_Line("Are passanger utility doors locked? : " & Util_Doors_Locked_Closed'Image);
               if Util_Doors_Locked_Closed = False
               then
                 Put_Line("Passengers are free to take their stuff.");
                  delay 2.0;
               end if;
               Open_Unlock_External_Cockpit_Doors;
               Put_Line("Unlocking cockpit door and external doors...");
               Put_Line("Are external doors and cockpit door locked? : " & Is_Ct_Ext_Lock_Close'Image);
               delay 2.0;
            end if;

            Put_Line("Putting Plane on towing mode shortly");
            delay 2.0;
            Power_Off_Mode(curr_Engine);
            Put_Line("Turning Engine off");
            delay 2.0;
            curr_tow := on;
            Put_Line("Plane in towing mode");
            Put_Line("Fuel " & current_Fuel_Level'Image);
            Print_Status;
         end if;
      end if;
      --  Will wait here until all tasks have terminated (up until TakeOffMode)
      Print_Status;
      delay 2.0;
      Print_Status;
      delay 3.0;
      Print_Status;
   end loop;
end Main;
