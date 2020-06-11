with GNAT.Traceback.Symbolic;
with GNAT.Exception_Traces;
procedure @_Project_Name_@.Main is
begin
   GNAT.Exception_Traces.Trace_On (GNAT.Exception_Traces.Every_Raise);
   GNAT.Exception_Traces.Set_Trace_Decorator (GNAT.Traceback.Symbolic.Symbolic_Traceback_No_Hex'Access);
   Application.Run;
end @_Project_Name_@.Main;
