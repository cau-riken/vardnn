%%
% Calculate pPCVAR (pairwise Principal Component Vector Auto-Regression) DI
% returns pPCVAR DI matrix (DI) and impaired node signals (DIsub)
% input:
%  net          pPCVAR network
%  nodeControl  node control matrix (node x node) (optional)
%  exControl    exogenous input control matrix for each node (node x exogenous input) (optional)
%  isFullNode   return both node & exogenous causality matrix (default:0)

function [DI, DIsub, coeff] = calcPpcvarDI(net, nodeControl, exControl, isFullNode)
    if nargin < 4, isFullNode = 0; end
    if nargin < 3, exControl = []; end
    if nargin < 2, nodeControl = []; end

    nodeNum = net.nodeNum;
    lags = net.lags;
    if isFullNode==0, nodeMax = nodeNum; else nodeMax = nodeNum + net.exNum; end

    % set control 3D matrix (node x node x lags)
    [nodeControl, exControl, control] = getControl3DMatrix(nodeControl, exControl, nodeNum, net.exNum, lags);

    % calc pairwise PCVAR
    DI = nan(nodeNum, nodeMax);
    coeff = nan(nodeNum, nodeMax);
    DIsub = nan(nodeNum, nodeMax, 2);
    for i=1:nodeNum
        [~,idx] = find(control(i,i,:)==1);
        Yi = ones(1, lags);
        Xti = Yi(:,idx);

        for j=1:nodeMax
            if i==j, continue; end
            if j<=nodeNum && ~any(nodeControl(i,j,:),'all'), continue; end
            if j>nodeNum && ~any(exControl(i,j-nodeNum,:),'all'), continue; end

            mc = net.maxComp{i,j};
            mu = net.mu{i,j};

            % autoregression plus other regression
            [~,idx] = find(control(i,j,:)==1);
            Yj = ones(1, lags);
            Xtj = [Xti, Yj(:,idx)];

            score = (Xtj - mu) / net.coeff{i,j}.';
            subScore = [score(:,1:mc), 1];
            DIsub(i,j,1) = subScore * net.bvec{i,j};
        
            % autoregression plus other regression
            Yj(:) = 0;
            Xtj = [Xti, Yj(:,idx)];
            score = (Xtj - mu) / net.coeff{i,j}.';
            subScore = [score(:,1:mc), 1];
            DIsub(i,j,2) = subScore * net.bvec{i,j};
            coeff(i,j) = DIsub(i,j,1)-DIsub(i,j,2); % actually this is sum of b(p+2:end)
            DI(i,j) = abs(coeff(i,j));
        end
    end
end

