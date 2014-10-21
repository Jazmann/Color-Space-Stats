function createBinsFromDir(dirName, individualName, digitName,trans)
axisRanges=round(trans.range*trans.discreteRange);
axisLengths=round(trans.axisLength*trans.discreteRange);
RGBBin=Bin([256,256,256],[0,0,0],[255,255,255]);
YabBin=Bin(axisLengths', axisRanges(:,1)', axisRanges(:,2)');
nameYab = strcat('Yab_',individualName,'_',digitName,'_Bin');
nameRGB = strcat('RGB_',individualName,'_',digitName,'_Bin');
RGBBin.name = nameRGB;
RGBBin.axisNames=['R','G','B'];
RGBBin=RGBBin.addDirectory(dirName);
RGBBin=RGBBin.norm();
% YabBin.name = nameYab;
% YabBin.axisNames=['Y','a','b'];
% YabBin=YabBin.addDirectory(dirName,trans);
% YabBin=YabBin.norm();
eval(sprintf('%s=RGBBin',RGBBin.name));
eval(sprintf('save(''%s%s.mat'',''%s'') ',dirName,RGBBin.name,RGBBin.name));
% eval(sprintf('%s=YabBin',YabBin.name));
% eval(sprintf('save(''%s%s.mat'',''%s'') ',dirName,YabBin.name,YabBin.name));
end
