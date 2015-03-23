load(strcat(dirName,'/',name,'_Skinned_Rot_TopTail_CaCb'));
% Despeckle the chromatic bins.
despecRadius = 2; % The radius to despeckle by.
eval(strcat(name,'_Skinned_Rot_TopTail_CaCb_Despec = ', name,'_Skinned_Rot_TopTail_CaCb.removeZeros(despecRadius)'));
% Save the result.
save(strcat(dirName,'/',name,'_Skinned_Rot_TopTail_CaCb_Despec'),strcat( name,'_Skinned_Rot_TopTail_CaCb_Despec'));
