Yab16=transform(theta, 'qR', 'LCaCb', 1, 3);
discScale=ceil(Yab16.axisLength.*(Yab16.discreteRange-1)) ./ (Yab16.axisLength.*(Yab16.discreteRange-1));
newShift = Yab16.shift.*discScale;
Yab16.scale=Yab16.scale.*discScale;
Yab16.shift=newShift;
Yab16.range(:,1)=Yab16.range(:,1).*discScale;
Yab16.range(:,2)=Yab16.range(:,2).*discScale;
Yab16.axisLength=Yab16.axisLength.*discScale;

testScale=[2/Yab16.axisLength(1);1;1];
Yab16.scale=Yab16.scale.*testScale;
Yab16.shift=Yab16.shift.*testScale;
Yab16.range(:,1)=Yab16.range(:,1).*testScale;
Yab16.range(:,2)=Yab16.range(:,2).*testScale;
Yab16.axisLength=Yab16.axisLength.*testScale;

speck16=transform.speckle(Yab16,'round');
speck16_Bin=speck16.bin;
save('./Transform/speck16_Bin.mat','speck16_Bin');


speck16=transform.speckle(Yab16,'floor');
speck16_Bin=speck16.bin;
save('./Transform/speck16_Bin.mat','speck16_Bin');

mapYab16=zeros([Yab16.discreteRange,Yab16.discreteRange,Yab16.discreteRange,3]);
for r=0:Yab16.discreteRange-1
    disp(round(100 .* r ./ Yab16.discreteRange ))
    for g=0:Yab16.discreteRange-1
        for b=0:Yab16.discreteRange-1
            mapYab16(r+1,g+1,b+1,:)=Yab16.toRot([r,g,b]);
        end
    end
end
save('./Transform/mapYab16.mat','mapYab16');

mapYab8=zeros([Yab8.discreteRange,Yab8.discreteRange,Yab8.discreteRange,3]);
for r=0:Yab8.discreteRange-1
    disp(round(100 .* r ./ Yab8.discreteRange ))
    for g=0:Yab8.discreteRange-1
        for b=0:Yab8.discreteRange-1
            mapYab8(r+1,g+1,b+1,:)=Yab8.toRot([r,g,b]);
        end
    end
end
save('./Transform/mapYab8.mat','mapYab8');

cornersYab16=zeros([2,2,2,3]);
for r=0:1
    for g=0:1
        for b=0:1
            cornersYab16(r+1,g+1,b+1,:)=Yab16.toRot(Yab16.discreteRange.*[r,g,b]);
        end
    end
end

uCornersYab16=zeros([2,2,2,3]);
for r=0:1
    for g=0:1
        for b=0:1
            uCornersYab16(r+1,g+1,b+1,:)=Yab16.toRot([r,g,b]);
        end
    end
end


cornersYab8=zeros([2,2,2,3]);
for r=0:1
    for g=0:1
        for b=0:1
            cornersYab8(r+1,g+1,b+1,:)=Yab8.toRot(Yab8.discreteRange.*[r,g,b]);
        end
    end
end

round(Yab.toRot([0,0,0; ...
    1,0,0; ...
    0,1,0; ...
    0,0,1; ...
    0,1,1; ...
    1,0,1; ...
    1,1,0; ...
    1,1,1; ...
    ]))

floor(Yab.toRot([0,0,0; ...
    1,0,0; ...
    0,1,0; ...
    0,0,1; ...
    0,1,1; ...
    1,0,1; ...
    1,1,0; ...
    1,1,1; ...
    ]))
