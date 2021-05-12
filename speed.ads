package speed with SPARK_Mode is

   type Speed is range 0..10; -- some metric that allows levels of speed 
   type Speed_Type is (normal, speeding, takeoff_Landing, standby);

   type Speedometer is tagged record
      current_Speed_Type : Speed_Type;
   end record; 
   
   current_speed: Speed;
   
  function Speed_Invariant return Boolean is
     (current_speed >= Speed'First and current_speed <= Speed'Last);
   
  procedure Accelerate_Speed (current_speed : in out Speed; This : in out Speedometer) with
     Pre'Class => (Speed_Invariant and current_speed < Speed'Last), 
     Post => Speed_Invariant and (current_speed = current_speed'Old + 1 or  
       current_speed = current_speed'Old);

   procedure Decrease_Speed (current_speed : in out Speed; This : in out Speedometer) with
     Pre'Class => (Speed_Invariant and current_speed > Speed'First), 
     Post => Speed_Invariant and (current_speed = current_speed'Old - 1 or  
     current_speed = current_speed'Old);
   
   procedure Assign_Speed_Mode(This : in out Speedometer)  with
     Pre'Class => Speed_Invariant,
     Post => Speed_Invariant;
   
   
end speed;
