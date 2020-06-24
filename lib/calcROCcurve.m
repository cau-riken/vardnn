%%
% Caluclate ROC curve of X with ground truth G
% returns x, y vectors and AUC value
% input:
%  X           target matrix (node x node) to get ROC curve
%  G           ground truth matrix (node x node) (TRUE is G > Gth)
%  ignoreDiag  ignore diagonal in the matrix (default:1)
%  Gth         ground truth threshold (default:0)

function [x, y, auc] = calcROCcurve(X, G, ignoreDiag, Gth)
    if nargin < 4, Gth = 0; end
    if nargin < 3, ignoreDiag = 1; end
    n = size(X,1);
    x = [0]; y = [0]; % start from (0,0)
    if ignoreDiag == 1
        D = eye(n, n);
        D(D>0) = NaN;
        G = G + D;
        X = X + D;
    end
    G = (G > Gth); % ground truth

    tpmax = length(find(G>0));
    fpmax = n*n - ignoreDiag * n - tpmax;
    st = nanmax(nanmax(X)); % starting threshold
    ed = nanmin(nanmin(X)); % end threshold
    for i=1:101
        th = (st * (101-i) + ed * (i-1)) / 100;
        idx = find(X >= th);
        t = G(idx);
        tp = length(find(t>0));
        fp = length(find(t==0));
        x = [x fp/fpmax];
        y = [y tp/tpmax];
    end
    auc = trapz(x, y);
end

