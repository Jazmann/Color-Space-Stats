
classdef transform
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        transformType = 'rR';
        scaleType = 'nYAB';
        T;
        scale;
        iT;
        shift;
        naturalRange;
        range;
        naturalAxisLength;
        axisLength;
        intIndx;
        discreteRange = 256;
        rR;
        fR;
        qR;
        scale_nYAB_YAB;
        scale_nYAB_rR;
        scale_rR_fR;
        scale_YAB_rR;
        scale_qR_rR;
        scale_rR_qR;
        scale_qR_fR;
        
    end
    
    methods
        function obj = transform(theta, tType, sType, shiftQ)
            % Set constants.
            pi_6 = double(pi./6.); pi_3 = double(pi./3.); pi_2 = double(pi./2.);
            thetaModPi_2 = mod(theta,pi_2);
            % Determine the segment in which theta lies.
            if thetaModPi_2 >= 0. || thetaModPi_2 < pi_6
                theta_segment = 1;
            elseif thetaModPi_2 >= pi_6 || thetaModPi_2 < pi_3
                theta_segment =  2;
            elseif thetaModPi_2 >= pi_3 || thetaModPi_2 < pi_2
                theta_segment = 3;
            else
                theta_segment = 4; % Not possible.
            end;
            % Set the number of bits for the src types
            n = ceil(log2(obj.discreteRange));
            
            % Set defaults
            if nargin<=1
                tType='qR';
            end
            
            if nargin<=2
                sType='nYAB';
            end
            
            if nargin<=3
                shiftQ=1;
            end
            
            obj.scale_qR_fR = [1; 2.^(n-2); 2.^(n-2)];
            
            
            obj.rR = [1,1,1; ...
                (-1).*sin(pi_6+theta),       cos(theta), (-1).*sin(pi_6-theta); ...
                (-1).*cos(pi_6+theta), (-1).*sin(theta),       cos(pi_6-theta)];
            
            switch theta_segment
                case 1
                    obj.fR = [1, 1, 1; ...
                        1, (-1).*cos(theta).*csc(pi_6+theta),       csc(pi_6+theta).*sin(pi_6-theta); ...
                        1,       sin(theta).*sec(pi_6+theta), (-1).*sec(pi_6+theta).*cos(pi_6-theta)];
                case 2
                    obj.fR = ...
                        [1, 1, 1; ...
                        (-1).*sec(theta).*sin(pi_6+theta), 1, (-1).*sec(theta).*sin(pi_6-theta); ...
                        csc(theta).*cos(pi_6+theta), 1, (-1).*csc(theta).*cos(pi_6-theta)];
                case 3
                    obj.fR = ...
                        [1, 1, 1; ...
                        csc(pi_6-theta).*sin(pi_6+theta), (-1).*cos(theta).*csc(pi_6-theta), 1; ...
                        (-1).*sec(pi_6-theta).*cos(pi_6+theta), (-1).*sin(theta).*sec(pi_6-theta), 1];
                otherwise
                    obj.fR = null;
            end
            
            obj.qR = round(horzcat(obj.scale_qR_fR,obj.scale_qR_fR,obj.scale_qR_fR).* obj.fR);
            
            obj.scale_nYAB_YAB = [3.^(-1/2); ...
                (1/2).*(3/2).^(1/2).*sec(pi_6-mod(theta-pi_6,pi_3)); ...
                (1/2).*(3/2).^(1/2).*sec(pi_6-mod(theta,pi_3))];
            
            obj.scale_nYAB_rR = [(1/3); ...
                (1/2).*sec(pi_6-mod(theta-pi_6,pi_3)); ...
                (1/2).*sec(pi_6-mod(theta,     pi_3))];
            
            switch theta_segment
                case 1
                    obj.scale_rR_fR = [1; (-1).*sin(pi_6+theta); (-1).*cos(pi_6+theta)];
                case 2
                    obj.scale_rR_fR = [1;       cos(theta);      (-1).*sin(theta)];
                case 3
                    obj.scale_rR_fR = [1; (-1).*sin(pi_6-theta);       cos(pi_6-theta)];
                otherwise
                    obj.scale_rR_fR = null;
            end
            
            obj.scale_YAB_rR = [3.^(-1/2); (2/3).^(1/2); (2/3).^(1/2)];
            
            switch theta_segment
                case 1
                    obj.scale_qR_rR = [1; (-1).*2.^(n-2).*csc(pi_6+theta); (-1).*2.^(n-2).*sec(pi_6+theta)];
                    obj.scale_rR_qR = [1; (-1).*2.^(2-n).*sin(pi_6+theta); (-1).*2.^(2-n).*cos(pi_6+theta)];
                case 2
                    obj.scale_qR_rR = [1;       2.^(n-2).*sec(theta);      (-1).*2.^(n-2).*csc(theta)];
                    obj.scale_rR_qR = [1;       2.^(2-n).*cos(theta);      (-1).*2.^(2-n).*sin(theta)];
                case 3
                    obj.scale_qR_rR = [1; (-1).*2.^(n-2).*csc(pi_6-theta);       2.^(n-2).*sec(pi_6-theta)];
                    obj.scale_rR_qR = [1; (-1).*2.^(2-n).*sin(pi_6-theta);       2.^(2-n).*cos(pi_6-theta)];
                otherwise
                    obj.scale_qR_rR = null;
                    obj.scale_rR_qR = null;
            end
            
            obj.naturalRange = [0,  3.^(1/2);
                (-1).*(2/3).^(1/2) .* cos(pi_6 -  mod(theta-pi_6, pi_3)),  ...
                (2/3).^(1/2) .* cos(pi_6 -  mod(theta-pi_6, pi_3)); ...
                (-1).*(2/3).^(1/2) .* cos(pi_6 -  mod(theta, pi_3)),   ...
                (2/3).^(1/2) .* cos(pi_6 -  mod(theta, pi_3))];
            
            obj.naturalAxisLength =  [3.^(1/2); ...
                (2.).*((2/3).^(1/2) .* cos(pi_6 -  mod(theta-pi_6, pi_3))); ...
                (2.).*((2/3).^(1/2) .* cos(pi_6 -  mod(theta, pi_3)))];
            
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
                case 'qR'
                    obj.T = obj.qR;
                otherwise
            end
            obj.iT = inv(obj.T);
        end
        
        function obj=setScale(obj, tType, shiftQIn)
            obj.scaleType = tType; % 'nYAB' 'YAB'
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
                case 'nYAB'
                    if shiftQ
                        obj.shift = [0; 0.5; 0.5];
                        obj.range = [0,1;  0.0,1.0;  0.0,1.0]; %   shifted &   scaled
                    else
                        obj.shift = [0; 0; 0];
                        obj.range = [0,1; -0.5,0.5; -0.5,0.5]; % unshifted &   scaled
                    end
                    
                    obj.axisLength = [1; 1; 1];            %   scaled
                    
                case 'YAB'
                    if shiftQ
                        obj.shift = [(-1).*obj.naturalRange(1,1);(-1).*obj.naturalRange(2,1);(-1).*obj.naturalRange(3,1)];
                        obj.range = [0,obj.naturalAxisLength(1);  0.0,obj.naturalAxisLength(2);  0.0,obj.naturalAxisLength(3)]; %   shifted & unscaled
                    else
                        obj.shift = [0; 0; 0];
                        obj.range = obj.naturalRange;          % unshifted & unscaled
                    end
                    
                    obj.axisLength = obj.naturalAxisLength; % unscaled
                    
                otherwise
                    obj.scale = [1;1;1];
            end
            
            switch obj.transformType
                case 'rR'
                    switch tType
                        case 'nYAB'
                            obj.scale = obj.scale_nYAB_rR;
                        case 'YAB'
                            obj.scale = obj.scale_YAB_rR;
                        otherwise
                            obj.scale = [1;1;1];
                    end
                case 'fR'
                    switch tType
                        case 'nYAB'
                            obj.scale = obj.scale_nYAB_rR.* obj.scale_rR_fR;
                        case 'YAB'
                            obj.scale = obj.scale_YAB_rR .* obj.scale_rR_fR;
                        otherwise
                            obj.scale = [1;1;1];
                    end
                case 'qR'
                    switch tType
                        case 'nYAB'
                            obj.scale = obj.scale_nYAB_rR.* obj.scale_rR_qR;
                        case 'YAB'
                            obj.scale = obj.scale_YAB_rR .* obj.scale_rR_qR;
                        otherwise
                            obj.scale = [1;1;1];
                    end
                otherwise
            end
        end
        
        function outImage = toRot(obj, pixelList)
            outImage = pixelList * obj.T';
            %# Shift each color plane (stored in each column of the N-by-3 matrix):
            outImage(:,1) = (obj.scale(1).*outImage(:,1) + obj.shift(1).*obj.discreteRange);
            outImage(:,2) = (obj.scale(2).*outImage(:,2) + obj.shift(2).*obj.discreteRange);
            outImage(:,3) = (obj.scale(3).*outImage(:,3) + obj.shift(3).*obj.discreteRange);
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
            outImage(:,1) = (pixelList(:,1) - obj.shift(1).*obj.discreteRange)./obj.scale(1);
            outImage(:,2) = (pixelList(:,2) - obj.shift(2).*obj.discreteRange)./obj.scale(2);
            outImage(:,3) = (pixelList(:,3) - obj.shift(3).*obj.discreteRange)./obj.scale(3);
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
            axisLengths=ceil(trans.axisLength.*srcRange');
            
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
