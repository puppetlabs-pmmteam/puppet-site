@ECHO OFF
REM Simple batch script to spit out the LOCATION environment variable
if NOT [%LOCATION%] == [] (
  ECHO LOCATION=%LOCATION%
)