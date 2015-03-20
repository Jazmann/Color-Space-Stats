load(strcat(dirName,'/',name,'_Skinned_Rot_TopTail_CaCb_Despec'));
tol = 0.05; % fBin values lower than this will be ignored.
BW = eval(strcat(name,'_Skinned_Rot_TopTail_CaCb_Despec.fBin > tol'));
CH_objects = bwconvhull(BW,'objects');
imshow(CH_objects);
title('Objects Convex Hull');
bwarea(CH_objects)
Ilabel = bwlabel(CH_objects,8);
stat = regionprops(Ilabel,'Area','Centroid','MajorAxisLength','MinorAxisLength','Orientation');
imshow(CH_objects);
hold on;
for x = 1:numel(stat)
    plot(stat(x).Centroid(1),stat(x).Centroid(2),'ro');
end

Afields = fieldnames(stat);
Acell = struct2cell(stat);
sz = size(Acell)    

% Convert to a matrix
Acell = reshape(Acell, sz(1), []);      % Px(MxN)

% Make each field a column
Acell = Acell';                         % (MxN)xP

% Sort by first field "area"
Acell = sortrows(Acell, -1)

% Put back into original cell array format
Acell = reshape(Acell', sz);

% Convert to Struct
stat = cell2struct(Acell, Afields, 1);
IlabelIndx = zeros(length(stat));
for id = 1:length(stat)
    IlabelIndx(id) = Ilabel(round(stat(id).Centroid(2)), round(stat(id).Centroid(1)));
end

nBlobs = 2; % number of blobs to divide bins into
for id = 1:nBlobs
    mask{id}  = ( Ilabel == IlabelIndx(id) );
    masked{id}=eval(strcat(name,'_Skinned_Rot_TopTail_CaCb_Despec'));
    masked{id}.fBin=masked{id}.fBin .* mask{id};
    masked{id}.bin=masked{id}.bin .* mask{id};
    masked{id}=masked{id}.norm();
    masked{id}.count = sum(sum(masked{id}.bin));
end

eval(strcat(name,'_Skinned_Rot_TopTail_CaCb_Despec,fBin = '));

maskedBin = eval(strcat(name,'_Skinned_Rot_TopTail_CaCb_Despec'));

eval(strcat(name,'_Skinned_Rot_TopTail_CaCb_Despec = ', name,'_Skinned_Rot_TopTail_CaCb.removeZeros(2)'));

save(strcat(dirName,'/',name,'_Skinned_Rot_TopTail_CaCb_Despec'),strcat( name,'_Skinned_Rot_TopTail_CaCb_Despec'));