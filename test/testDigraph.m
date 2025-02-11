% load healthy control analysis result of VARDNN-GC
load('results/ad-dlcm_ex-cn-roi132.mat');
load('data/roiNames.mat');

% invert weight 
m = 1 ./ meanWeights;
G = digraph(m, 'omitselfloops');

% plot function hub graph
figure;
gp=plot(G);
layout(gp,'force','WeightEffect','direct');
gp.NodeLabel = roiNames;
gp.LineStyle = ':';
gp.NodeColor = [1 0 0];
gp.EdgeColor = [0.9 0.9 0.9];

%%
% plot function hub graph 2
sigma = std(meanWeights(:),1,'omitnan');
avg = mean(meanWeights(:),'omitnan');
mOrg = (meanWeights - avg) / sigma;
rangeW = [-2,-3,-4,-5];
rangeS = [2,3,4,5];
%{
figure;
for i=1:length(rangeS)
    m = mOrg;
    m(m<rangeS(i)) = 0;
    if i<length(rangeS)
        m(m>=rangeS(i+1)) = 0;
    end
    hold on; 
    m = 1 ./ m;
    m(isinf(m)) = 0;
    G = digraph(m, 'omitselfloops');
    gp=plot(G);
    layout(gp,'force','WeightEffect','direct');
    gp.LineStyle = '-';
    gp.EdgeColor = [0.9, 1-i*0.2, 1-i*0.2];
    hold off;
end
gp.NodeColor = [0.7, 0.3, 0.3];
gp.NodeLabel = roiNames;
%}
%%
% plot circle graph
figure;
for i=1:length(rangeW)
    m = mOrg;
    m(m>rangeW(i)) = 0;
    if i<length(rangeW)
        m(m<=rangeW(i+1)) = 0;
    end
    hold on; 
    G = digraph(m, 'omitselfloops');
    gp=plot(G);
    layout(gp,'circle');
    gp.LineStyle = '-';
    gp.EdgeColor = [1-i*0.2, 1-i*0.2, 0.9];
    hold off;
end
for i=1:length(rangeS)
    m = mOrg;
    m(m<rangeS(i)) = 0;
    if i<length(rangeS)
        m(m>=rangeS(i+1)) = 0;
    end
    hold on; 
    G = digraph(m, 'omitselfloops');
    gp=plot(G);
    layout(gp,'circle');
    gp.LineStyle = '-';
    gp.EdgeColor = [0.9, 1-i*0.2, 1-i*0.2];
    hold off;
end
gp.NodeColor = [0.7, 0.7, 0.7];
gp.NodeLabel = roiNames;
