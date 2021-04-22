package body door with SPARK_Mode is
   
   procedure closeDoors is 
   begin
      CockPitDoor.status := Closed;
      ExternalDoors.status := Closed;
   end closeDoors;
   
   procedure lockDoors is 
   begin
      CockPitDoor.lock := Locked;
      ExternalDoors.lock := Locked;
   end lockDoors;

   procedure lockAllDoors is begin
      if (CockPitDoor.status = Closed and ExternalDoors.status = Closed) and (CockPitDoor.lock = Locked and ExternalDoors.lock = Locked) then DoorsLockedAndClosed := True;
      else
         DoorsLockedAndClosed := False;
      end if;  
   end lockAllDoors;
   
end door;
