
function run_all( dirName, name)
% add directory for the exported fields to be visualised with Mathematica.
mkdir(strcat(dirName,'/mathematica'));
% 1 : Find the bins.
getRGBBins(dirName,name);
load(strcat(dirName,'/',name));
eval(strcat( 'Bin.saveFields(',name,',''',dirName,'/mathematica/',name,''' )'));

% 2 : Skin the bins.
% Set the depth to skin the bins by. this will set to zero all bins which
% lie within skinDepth of the extreme edges of the bin ranges.
skinDepth=9;
eval(strcat( name,'_Skinned = Bin.skin(',name,',skinDepth)'));
% Save the result.
save(strcat(dirName,'/',name,'_Skinned'),strcat( name,'_Skinned'));
eval(strcat( 'Bin.saveFields(',name,'_Skinned',',''',dirName,'/mathematica/',name,'_Skinned',''')'));

% 3 : Rotate the bins
% use a theta=0, signed factored, normalised, shifted transform
fR=transform(0, 'fRs', 'nLCaCb', 1, 8);
% Rotate the bins.
eval(strcat(name,'_Skinned_Rot = ', name,'_Skinned.rot(fR)'));
eval(strcat(name,'_Skinned_Rot = ', name,'_Skinned.norm()'));

% Save the result.
save(strcat(dirName,'/',name,'_Skinned_Rot'),strcat( name,'_Skinned_Rot'));
eval(strcat( 'Bin.saveFields(',name,'_Skinned_Rot',',''',dirName,'/mathematica/',name,'_Skinned_Rot',''')'));

% 4 : Top and Tail the luminocity axis.
topTailRng = 42;
eval(strcat(name,'_Skinned_Rot_TopTail = Bin.skin(', name,'_Skinned_Rot, [topTailRng;0;0])'));
eval(strcat(name,'_Skinned_Rot_TopTail.name = ''',name,'_Skinned_Rot_TopTail'''));
% Save the result.
save(strcat(dirName,'/',name,'_Skinned_Rot_TopTail'),strcat( name,'_Skinned_Rot_TopTail'));
eval(strcat( 'Bin.saveFields(',name,'_Skinned_Rot_TopTail',',''',dirName,'/mathematica/',name,'_Skinned_Rot_TopTail',''')'));

% 5 : Collapse the luminocity axis.
eval(strcat(name,'_Skinned_Rot_TopTail_CaCb = ', name,'_Skinned_Rot_TopTail.collapse(1, [1,256])'));
% Save the result.
save(strcat(dirName,'/',name,'_Skinned_Rot_TopTail_CaCb'),strcat( name,'_Skinned_Rot_TopTail_CaCb'));
eval(strcat( 'Bin.saveFields(',name,'_Skinned_Rot_TopTail_CaCb',',''',dirName,'/mathematica/',name,'_Skinned_Rot_TopTail_CaCb',''')'));

% 6 : Despeckle the chromatic bins.
despecRadius = 2; % The radius to despeckle by.
eval(strcat(name,'_Skinned_Rot_TopTail_CaCb_Despec = ', name,'_Skinned_Rot_TopTail_CaCb.removeZeros(despecRadius)'));
% Save the result.
save(strcat(dirName,'/',name,'_Skinned_Rot_TopTail_CaCb_Despec'),strcat( name,'_Skinned_Rot_TopTail_CaCb_Despec'));
eval(strcat( 'Bin.saveFields(',name,'_Skinned_Rot_TopTail_CaCb_Despec',',''',dirName,'/mathematica/',name,'_Skinned_Rot_TopTail_CaCb_Despec',''')'));

% 7 : Split into blobs
tol = 0.05; % fBin values lower than this will be ignored.
nBlobs = 2; % number of blobs to divide bins into
masked = eval(strcat('Bin.blobSplit(',name,'_Skinned_Rot_TopTail_CaCb_Despec, nBlobs, tol)'));
% Find the Gaussian Fit and save the results.
for id = 1:nBlobs
    masked{id} = masked{id}.gFit;
    eval(strcat(name,'_Skinned_Rot_TopTail_CaCb_Despec_blob',num2str(id),' = masked{id}'));
    save(strcat(dirName,'/',name,'_Skinned_Rot_TopTail_CaCb_Despec_blob',num2str(id)),strcat(name,'_Skinned_Rot_TopTail_CaCb_Despec_blob',num2str(id)));
    eval(strcat( 'Bin.saveFields(',name,'_Skinned_Rot_TopTail_CaCb_Despec_blob',num2str(id),',''',dirName,'/mathematica/',name,'_Skinned_Rot_TopTail_CaCb_Despec_blob',num2str(id),''')'));
end

% 8 : Identify the skin blob
skinApprox = [110.0, 87.0]
blobNum = 1;
eval(strcat('dif = ',name,'_Skinned_Rot_TopTail_CaCb_Despec_blob',num2str(blobNum),'.gMean - skinApprox'));
for id = 2:nBlobs
eval(strcat('newDif = ',name,'_Skinned_Rot_TopTail_CaCb_Despec_blob',num2str(id),'.gMean - skinApprox'));
if newDif < dif
    blobNum=id;
    dif = newDif;
end

end

% 9 : Start again at 3 with new theta
eval(strcat('theta = ',name,'_Skinned_Rot_TopTail_CaCb_Despec_blob',num2str(blobNum),'.gTheta'));
fR=transform(theta, 'fRs', 'nLCaCb', 1, 8);
% Rotate the bins.
eval(strcat(name,'_Theta_Rot = ', name,'_Skinned.rot(fR)'));
eval(strcat(name,'_Theta_Rot = ', name,'_Skinned.norm()'));

% Save the result.
save(strcat(dirName,'/',name,'_Theta_Rot'),strcat( name,'_Theta_Rot'));
eval(strcat( 'Bin.saveFields(',name,'_Theta_Rot',',''',dirName,'/mathematica/',name,'_Theta_Rot',''')'));

% 10 : Top and Tail the luminocity axis.
topTailRng = 42;
eval(strcat(name,'_Theta_Rot_TopTail = Bin.skin(', name,'_Theta_Rot, [topTailRng;0;0])'));
eval(strcat(name,'_Theta_Rot_TopTail.name = ''',name,'_Theta_Rot_TopTail'''));
% Save the result.
save(strcat(dirName,'/',name,'_Theta_Rot_TopTail'),strcat( name,'_Theta_Rot_TopTail'));
eval(strcat( 'Bin.saveFields(',name,'_Theta_Rot_TopTail',',''',dirName,'/mathematica/',name,'_Theta_Rot_TopTail',''')'));

% 11 : Collapse the luminocity axis.
eval(strcat(name,'_Theta_Rot_TopTail_CaCb = ', name,'_Theta_Rot_TopTail.collapse(1, [1,256])'));
% Save the result.
save(strcat(dirName,'/',name,'_Theta_Rot_TopTail_CaCb'),strcat( name,'_Theta_Rot_TopTail_CaCb'));
eval(strcat( 'Bin.saveFields(',name,'_Theta_Rot_TopTail_CaCb',',''',dirName,'/mathematica/',name,'_Theta_Rot_TopTail_CaCb',''')'));

% 12 : Despeckle the chromatic bins.
despecRadius = 2; % The radius to despeckle by.
eval(strcat(name,'_Theta_Rot_TopTail_CaCb_Despec = ', name,'_Theta_Rot_TopTail_CaCb.removeZeros(despecRadius)'));
% Save the result.
save(strcat(dirName,'/',name,'_Theta_Rot_TopTail_CaCb_Despec'),strcat( name,'_Theta_Rot_TopTail_CaCb_Despec'));
eval(strcat( 'Bin.saveFields(',name,'_Theta_Rot_TopTail_CaCb_Despec',',''',dirName,'/mathematica/',name,'_Theta_Rot_TopTail_CaCb_Despec',''')'));

% 13 : Split into blobs
tol = 0.05; % fBin values lower than this will be ignored.
nBlobs = 2; % number of blobs to divide bins into
masked = eval(strcat('Bin.blobSplit(',name,'_Theta_Rot_TopTail_CaCb_Despec, nBlobs, tol)'));
% Find the Gaussian Fit and save the results.
for id = 1:nBlobs
    masked{id} = masked{id}.gFit;
    eval(strcat(name,'_Theta_Rot_TopTail_CaCb_Despec_blob',num2str(id),' = masked{id}'));
    save(strcat(dirName,'/',name,'_Theta_Rot_TopTail_CaCb_Despec_blob',num2str(id)),strcat(name,'_Theta_Rot_TopTail_CaCb_Despec_blob',num2str(id)));
    eval(strcat( 'Bin.saveFields(',name,'_Theta_Rot_TopTail_CaCb_Despec_blob',num2str(id),',''',dirName,'/mathematica/',name,'_Theta_Rot_TopTail_CaCb_Despec_blob',num2str(id),''')'));
end

