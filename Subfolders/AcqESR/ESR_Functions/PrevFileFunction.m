function PrevFileFunction(~,~)
global Ftot M AcqParameters CameraType

panel = guidata(gcbo);

load([getPath('Param') 'FileInfo.mat'],'-mat','Data_Path')

folderPath = Data_Path;
fileName = panel.fname.String;

[newFileName,exists] = GetPrevFileName(fileName,folderPath);

if exists
    pname = Data_Path;
    fname = newFileName;
    OpenFileCommonScript;
end

end