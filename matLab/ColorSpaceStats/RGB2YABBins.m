
theta = 0;
Yab=transform(theta, 'qR', 'YAB', 1);
axisRanges=round(Yab.range*Yab.discreteRange);
axisLengths=round(Yab.axisLength*Yab.discreteRange);
RGB_Find_Speckle=Bin([256,256,256],[0,0,0],[255,255,255]);
RGB_Find_Speckle.bin = ones(256,256,256);
RGB_Find_Speckle.count=25*256*256;
Yab_Find_Speckle=RGB_Find_Speckle.rot(Yab);
Yab_Find_Speckle.loc=find(Yab_Find_Speckle.bin);

Yab_FSkin_Hands_Bin = RGB_FSkin_Hands_Bin.rot(Yab);
Yab_FSkin_Hands_Bin = Yab_FSkin_Hands_Bin.norm;
Yab_FSkin_Hands_Bin.axisNames = ['Y','a','b'];
Yab_FSkin_Hands_Bin.name = 'F Skin Hands Yab';
Yab_FSkin_Hands_Bin.loc=Yab_Find_Speckle.loc;

Yab_FSkin_Hands_Bin = Yab_FSkin_Hands_Bin.resetSubs;
Yab_FSkin_Hands_Bin = Yab_FSkin_Hands_Bin.fit;
grid = Yab_FSkin_Hands_Bin.grid;
Yab_FSkin_Hands_Bin.fBin = Yab_FSkin_Hands_Bin.f(grid{2},grid{1});