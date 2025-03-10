
function tempStatus = CheckAndorTemp()
global ObjCamera CameraType

[rc, temp] = AT_GetFloat(ObjCamera,'SensorTemperature');
AT_CheckWarning(rc);

disp(['T_Andor = ' num2str(temp) '°C'])

[rc,tempIndex] = AT_GetEnumIndex(ObjCamera,'TemperatureStatus');
AT_CheckWarning(rc);

[rc,tempStatus] = AT_GetEnumStringByIndex(ObjCamera,'TemperatureStatus',tempIndex,256);
AT_CheckWarning(rc);

disp(tempStatus);
    
end