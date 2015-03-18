
classdef transform
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        transformType = 'rR';
        scaleType = 'nLCaCb';
        T;
        scale;
        iT;
        shift;
        naturalRange;
        range;
        naturalAxisLength;
        axisLength;
        intIndx;
        discreteRange;
        n;
        rR;
        fR;
        qR;
        fRs;
        qRs;
        scale_fRs_fR;
        scale_nLCaCb_LCaCb;
        scale_LCaCb_nLCaCb;
        scale_LCaCb_rR;
        scale_rR_fR;
        scale_rR_fRs;
        scale_qR_fR;
        scale_fR_qR;
        scale_qRs_fRs;
        scale_fRs_qRs;
        scale_nLCaCb_fRs;
        scale_fRs_nLCaCb;
        scale_nLCaCb_qRs;
        scale_qRs_nLCaCb;
        scale_nLCaCb_rR;
        scale_rR_qR;
        scale_qR_rR;
        
        
    end
    
    methods
        function obj = transform(theta, tType, sType, shiftQ, srcBitDepth)
            % Set constants.
            pi_6 = double(pi./6.); pi_3 = double(pi./3.); pi_2 = double(pi./2.);
            thetaModPi_6 = mod(theta,pi_6);
            thetaModPi_3 = mod(theta,pi_3);
            thetaModPi_2 = mod(theta,pi_2);
            thetaModPi = mod(theta,pi);

            % Determine the segment in which theta lies.
            if     thetaModPi >= 0.       || thetaModPi < pi_6
                theta_segment = 1;
            elseif thetaModPi >= pi_6     || thetaModPi < pi_3
                theta_segment = 2;
            elseif thetaModPi >= pi_3     || thetaModPi < pi_2
                theta_segment = 3;
            elseif thetaModPi >= pi_2     || thetaModPi < 4 * pi_6
                theta_segment = 4;
            elseif thetaModPi >= 4 * pi_6 || thetaModPi < 5 * pi_6
                theta_segment = 5;
            elseif thetaModPi >= 5 * pi_6 || thetaModPi < pi
                theta_segment = 6;
            else
                theta_segment = 7; % Not possible.
            end;
            
            % Set defaults
            if nargin <= 1
                tType='qR';
            end
            
            if nargin <= 2
                sType='nLCaCb';
            end
            
            if nargin <= 3
                shiftQ=1;
            end
            
            if nargin <= 4
                obj.n = 8;
                obj.discreteRange = 2^8;
            else
                obj.n = srcBitDepth;
                obj.discreteRange = 2^srcBitDepth;
            end
            % Set the number of bits for the src types
            
            obj.scale_qR_fR = [1; 2.^(obj.n-2); 2.^(obj.n-2)];
            
            
            obj.rR =  [1,1,1; ...
                (-1).*sin(pi_6+theta),       cos(theta), (-1).*sin(pi_6-theta); ...
                (-1).*cos(pi_6+theta), (-1).*sin(theta),       cos(pi_6-theta)];
            fReA = (-0.5) * (1. + sqrt(3.) * tan(thetaModPi_6));
            fReB = (-0.5) * (1. + sqrt(3.) * tan(pi_6 - thetaModPi_6));
            switch theta_segment
                case 1
                    obj.fR = [1          ,1          ,1          ;
                        fReA       ,1          ,-1 - fReA  ;
                        fReB       ,-1 - fReB  ,1          ];
                case 2
                    obj.fR = [1          ,1          ,1          ;
                        1          ,fReB       ,-1 - fReB  ;
                        -1 - fReA  ,fReA       ,1          ];
                case 3
                    obj.fR = [1          ,1          ,1          ;
                        1          ,-1 - fReA  ,fReA       ;
                        -1 - fReB  ,1          ,fReB       ];
                case 4
                    obj.fR = [1          ,1          ,1          ;
                        fReB       ,-1 - fReB  ,1          ;
                        fReA       ,1          ,-1 - fReA  ];
                case 5
                    obj.fR = [1          ,1          ,1          ;
                        -1 - fReA  ,fReA       ,1          ;
                        1          ,fReB       ,-1 - fReB  ];
                case 6
                    obj.fR = [1          ,1          ,1          ;
                        -1 - fReB  ,1          ,fReB       ;
                        1          ,-1 - fReA  ,fReA       ];
                otherwise
                    obj.fR = null;
            end
            
            switch theta_segment
                case 1
                    obj.fRs = [1          ,1          ,1          ;
                        fReA       ,1          ,-1 - fReA  ;
                        fReB       ,-1 - fReB  ,1         ];
                case 2
                    obj.fRs = [1          ,1          ,1          ;
                        -1         ,-fReB      ,1 + fReB   ;
                        -1 - fReA  , fReA      ,1         ];
                case 3
                    obj.fRs = [1          ,1          ,1           ;
                        -1         ,1 + fReA   ,-fReA       ;
                        1 + fReB  ,-1         ,-fReB      ];
                case 4
                    obj.fRs = [1          ,1          ,1          ;
                        fReB       ,-1 - fReB  ,1          ;
                        -fReA       ,-1         ,1 + fReA  ];
                case 5
                    obj.fRs = [1          ,1          ,1          ;
                        -1 - fReA  ,fReA       ,1          ;
                        1          ,fReB       ,-1 - fReB ];
                case 6
                    obj.fRs = [1          ,1          ,1           ;
                        1 + fReB   ,-1         ,-fReB       ;
                        1          ,-1 - fReA  , fReA      ];
                otherwise
                    obj.fRs = null;
            end
            
            u = 2.^(obj.n-2);
            iu = 2.^(2-obj.n);
            qReAp = (-1) * (2.^(obj.n-3) + round(2.^(obj.n-3) * sqrt(3.) * tan(thetaModPi_6)));
            qReBp = (-1) * (2.^(obj.n-3) + round(2.^(obj.n-3) * sqrt(3.) * tan(pi_6 - thetaModPi_6)));
            qReAm = (-1) * (2.^(obj.n-3) - round(2.^(obj.n-3) * sqrt(3.) * tan(thetaModPi_6)));
            qReBm = (-1) * (2.^(obj.n-3) - round(2.^(obj.n-3) * sqrt(3.) * tan(pi_6 - thetaModPi_6)));
            
            switch theta_segment
                case 1
                    obj.qR = [1      ,1      ,1      ;
                        qReAp  ,u      ,qReAm  ;
                        qReBp  ,qReBm  ,u      ];
                case 2
                    obj.qR = [1      ,1      ,1      ;
                        u      ,qReBp  ,qReBm  ;
                        qReAm  ,qReAp  ,u      ];
                case 3
                    obj.qR = [1      ,1      ,1      ;
                        u      ,qReAm  ,qReAp  ;
                        qReBm  ,u      ,qReBp  ];
                case 4
                    obj.qR = [1      ,1      ,1      ;
                        qReBp  ,qReBm  ,u      ;
                        qReAp  ,u      ,qReAm  ];
                case 5
                    obj.qR = [1      ,1      ,1      ;
                        qReAm  ,qReAp  ,u      ;
                        u      ,qReBp  ,qReBm  ];
                case 6
                    obj.qR = [1      ,1      ,1      ;
                        qReBm  ,u      ,qReBp  ;
                        u      ,qReAm  ,qReAp  ];
                otherwise
                    obj.qR = null;
            end
            
            
            switch theta_segment
                case 1
                    obj.qRs = [1      ,1      ,1      ;
                        qReAp   ,u      ,qReAm  ;
                        qReBp   ,qReBm  ,u      ];
                case 2
                    obj.qRs = [1      ,1            ,1      ;
                        (-1.)*u ,(-1.)*qReBp  ,(-1.)*qReBm  ;
                        qReAm   ,qReAp        ,u      ];
                case 3
                    obj.qRs = [1           ,1            ,1      ;
                        (-1.)*u      ,(-1.)*qReAm  ,(-1.)*qReAp  ;
                        (-1.)*qReBm  ,(-1.)*u      ,(-1.)*qReBp  ];
                case 4
                    obj.qRs = [1           ,1            ,1      ;
                        qReBp        ,qReBm        ,u      ;
                        (-1.)*qReAp  ,(-1.)*u      ,(-1.)*qReAm  ];
                case 5
                    obj.qRs = [1      ,1      ,1      ;
                        qReAm   ,qReAp  ,u      ;
                        u       ,qReBp  ,qReBm  ];
                case 6
                    obj.qRs = [1           ,1            ,1      ;
                        (-1.)*qReBm  ,(-1.)*u      ,(-1.)*qReBp  ;
                        u            ,qReAm        ,qReAp  ];
                otherwise
                    obj.qRs = null;
            end
            
            switch theta_segment
                case 1
                    obj.scale_fRs_fR = [ 1, 1, 1];
                    
                case 2
                    obj.scale_fRs_fR = [ 1,-1, 1];
                    
                case 3
                    obj.scale_fRs_fR = [ 1,-1,-1];
                    
                case 4
                    obj.scale_fRs_fR = [ 1, 1,-1];
                    
                case 5
                    obj.scale_fRs_fR = [ 1, 1, 1];
                    
                case 6
                    obj.scale_fRs_fR = [ 1,-1, 1];
                otherwise
                    obj.qR = null;
            end
            
            
            % obj.qR = round(horzcat(obj.scale_qR_fR,obj.scale_qR_fR,obj.scale_qR_fR).* obj.fR);
            
            obj.scale_nLCaCb_LCaCb = [3.^(-1/2), ...
                (1/2).*(3/2).^(1/2).*sec(pi_6 - mod(pi_6 - theta,pi_3)), ...
                (1/2).*(3/2).^(1/2).*sec(pi_6 - thetaModPi_3)];
            
            obj.scale_LCaCb_nLCaCb = [3.^(1/2), ...
                2.*(2/3).^(1/2).*cos(pi_6 - mod(pi_6 - theta,pi_3)), ...
                2.*(2/3).^(1/2).*cos(pi_6 - thetaModPi_3)];
            
            obj.scale_LCaCb_rR = [3.^(-1/2),(2/3).^(1/2),(2/3).^(1/2)];
            
            switch theta_segment
                case 1
                    obj.scale_rR_fR =   [1,cos(theta),cos(pi_6 - theta)];
                case 2
                    obj.scale_rR_fR =   [1,(-1).*sin((1/6).*pi+theta),cos(pi_6 - theta)];
                case 3
                    obj.scale_rR_fR =   [1,(-1).*sin(pi_6+theta),(-1).*sin(theta)];
                case 4
                    obj.scale_rR_fR =   [1,(-1).*sin(pi_6 - theta),(-1).*sin(theta)];
                case 5
                    obj.scale_rR_fR =   [1,(-1).*sin(pi_6 - theta),(-1).*cos((1/6).*pi+theta)];
                case 6
                    obj.scale_rR_fR =   [1,cos(theta),(-1).*cos(pi_6+theta)];
                otherwise
                    obj.scale_rR_fR = null;
            end
            
            
            obj.scale_rR_fRs = [1, ...
                cos(pi_6 - mod(theta - pi_6,pi_3)), ...
                cos(pi_6 - thetaModPi_3)];
            
            obj.scale_qR_fR = [1,u,u];
            
            obj.scale_fR_qR = [1,iu,iu];
            
            obj.scale_qRs_fRs = [1,u,u];
            
            obj.scale_fRs_qRs = [1,iu,iu];
            
            obj.scale_nLCaCb_fRs = [(1/3),(1/2),(1/2)];
            
            obj.scale_fRs_nLCaCb = [3,2,2];
            
            obj.scale_nLCaCb_qRs = [(1/3),2.^(1-obj.n),2.^(1-obj.n)];
            
            obj.scale_qRs_nLCaCb = [3,2.^(3-obj.n),2.^(3-obj.n)];
            
            obj.scale_nLCaCb_rR = [(1/3),(1/2).*sec(pi_6 - mod(theta - pi_6,pi_3)) ...
                ,(1/2).*sec(pi_6 - thetaModPi_3 )];
            
            switch theta_segment
                case {1,4}
                    obj.scale_rR_qR =  [1,(-1).*iu.*sin(pi_6+theta), (-1).*iu.*cos(pi_6+theta)];
                case {2,5}
                    obj.scale_rR_qR =  [1,iu.*cos(theta),(-1).*iu.*sin(theta)];
                case {3,6}
                    obj.scale_rR_qR =  [1, (-1).*iu.*sin(pi_6 - theta), iu.*cos(pi_6 - theta)];
                otherwise
                    obj.scale_rR_qR = null;
            end
            
            switch theta_segment
                case {1,4}
                    obj.scale_qR_rR = [1,(-1).*u.*csc(pi_6+theta),(-1).*u.*sec(pi_6+theta)];
                case {2,5}
                    obj.scale_qR_rR = [1,u.*sec(theta),(-1).*u.*csc(theta)];
                case {3,6}
                    obj.scale_qR_rR = [1,(-1).*u.*csc(pi_6 - theta),u.*sec(pi_6 - theta)];
                otherwise
                    obj.scale_qR_rR = null;
            end
            
            
            obj.naturalRange = [0,  3.^(1/2);
                (-1).*(2/3).^(1/2) .* cos(pi_6 -  mod(theta-pi_6, pi_3)),  ...
                (2/3).^(1/2) .* cos(pi_6 -  mod(theta-pi_6, pi_3)); ...
                (-1).*(2/3).^(1/2) .* cos(pi_6 -  mod(theta, pi_3)),   ...
                (2/3).^(1/2) .* cos(pi_6 -  mod(theta, pi_3))];
            
            obj.naturalAxisLength =  [3.^(1/2); ...
                (2.).*((2/3).^(1/2) .* cos(pi_6 - mod(theta-pi_6, pi_3))); ...
                (2.).*((2/3).^(1/2) .* cos(pi_6 - mod(theta, pi_3)))];
            
            obj.range = obj.naturalRange;          % unshifted & unscaled
            obj.range = [0,1; -0.5,0.5; -0.5,0.5]; % unshifted &   scaled
            obj.range = [0,1;  0.0,1.0;  0.0,1.0]; %   shifted &   scaled
            
            obj.axisLength = obj.naturalAxisLength; % unscaled
            obj.axisLength = [1; 1; 1];             %   scaled
            
            obj.shift = [(-1).*obj.naturalRange(1,1); (-1).*obj.naturalRange(2,1); (-1).*obj.naturalRange(3,1)];
            obj.shift = [0; 0.5; 0.5];
            
            obj=setTransform(obj, tType);
            obj=setScale(obj, sType, shiftQ);
            
            
        end % function
        
        function obj=setTransform(obj, tType)
            obj.transformType = tType;
            switch tType
                case 'rR'
                    obj.T = obj.rR;
                case 'fR'
                    obj.T = obj.fR;
                case 'fRs'
                    obj.T = obj.fRs;
                case 'qR'
                    obj.T = obj.qR;
                case 'qRs'
                    obj.T = obj.qRs;
                otherwise
            end
            obj.iT = inv(obj.T);
        end
        
        function obj=setScale(obj, tType, shiftQIn)
            obj.scaleType = tType; % 'nLCaCb' 'LCaCb'
            % pxlShift is a shift to ensure a 1-1 transform after rounding
            pxlShift=[sqrt(3)./2.0 - 1.0; -0.5;-0.5]./(obj.discreteRange);
            %pxlShift=[0.;0.;0.]%[sqrt(3)./2.0 - 1.0; -0.5;-0.5]./(obj.discreteRange);
            if nargin<3
                shiftQ=1;
            else
                switch shiftQIn
                    case 'yes'
                        shiftQ=1;
                    case 'no'
                        shiftQ=0;
                    otherwise
                        shiftQ = shiftQIn;
                end
            end
            switch tType
                case 'nLCaCb'
                    if shiftQ
                        obj.shift = [0; 0.5; 0.5]+pxlShift;
                        obj.range = [0,1;  0.0,1.0;  0.0,1.0]; %   shifted &   scaled
                    else
                        obj.shift = [0; 0; 0]+pxlShift;
                        obj.range = [0,1; -0.5,0.5; -0.5,0.5]; % unshifted &   scaled
                    end
                    
                    obj.axisLength = [1; 1; 1];            %   scaled
                    
                case 'LCaCb'
                    if shiftQ
                        obj.shift = [(-1).*obj.naturalRange(1,1);(-1).*obj.naturalRange(2,1);(-1).*obj.naturalRange(3,1)]+pxlShift;
                        obj.range = [0,obj.naturalAxisLength(1);  0.0,obj.naturalAxisLength(2);  0.0,obj.naturalAxisLength(3)]; %   shifted & unscaled
                    else
                        obj.shift = [0; 0; 0]+pxlShift;
                        obj.range = obj.naturalRange;          % unshifted & unscaled
                    end
                    
                    obj.axisLength = obj.naturalAxisLength; % unscaled
                    
                otherwise
                    obj.scale = [1;1;1];
            end
            
            switch obj.transformType
                case 'rR'
                    switch tType
                        case 'nLCaCb'
                            obj.scale = obj.scale_nLCaCb_rR;
                        case 'LCaCb'
                            obj.scale = obj.scale_LCaCb_rR;
                        otherwise
                            obj.scale = [1;1;1];
                    end
                case 'fR'
                    switch tType
                        case 'nLCaCb'
                            obj.scale = obj.scale_nLCaCb_fRs .* obj.scale_fRs_fR;
                        case 'LCaCb'
                            obj.scale = obj.scale_LCaCb_nLCaCb .* obj.scale_nLCaCb_fRs .* obj.scale_fRs_fR;
                        otherwise
                            obj.scale = [1;1;1];
                    end
                case 'fRs'
                    switch tType
                        case 'nLCaCb'
                            obj.scale = obj.scale_nLCaCb_fRs ;
                        case 'LCaCb'
                            obj.scale = obj.scale_LCaCb_nLCaCb .* obj.scale_nLCaCb_fRs ;
                        otherwise
                            obj.scale = [1;1;1];
                    end
                case 'qR'
                    switch tType
                        case 'nLCaCb'
                            obj.scale = obj.scale_nLCaCb_qRs .* obj.scale_fRs_fR;
                        case 'LCaCb'
                            obj.scale = obj.scale_LCaCb_nLCaCb .* obj.scale_nLCaCb_qRs .* obj.scale_fRs_fR;
                        otherwise
                            obj.scale = [1;1;1];
                    end
                case 'qRs'
                    switch tType
                        case 'nLCaCb'
                            obj.scale = obj.scale_nLCaCb_qRs ;
                        case 'LCaCb'
                            obj.scale = obj.scale_LCaCb_nLCaCb .* obj.scale_nLCaCb_qRs;
                        otherwise
                            obj.scale = [1;1;1];
                    end
                otherwise
            end
        end
        
        function outImage = toRot(obj, pixelList)
            outImage = pixelList * obj.T';
            %# Shift each color plane (stored in each column of the N-by-3 matrix):
            outImage(:,1) = (obj.scale(1).*outImage(:,1) + obj.shift(1).*(obj.discreteRange));
            outImage(:,2) = (obj.scale(2).*outImage(:,2) + obj.shift(2).*(obj.discreteRange));
            outImage(:,3) = (obj.scale(3).*outImage(:,3) + obj.shift(3).*(obj.discreteRange));
        end % function
        
        
        function outImage = toRotImg(obj, img)
            sizeImg = size(img);
            outImage = reshape(double(img),[],sizeImg(end));
            outImage = obj.toRot(outImage);
            outImage = reshape(outImage,sizeImg);
        end % function
        
        function outImage = fromRotImg(obj, img)
            sizeImg = size(img);
            outImage = reshape(double(img),[],sizeImg(end));
            outImage = obj.fromRot(outImage);
            outImage = reshape(outImage,sizeImg);
        end % function
        
        
        function outImage = fromRot(obj, pixelList)
            %# Shift each color plane (stored in each column of the N-by-3 matrix):
            outImage(:,1) = (pixelList(:,1) - obj.shift(1).*(obj.discreteRange))./obj.scale(1);
            outImage(:,2) = (pixelList(:,2) - obj.shift(2).*(obj.discreteRange))./obj.scale(2);
            outImage(:,3) = (pixelList(:,3) - obj.shift(3).*(obj.discreteRange))./obj.scale(3);
            outImage = outImage * obj.iT';
        end % function
        
        function indx = toRotIndx(obj, indx, scale)
            if nargin < 3
                scale = obj.discreteRange;
            end
            pixelIndx = reshape(indx,3,[]);
            indx = round(obj.T * (pixelIndx-1) + (scale .* obj.shift)) + 1;
        end % function
        
        function indx = fromRotIndx(obj, indx, scale)
            if nargin < 3
                scale = obj.discreteRange;
            end
            pixelIndx = reshape(indx,3,[]);
            indx = round(obj.T' * ((pixelIndx-1) - scale .* obj.shift)) + 1;
        end % function
        
    end
    
    methods (Static = true)
        
        function speck = speckle(trans, method)
            if nargin <2
                method='round';% method = 'round' 'ceil' 'floor'
            end
            srcRange = [trans.discreteRange,trans.discreteRange,trans.discreteRange;];
            dstRange = round(horzcat(trans.range(:,1).*srcRange',trans.range(:,2).*srcRange'));
            axisLengths=ceil(trans.axisLength.*srcRange')+1;
            
            RGB_Find_Speckle=Bin(srcRange,[0,0,0],srcRange-1.0);
            RGB_Find_Speckle.bin = ones(srcRange);
            RGB_Find_Speckle.count=trans.discreteRange^3;
            trans_Find_Speckle.name = strcat('Speckle ',method);
            trans_Find_Speckle = RGB_Find_Speckle.rot(trans,[],method);
            trans_Find_Speckle.loc=find(trans_Find_Speckle.bin);
            if nargout ==2
                speck=[trans_Find_Speckle.bin,trans_Find_Speckle.loc];
            else
                speck=trans_Find_Speckle;
            end
            
        end
    end
end
