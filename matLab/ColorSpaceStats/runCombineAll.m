rootDirName='/Users/jaspershemilt/Developer/projects/Color-Space-Stats/matLab/ColorSpaceStats/Skin/';

stageNames = {'', ...
    '_Skinned', ...
    '_Skinned_Rot', ...
    '_Skinned_Rot_TopTail', ...
    '_Skinned_Rot_TopTail_CaCb', ...
    '_Skinned_Rot_TopTail_CaCb_Despec', ...
    '_Skinned_Rot_TopTail_CaCb_Despec_blob1', ...
    '_Skinned_Rot_TopTail_CaCb_Despec_blob2'};

indDirNames = {'IndividualSkin/FSkin/', ...
    'IndividualSkin/JSkin/', ...
    'IndividualSkin/NSkin/'};

indNames = {'RGB_FSkin_', ...
    'RGB_JSkin_', ...
    'RGB_NSkin_'};

partDirNames = { ...
    'Hands/Orig/', ...
    'Index/Pad/Orig/', ...
    'Index/Tip/Orig/', ...
    'Thumb/Pad/Orig/', ...
    'Thumb/Tip/Orig/'};

partNames = {'Hand_Bin', ...
    'Index_Pad_Bin', ...
    'Index_Tip_Bin', ...
    'Thumb_Pad_Bin', ...
    'Thumb_Tip_Bin'};


for i = 1:3
    % Setup Output Directory
    outDirName = strcat(rootDirName,indDirNames{i},'comb/');
    mkdir(outDirName);
    mkdir(strcat(outDirName,'mathematica/'));
    for s = 1:8
        % Load The first bin
        name = strcat(indNames{i},partNames{1},stageNames{s});
        sprintf(strcat('%d : Loading : ',name), s)
        load(strcat(rootDirName, indDirNames{i}, partDirNames{1}, name,'.mat'))
        % Patch
        if s <=2
            eval([name,'.axisNames',' = [''R'',''G'',''B'']'])
            % out.axisNames = ['R','G','B'];
        elseif s <= 4
            eval([name,'.axisNames',' = [''L'',''Ca'',''Cb'']']);
        else
            eval([name,'.axisNames',' = [''Ca'',''Cb'']']);
        end
        eval([name,' = ',name,'.norm']);
        save(strcat(rootDirName, indDirNames{i}, partDirNames{1}, name),name);
        % Equate out with first bin
        out = eval(name);
        outName = strcat(indNames{i},'Bin',stageNames{s});
        out.name = outName;
        for p = 2:5
            % Load The p th bin
            name = strcat(indNames{i},partNames{p},stageNames{s});
            sprintf(strcat('%d : Loading : ',name), s)
            load(strcat(rootDirName, indDirNames{i}, partDirNames{p}, name,'.mat'));
            % Patch
            if s <=2
                eval([name,'.axisNames',' = [''R'',''G'',''B'']'])
                % out.axisNames = ['R','G','B'];
            elseif s <= 4
                eval([name,'.axisNames',' = [''L'',''Ca'',''Cb'']']);
            else
                eval([name,'.axisNames',' = [''Ca'',''Cb'']']);
            end
            eval([name,' = ',name,'.norm']);
            save(strcat(rootDirName, indDirNames{i}, partDirNames{p}, name),name);
            % add bins to out
            sprintf(strcat('%d : loading : ',rootDirName,indDirNames{i}, partDirNames{p}, name,'.mat'), p)
            out = out.add(eval(name));
        end
        
        eval([outName,' = out.norm']);
        save(strcat(outDirName,outName),outName);
        eval(strcat( 'Bin.saveFields(',outName,',''',outDirName,'/mathematica/',outName,''' )'));
    end
end


outDirName = strcat(rootDirName,'comb');
mkdir(outDirName);
mkdir(strcat(outDirName,'/mathematica'));
for s = 1:8
    name = strcat(indNames{1},'Bin',stageNames{s});
    sprintf(strcat('%d : Combining : ',name), s)
    load(strcat(rootDirName,indDirNames{1},'comb/',name,'.mat'))
    out = eval(name);
    outName = strcat('Bin',stageNames{s});
    out.name = outName;
    if s <=2
        out.axisNames = ['R','G','B'];
    else
        out.axisNames = ['L','Ca','Cb'];
    end
    
    for i = 2:3
        name = strcat(indNames{i},'Bin',stageNames{s});
        load(strcat(rootDirName,indDirNames{i},'comb/',name,'.mat'));
        out = out.add(eval(name));
    end
    eval([outName,' = out.norm']);
    save(strcat(outDirName,'/',outName),outName);
    eval(strcat( 'Bin.saveFields(',outName,',''',outDirName,'/mathematica/',outName,''' )'));
end


%         dataMin  = 0; dataMax = 255;
%         out = Bin([dataMax+1,dataMax+1,dataMax+1],[dataMin,dataMin,dataMin],[dataMax,dataMax,dataMax]);
%         outName = strcat(indName,'Bin',stageName);
%         out.name = outName;
%         out.axisNames = ['R','G','B'];

%         dirName = 'Index/Pad/Orig/';
%         name = strcat(indName,'Index_Pad_Bin');
%         load(strcat(rootDirName,indDirName,dirName,name,'.mat'));
%         out = out.add(eval(name));
%         dirName = 'Index/Tip/Orig/';
%         name = strcat(indName,'Index_Tip_Bin');
%         load(strcat(rootDirName,indDirName,dirName,name,'.mat'));
%         out = out.add(eval(name));
%         dirName = 'Thumb/Pad/Orig/';
%         name = strcat(indName,'Thumb_Pad_Bin');
%         load(strcat(rootDirName,indDirName,dirName,name,'.mat'));
%         out = out.add(eval(name));
%         dirName = 'Thumb/Tip/Orig/';
%         name = strcat(indName,'Thumb_Tip_Bin');
%         load(strcat(rootDirName,indDirName,dirName,name,'.mat'));
%         out = out.add(eval(name));

