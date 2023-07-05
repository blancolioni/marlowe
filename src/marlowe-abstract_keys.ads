generic

   type Key_Type is private;

   Key_Name     : String;
   Unique       : Boolean;

   with function "<" (Left, Right : Key_Type) return Boolean is <>;
   with function "=" (Left, Right : Key_Type) return Boolean is <>;

package Marlowe.Abstract_Keys is

   type Key_Context is private;

   function Empty_Context return Key_Context;

   procedure Open;
   procedure Create;
   procedure Close;

   function Valid (Context : Key_Context) return Boolean;
   function Get_Element (Context : Key_Context) return Database_Index;

   procedure Insert (Key     : Key_Type;
                     Element : Database_Index);

   procedure Change (Old_Key : Key_Type;
                     New_Key : Key_Type;
                     Element : Database_Index);

   function First_With_Element (Key      : Key_Type;
                                Element  : Database_Index;
                                Use_Key  : Boolean)
                               return Key_Context;

   function First return Key_Context;
   function First (Key : Key_Type) return Key_Context;
   function First_Greater (Key : Key_Type) return Key_Context;

   function Last return Key_Context;
   function Last (Key : Key_Type) return Key_Context;
   function Last_Less (Key : Key_Type) return Key_Context;

   function Next (Current : Key_Context) return Key_Context;
   function Previous (Current : Key_Context) return Key_Context;

   procedure Delete (Key : in out Key_Context);

   procedure Trace (On : Boolean);

private

   type Key_Context is
      record
         Element    : Database_Index;
         Key        : Key_Type;
         Scratch    : Natural;
         Uses_Key   : Boolean         := False;
      end record;

   function Get_Element (Context : Key_Context) return Database_Index
   is (Context.Element);

   function Valid (Context : Key_Context) return Boolean
   is (Context.Element /= 0);

end Marlowe.Abstract_Keys;
