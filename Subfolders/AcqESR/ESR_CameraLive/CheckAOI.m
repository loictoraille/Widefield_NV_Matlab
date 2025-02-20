
function AOI_out = CheckAOI(AOI_in)
global ObjCamera CameraType

AOI_out = AOI_in;

[AOIXmin,AOIYmin,AOIWidthMax,AOIHeightMax] = HardWrittenAOIEdges(CameraType);

if AOI_in.X < AOIXmin
   AOI_out.X = AOIXmin;
end
if AOI_in.Y < AOIYmin
   AOI_out.Y = AOIYmin;
end
if AOI_in.Width > AOIWidthMax
   AOI_out.Width = AOIWidthMax;
end
if AOI_in.Width > AOIHeightMax
   AOI_out.Width = AOIHeightMax;
end

end