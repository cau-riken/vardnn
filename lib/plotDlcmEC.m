%%
% plot DLCM effective connectivity matrix
% input:
%  netDLCM      trained DLCM network
%  nodeControl  node control matrix (node x node) (optional)
%  exControl    exogenous input control matrix for each node (node x exogenous input) (optional)
%  range        plotting minimum and maximum range of GCI (default:0.5)
%               if range==0, range shows standard deviation [-3 sigma, 3 sigma]
%  isFullNode   return both node & exogenous causality matrix (default:0)

function [EC] = plotDlcmEC(netDLCM, nodeControl, exControl, range, isFullNode)
    if nargin < 5, isFullNode = 0; end
    if nargin < 4, range = 0.5; end
    if nargin < 3, exControl = []; end
    if nargin < 2, nodeControl = []; end

    EC = calcDlcmEC(netDLCM, nodeControl, exControl, isFullNode);
    % show DLCM weight causality of predicted node signals
    if range <= 0
        sigma = std(EC(:),1,'omitnan');
        avg = mean(EC(:),'omitnan');
        EC2 = (EC - avg) / sigma;
        range = 3;
    else
        EC2 = EC;
    end
    clims = [-range, range];
    imagesc(EC2,clims);
    daspect([1 1 1]);
    title('DLCM Effective Connectivity');
    xlabel('Source Nodes');
    ylabel('Target Nodes');
    colorbar;
end
