with System.Storage_Elements;

package Marlowe.Pages.Data_Definition is

   type Data_Definition_Page_Record is private;

   type Data_Definition_Page is access all Data_Definition_Page_Record;

   function To_Data_Definition_Page
     (Item : Page)
      return Data_Definition_Page;

   function To_Page (Item : Data_Definition_Page) return Page;

   procedure Initialise (Item       : Data_Definition_Page;
                         Loc        : File_And_Page);

   procedure Release (Item : in out Data_Definition_Page);

   function Maximum_Data_Record_Count return Natural;
   --  How many data records a header page can describe

   function Number_Of_Data_Records
     (Item : Data_Definition_Page)
      return Natural;

   type Local_Record_Index is private;

   function To_Local_Index
     (Page   : Data_Definition_Page;
      Index  : Table_Index)
      return Local_Record_Index;

   function Get_Record_Name (Item  : Data_Definition_Page;
                             Index : Local_Record_Index)
                           return String;
   function Get_Record_Root (Item  : Data_Definition_Page;
                             Index : Local_Record_Index)
                             return File_And_Page;

   procedure Set_Record_Root (Item     : Data_Definition_Page;
                              Index    : Local_Record_Index;
                              New_Root : File_And_Page);

   function Get_Record_Length
     (Item     : Data_Definition_Page;
      Index    : Local_Record_Index)
      return System.Storage_Elements.Storage_Count;

   function Get_Next_Record_Overflow
     (Item  : Data_Definition_Page;
      Index : Local_Record_Index)
      return File_Page_And_Slot;
   --  Next available location for record data which does
   --  not fit into the 56 bytes available in the main
   --  record data page.

   procedure Set_Next_Record_Overflow
     (Item  : Data_Definition_Page;
      Index : Local_Record_Index;
      Addr  : File_Page_And_Slot);

   function Add_Record_Definition
     (To_Page  : Data_Definition_Page;
      Name     : String;
      Length   : System.Storage_Elements.Storage_Count)
      return Real_Table_Index;

   function Get_Overflow_Page (From : Data_Definition_Page)
                              return File_And_Page;

   procedure Set_Overflow_Page (From          : Data_Definition_Page;
                                Overflow_Page : File_And_Page);

   function First_Table_Index
     (From : Data_Definition_Page)
      return Table_Index;

   procedure Set_First_Table_Index
     (Page : Data_Definition_Page;
      Value : Table_Index);

   function Allocate_Record (Item    : Data_Definition_Page;
                             Index : Local_Record_Index)
                             return Database_Index;

   function Last_Record_Index (Item  : Data_Definition_Page;
                               Table : Local_Record_Index)
                              return Database_Index;

private

   Max_Name_Length : constant := 37;
   --  We will be able to support longer names, but the name will
   --  be somehow compressed

   Record_Length_Bits : constant := 16;
   type Record_Length is mod 2 ** Record_Length_Bits;

   type Record_Info is
      record
         Root           : File_And_Page;
         Overflow       : File_Page_And_Slot;
         Count          : Database_Index;
         Length         : Record_Length;
         Name_Length    : System.Storage_Elements.Storage_Element;
         Name           : String (1 .. Max_Name_Length);
      end record;

   Record_Info_Size : constant := 64 * System.Storage_Unit;

   for Record_Info use
      record
         Root           at  0 range  0 .. 63;
         Overflow       at  8 range  0 .. 63;
         Count          at 16 range  0 .. 63;
         Length         at 24 range  0 .. 15;
         Name_Length    at 26 range  0 ..  7;
         Name           at 27 range  0 .. Max_Name_Length * 8 - 1;
      end record;

   for Record_Info'Size use Record_Info_Size;

   Record_Info_Bits : constant := Page_Contents_Bits - 128;
   Record_Info_Count : constant :=
                         Record_Info_Bits / Record_Info_Size;
   type Local_Record_Index is range 1 .. Record_Info_Count;
   type Record_Info_Array is
     array (Local_Record_Index) of Record_Info;
   pragma Pack (Record_Info_Array);

   subtype Unused_Array is System.Storage_Elements.Storage_Array (1 .. 22);

   type Data_Definition_Page_Contents is
      record
         Overflow     : File_And_Page;
         Count        : Word_4;
         Info         : Record_Info_Array;
         First        : Table_Index;
         Unused       : Unused_Array;
      end record;

   for Data_Definition_Page_Contents'Size use Page_Contents_Bits;

   type Data_Definition_Page_Record is
      record
         Header    : Page_Header;
         Contents  : Data_Definition_Page_Contents;
         Tail      : Page_Tail;
      end record;

   for Data_Definition_Page_Record'Size use Page_Bits;

end Marlowe.Pages.Data_Definition;
