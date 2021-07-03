%%
% get VARDNN weight causality index matrix
% input:
%  net          trained VARDNN network
%  nodeControl  node control matrix (node x node) (optional)
%  exControl    exogenous input control matrix for each node (node x exogenous input) (optional)

function wcI = calcDlcmWCIm123(net, nodeControl, exControl)
    if nargin < 3
        exControl = [];
    end
    if nargin < 2
        nodeControl = [];
    end
    nodeNum = net.nodeNum;
    nodeInNum = nodeNum + net.exNum;

    wcI = nan(nodeNum,nodeNum);
    for i=1:nodeNum
        % get input control
        control = ones(1, nodeNum);
        excontrol = ones(1, nodeInNum - nodeNum);
        if ~isempty(nodeControl)
            control = nodeControl(i,:);
        end
        if ~isempty(exControl)
            excontrol = exControl(i,:);
        end
        ctrl = [control, excontrol];

        % calc liner weights relation
        w1 = net.nodeNetwork{i, 1}.Layers(2, 1).Weights;
        w2 = net.nodeNetwork{i, 1}.Layers(4, 1).Weights;
        w3 = net.nodeNetwork{i, 1}.Layers(6, 1).Weights;
        b1 = net.nodeNetwork{i, 1}.Layers(2, 1).Bias;
        b2 = net.nodeNetwork{i, 1}.Layers(4, 1).Bias;
        b3 = net.nodeNetwork{i, 1}.Layers(6, 1).Bias;

        w23 = w2.' * w3.';
        b23 = b2.' * w3.' + b3;
        
%        w123 = w1.' * w23;
%        b123 = b1.' * w23 + b23;
%        w = w123.';
%        b = b123;

        w23r = repmat(w23, 1, size(w1,2));
        w = w1 .* w23r;
        b = b1 .* w23  + b23;

        % remove useless weights
        for j=nodeInNum:-1:1
            if ctrl(j) < 1
                w(:,j) = [];
            end
        end
        weight = [w, b];
        VarEi = var(weight(:));

        % imparement node signals
        for j=1:nodeNum
            if i==j, continue; end
            nweight = weight;
            nweight(:,j) = [];
            VarEj = var(nweight(:));
            wcI(i,j) = log(VarEi / VarEj);
        end
    end
end