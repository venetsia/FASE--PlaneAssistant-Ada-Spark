with Ada.Text_IO; use Ada.Text_IO;

package body plane with SPARK_Mode is

  function TakeOffModeDoorCheck (curr_Plane_mode : PlaneMode) return Boolean is       
   begin 
      if doorsLockedAndClosed = True and curr_Plane_mode = takeoffLanding
      then
         return True;
      else
         return False;
      end if;
   end TakeOffModeDoorCheck; 
   
   procedure TakeOffDoors(curr_Plane_mode : out PlaneMode) is 
   begin
      if DoorsLockedAndClosed = False then 
         curr_Plane_mode := standBy; 
         --Put_Line("Cannot take off! Doors Locked and Closed: " & DoorsLockedAndClosed'Image & ". Please close and lock doors");
      else
         curr_Plane_mode := takeoffLanding;
      end if;
   end TakeOffDoors;
   
   procedure TakeOffModeFuel (curr_Plane_mode :  in out PlaneMode; curr_Fuel : in PlaneFuelTank) is       
   begin 
      if curr_Fuel.status /= Low then curr_Plane_mode := takeoffLanding;
      end if;
      if curr_Fuel.status = Low then curr_Plane_mode := standBy; 
         Put_Line("Fuel: " & curr_Fuel.status'Image & ". Cannot take of while low on fuel");
      end if;
   end TakeOffModeFuel; 
   
   procedure WarniningDuringFlight (curr_Plane_mode : in PlaneMode; curr_Fuel : in  out PlaneFuelTank) is       
   begin 
      if  curr_Plane_mode = normal and curr_Fuel.status = Low then curr_Fuel.warning := on;
      end if;
      if curr_Plane_mode = normal and curr_Fuel.status /= Low then curr_Fuel.warning := off;
      end if;
   end WarniningDuringFlight; 
  
   procedure NormalFlightSpeedAltitude (curr_Plane_mode : out PlaneMode; curr_speed: in Speedometer; curr_altitude : in Altitudometer) is
   begin
      if curr_speed.currentSpeedType = normal and curr_altitude.currentAltitudeType = normal
      then
         curr_Plane_mode := normal;
      else if curr_speed.currentSpeedType = takeoffLanding and curr_altitude.currentAltitudeType = takeoffLanding then
            curr_Plane_mode := takeoffLanding;
         else
            curr_Plane_mode := standBy;
         end if;
      end if;
   end NormalFlightSpeedAltitude;
   
   procedure LandingGearEnabaler (curr_Plane_mode : in PlaneMode; curr_altitude : in Altitudometer; curr_land_gear : out LandingGear) is
   begin      
      if curr_Plane_mode = takeoffLanding and curr_altitude.lowerLandingGear = fine 
      then curr_land_gear := lowered;
      else curr_land_gear := unlowered;
      end if;
   end LandingGearEnabaler;
   
   procedure TowingMode (curr_Engine : out Engine; curr_tow : in Towing; curr_Plane_mode : PlaneMode) is
   begin
      if curr_tow = on then curr_Engine := off;
         else curr_Engine := on;
      end if;
   end TowingMode;
   
   procedure PowerOnMode(curr_Engine : in out Engine) is
   begin
      if curr_Engine = off then
         curr_Engine := on; Put_Line("Engine is "& curr_Engine'Image);
      else
         curr_Engine := on; Put_Line("Engine is "& curr_Engine'Image);
      end if;
   end PowerOnMode;
   
   procedure PowerOffMode(curr_Engine : in  out Engine) is
   begin
      if curr_Engine = on then
         curr_Engine := off; Put_Line("Engine is "& curr_Engine'Image);
      else
         curr_Engine := off; Put_Line("Engine is "& curr_Engine'Image);
      end if;
   end PowerOffMode;
   
end plane;
