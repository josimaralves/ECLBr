program PTestSysIfTuple;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}
{$STRONGLINKTYPES ON}
uses
  FastMM4,
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ELSE}
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  {$ENDIF }
  DUnitX.TestFramework,
  eclbr.objectlib in '..\..\Source\eclbr.objectlib.pas',
  eclbr.regexlib in '..\..\Source\eclbr.regexlib.pas',
  eclbr.sysvector in '..\..\Source\eclbr.sysvector.pas',
  eclbr.sysdictionary in '..\..\Source\eclbr.sysdictionary.pas',
  eclbr.sysifthen in '..\..\Source\eclbr.sysifthen.pas',
  eclbr.syslist in '..\..\Source\eclbr.syslist.pas',
  eclbr.sysmap in '..\..\Source\eclbr.sysmap.pas',
  eclbr.sysutils in '..\..\Source\eclbr.sysutils.pas',
  eclbr.include in '..\..\Source\eclbr.include.pas',
  eclbr.interfaces in '..\..\Source\eclbr.interfaces.pas',
  eclbr.sysmatch in '..\..\Source\eclbr.sysmatch.pas',
  eclbr.result.pair.exception in '..\..\Source\resultpair\eclbr.result.pair.exception.pas',
  eclbr.result.pair in '..\..\Source\resultpair\eclbr.result.pair.pas',
  eclbr.result.pair.value in '..\..\Source\resultpair\eclbr.result.pair.value.pas',
  UTestEclbr.SysIfTuple in 'UTestEclbr.SysIfTuple.pas',
  eclbr.systuple in '..\..\Source\eclbr.systuple.pas';

var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
  nunitLogger : ITestLogger;
begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
  exit;
{$ENDIF}
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //tell the runner how we will log things
    //Log to the console window
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False; //When true, Assertions must be made during tests;

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    TDUnitX.Options.ExitBehavior := TDUnitXExitBehavior.Pause;
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end.