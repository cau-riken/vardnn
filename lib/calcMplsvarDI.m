%%
% Calculate mPLSVAR (multivaliate PLS Vector Auto-Regression) DI
% returns mPLSVAR DI matrix (DI) and impaired node signals (DIsub)
% input:
%  net          mPLSVAR network
%  nodeControl  node control matrix (node x node) (optional)
%  exControl    exogenous input control matrix for each node (node x exogenous input) (optional)
%  isFullNode   return both node & exogenous causality matrix (default:0)

function [DI, DIsub, coeff] = calcMplsvarDI(net, nodeControl, exControl, isFullNode)
    if nargin < 4, isFullNode = 0; end
    if nargin < 3, exControl = []; end
    if nargin < 2, nodeControl = []; end

    nodeNum = net.nodeNum;
    inputNum = nodeNum + net.exNum;
    lags = net.lags;
    if isFullNode==0, nodeMax = nodeNum; else nodeMax = inputNum; end

    % set control 3D matrix (node x node x lags)
    [nodeControl, exControl, control] = getControl3DMatrix(nodeControl, exControl, nodeNum, net.exNum, lags);

    % calc mPLSVAR DI
    Yj = ones(1,lags*inputNum);
    DI = nan(nodeNum,nodeMax);
    coeff = nan(nodeNum,nodeMax);
    DIsub = nan(nodeNum,nodeMax+1);
    for i=1:nodeNum
        b = net.bvec{i};
        z = sum(b);
        DIsub(i,1) = z;
        [~,idx] = find(control(i,:,:)==1);

        for j=1:nodeMax
            if i==j, continue; end
            if j<=nodeNum && ~any(nodeControl(i,j,:),'all'), continue; end
            if j>nodeNum && ~any(exControl(i,j-nodeNum,:),'all'), continue; end

            zj = z;
            for k=1:lags
                s = j + (k-1)*inputNum;
                bIdx = find(idx==s);
                if ~isempty(bIdx)
                    zj = zj - b(1+bIdx);
                end
            end

            DI(i,j) = abs(z - zj); % actually this is sum of b(bIdx+nlen*(k-1))
            coeff(i,j) = z - zj;
            DIsub(i,j+1) = zj;
        end
    end
end

