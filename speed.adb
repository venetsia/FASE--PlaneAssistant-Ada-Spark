with Ada.Text_IO; use Ada.Text_IO;

package body speed with SPARK_Mode is

   procedure accelerateSpeed(current_speed : in out Speed) is
   begin
      if (current_speed < Speed'Last)
      then current_speed := current_speed + 1;
      end if;
      Put_Line("Current Speed is : "& current_speed'Image);
   end accelerateSpeed;
   
   procedure decreaseSpeed(current_speed : in out Speed) is
   begin
      if (current_speed > Speed'First)
      then current_speed := current_speed - 1;
      end if;
      Put_Line("Current Speed is : "& current_speed'Image);
   end decreaseSpeed;

   procedure AssignSpeedMode(This : in out Speedometer) is
   begin
      if (current_speed >= 6 and current_speed <= Speed'Last)
      then This.currentSpeedType := normal;
      else if (current_speed < 6 and current_speed /= Speed'First) 
         then This.currentSpeedType := takeoffLanding;
         else if current_speed = Speed'First
            then
               This.currentSpeedType := standBy;
            end if;   
         end if;
      end if;
   end AssignSpeedMode;
   
end speed;
