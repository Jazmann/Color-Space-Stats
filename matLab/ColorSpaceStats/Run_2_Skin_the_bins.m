dirName='/Users/jaspershemilt/Developer/projects/Color-Space-Stats/matLab/ColorSpaceStats/Skin/IndividualSkin/JSkin/Index/Pad/Small';
name='RGB_JSkin_Index_Pad_Bin';
load(strcat(dirName,'/',name));
skinDepth=9;
eval(strcat( name,'_Skinned = Bin.skin(',name,',skinDepth)'));

save(strcat(dirName,'/',name,'_Skinned'),strcat( name,'_Skinned'));
