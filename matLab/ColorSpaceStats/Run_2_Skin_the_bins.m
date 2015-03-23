dirName='/Users/jaspershemilt/Developer/projects/Color-Space-Stats/matLab/ColorSpaceStats/Skin/IndividualSkin/JSkin/Index/Pad/Small';
name='RGB_JSkin_Index_Pad_Bin';
load(strcat(dirName,'/',name));
% Set the depth to skin the bins by. this will set to zero all bins which
% lie within skinDepth of the extreme edges of the bin ranges.
skinDepth=9;
eval(strcat( name,'_Skinned = Bin.skin(',name,',skinDepth)'));
% Save the result.
save(strcat(dirName,'/',name,'_Skinned'),strcat( name,'_Skinned'));
