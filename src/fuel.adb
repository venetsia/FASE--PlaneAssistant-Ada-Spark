with Ada.Text_IO; use Ada.Text_IO;

package body fuel  with SPARK_Mode is
   
   procedure Add_Fuel(This : in out Plane_Fuel_Tank) is
   begin
      if (current_Fuel_Level >= 15)
      then current_Fuel_Level := current_Fuel_Level + 1; This.warning := off; This.status := Sufficient;
      else
         if (current_Fuel_Level  < 15)
         then current_Fuel_Level  := current_Fuel_Level  + 1; This.warning := on; This.status := Low;
         end if;
      end if;
   end Add_Fuel;
   
   procedure Burn_Fuel(This : in out Plane_Fuel_Tank) is
   begin
      Put_Line("Fuel " & current_Fuel_Level'Image);
      if (current_Fuel_Level >= 15)
      then current_Fuel_Level := current_Fuel_Level - 1; This.warning := off; This.status := Sufficient;
      else
         if (current_Fuel_Level  < 15)
         then current_Fuel_Level  := current_Fuel_Level  - 1; This.warning := on; This.status := Low;
         end if;
      end if;
   end Burn_Fuel;
   
   procedure Low_Sufficient_Fuel_Level (This : in out Plane_Fuel_Tank) is 
   begin
      if current_Fuel_Level >= 15
      then 
         This.status := Sufficient;
         This.warning := off;
      else 
         This.status := Low;
         This.warning := on;
         Put_Line("Warning light is " & This.warning'Image);
      end if;
   end Low_Sufficient_Fuel_Level;
   
   
end fuel;
