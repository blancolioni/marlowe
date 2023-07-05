package body Marlowe.Debug is

   -------------
   -- Enabled --
   -------------

   function Enabled
     (Class : Marlowe.Debug_Classes.Marlowe_Debug_Class)
      return Boolean
   is
      pragma Unreferenced (Class);
   begin
      return False;
   end Enabled;

end Marlowe.Debug;
