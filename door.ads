package door with SPARK_Mode is

   --Variable--
   doorsLockedAndClosed : Boolean; --True if no doors are open and locked
   cockPitDoorLockedAndClosed : Boolean; -- True if locked and closed
   externalDoorsLockedAndClosed : Boolean; -- True if closed and locked
    -- Types -- 
   type OpenClosed is (Open, Closed);
   type LockedUnlocked is (Locked, Unlocked);

   --Create Door
    type Door is tagged record
      status : OpenClosed;
      lock : LockedUnlocked;
   end record;
   
   CockPitDoor : Door := (status => Closed, lock => Locked); -- The CockPit Door
   ExternalDoors : Door := (status => Closed, lock => Locked); -- The External Doors 
   
   --Invariant--
   function DoorsClosedInvariant return Boolean is 
      ((externalDoorsLockedAndClosed = False and cockPitDoorLockedAndClosed = False) or (doorsLockedAndClosed = True));
   
   --Closes Plane Doors
   procedure closeDoors with 
     Global => (In_Out => (CockPitDoor, ExternalDoors)),
     Post => CockPitDoor.status = Closed and ExternalDoors.status = Closed;
   
   --Locks Plane Doors
   procedure LockDoors with 
     Global => (Proof_In => doorsLockedAndClosed, In_Out => (CockPitDoor, ExternalDoors, cockPitDoorLockedAndClosed, externalDoorsLockedAndClosed)),
     Pre => CockPitDoor.status = Closed and ExternalDoors.status = Closed and DoorsClosedInvariant,
     Post => CockPitDoor.lock = Locked and ExternalDoors.lock = Locked;
   
   --Ensure both doors are closed and locked
   procedure lockAllDoors with 
     Global =>( Input => (externalDoorsLockedAndClosed, cockPitDoorLockedAndClosed),
               In_Out => doorsLockedAndClosed),
     Pre => externalDoorsLockedAndClosed = True and cockPitDoorLockedAndClosed = True and DoorsClosedInvariant,
     Post => externalDoorsLockedAndClosed = True and then cockPitDoorLockedAndClosed = True and then DoorsClosedInvariant and then doorsLockedAndClosed = True;
   
end door;
