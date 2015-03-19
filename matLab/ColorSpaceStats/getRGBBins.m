function [ rgbBin] = getRGBBins(dirName,name)
% dirName is the path to a directory of 24bit RGB jpg images
% name is the name of the variable to output
dataMin  = 0; dataMax = 255; 
rgbBin = Bin([dataMax+1,dataMax+1,dataMax+1],[dataMin,dataMin,dataMin],[dataMax,dataMax,dataMax]);
rgbBin.name = name;
rgbBin.axisNames = ['R','G','B'];
rgbBin = rgbBin.addDirectory(dirName);
eval([name,' = rgbBin']);
save(strcat(dirName,'/',name),name);
end
