load(strcat(dirName,'/',name,'_Skinned_Rot_TopTail_CaCb_Despec'));

% 7 : Split into blobs
tol = 0.05; % fBin values lower than this will be ignored.
nBlobs = 2; % number of blobs to divide bins into
masked = eval(strcat('Bin.blobSplit(',name,'_Skinned_Rot_TopTail_CaCb_Despec, nBlobs, tol)'));
% Find the Gaussian Fit and save the results.
for id = 1:nBlobs
    masked{id} = masked{id}.gFit;
    eval(strcat(name,'_Skinned_Rot_TopTail_CaCb_Despec_blob',num2str(id),' = masked{id}'));
    save(strcat(dirName,'/',name,'_Skinned_Rot_TopTail_CaCb_Despec_blob',num2str(id)),strcat(name,'_Skinned_Rot_TopTail_CaCb_Despec_blob',num2str(id)));
end
