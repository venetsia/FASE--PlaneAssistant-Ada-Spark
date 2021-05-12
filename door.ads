package door with SPARK_Mode is
   
   --Variable --
   
   Is_Ct_Ext_Lock_Close : Boolean :=  False;
   Util_Doors_Locked_Closed : Boolean := False;
    -- Types -- 
   type Open_Closed is (Open, Closed);
   type Locked_Unlocked is (Locked, Unlocked);

   --Create Door
    type Doors is tagged record
      status : Open_Closed;
      lock : Locked_Unlocked;
   end record;
   
   type Passenger_Utility_Doors is tagged record
      status : Open_Closed;
      lock : Locked_Unlocked;
   end record;
   
   Cockpit_Door : Doors := (status => Closed, lock => Locked); -- The CockPit Door
   External_Doors : Doors := (status => Closed, lock => Locked); -- The External Doors
   Toilet_Doors : Passenger_Utility_Doors := (status => Closed, lock => Locked); -- Toilet Doors Locked
   Cabin_Doors : Passenger_Utility_Doors := (status => Closed, lock => Locked); -- Cabin Doors locked
     
   --Closes Plane Doors
   procedure close_External_Cockpit_Doors with 
     Global => (In_Out => (Cockpit_Door, External_Doors)),
     Post => Cockpit_Door.status = Closed and External_Doors.status = Closed;
   
   --Locks Plane Doors
   procedure Lock_All_Doors with 
     Global => (In_Out => (Cockpit_Door, External_Doors)),
     Pre => Cockpit_Door.status = Closed and External_Doors.status = Closed,
     Post => ((Cockpit_Door.lock = Locked and Cockpit_Door.status = Closed) and (External_Doors.lock = Locked and External_Doors.status = Closed));
   
   --Ensure both doors are closed and locked
   procedure Is_Lock_External_Cockpit with 
     Global =>(Input => (Cockpit_Door, External_Doors), Output => (Is_Ct_Ext_Lock_Close)),
     Pre => ((Cockpit_Door.status = Closed and External_Doors.status = Closed) and (Cockpit_Door.lock = Locked and External_Doors.lock = Locked)) 
             or ((Cockpit_Door.status = Open and External_Doors.status = Open) and (Cockpit_Door.lock = Unlocked and External_Doors.lock = Unlocked)),
     Post => Is_Ct_Ext_Lock_Close = True or Is_Ct_Ext_Lock_Close = False;
   
   procedure Passanger_Utility_Doors_Lock with
     Global => (Output =>(Util_Doors_Locked_Closed), In_Out =>(Cabin_Doors, Toilet_Doors)),
     Post => Util_Doors_Locked_Closed = True;
   
   --Opens Plane Doors
   procedure open_External_Cockpit_Doors with 
     Global => (In_Out => (Cockpit_Door, External_Doors)),
     Pre => Cockpit_Door.lock = Unlocked and External_Doors.lock = Unlocked,
     Post => Cockpit_Door.status = Open and External_Doors.status = Open and Cockpit_Door.lock = Unlocked and External_Doors.lock = Unlocked;
   
   procedure Unlock_Passanger_Utility_Doors with
     Global => (In_Out => (Cabin_Doors, Toilet_Doors), Output=> Util_Doors_Locked_Closed),
     Post => Cabin_Doors.lock = Unlocked and Toilet_Doors.lock = Unlocked;
   
   --Locks Plane Doors
   procedure Unlock_External_Cockpit_Doors with 
     Global => (In_Out => (Cockpit_Door, External_Doors), Output => Is_Ct_Ext_Lock_Close),
     Pre => (Cockpit_Door.status = Closed and Cockpit_Door.lock = Locked) and (External_Doors.status = Closed and External_Doors.lock = Locked),
     Post => ((Cockpit_Door.lock = Unlocked and Cockpit_Door.status = Closed) and (External_Doors.lock = Unlocked and External_Doors.status = Closed));
   

end door;
