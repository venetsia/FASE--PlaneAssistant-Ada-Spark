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
     Post => (current_FuelLevel >= FuelLevels'First and current_FuelLevel <= FuelLevels'Last) and This.FuelInvariant;
   
   procedure LowLevelOfFuel (This : in out PlaneFuelTank) with
     Pre'Class => This.warning = off,
     Post => This.FuelInvariant;                     
                               
                               
   procedure WarningSignONOFF (This : in out PlaneFuelTank) with
     Pre'Class => This.status = Low and This.FuelInvariant,
     Post => This.FuelInvariant;
   
   function ConstructFuelTank return PlaneFuelTank;
end fuel;
