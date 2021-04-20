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
      
      if CockPitDoor.lock = Locked then cockPitDoorLockedAndClosed := True;
      end if;
      if ExternalDoors.lock = Locked then externalDoorsLockedAndClosed := True; 
      end if;   
   end lockDoors;

   procedure lockAllDoors is begin
         if externalDoorsLockedAndClosed and cockPitDoorLockedAndClosed = True then doorsLockedAndClosed := True;
      end if;  
   end lockAllDoors;
   
end door;
