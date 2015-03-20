% 
function [ rgbBin] = addRGBBins(dirName)
%
dataMin  = 0; dataMax = 255; 
rgbBin = Bin([dataMax+1,dataMax+1,dataMax+1],[dataMin,dataMin,dataMin],[dataMax,dataMax,dataMax]);

D = [dir(strcat(dirName,'/*.jpg')),dir(strcat(dirName,'/*.JPG'))];
for k = 1:numel(D)
  img = imread(strcat(dirName,'/',D(k).name));
[rows, cols, channels] = size(img);
for i = 1:rows
    for j = 1:cols
        chanVals = squeeze(img(i,j,:))  + 1;
        rgbBin = rgbBin.addValue(chanVals);
    end
end

end

% save the output Rv, Gv, Bv, binOut, cA
save(strcat(dirName,'/rgbBin'),'rgbBin');

end

