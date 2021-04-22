with Ada.Text_IO; use Ada.Text_IO;

package body fuel  with SPARK_Mode is
   
   procedure addFuel(This : in out PlaneFuelTank) is
   begin
      if (current_FuelLevel >= 2500)
      then current_FuelLevel := current_FuelLevel + 1; This.warning := off; This.status := Sufficient;
      else
         if (current_FuelLevel  < 2500)
         then current_FuelLevel  := current_FuelLevel  + 1; This.warning := on; This.status := Low;
         end if;
      end if;
      Put_Line("Fuel in liters is"& current_FuelLevel'Image & ", which is is " & This.status'Image);
   end addFuel;
   
   procedure burnFuel(This : in out PlaneFuelTank) is
   begin
      if (current_FuelLevel >= 2500)
      then current_FuelLevel := current_FuelLevel - 1; This.warning := off; This.status := Sufficient;
      else
         if (current_FuelLevel  < 2500)
         then current_FuelLevel  := current_FuelLevel  - 1; This.warning := on; This.status := Low;
         end if;
      end if;
      Put_Line("Fuel in liters is"& current_FuelLevel'Image & ", which is is " & This.status'Image);
   end burnFuel;
   
   procedure LoworSufficientLevelOfFuel (This : in out PlaneFuelTank) is 
   begin
      if current_FuelLevel >= 2500
      then This.status := Sufficient;
      else This.status := Low; Put_Line("Low on fuel, status changed:"& This.status'Image);
      end if;
   end LoworSufficientLevelOfFuel;
   
   
   procedure WarningSignONOFF (This : in out PlaneFuelTank) is
   begin
      if This.status = Low then
         This.warning := on;Put_Line("Warning light is " & This.warning'Image);
      else
         This.warning := off; Put_Line("Warning light is " & This.warning'Image);
      end if;
   end WarningSignONOFF;

   
   function ConstructFuelTank return PlaneFuelTank is 
      result : PlaneFuelTank := (status => (Sufficient), warning => (off));
   begin           
      return result;
   end ConstructFuelTank;
   
end fuel;
