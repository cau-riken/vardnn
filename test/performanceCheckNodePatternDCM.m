% Before using this function, download SPM12 codes from
% https://www.fil.ion.ucl.ac.uk/spm/software/download/
% and add a path "spm12" and sub folders, then remove "spm12/external" folder and sub folders.

function performanceCheckNodePatternDCM
    % load signals
    load('test/testTrain-rand500-uniform.mat');
    siOrg = si;
    
    nodeNum = 8;
    sigLen = 100;

    %% pattern 1 -------------------------------------------------
%{
    disp('full random -- full independent nodes');
    si = siOrg(1:nodeNum,1:sigLen);
    checkingPattern(si, 1);
%}
    %% pattern 2 -------------------------------------------------
%{
    disp('node 2 and 6 are syncronized');
    si = siOrg(1:nodeNum, 1:sigLen);
    si(2,:) = si(6,:);
    checkingPattern(si, 2);
%}
    %% pattern 3 -------------------------------------------------
%%{
    disp('node 2 is excited by node 6');
    si = siOrg(1:nodeNum, 1:sigLen);
    si(2,2:end) = si(6,1:sigLen-1);
    checkingPattern(si, 3);
%%}
    %% pattern 4 -------------------------------------------------
%%{
    disp('node 2 is excited half by node 6');
    si = siOrg(1:nodeNum, 1:sigLen);
    si(2,2:end) = si(6,1:sigLen-1) * 0.5;
    checkingPattern(si, 4);
%%}
    %% pattern 5 -------------------------------------------------

%%{
    disp('node 2,4 is excited by node 6');
    si = siOrg(1:nodeNum, 1:sigLen);
    si(2,2:end) = si(6,1:sigLen-1);
    si(4,2:end) = si(6,1:sigLen-1);
    checkingPattern(si, 5);
%%}
    %% pattern 6 -------------------------------------------------
%%{
    disp('nodes are excited 6-.->2, 2-.->4');
    si = siOrg(1:nodeNum, 1:sigLen);
    si(2,2:end) = si(6,1:sigLen-1);
    si(4,3:end) = si(2,2:sigLen-1);
    checkingPattern(si, 6);
%%}
    %% pattern # -------------------------------------------------
%{
    disp('node 2 and 6 are syncronized, but inverted');
    si = siOrg(1:nodeNum, 1:sigLen);
    si(2,:) = 1 - si(6,:);
    checkingPattern(si, 4);
%}
    %% pattern # -------------------------------------------------
%{
    disp('node 2 is inhibitted by node 6');
    si = siOrg(1:nodeNum, 1:sigLen);
    si(2,2:end) = 1 - si(6,1:sigLen-1);
    checkingPattern(si, 3);
%}
end

%% 
function [FC, DI, gcI] = checkingPattern(si, idx)
    nodeNum = size(si,1);
    sigLen = size(si,2);

    % layer parameters
    netDLCM = initMvarDnnNetwork(si);

    % show signals before training
    %{
    maxEpochs = 1;
    miniBatchSize = 1;
    options = trainingOptions('adam', ...
        'ExecutionEnvironment','cpu', ...
        'MaxEpochs',maxEpochs, ...
        'MiniBatchSize',miniBatchSize, ...
        'Shuffle','every-epoch', ...
        'GradientThreshold',5,...
        'Verbose',false);
%            'Plots','training-progress');

    disp('initial state before training');
    netDLCM = trainMvarDnnNetwork(si, [], [], [], netDLCM, options);
    [t,mae,maeerr] = plotNodeSignals(nodeNum,si,exSignal,netDLCM);
    disp(['t=' num2str(t) ', mae=' num2str(mae)]);
    %}
    % training VARDNN network
    maxEpochs = 1000;
    miniBatchSize = ceil(sigLen / 3);
    options = trainingOptions('adam', ...
        'ExecutionEnvironment','cpu', ...
        'MaxEpochs',maxEpochs, ...
        'MiniBatchSize',miniBatchSize, ...
        'Shuffle','every-epoch', ...
        'GradientThreshold',5,...
        'Verbose',false);
%            'Plots','training-progress');

    disp('start training');
    netDLCM = trainMvarDnnNetwork(si, [], [], [], netDLCM, options);
    netFile = ['results/net-pat-' num2str(idx) '.mat'];
    save(netFile, 'netDLCM');

    % show signals after training
    figure; [S, t,mae,maeerr] = plotPredictSignals(si,[],[],[],netDLCM);
    disp(['t=' num2str(t) ', mae=' num2str(mae)]);

    % show original signal FC
    figure; FC = plotFunctionalConnectivity(si);
    % show original signal granger causality index (GCI)
    figure; gcI = plotPairwiseGCI(si);
    % show original time shifted correlation (tsc-FC)
    %tscFC = plotTimeShiftedCorrelation(si);
    % show deep-learning effective connectivity
%    figure; DI = plotMvarDnnECmeanWeight(netDLCM);
%    figure; DI = plotMvarDnnECmeanAbsWeight(netDLCM);
%    figure; DI = plotMvarDnnECmeanDeltaWeight(netDLCM);
    figure; DI = plotMvarDnnECmeanAbsDeltaWeight(netDLCM);
    % show VARDNN-GC
    figure; dlGC = plotMvarDnnGCI(si, [], [], [], netDLCM);

    % DEM Structure: create random inputs
    % -------------------------------------------------------------------------
    N  = 12;                              % number of runs
    T  = sigLen;                          % number of observations (scans)
    TR = 2;                               % repetition time or timing
    n  = nodeNum;                         % number of regions or nodes

    % priors
    % -------------------------------------------------------------------------
    dcmopt.maxnodes   = nodeNum;          % effective number of nodes

    dcmopt.nonlinear  = 0;
    dcmopt.two_state  = 0;
    dcmopt.stochastic = 0;
    dcmopt.centre     = 1;
    dcmopt.induced    = 1;

    % initialize DCM stcuct
    DCM = struct();
    DCM.options = dcmopt;

    DCM.a    = ones(n,n);
    DCM.b    = zeros(n,n,0);
    DCM.c    = zeros(n,1);
    DCM.d    = zeros(n,n,0);

    DCM.Y.dt = TR;
    DCM.U.u  = zeros(T,1);
    DCM.U.dt = TR;

    CSD   = {};
    % response
    % -----------------------------------------------------------------
    DCM.Y.y  = si.';
%%{
    % nonlinear system identification (Variational Laplace)
    % =================================================================
    CSD{end + 1} = spm_dcm_fmri_csd(DCM);
    BPA          = spm_dcm_average(CSD,'simulation',1);

    A = BPA.Ep.A;
    figure; plotDcmEC(A);
%%}
end

