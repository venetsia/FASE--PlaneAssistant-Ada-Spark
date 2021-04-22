package door with SPARK_Mode is
   
   --Variable --
   
   DoorsLockedAndClosed : Boolean;
    -- Types -- 
   type OpenClosed is (Open, Closed);
   type LockedUnlocked is (Locked, Unlocked);

   --Create Door
    type Doors is tagged record
      status : OpenClosed;
      lock : LockedUnlocked;
   end record;
   
   CockPitDoor : Doors := (status => Closed, lock => Locked); -- The CockPit Door
   ExternalDoors : Doors := (status => Closed, lock => Locked); -- The External Doors 
     
   --Closes Plane Doors
   procedure closeDoors with 
     Global => (In_Out => (CockPitDoor, ExternalDoors)),
     Post => CockPitDoor.status = Closed and ExternalDoors.status = Closed;
   
   --Locks Plane Doors
   procedure lockDoors with 
     Global => (In_Out => (CockPitDoor, ExternalDoors)),
     Pre => CockPitDoor.status = Closed and ExternalDoors.status = Closed,
     Post => ((CockPitDoor.lock = Locked and CockPitDoor.status = Closed) and (ExternalDoors.lock = Locked and ExternalDoors.status = Closed));
   
   --Ensure both doors are closed and locked
   procedure lockAllDoors with 
     Global =>(Input => (CockPitDoor, ExternalDoors), Output => (DoorsLockedAndClosed)),
     Pre => (CockPitDoor.status = Closed and ExternalDoors.status = Closed) and (CockPitDoor.lock = Locked and ExternalDoors.lock = Locked),
     Post => DoorsLockedAndClosed = True;
end door;
