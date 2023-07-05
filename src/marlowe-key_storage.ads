with System.Storage_Elements;

package Marlowe.Key_Storage is

   type Unsigned_Integer is mod 2 ** Integer'Size;

   subtype Storage_Array is System.Storage_Elements.Storage_Array;

   function To_Storage_Array (Value : Database_Index)
                              return System.Storage_Elements.Storage_Array;

   function To_Storage_Array
     (Value : Integer;
      Length : System.Storage_Elements.Storage_Count)
      return System.Storage_Elements.Storage_Array;

   function To_Storage_Array
     (Value : Float)
      return System.Storage_Elements.Storage_Array;

   function To_Storage_Array
     (Value : Long_Float)
      return System.Storage_Elements.Storage_Array;

   function To_Storage_Array
     (Value : String;
      Length : System.Storage_Elements.Storage_Count)
      return System.Storage_Elements.Storage_Array;

   function Fixed_String_To_Storage
     (Value  : String;
      Length : System.Storage_Elements.Storage_Count)
      return System.Storage_Elements.Storage_Array;

   procedure To_Storage
     (Value   : Database_Index;
      Storage : in out Storage_Array);

   procedure To_Storage
     (Value   : Boolean;
      Storage : in out Storage_Array);

   procedure To_Storage
     (Value   : Integer;
      Storage : in out Storage_Array);

   procedure To_Storage
     (Value   : Unsigned_Integer;
      Storage : in out Storage_Array);

   procedure To_Storage
     (Value   : Float;
      Storage : in out Storage_Array);

   procedure To_Storage
     (Value   : Long_Float;
      Storage : in out Storage_Array);

   procedure Bounded_String_To_Storage
     (Value   : String;
      Storage : in out Storage_Array);

   procedure Fixed_String_To_Storage
     (Value   : String;
      Storage : in out Storage_Array);

   procedure To_Storage
     (Value   : File_And_Page;
      Storage : in out Storage_Array);

   procedure From_Storage
     (Value   :    out Database_Index;
      Storage : Storage_Array);

   procedure From_Storage
     (Value   :    out Integer;
      Storage : Storage_Array);

   procedure From_Storage
     (Value   :    out Unsigned_Integer;
      Storage : Storage_Array);

   procedure From_Storage
     (Value   :    out Boolean;
      Storage : Storage_Array);

   procedure From_Storage
     (Value   :    out Float;
      Storage : Storage_Array);

   procedure From_Storage
     (Value   :    out Long_Float;
      Storage : Storage_Array);

   procedure From_Storage
     (Value   :    out File_And_Page;
      Storage : Storage_Array);

   procedure Bounded_String_From_Storage
     (Value   :    out String;
      Length  :    out Natural;
      Storage : Storage_Array);

   procedure Fixed_String_From_Storage
     (Value   :    out String;
      Storage : Storage_Array);

   function To_Database_Index
     (Key_Value : System.Storage_Elements.Storage_Array)
      return Database_Index;

   type Compare_Result is (Less, Equal, Greater);

   function Compare (Left, Right : System.Storage_Elements.Storage_Array)
                    return Compare_Result;

   function Equal (Left, Right : System.Storage_Elements.Storage_Array)
                   return Boolean;

   function Image (Key : System.Storage_Elements.Storage_Array)
                   return String;

   generic
      type Component_Type is mod <>;
   package Unsigned_Key_Components is
      function To_Storage_Array
        (Value  : Component_Type;
         Length : System.Storage_Elements.Storage_Count)
         return System.Storage_Elements.Storage_Array;

      function To_Ada_Type
        (Key_Value : System.Storage_Elements.Storage_Array)
        return Component_Type;
   end Unsigned_Key_Components;

   generic
      type Integral is range <>;
   package Integral_Storage is

      procedure From_Storage
        (Value   :    out Integral;
         Storage : Storage_Array);

      procedure To_Storage
        (Value   : Integral;
         Storage : in out Storage_Array);

   end Integral_Storage;

end Marlowe.Key_Storage;
