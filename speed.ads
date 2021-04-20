package speed with SPARK_Mode is

  type Speed is range 0..1000; -- meters per hour
   
   type Speedometer is tagged record
      current_speed: Speed;
   end record; 
   
  function SpeedInvariant (This : in Speedometer) return Boolean is
     (This.current_speed >= Speed'First and This.current_speed <= Speed'Last);
   
  procedure accelerateSpeed (This : in out Speedometer) with
     Pre'Class => (This.SpeedInvariant and This.current_speed < Speed'Last), 
     Post => This.SpeedInvariant;

end speed;
