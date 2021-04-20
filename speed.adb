with Ada.Text_IO; use Ada.Text_IO;

package body speed with SPARK_Mode is

    procedure accelerateSpeed(This : in out Speedometer) is
   begin
      if (This.current_speed < Speed'Last)
      then This.current_speed := This.current_speed + 1;
      end if;
      Put_Line("Current Speed is:"& This.current_speed'Image);
   end accelerateSpeed;

end speed;
