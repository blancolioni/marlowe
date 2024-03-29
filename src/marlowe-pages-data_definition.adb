with Ada.Unchecked_Conversion;
with Ada.Unchecked_Deallocation;

with Marlowe.Page_Types;

package body Marlowe.Pages.Data_Definition is

   ---------------------------
   -- Add_Record_Definition --
   ---------------------------

   function Add_Record_Definition
     (To_Page  : Data_Definition_Page;
      Name     : String;
      Length   : System.Storage_Elements.Storage_Count)
      return Real_Table_Index
   is
      Local_Index : constant Local_Record_Index :=
                      Local_Record_Index (To_Page.Contents.Count + 1);
      Result : constant Real_Table_Index :=
                      To_Page.Contents.First
                        + Real_Table_Index (Local_Index);
   begin
      To_Page.Contents.Count := Word_4 (Local_Index);
      To_Page.Contents.Info (Local_Index) :=
        (Root        => 0,
         Overflow    => 0,
         Count       => 0,
         Length      => Record_Length (Length),
         Name_Length => System.Storage_Elements.Storage_Element (Name'Length),
         Name        => (others => ' '));
      To_Page.Contents.Info (Local_Index).Name (1 .. Name'Length) := Name;
      return Result;
   end Add_Record_Definition;

   ---------------------
   -- Allocate_Record --
   ---------------------

   function Allocate_Record (Item  : Data_Definition_Page;
                             Index : Local_Record_Index)
                             return Database_Index
   is
      Count : Database_Index renames
                Item.Contents.Info (Index).Count;
   begin
      Count := Count + 1;
      return Count;
   end Allocate_Record;

   -----------------------
   -- First_Table_Index --
   -----------------------

   function First_Table_Index
     (From : Data_Definition_Page)
      return Table_Index
   is
   begin
      return From.Contents.First;
   end First_Table_Index;

   ------------------------------
   -- Get_Next_Record_Overflow --
   ------------------------------

   function Get_Next_Record_Overflow
     (Item  : Data_Definition_Page;
      Index : Local_Record_Index)
      return File_Page_And_Slot
   is
   begin
      return Item.Contents.Info (Index).Overflow;
   end Get_Next_Record_Overflow;

   -----------------------
   -- Get_Overflow_Page --
   -----------------------

   function Get_Overflow_Page
     (From : Data_Definition_Page)
      return File_And_Page
   is
   begin
      return From.Contents.Overflow;
   end Get_Overflow_Page;

   -----------------------
   -- Get_Record_Length --
   -----------------------

   function Get_Record_Length
     (Item     : Data_Definition_Page;
      Index : Local_Record_Index)
      return System.Storage_Elements.Storage_Count
   is
      Rec : Record_Info renames Item.Contents.Info (Index);
   begin
      return System.Storage_Elements.Storage_Count (Rec.Length);
   end Get_Record_Length;

   ---------------------
   -- Get_Record_Name --
   ---------------------

   function Get_Record_Name
     (Item  : Data_Definition_Page;
      Index : Local_Record_Index)
      return String
   is
      Rec : Record_Info renames Item.Contents.Info (Index);
   begin
      return Rec.Name (1 .. Natural (Rec.Name_Length));
   end Get_Record_Name;

   ---------------------
   -- Get_Record_Root --
   ---------------------

   function Get_Record_Root
     (Item  : Data_Definition_Page;
      Index : Local_Record_Index)
      return File_And_Page
   is
      Rec : Record_Info renames Item.Contents.Info (Index);
   begin
      return Rec.Root;
   end Get_Record_Root;

   ----------------
   -- Initialise --
   ----------------

   procedure Initialise
     (Item       : Data_Definition_Page;
      Loc        : File_And_Page)
   is
   begin
      Initialise (To_Page (Item),
                  Marlowe.Page_Types.Data_Definition_Page_Type, Loc);
      Item.Contents.Count := 0;
      Item.Contents.Overflow := 0;
   end Initialise;

   -----------------------
   -- Last_Record_Index --
   -----------------------

   function Last_Record_Index
     (Item  : Data_Definition_Page;
      Table : Local_Record_Index)
      return Database_Index
   is
   begin
      return Item.Contents.Info (Table).Count;
   end Last_Record_Index;

   -------------------------------
   -- Maximum_Data_Record_Count --
   -------------------------------

   function Maximum_Data_Record_Count return Natural is
   begin
      return Natural (Record_Info_Array'Length);
   end Maximum_Data_Record_Count;

   ----------------------------
   -- Number_Of_Data_Records --
   ----------------------------

   function Number_Of_Data_Records
     (Item : Data_Definition_Page)
      return Natural
   is
   begin
      return Natural (Item.Contents.Count);
   end Number_Of_Data_Records;

   -------------
   -- Release --
   -------------

   procedure Release (Item : in out Data_Definition_Page) is
      procedure Free is
         new Ada.Unchecked_Deallocation (Data_Definition_Page_Record,
                                         Data_Definition_Page);
   begin
      Free (Item);
   end Release;

   ---------------------------
   -- Set_First_Table_Index --
   ---------------------------

   procedure Set_First_Table_Index
     (Page  : Data_Definition_Page;
      Value : Table_Index)
   is
   begin
      Page.Contents.First := Value;
   end Set_First_Table_Index;

   ------------------------------
   -- Set_Next_Record_Overflow --
   ------------------------------

   procedure Set_Next_Record_Overflow
     (Item  : Data_Definition_Page;
      Index : Local_Record_Index;
      Addr  : File_Page_And_Slot)
   is
   begin
      Item.Contents.Info (Index).Overflow := Addr;
   end Set_Next_Record_Overflow;

   -----------------------
   -- Set_Overflow_Page --
   -----------------------

   procedure Set_Overflow_Page
     (From          : Data_Definition_Page;
      Overflow_Page : File_And_Page)
   is
   begin
      From.Contents.Overflow := Overflow_Page;
   end Set_Overflow_Page;

   ---------------------
   -- Set_Record_Root --
   ---------------------

   procedure Set_Record_Root
     (Item     : Data_Definition_Page;
      Index : Local_Record_Index;
      New_Root : File_And_Page)
   is
      Rec : Record_Info renames Item.Contents.Info (Index);
   begin
      Rec.Root := New_Root;
   end Set_Record_Root;

   -----------------------------
   -- To_Data_Definition_Page --
   -----------------------------

   function To_Data_Definition_Page
     (Item : Page)
      return Data_Definition_Page
   is
      use Marlowe.Page_Types;
      function TFHP is
         new Ada.Unchecked_Conversion (Page, Data_Definition_Page);
   begin
      pragma Assert (Get_Page_Type (Item) = Data_Definition_Page_Type
                     or else Get_Page_Type (Item) = No_Page_Type);
      return TFHP (Item);
   end To_Data_Definition_Page;

   --------------------
   -- To_Local_Index --
   --------------------

   function To_Local_Index
     (Page   : Data_Definition_Page;
      Index  : Table_Index)
      return Local_Record_Index
   is
   begin
      return Local_Record_Index (Index - Page.Contents.First);
   end To_Local_Index;

   -------------
   -- To_Page --
   -------------

   function To_Page (Item : Data_Definition_Page) return Page is
      function TP is
         new Ada.Unchecked_Conversion (Data_Definition_Page, Page);
   begin
      return TP (Item);
   end To_Page;

end Marlowe.Pages.Data_Definition;
