with Ada.Text_IO; use Ada.Text_IO;

package body plane with SPARK_Mode is

  function TakeOffModeDoorCheck (curr_Plane_mode : PlaneMode) return Boolean is       
   begin 
      if doorsLockedAndClosed = True and curr_Plane_mode = takeOff then
         return True;
      else
         return False;
      end if;
   end TakeOffModeDoorCheck; 
   
   procedure TakeOffDoors(curr_Plane_mode : in out PlaneMode) is 
   begin
      if doorsLockedAndClosed = False then curr_Plane_mode := standBy;
      end if;
   end TakeOffDoors;
   
   procedure TakeOffModeFuel (curr_Plane_mode :  in out PlaneMode; curr_Fuel : in PlaneFuelTank) is       
   begin 
      if curr_Fuel.status /= Low then curr_Plane_mode := takeOff;
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
      
   
end plane;
