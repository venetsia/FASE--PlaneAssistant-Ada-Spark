with plane; use plane;
with door; use door;
with fuel; use fuel;
with speed; use speed;
with altitude; use altitude;
with Ada.Text_IO; use Ada.Text_IO;

procedure Main with SPARK_Mode is

   curr_Plane_mode : PlaneMode := standBy;
   curr_land_gear : LandingGear := lowered;
   curr_Engine : Engine := off;
   curr_tow :Towing := off;
   curr_Fuel : PlaneFuelTank := (status => Sufficient, warning => off);
   curr_speed :Speedometer := (currentSpeedType => standby);
   curr_altitude : Altitudometer := (currentAltitudeType => standby, lowerLandingGear => Fine);

   procedure PrintStatus is
   begin
      Ada.Text_IO.Put(ASCII.ESC & "[2J");
      Put_line("Status of PlaneMode       : " & curr_Plane_mode'Image);
      Put_Line("Check if Doors are locked: " & curr_Door.lock'Image);
      Put_Line("Landing gear: " &curr_land_gear'Image);
      Put_Line("Engine: " &curr_Engine'Image);
      Put_Line("Towing: " &curr_tow'Image);
      Put_Line("Fuel is: " &curr_Fuel.status'Image & "and warning is" &curr_Fuel.warning'Image);
      Put_Line("Curremt speed is in mode: " &curr_speed.currentSpeedType'Image);
      Put_Line("Current altitude is in mode: " &curr_altitude.currentAltitudeType'Image &" and lowering landing gear is: " &curr_altitude.lowerLandingGear'Image);
      Put_Line("...........................");
   end PrintStatus;

   procedure StartPlane is
   begin
      PowerOnMode(curr_Engine);
   end StartPlane;

   procedure CloseAndLockDoors is
   begin
      closeDoors;
      lockDoors;
      lockAllDoors;
   end CloseAndLockDoors;

   procedure TakeOff is
   begin
      TakeOffDoors(curr_Plane_mode, curr_Door);
      TakeOffModeFuel(curr_Plane_mode,curr_Fuel);
   end TakeOff;


begin
   while True loop
      PrintStatus;
      delay 3.0;
      Put_line("Powering Plane On");
      delay 1.0;
      StartPlane;
      CloseAndLockDoors;
      delay 3.0;
      PrintStatus;
      delay 2.0;
      TakeOff;
      PrintStatus;
      delay 3.0;
   end loop;
end Main;
