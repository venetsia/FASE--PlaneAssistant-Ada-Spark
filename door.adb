package body door with SPARK_Mode is
   
   procedure close_External_Cockpit_Doors is 
   begin
      Cockpit_Door.status := Closed;
      External_Doors.status := Closed;
   end close_External_Cockpit_Doors;
   
   procedure Lock_All_Doors is 
   begin
      Cockpit_Door.lock := Locked;
      External_Doors.lock := Locked;
   end Lock_All_Doors;

   procedure Is_Lock_External_Cockpit is begin
      if (Cockpit_Door.status = Closed and Cockpit_Door.lock = Locked) and (External_Doors.status = Closed and External_Doors.lock = Locked)
      then 
         Is_Ct_Ext_Lock_Close := True;
      else
         Is_Ct_Ext_Lock_Close := False;
      end if;  
   end Is_Lock_External_Cockpit;
   
   procedure Passanger_Utility_Doors_Lock is begin
      Toilet_Doors.status := Closed;
      Cabin_Doors.status := Closed;
      if (Cabin_Doors.status = Closed and Toilet_Doors.status = Closed)
      then Util_Doors_Locked_Closed := True;
      else
           Util_Doors_Locked_Closed := False;
      end if;
   end Passanger_Utility_Doors_Lock;
   
   procedure Open_External_Cockpit_Doors is 
      begin
      Cockpit_Door.status := Open;
      External_Doors.status := Open;
      Is_Lock_External_Cockpit;

   end Open_External_Cockpit_Doors;
   
   procedure Unlock_Passanger_Utility_Doors is
   begin
      Cabin_Doors.lock := Unlocked;
      Toilet_Doors.lock := Unlocked;
      Util_Doors_Locked_Closed := False;
   end Unlock_Passanger_Utility_Doors;
   
   
   procedure Unlock_External_Cockpit_Doors is 
   begin
      Cockpit_Door.lock := Unlocked;
      External_Doors.lock := Unlocked;
      Is_Ct_Ext_Lock_Close := False;
   end Unlock_External_Cockpit_Doors;

   
   
end door;
