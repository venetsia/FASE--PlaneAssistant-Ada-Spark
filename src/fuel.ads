package fuel with SPARK_Mode is

   type fuel_Status is (Low, Sufficient);
   type warn_Sign is (on, off);
   type Fuel_Levels is range 0..45; -- litres
   
   type Plane_Fuel_Tank is tagged record
      status: fuel_Status;
      warning: warn_Sign;
   end record;
   
   current_Fuel_Level: Fuel_Levels; 
   
   function Fuel_Invariant (This : in Plane_Fuel_Tank) return Boolean is
     (This.status = Low or This.warning = off);
   
   function Fuel_Level_Invarant return Boolean is
     (current_Fuel_Level >= Fuel_Levels'First and current_Fuel_Level <= Fuel_Levels'Last);
   
   procedure Add_Fuel (This : in out Plane_Fuel_Tank) with
     Pre'Class => ((This.Fuel_Invariant  and Fuel_Level_Invarant) and (current_Fuel_Level >= Fuel_Levels'First and current_Fuel_Level < Fuel_Levels'Last)), 
     Post => (This.Fuel_Invariant  and Fuel_Level_Invarant) and (current_Fuel_Level = current_Fuel_Level'Old + 1 or  
                current_Fuel_Level = current_Fuel_Level'Old);
   
   procedure Burn_Fuel (This : in out Plane_Fuel_Tank) with
     Pre'Class => ((This.Fuel_Invariant  and Fuel_Level_Invarant) and (current_Fuel_Level <= Fuel_Levels'Last and current_Fuel_Level > Fuel_Levels'First)), 
     Post => (This.Fuel_Invariant  and Fuel_Level_Invarant) and (current_Fuel_Level = current_Fuel_Level'Old - 1 or  
                current_Fuel_Level = current_Fuel_Level'Old);
   
   procedure Low_Sufficient_Fuel_Level (This : in out Plane_Fuel_Tank) with
     Pre'Class => (This.Fuel_Invariant  and Fuel_Level_Invarant) and (current_Fuel_Level < 15 or current_Fuel_Level >= 15),
     Post => (This.Fuel_Invariant  and Fuel_Level_Invarant);                     
                               
end fuel;

