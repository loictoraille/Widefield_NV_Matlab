function temperature = heliCamGetTemperature(ObjCamera)
	%return the temperature in °C of the device selected (by the "DeviceTemperatureSelector")
	%TODO: Check if the value is accessible in acquisition mode (is there any interruption of access to the data)
	temperature = ObjCamera.c4dev.readFloat("DeviceTemperature");
end

