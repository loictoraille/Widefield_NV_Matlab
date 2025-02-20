function [rc, timeStamp] = AT_GetTimeStamp(imageBuffer, imageSizeBytes)
% Function to extract MetaData from sCMOS cameras
% Inputs:
%       imageSizeBytes - the image size in bytes
%       imageBuffer - the raw image buffer returned to Matlab via
%       AT_WaitBuffer
% Returns:
%       rc - return code (returns AT_SUCCESS if successful)
%       timeStamp - the timestamp metadata from the buffer

LENGTH_FIELD_SIZE = 4;
CID_FIELD_SIZE = 4;
CID_FPGA_TICKS = 1;
AT_SUCCESS = 0;
AT_ERR_NODATA = 11;

timeStamp = 0;
rc = AT_ERR_NODATA;

offset = imageSizeBytes;
while offset > 0
    % Get length of metadata
    offset = offset - LENGTH_FIELD_SIZE;
    dataLength = extractIntValue(imageBuffer, offset, LENGTH_FIELD_SIZE)- CID_FIELD_SIZE;

    % Get Metadata identifier
    offset = offset - CID_FIELD_SIZE;
    cid = extractIntValue(imageBuffer, offset, CID_FIELD_SIZE);

    offset = offset - dataLength;
    if cid == CID_FPGA_TICKS
       timeStamp =  extractIntValue(imageBuffer, offset, dataLength);
       rc = AT_SUCCESS;
       break;
    end;
end



function value = extractIntValue(array, offset, numBytes)
value=uint64(0);
for i=1:numBytes 
   value = value + uint64(array(offset+i)) * uint64(power(2, 8*(i-1)));
end
