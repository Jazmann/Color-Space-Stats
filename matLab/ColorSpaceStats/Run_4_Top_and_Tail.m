
load(strcat(dirName,'/',name,'_Skinned_Rot'));
% Set the distance to top and tail the bins by.
topTailRng = 42; 
eval(strcat(name,'_Skinned_Rot_TopTail = Bin.skin(', name,'_Skinned_Rot, [topTailRng;0;0])'));
eval(strcat(name,'_Skinned_Rot_TopTail.name = ',name,'_Skinned_Rot_TopTail'));
% Save the result.
save(strcat(dirName,'/',name,'_Skinned_Rot_TopTail'),strcat( name,'_Skinned_Rot_TopTail'));