%%
% Calculate multivariate Granger Causality
% returns Granger causality index matrix (gcI), significance (h=1 or 0)
% p-values (P), F-statistic (F), the critical value from the F-distribution (cvFd)
% and AIC, BIC (of node vector)
% input:
%  X            multivariate time series matrix (node x time series)
%  exSignal     multivariate time series matrix (exogenous input x time series) (optional)
%  nodeControl  node control matrix (node x node) (optional)
%  exControl    exogenous input control matrix for each node (node x exogenous input) (optional)
%  lags         number of lags for autoregression (default:3)
%  alpha        the significance level of F-statistic (default:0.05)
%  isFullNode   return both node & exogenous causality matrix (default:0)

function [gcI, h, P, F, cvFd, AIC, BIC, nodeAIC, nodeBIC] = calcMultivariateGCI(X, exSignal, nodeControl, exControl, lags, alpha, isFullNode)
    if nargin < 7, isFullNode = 0; end
    if nargin < 6, alpha = 0.05; end
    if nargin < 5, lags = 3; end
    if nargin < 4, exControl = []; end
    if nargin < 3, nodeControl = []; end
    if nargin < 2, exSignal = []; end

    nodeNum = size(X,1);
    sigLen = size(X,2);
    exNum = size(exSignal,1);
    inputNum = nodeNum + exNum;
    if isFullNode==0, nodeMax = nodeNum; else nodeMax = nodeNum + exNum; end

    % set node input
    Y = [X; exSignal];

    % set control 3D matrix (node x node x lags)
    [nodeControl,exControl,control] = getControl3DMatrix(nodeControl, exControl, nodeNum, exNum, lags);

    Y = flipud(Y.'); % need to flip signal

    % first, calculate vector auto-regression (VAR) without target
    Yj = zeros(sigLen-lags, lags*inputNum);
    for k=1:lags
        Yj(:,1+inputNum*(k-1):inputNum*k) = Y(1+k:sigLen-lags+k,:);
    end

    nodeAIC = zeros(nodeNum,1);
    nodeBIC = zeros(nodeNum,1);
    gcI = nan(nodeNum,nodeMax);
    h = nan(nodeNum,nodeMax);
    P = nan(nodeNum,nodeMax);
    F = nan(nodeNum,nodeMax);
    cvFd = nan(nodeNum,nodeMax);
    AIC = nan(nodeNum,nodeMax);
    BIC = nan(nodeNum,nodeMax);
    for i=1:nodeNum
        [~,idx] = find(control(i,:,:)==1);
        
        % vector auto-regression (VAR)
        Xt = Y(1:sigLen-lags,i);
        Xti = Yj(:,idx); %, ones(sigLen-lags,1)]; % might not be good to add bias
        % apply the regress function
        [b,bint,r] = regress(Xt,Xti);
        Vxt = var(r,1);

        % AIC and BIC of this node (assuming residuals are gausiann distribution)
        T = sigLen-lags;
        RSS = r'*r;
        k = size(Xti,2);
        nodeAIC(i) = T*log(RSS/T) + 2 * k;
        nodeBIC(i) = T*log(RSS/T) + k*log(T);

        for j=1:nodeMax
            if i==j, continue; end
            control2 = control;
            control2(i,j,:) = 0;
            [~,idx2] = find(control2(i,:,:)==1);
            
            Xtj = Yj(:,idx2); %, ones(sigLen-lags,1)]; % might not be good to add bias
            [b,bint,r] = regress(Xt,Xtj);
            Vyt = var(r,1);

            gcI(i,j) = log(Vyt / Vxt);

            % AIC and BIC (assuming residuals are gausiann distribution)
            % BIC = n*ln(RSS/n)+k*ln(n)
            RSS1 = r'*r;
            k1 = size(Xtj,2);
            AIC(i,j) = T*log(RSS1/T) + 2 * k1;
            BIC(i,j) = T*log(RSS1/T) + k1*log(T);

            % calc F-statistic
            % https://en.wikipedia.org/wiki/F-test
            % F = ((RSS1 - RSS2) / (p2 - p1)) / (RSS2 / n - p2)
            %RSS1 = r'*r;  % p1 = p*nn1;
            RSS2 = RSS;   % p2 = p*nodeNum;
            F(i,j) = ((RSS1 - RSS2)/lags) / (RSS2 / (sigLen - k));
            P(i,j) = 1 - fcdf(F(i,j),lags,(sigLen-k));
            cvFd(i,j) = finv(1-alpha,lags,(sigLen-k));
            h(i,j) = F(i,j) > cvFd(i,j);
        end
    end
    % output control
    if isFullNode==0
        gcI = gcI(:,1:nodeNum);
        F = F(:,1:nodeNum);
        P = P(:,1:nodeNum);
        cvFd = cvFd(:,1:nodeNum);
        h = h(:,1:nodeNum);
        AIC = AIC(:,1:nodeNum);
        BIC = BIC(:,1:nodeNum);
    end
    if ~isempty(nodeControl)
        nodeControl=double(nodeControl(:,:,1)); nodeControl(nodeControl==0) = nan;
        gcI(:,1:nodeNum) = gcI(:,1:nodeNum) .* nodeControl;
        F(:,1:nodeNum) = F(:,1:nodeNum) .* nodeControl;
        P(:,1:nodeNum) = P(:,1:nodeNum) .* nodeControl;
        cvFd(:,1:nodeNum) = cvFd(:,1:nodeNum) .* nodeControl;
        h(:,1:nodeNum) = h(:,1:nodeNum) .* nodeControl;
        AIC(:,1:nodeNum) = AIC(:,1:nodeNum) .* nodeControl;
        BIC(:,1:nodeNum) = BIC(:,1:nodeNum) .* nodeControl;
    end
    if ~isempty(exControl) && isFullNode > 0
        exControl=double(exControl(:,:,1)); exControl(exControl==0) = nan;
        gcI(:,nodeNum+1:end) = gcI(:,nodeNum+1:end) .* exControl;
        F(:,nodeNum+1:end) = F(:,nodeNum+1:end) .* exControl;
        P(:,nodeNum+1:end) = P(:,nodeNum+1:end) .* exControl;
        cvFd(:,nodeNum+1:end) = cvFd(:,nodeNum+1:end) .* exControl;
        h(:,nodeNum+1:end) = h(:,nodeNum+1:end) .* exControl;
        AIC(:,nodeNum+1:end) = AIC(:,nodeNum+1:end) .* exControl;
        BIC(:,nodeNum+1:end) = BIC(:,nodeNum+1:end) .* exControl;
    end
end

