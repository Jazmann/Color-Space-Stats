function createBinsFromDir(dirName, individualName, digitName,trans, transLoc, method)
RGBBin=Bin([256,256,256],[0,0,0],[255,255,255]);
RGBBin.name = nameRGB;
RGBBin.axisNames=['R','G','B'];
RGBBin=RGBBin.addDirectory(dirName);
RGBBin=RGBBin.norm();
nameRGB = strcat(axisNames,'_',individualName,'_',digitName,'_Bin');
eval(sprintf('%s=RGBBin',RGBBin.name));
eval(sprintf('save(''%s%s.mat'',''%s'') ',dirName,RGBBin.name,RGBBin.name));
if nargin>3
axisRanges=round(trans.range*trans.discreteRange);
axisLengths=round(trans.axisLength*trans.discreteRange);
% YabBin=Bin(axisLengths', axisRanges(:,1)', axisRanges(:,2)');
switch nargin
    case 6
        nameYab = strcat('Yab_',individualName,'_',digitName,'_',method,'_Bin');
        YabBin=RGBBin.rot(trans, transLoc, method);
    case 5
        nameYab = strcat('Yab_',individualName,'_',digitName,'_round_Bin');
        YabBin=RGBBin.rot(trans, transLoc);
    case 4
        nameYab = strcat('Yab_',individualName,'_',digitName,'_round_Bin');
        YabBin=RGBBin.rot(trans);
end
YabBin.name = nameYab;
YabBin.axisNames=['Y','a','b'];
YabBin=YabBin.norm();
eval(sprintf('%s=YabBin',YabBin.name));
eval(sprintf('save(''%s%s.mat'',''%s'') ',dirName,YabBin.name,YabBin.name));
end
end
