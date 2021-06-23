%%
% Caluclate pVAR (pairwise Vector Auto-Regression) EC
% returns pVAR EC matrix (EC) and impaired node signals (ECsub)
% input:
%  X            multivariate time series matrix (node x time series)
%  exSignal     multivariate time series matrix (exogenous input x time series) (optional)
%  nodeControl  node control matrix (node x node) (optional)
%  exControl    exogenous input control matrix for each node (node x exogenous input) (optional)
%  lags         number of lags for autoregression (default:3)
%  isFullNode   return both node & exogenous causality matrix (default:0)

function [EC, ECsub, coeff] = calcPvarEC(X, exSignal, nodeControl, exControl, lags, isFullNode)
    if nargin < 6, isFullNode = 0; end
    if nargin < 5, lags = 3; end
    if nargin < 4, exControl = []; end
    if nargin < 3, nodeControl = []; end
    if nargin < 2, exSignal = []; end
    nodeNum = size(X,1);
    sigLen = size(X,2);
    p = lags;
    if isFullNode==0, nodeMax = nodeNum; else nodeMax = nodeNum + size(exSignal,1); end
    
    % set node input
    Y = [X; exSignal];
    Y = flipud(Y.'); % need to flip signal
    
    % calc Pairwise VAR
    EC = nan(nodeNum, nodeMax);
    coeff = nan(nodeNum, nodeMax);
    ECsub = nan(nodeNum, nodeMax, 2);
    for i=1:nodeNum
        for j=1:nodeMax
            if i==j, continue; end
            if j<=nodeNum && ~isempty(nodeControl) && nodeControl(i,j) == 0, continue; end
            if j>nodeNum && ~isempty(exControl) && exControl(i,j-nodeNum) == 0, continue; end

            % autoregression plus other regression
            Yt = Y(1:(sigLen-p),i); % target
            Yti = ones(sigLen-p, p*2+1);
            for k=1:p
                Yti(:,1+k) = Y(k+1:sigLen-p+k,i); % target
                Yti(:,1+p+k) = Y(k+1:sigLen-p+k,j); % source
            end
            [b,bint,Yr] = regress(Yt,Yti);
            ECsub(i,j,1) = sum(b);
            ECsub(i,j,2) = sum(b(1:p+1));
            coeff(i,j) = ECsub(i,j,1)-ECsub(i,j,2); % actually this is sum of b(p+2:end)
            EC(i,j) = abs(coeff(i,j));
        end
    end
end

