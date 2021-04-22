package speed with SPARK_Mode is

  type Speed is range 0..10; -- some metric that allows levels of speed 
   type SpeedType is (normal, takeoffLanding, standby);
   
   type Speedometer is tagged record
      currentSpeedType : SpeedType;
   end record; 
   
   current_speed: Speed;
   
  function SpeedInvariant return Boolean is
     (current_speed >= Speed'First and current_speed <= Speed'Last);
   
  procedure accelerateSpeed (current_speed : in out Speed) with
     Pre => (SpeedInvariant and current_speed < Speed'Last), 
     Post => SpeedInvariant and (current_speed = current_speed'Old + 1 or  
       current_speed = current_speed'Old);

   procedure decreaseSpeed (current_speed : in out Speed) with
     Pre => (SpeedInvariant and current_speed > Speed'First), 
     Post => SpeedInvariant and (current_speed = current_speed'Old - 1 or  
     current_speed = current_speed'Old);
   
   procedure AssignSpeedMode(This : in out Speedometer)  with
     Pre'Class => SpeedInvariant,
     Post => SpeedInvariant and (This.currentSpeedType = standBy or This.currentSpeedType = takeoffLanding or This.currentSpeedType = normal);
   
   
end speed;
