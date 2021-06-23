%%
% Caluclate pPCVAR (pairwise Principal Component Vector Auto-Regression) EC
% returns pPCVAR EC matrix (EC) and impaired node signals (ECsub)
% input:
%  net          pPCVAR network
%  nodeControl  node control matrix (node x node) (optional)
%  exControl    exogenous input control matrix for each node (node x exogenous input) (optional)
%  isFullNode   return both node & exogenous causality matrix (default:0)

function [EC, ECsub, coeff] = calcPpcvarEC(net, nodeControl, exControl, isFullNode)
    if nargin < 4, isFullNode = 0; end
    if nargin < 3, exControl = []; end
    if nargin < 2, nodeControl = []; end

    nodeNum = net.nodeNum;
    nodeInNum = nodeNum + net.exNum;
    lags = net.lags;
    if isFullNode==0, nodeMax = nodeNum; else nodeMax = nodeInNum; end
    
    % calc pairwise PCVAR
    EC = nan(nodeNum, nodeMax);
    coeff = nan(nodeNum, nodeMax);
    ECsub = nan(nodeNum, nodeMax, 2);
    for i=1:nodeNum
        for j=1:nodeMax
            if i==j, continue; end
            if j<=nodeNum && ~isempty(nodeControl) && nodeControl(i,j) == 0, continue; end
            if j>nodeNum && ~isempty(exControl) && exControl(i,j-nodeNum) == 0, continue; end

            mc = net.maxComp{i,j};
            mu = net.mu{i,j};

            Xti = ones(1,lags*2);
            score = (Xti - mu) / net.coeff{i,j}.';
            subScore = [score(:,1:mc), 1];
            ECsub(i,j,1) = subScore * net.bvec{i,j};
        
            % autoregression plus other regression
            Xti(:,lags+1:end) = 0;
            score = (Xti - mu) / net.coeff{i,j}.';
            subScore = [score(:,1:mc), 1];
            ECsub(i,j,2) = subScore * net.bvec{i,j};
            coeff(i,j) = ECsub(i,j,1)-ECsub(i,j,2); % actually this is sum of b(p+2:end)
            EC(i,j) = abs(coeff(i,j));
        end
    end
end

