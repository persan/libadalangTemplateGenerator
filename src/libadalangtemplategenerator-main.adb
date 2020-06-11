with Ada.Text_IO; use Ada.Text_IO;
with Libadalang.Common;
with Ada.Strings.Maps;
with Ada.Strings.Fixed;
with GNAT.Case_Util;
procedure libadalangTemplateGenerator.Main is

   Outdir   : constant String := "libadalang_project/src/";
   Ada2file : constant Ada.Strings.Maps.Character_Mapping :=
                Ada.Strings.Maps.To_Mapping ("ABCDEFGHIJKLMNOPQRSTUVWXYZ.",
                                             "abcdefghijklmnopqrstuvwxyz-");
   use Ada.Strings.Fixed;

   procedure Spec (Name : String) is
      Outf : Ada.Text_IO.File_Type;
   begin
      Create (Outf, Out_File, Outdir & Translate (Name, Ada2file) & ".ads");
      Put_Line (Outf, "with Libadalang.Analysis; use Libadalang.Analysis;");
      Put_Line (Outf, "with Libadalang.Helpers;");
      Put_Line (Outf, "with Ada.Strings.Unbounded;");
      Put_Line (Outf, "package " & Name & " is");
      Put_Line (Outf, "   procedure Process_Unit (Context : Libadalang.Helpers.App_Job_Context; Unit : Analysis_Unit);");
      Put_Line (Outf, "");
      Put_Line (Outf, "   package Application is new Libadalang.Helpers.App");
      Put_Line (Outf, "     (Name         => ""magic_app"",");
      Put_Line (Outf, "      Description  => ""Magic app. Will do magic"",");
      Put_Line (Outf, "      Process_Unit => Process_Unit);");
      Put_Line (Outf, "");
      Put_Line (Outf, "   type Analyzser (Context : access Libadalang.Helpers.App_Job_Context;");
      Put_Line (Outf, "                   Unit    : access Analysis_Unit) is tagged");
      Put_Line (Outf, "      record");
      Put_Line (Outf, "         Name        : Ada.Strings.Unbounded.Unbounded_String;");
      Put_Line (Outf, "         Spec_Buffer : Ada.Strings.Unbounded.Unbounded_String;");
      Put_Line (Outf, "         Body_Buffer : Ada.Strings.Unbounded.Unbounded_String;");
      Put_Line (Outf, "      end record;");
      Put_Line (Outf, "");
      for I in Libadalang.Common.Ada_Node_Kind_Type loop
         declare
            Name : String := I'Img;
         begin
            GNAT.Case_Util.To_Mixed (Name);
            Put_Line (Outf, "   procedure On_" & Name & " (Self : in out Analyzser; Node : Ada_Node'Class);");
            Put_Line (Outf, "");
         end;
      end loop;
      Put_Line (Outf, "end " & Name & ";");
      Close (Outf);
   end Spec;
   procedure Implementation (Name : String) is
      Outf : Ada.Text_IO.File_Type;
   begin
      Create (Outf, Out_File, Outdir & Translate (Name, Ada2file) & ".adb");
      Put_Line (Outf, "with Libadalang.Common;");
      Put_Line (Outf, "with Ada.Text_IO;");
      Put_Line (Outf, "with GNAT.Source_Info;");
      Put_Line (Outf, "package body " & Name & " is");
      Put_Line (Outf, "");
      Put_Line (Outf, "   use Libadalang.Common;");
      Put_Line (Outf, "   use Ada.Text_IO;");
      Put_Line (Outf, "   use GNAT.Source_Info;");
      Put_Line (Outf, "");
      Put_Line (Outf, "   procedure Process_Unit (Context : Libadalang.Helpers.App_Job_Context; Unit : Analysis_Unit) is");
      Put_Line (Outf, "      Self : Analyzser (Context'Unrestricted_Access, Unit'Unrestricted_Access);");
      Put_Line (Outf, "   begin");
      Put_Line (Outf, "      for Node of Unit.Root.Children loop");
      Put_Line (Outf, "         case Node.Kind is");
      Put_Line (Outf, "            when Ada_Library_Item =>");
      Put_Line (Outf, "               Self.On_Ada_Library_Item (Node);");
      Put_Line (Outf, "            when others =>");
      Put_Line (Outf, "               Put_Line (Enclosing_Entity & "" : "" & Node.Kind'Img & "" : "" & Node.Image);");
      Put_Line (Outf, "         end case;");
      Put_Line (Outf, "      end loop;");
      Put_Line (Outf, "   end Process_Unit;");
      Put_Line (Outf, "");
      for I in Libadalang.Common.Ada_Node_Kind_Type loop
         declare
            Name : String := I'Img;
         begin
            GNAT.Case_Util.To_Mixed (Name);
            Put_Line (Outf, "   procedure On_" & Name & " (Self : in out Analyzser; Node : Ada_Node'Class) is");
            Put_Line (Outf, "   begin");
            Put_Line (Outf, "      Put_Line (Source_Location & "":"" & Enclosing_Entity & "" >> "" & Node.Kind'Img & "" : "" & Node.Image);");
            Put_Line (Outf, "      for N of Node.Children loop");
            Put_Line (Outf, "         if not N.Is_Null then");
            Put_Line (Outf, "            case Node.Kind is");
            Put_Line (Outf, "               when " & Name & " =>");
            Put_Line (Outf, "                  Self.On_" & Name & " (N);");
            Put_Line (Outf, "               when others =>");
            Put_Line (Outf, "                  Put_Line (Source_Location & "":"" & Enclosing_Entity & "" : "" & N.Kind'Img & "" : "" & N.Image);");
            Put_Line (Outf, "            end case;");
            Put_Line (Outf, "         end if;");
            Put_Line (Outf, "      end loop;");
            Put_Line (Outf, "   end On_" & Name & ";");
            Put_Line (Outf, "");
         end;
      end loop;
      Put_Line (Outf, "end " & Name & ";");
      Close (Outf);
   end Implementation;
begin
   Spec ("@_Project_Name_@");
   Implementation ("@_Project_Name_@");
end libadalangTemplateGenerator.Main;
