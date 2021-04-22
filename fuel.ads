package fuel with SPARK_Mode is

   type fuelStatus is (Low, Sufficient);
   type warnSign is (on, off);
   type FuelLevels is range 0..4000; -- litres
   
   type PlaneFuelTank is tagged record
      status: fuelStatus;
      warning: warnSign;
   end record;
   
   current_FuelLevel: FuelLevels; 
   
   function FuelInvariant (This : in PlaneFuelTank) return Boolean is
     (This.status = Low or This.warning = off);
   
   procedure addFuel (This : in out PlaneFuelTank) with
     Pre'Class => (This.FuelInvariant and (current_FuelLevel >= FuelLevels'First and current_FuelLevel < FuelLevels'Last)), 
     Post => (current_FuelLevel = current_FuelLevel'Old + 1 or  
                current_FuelLevel = current_FuelLevel'Old);
   
   procedure burnFuel (This : in out PlaneFuelTank) with
     Pre'Class => (This.FuelInvariant and (current_FuelLevel <= FuelLevels'Last and current_FuelLevel > FuelLevels'First)), 
     Post => (current_FuelLevel = current_FuelLevel'Old - 1 or  
                current_FuelLevel = current_FuelLevel'Old);
   
   procedure LoworSufficientLevelOfFuel (This : in out PlaneFuelTank) with
     Pre'Class => This.warning = off or This.warning = on,
     Post => This.warning = off or This.warning = on;                     
                               
                               
   procedure WarningSignONOFF (This :  in out PlaneFuelTank) with
     Pre'Class => This.FuelInvariant and ((This.status /= Low) and (This.status = Low)),
     Post => This.FuelInvariant;
   
   function ConstructFuelTank return PlaneFuelTank;
end fuel;
