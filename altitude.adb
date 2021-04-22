with Ada.Text_IO; use Ada.Text_IO;

package body altitude with SPARK_Mode is
   
   procedure accelerateAltitude(current_altitude  : in out Altitude) is
   begin
      if (current_altitude < Altitude'Last)
      then current_altitude := current_altitude + 1;
      end if;
      Put_Line("Current Altitude is: "& current_altitude'Image);
   end accelerateAltitude;
   
   procedure decreaseAltitude (current_altitude : in out Altitude) is
     begin
      if (current_altitude < Altitude'First)
      then current_altitude := current_altitude - 1;
      end if;
      Put_Line("Current Altitude is: "& current_altitude'Image);
   end decreaseAltitude;


   procedure AssignAltutudeMode(This : in out Altitudometer) is
   begin
      if (current_altitude >= 10000 and current_altitude <= Altitude'Last)
      then This.currentAltitudeType := normal;
      else if (current_altitude < 10000 and current_altitude /= Altitude'First) 
         then This.currentAltitudeType := takeoffLanding;
         else if current_altitude = Altitude'First
            then
               This.currentAltitudeType := standBy;
            end if;   
         end if;
      end if;
   end AssignAltutudeMode;
   
   procedure CheckAltitudeForLandingGear(This : in out Altitudometer) is
   begin
        if current_altitude <= 25 then This.lowerLandingGear := fine;
      else This.lowerLandingGear := notFine;
      end if;
   end CheckAltitudeForLandingGear;
   
   
   
end altitude;
