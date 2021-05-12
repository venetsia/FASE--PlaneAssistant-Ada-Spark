with Ada.Text_IO; use Ada.Text_IO;


package body altitude with SPARK_Mode is
   
   procedure Accelerate_Altitude(current_altitude  : in out Altitude; This : in out Altitudometer) is
   begin
      if (current_altitude < Altitude'Last)
      then current_altitude := current_altitude + 1;
      end if;
    --  Put_Line("Current Altitude is: "& current_altitude'Image);
      Assign_Altutude_Mode(This);
      Check_Altitude_For_Landing_Gear(This, current_altitude);
   end Accelerate_Altitude;
   
   procedure Decrease_Altitude (current_altitude : in out Altitude; This : in out Altitudometer) is
     begin
      if (current_altitude > Altitude'First)
      then current_altitude := current_altitude - 1;
      end if;
      Assign_Altutude_Mode(This);
      Check_Altitude_For_Landing_Gear(This, current_altitude);
   end Decrease_Altitude;


   procedure Assign_Altutude_Mode(This : in out Altitudometer) is
   begin
      if (current_altitude >= 20 and current_altitude <= Altitude'Last)
      then This.current_Altitude_Type := normal;
      else if (current_altitude < 20 and current_altitude /= Altitude'First) 
         then This.current_Altitude_Type := takeoff_Landing;
         else if current_altitude = Altitude'First
            then
               This.current_Altitude_Type := standBy;
            end if;   
         end if;
      end if;
   end Assign_Altutude_Mode;
   
   procedure Check_Altitude_For_Landing_Gear(This     : in out Altitudometer; current_altitude :in  Altitude) is
   begin
      if current_altitude <= 10 then This.lower_Landing_Gear := fine;
      else This.lower_Landing_Gear := notFine; 
      end if;
   end Check_Altitude_For_Landing_Gear;
   
   

   
end altitude;
