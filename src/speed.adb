with Ada.Text_IO; use Ada.Text_IO;

package body speed with SPARK_Mode is

   procedure Accelerate_Speed(current_speed : in out Speed; This : in out Speedometer ) is
   begin
      if (current_speed < Speed'Last)
      then current_speed := current_speed + 1;
      end if;
      Assign_Speed_Mode(This);
   end Accelerate_Speed;
   
   procedure Decrease_Speed(current_speed : in out Speed; This : in out Speedometer) is
   begin
      if (current_speed > Speed'First)
      then current_speed := current_speed - 1;
      end if;
      Assign_Speed_Mode(This);
   end Decrease_Speed;

   procedure Assign_Speed_Mode(This : in out Speedometer) is
   begin
      if (current_speed > 6 and current_speed <= Speed'Last)
      then This.current_Speed_Type := normal;
      end if;
      if (current_speed < 6 and current_speed /= Speed'First) 
      then This.current_Speed_Type := speeding;
      end if;
      if current_speed = Speed'First
      then
         This.current_Speed_Type := standBy;
      end if;
      if current_speed = 6 
      then
         This.current_Speed_Type := takeoff_Landing;
      end if;
   end Assign_Speed_Mode;
   
end speed;
