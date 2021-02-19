function analyzeGenderDLCM
    % CONN fmri data base path :
    base = '../../1000func/';

    % CONN output path
    pathesTR25 = {'nki23-35/2500', 'nki36-45/2500'};
    pathesTR14 = {'nki23-35/1400', 'nki36-45/1400'};
    pathesTR6 = {'nki23-35/645', 'nki36-45/645'};

    % load each type signals
    [tr25Signals, roiNames] = connData2signalsFile(base, pathesTR25, 'tr25', 'data/indi', 'id');
    [tr14Signals] = connData2signalsFile(base, pathesTR14, 'tr14', 'data/indi', 'id');
    [tr6Signals] = connData2signalsFile(base, pathesTR6, 'tr6', 'data/indi', 'id');
    load('data/indi/sbjInfo');
    Idx1 = intersect(find(sbjInfo(:,3)==1),find(sbjInfo(:,4)==1));
    Idx2 = intersect(find(sbjInfo(:,3)==2),find(sbjInfo(:,4)==1));
    Idx3 = intersect(find(sbjInfo2(:,3)==1),find(sbjInfo2(:,4)==1));
    Idx4 = intersect(find(sbjInfo2(:,3)==2),find(sbjInfo2(:,4)==1));

    global resultsPath;
    global resultsPrefix;
    resultsPath = 'results/indi';
    resultsPrefix = 'id';

    maxLag = 5;
    % calculate connectivity
    for j=1:maxLag
        % mvGC(i) no exogenous 
        [tr25GCs{j}, meanTR25GC{j}, ~] = calculateConnectivity(tr25Signals, roiNames, 'tr25', 'gc', 1, j, 0);
        [tr14GCs{j}, meanTR14GC{j}, ~] = calculateConnectivity(tr14Signals, roiNames, 'tr14', 'gc', 1, j, 0);
        [tr6GCs{j}, meanTR6GC{j}, ~] = calculateConnectivity(tr6Signals, roiNames, 'tr6', 'gc', 1, j, 0);
        % mvarEC(i) no exogenous 
        [tr25MVARECs{j}, meanTR25MVAREC{j}, ~] = calculateConnectivity(tr25Signals, roiNames, 'tr25', 'mvarec', 1, j, 0);
        [tr14MVARECs{j}, meanTR14MVAREC{j}, ~] = calculateConnectivity(tr14Signals, roiNames, 'tr14', 'mvarec', 1, j, 0);
        [tr6MVARECs{j}, meanTR6MVAREC{j}, ~] = calculateConnectivity(tr6Signals, roiNames, 'tr6', 'mvarec', 1, j, 0);
        [tr25MVARs{j}, meanTR25MVAR{j}, ~] = calculateConnectivity(tr25Signals, roiNames, 'tr25', 'mvar', 1, j, 0);
        [tr14MVARs{j}, meanTR14MVAR{j}, ~] = calculateConnectivity(tr14Signals, roiNames, 'tr14', 'mvar', 1, j, 0);
        [tr6MVARs{j}, meanTR6MVAR{j}, ~] = calculateConnectivity(tr6Signals, roiNames, 'tr6', 'mvar', 1, j, 0);
        % mpcvarEC(i) no exogenous 
        [tr25MPCVARECs{j}, meanTR25MPCVAREC{j}, ~] = calculateConnectivity(tr25Signals, roiNames, 'tr25', 'mpcvarec', 1, j, 0);
        [tr14MPCVARECs{j}, meanTR14MPCVAREC{j}, ~] = calculateConnectivity(tr14Signals, roiNames, 'tr14', 'mpcvarec', 1, j, 0);
        [tr6MPCVARECs{j}, meanTR6MPCVAREC{j}, ~] = calculateConnectivity(tr6Signals, roiNames, 'tr6', 'mpcvarec', 1, j, 0);
        % DLCM(i)-GC linear no exogenous
        [tr25DL2s{j}, meanTR25DL2{j}, ~] = calculateConnectivity(tr25Signals, roiNames, 'tr25', 'dlcm', 0, j, 0, []);
        [tr14DL2s{j}, meanTR14DL2{j}, ~] = calculateConnectivity(tr14Signals, roiNames, 'tr14', 'dlcm', 0, j, 0, []);
        [tr6DL2s{j}, meanTR6DL2{j}, ~] = calculateConnectivity(tr6Signals, roiNames, 'tr6', 'dlcm', 0, j, 0, []);
        % DLCM(i)-EC linear no exogenous
        [tr25DLW2s{j}, meanTR25DLW2{j}, ~] = calculateConnectivity(tr25Signals, roiNames, 'tr25', 'dlw', 0, j, 0, []);
        [tr14DLW2s{j}, meanTR14DLW2{j}, ~] = calculateConnectivity(tr14Signals, roiNames, 'tr14', 'dlw', 0, j, 0, []);
        [tr6DLW2s{j}, meanTR6DLW2{j}, ~] = calculateConnectivity(tr6Signals, roiNames, 'tr6', 'dlw', 0, j, 0, []);
        % DLCM(i)-GC no exogenous
        [tr25DLs{j}, meanTR25DL{j}, ~] = calculateConnectivity(tr25Signals, roiNames, 'tr25', 'dlcm', 0, j, 0);
        [tr14DLs{j}, meanTR14DL{j}, ~] = calculateConnectivity(tr14Signals, roiNames, 'tr14', 'dlcm', 0, j, 0);
        [tr6DLs{j}, meanTR6DL{j}, ~] = calculateConnectivity(tr6Signals, roiNames, 'tr6', 'dlcm', 0, j, 0);
        % DLCM(i)-EC no exogenous
        [tr25DLWs{j}, meanTR25DLW{j}, ~] = calculateConnectivity(tr25Signals, roiNames, 'tr25', 'dlw', 0, j, 0);
        [tr14DLWs{j}, meanTR14DLW{j}, ~] = calculateConnectivity(tr14Signals, roiNames, 'tr14', 'dlw', 0, j, 0);
        [tr6DLWs{j}, meanTR6DLW{j}, ~] = calculateConnectivity(tr6Signals, roiNames, 'tr6', 'dlw', 0, j, 0);
    end

    for i=1:maxLag
        j = i+maxLag;
        % mvGC(i) auto exogenous 
        [tr25GCs{j}, meanTR25GC{j}, ~] = calculateConnectivity(tr25Signals, roiNames, 'tr25', 'gc', 1, i, 1);
        [tr14GCs{j}, meanTR14GC{j}, ~] = calculateConnectivity(tr14Signals, roiNames, 'tr14', 'gc', 1, i, 1);
        [tr6GCs{j}, meanTR6GC{j}, ~] = calculateConnectivity(tr6Signals, roiNames, 'tr6', 'gc', 1, i, 1);
        % mvarEC(i) auto exogenous 
        [tr25MVARECs{j}, meanTR25MVAREC{j}, ~] = calculateConnectivity(tr25Signals, roiNames, 'tr25', 'mvarec', 1, i, 1);
        [tr14MVARECs{j}, meanTR14MVAREC{j}, ~] = calculateConnectivity(tr14Signals, roiNames, 'tr14', 'mvarec', 1, i, 1);
        [tr6MVARECs{j}, meanTR6MVAREC{j}, ~] = calculateConnectivity(tr6Signals, roiNames, 'tr6', 'mvarec', 1, i, 1);
        [tr25MVARs{j}, meanTR25MVAR{j}, ~] = calculateConnectivity(tr25Signals, roiNames, 'tr25', 'mvar', 1, i, 1);
        [tr14MVARs{j}, meanTR14MVAR{j}, ~] = calculateConnectivity(tr14Signals, roiNames, 'tr14', 'mvar', 1, i, 1);
        [tr6MVARs{j}, meanTR6MVAR{j}, ~] = calculateConnectivity(tr6Signals, roiNames, 'tr6', 'mvar', 1, i, 1);
        % mpcvarEC(i) auto exogenous 
        [tr25MPCVARECs{j}, meanTR25MPCVAREC{j}, ~] = calculateConnectivity(tr25Signals, roiNames, 'tr25', 'mpcvarec', 1, i, 1);
        [tr14MPCVARECs{j}, meanTR14MPCVAREC{j}, ~] = calculateConnectivity(tr14Signals, roiNames, 'tr14', 'mpcvarec', 1, i, 1);
        [tr6MPCVARECs{j}, meanTR6MPCVAREC{j}, ~] = calculateConnectivity(tr6Signals, roiNames, 'tr6', 'mpcvarec', 1, i, 1);
        % DLCM(i)-GC linear auto exogenous
        [tr25DL2s{j}, meanTR25DL2{j}, ~] = calculateConnectivity(tr25Signals, roiNames, 'tr25', 'dlcm', 0, i, 1, []);
        [tr14DL2s{j}, meanTR14DL2{j}, ~] = calculateConnectivity(tr14Signals, roiNames, 'tr14', 'dlcm', 0, i, 1, []);
        [tr6DL2s{j}, meanTR6DL2{j}, ~] = calculateConnectivity(tr6Signals, roiNames, 'tr6', 'dlcm', 0, i, 1, []);
        % DLCM(i)-EC linear auto exogenous
        [tr25DLW2s{j}, meanTR25DLW2{j}, ~] = calculateConnectivity(tr25Signals, roiNames, 'tr25', 'dlw', 0, i, 1, []);
        [tr14DLW2s{j}, meanTR14DLW2{j}, ~] = calculateConnectivity(tr14Signals, roiNames, 'tr14', 'dlw', 0, i, 1, []);
        [tr6DLW2s{j}, meanTR6DLW2{j}, ~] = calculateConnectivity(tr6Signals, roiNames, 'tr6', 'dlw', 0, i, 1, []);
        % DLCM(i)-GC auto exogenous
        [tr25DLs{j}, meanTR25DL{j}, ~] = calculateConnectivity(tr25Signals, roiNames, 'tr25', 'dlcm', 0, i, 1);
        [tr14DLs{j}, meanTR14DL{j}, ~] = calculateConnectivity(tr14Signals, roiNames, 'tr14', 'dlcm', 0, i, 1);
        [tr6DLs{j}, meanTR6DL{j}, ~] = calculateConnectivity(tr6Signals, roiNames, 'tr6', 'dlcm', 0, i, 1);
        % DLCM(i)-EC auto exogenous
        [tr25DLWs{j}, meanTR25DLW{j}, ~] = calculateConnectivity(tr25Signals, roiNames, 'tr25', 'dlw', 0, i, 1);
        [tr14DLWs{j}, meanTR14DLW{j}, ~] = calculateConnectivity(tr14Signals, roiNames, 'tr14', 'dlw', 0, i, 1);
        [tr6DLWs{j}, meanTR6DLW{j}, ~] = calculateConnectivity(tr6Signals, roiNames, 'tr6', 'dlw', 0, i, 1);
    end
    % FC no exogenous (pairwise, then exogenous does not have meaning)
    [tr25FCs, meanTR25FC, ~] = calculateConnectivity(tr25Signals, roiNames, 'tr25', 'fc', 1, j, 0);
    [tr14FCs, meanTR14FC, ~] = calculateConnectivity(tr14Signals, roiNames, 'tr14', 'fc', 1, j, 0);
    [tr6FCs, meanTR6FC, ~] = calculateConnectivity(tr6Signals, roiNames, 'tr6', 'fc', 1, j, 0);
    
    % diagnose groups and show ROC curves
    statisticalDiagnosisFramework(tr25GCs, tr25MVARECs, tr25MVARs, tr25MPCVARECs, tr25DL2s, tr25DLW2s, ...
        tr25DLs, tr25DLWs, tr25FCs, Idx1, Idx2, 'tr25f', 'm', roiNames);
    statisticalDiagnosisFramework(tr14GCs, tr14MVARECs, tr14MVARs, tr14MPCVARECs, tr14DL2s, tr14DLW2s, ...
        tr14DLs, tr14DLWs, tr14FCs, Idx3, Idx4, 'tr14f', 'm', roiNames);
    statisticalDiagnosisFramework(tr6GCs, tr6MVARECs, tr6MVARs, tr6MPCVARECs, tr6DL2s, tr6DLW2s, ...
        tr6DLs, tr6DLWs, tr6FCs, Idx3, Idx4, 'tr6f', 'm', roiNames);
end

function statisticalDiagnosisFramework(GCs, MVARECs, MVARs, MPCVARECs, DL2s, DLW2s, ...
        DLs, DLWs, FCs, Idx1, Idx2, name1, name2, roiNames)
    global resultsPath;
    global resultsPrefix;

    maxLag = length(GCs) / 2;

    % plot correlation and cos similarity
    nanx = eye(size(GCs{1},1),size(GCs{1},2));
    nanx(nanx==1) = NaN;
    cosSim = zeros(maxLag*2*8+1,1);
    for j=1:maxLag*2
        i = 0;
        cosSim(j+i) = getCosSimilarity(nanmean(GCs{j}(:,:,Idx1),3)+nanx, nanmean(GCs{j}(:,:,Idx2),3)+nanx); i=i+10;
        cosSim(j+i) = getCosSimilarity(nanmean(MVARECs{j}(:,:,Idx1),3)+nanx, nanmean(MVARECs{j}(:,:,Idx2),3)+nanx); i=i+10;
        cosSim(j+i) = getCosSimilarity(nanmean(MVARs{j}(:,:,Idx1),3)+nanx, nanmean(MVARs{j}(:,:,Idx2),3)+nanx); i=i+10;
        cosSim(j+i) = getCosSimilarity(nanmean(MPCVARECs{j}(:,:,Idx1),3)+nanx, nanmean(MPCVARECs{j}(:,:,Idx2),3)+nanx); i=i+10;
        cosSim(j+i) = getCosSimilarity(nanmean(DL2s{j}(:,:,Idx1),3)+nanx, nanmean(DL2s{j}(:,:,Idx2),3)+nanx); i=i+10; % linear DNN
        cosSim(j+i) = getCosSimilarity(nanmean(DLW2s{j}(:,:,Idx1),3)+nanx, nanmean(DLW2s{j}(:,:,Idx2),3)+nanx); i=i+10; % linear DNN
        cosSim(j+i) = getCosSimilarity(nanmean(DLs{j}(:,:,Idx1),3)+nanx, nanmean(DLs{j}(:,:,Idx2),3)+nanx); i=i+10; % non-linear DNN
        cosSim(j+i) = getCosSimilarity(nanmean(DLWs{j}(:,:,Idx1),3)+nanx, nanmean(DLWs{j}(:,:,Idx2),3)+nanx); i=i+10; % non-linear DNN
    end
    cosSim(i+1) = getCosSimilarity(nanmean(FCs(:,:,Idx1),3)+nanx, nanmean(FCs(:,:,Idx2),3)+nanx);
    figure; bar(cosSim);
    title(['cos similarity between ' name1 ' and ' name2 ' by each algorithm']);

    % normality test
%    DLWsNt = calculateAlzNormalityTest(DLWs{j}(:,:,Idx1), roiNames, name1, 'dlw');

    % compalizon test (Wilcoxon, Mann?Whitney U test)
    for j=1:maxLag*2
        [~, GCsUtP{j}, ~] = calculateAlzWilcoxonTest(GCs{j}(:,:,Idx1), GCs{j}(:,:,Idx2), roiNames, name1, name2, ['gc' num2str(j)]);
        [~, MvarECsUtP{j}, ~] = calculateAlzWilcoxonTest(MVARECs{j}(:,:,Idx1), MVARECs{j}(:,:,Idx2), roiNames, name1, name2, ['mvarec' num2str(j)]);
        [~, MvarsUtP{j}, ~] = calculateAlzWilcoxonTest(MVARs{j}(:,:,Idx1), MVARs{j}(:,:,Idx2), roiNames, name1, name2, ['mvar' num2str(j)]);
        [~, MpcvarECsUtP{j}, ~] = calculateAlzWilcoxonTest(MPCVARECs{j}(:,:,Idx1), MPCVARECs{j}(:,:,Idx2), roiNames, name1, name2, ['mpcvarec' num2str(j)]);
        [~, DL2sUtP{j}, ~] = calculateAlzWilcoxonTest(DL2s{j}(:,:,Idx1), DL2s{j}(:,:,Idx2), roiNames, name1, name2, ['dlcm_lin' num2str(j)]);
        [~, DLW2sUtP{j}, ~] = calculateAlzWilcoxonTest(DLW2s{j}(:,:,Idx1), DLW2s{j}(:,:,Idx2), roiNames, name1, name2, ['dlw_lin' num2str(j)]);
        [~, DLsUtP{j}, ~] = calculateAlzWilcoxonTest(DLs{j}(:,:,Idx1), DLs{j}(:,:,Idx2), roiNames, name1, name2, ['dlcm' num2str(j)]);
        [~, DLWsUtP{j}, ~] = calculateAlzWilcoxonTest(DLWs{j}(:,:,Idx1), DLWs{j}(:,:,Idx2), roiNames, name1, name2, ['dlw' num2str(j)]);
    end
    [~, FCsUtP, ~] = calculateAlzWilcoxonTest(FCs(:,:,Idx1), FCs(:,:,Idx2), roiNames, name1, name2, 'fc');

    % using minimum 100 p-value relations. perform 5-fold cross validation.
    topNum = 100;
    sigTh = 2;
    N = 4;

    fcAUC = zeros(1,N);
    gcAUC = zeros(maxLag*2,N);
    mvarecAUC = zeros(maxLag*2,N);
    mvarAUC = zeros(maxLag*2,N);
    mpcvarecAUC = zeros(maxLag*2,N);
    dlAUC = zeros(maxLag*2,N);
    dlwAUC = zeros(maxLag*2,N);
    dl2AUC = zeros(maxLag*2,N);
    dlw2AUC = zeros(maxLag*2,N);
    fcROC = cell(N,2);
    fcACC = cell(N,1);
    for lags=1:maxLag*2
        gcROC{lags} = cell(N,2);
        mvarecROC{lags} = cell(N,2);
        mvarROC{lags} = cell(N,2);
        mpcvarecROC{lags} = cell(N,2);
        dlROC{lags} = cell(N,2);
        dlwROC{lags} = cell(N,2);
        dl2ROC{lags} = cell(N,2);
        dlw2ROC{lags} = cell(N,2);
        gcACC{lags} = cell(N,1);
        mvarecACC{lags} = cell(N,1);
        mvarACC{lags} = cell(N,1);
        mpcvarecACC{lags} = cell(N,1);
        dlACC{lags} = cell(N,1);
        dlwACC{lags} = cell(N,1);
        dl2ACC{lags} = cell(N,1);
        dlw2ACC{lags} = cell(N,1);
    end

    sigCntG1 = cell(N,maxLag*2*8+1);
    sigCntG2 = cell(N,maxLag*2*8+1);
    for k=1:N
        for j=1:maxLag*2
            i = 1;
            % check sigma of healthy subject
            [control, target, meanTarget, stdTarget, meanControl] = getkFoldDataSet(GCs{j}(:,:,Idx1), GCs{j}(:,:,Idx2), k, N);
            [B, I, X] = sortAndPairPValues(control, target, GCsUtP{j}, topNum);
            sigCntG1{k,i} = calcAlzSigmaSubjects(control, meanTarget, stdTarget, meanControl, I, topNum, sigTh);
            sigCntG2{k,i} = calcAlzSigmaSubjects(target, meanTarget, stdTarget, meanControl, I, topNum, sigTh);
            [gcROC{j}{k,1}, gcROC{j}{k,2}, gcAUC(j,k), gcACC{j}{k}] = calcAlzROCcurve(sigCntG1{k,i}, sigCntG2{k,i}, topNum);

            i = i + 1;
            [control, target, meanTarget, stdTarget, meanControl] = getkFoldDataSet(MVARECs{j}(:,:,Idx1), MVARECs{j}(:,:,Idx2), k, N);
            [B, I, X] = sortAndPairPValues(control, target, MvarECsUtP{j}, topNum);
            sigCntG1{k,i} = calcAlzSigmaSubjects(control, meanTarget, stdTarget, meanControl, I, topNum, sigTh);
            sigCntG2{k,i} = calcAlzSigmaSubjects(target, meanTarget, stdTarget, meanControl, I, topNum, sigTh);
            [mvarecROC{j}{k,1}, mvarecROC{j}{k,2}, mvarecAUC(j,k), mvarecACC{j}{k}] = calcAlzROCcurve(sigCntG1{k,i}, sigCntG2{k,i}, topNum);

            i = i + 1;
            [control, target, meanTarget, stdTarget, meanControl] = getkFoldDataSet(MVARs{j}(:,:,Idx1), MVARs{j}(:,:,Idx2), k, N);
            [B, I, X] = sortAndPairPValues(control, target, MvarsUtP{j}, topNum);
            sigCntG1{k,i} = calcAlzSigmaSubjects(control, meanTarget, stdTarget, meanControl, I, topNum, sigTh);
            sigCntG2{k,i} = calcAlzSigmaSubjects(target, meanTarget, stdTarget, meanControl, I, topNum, sigTh);
            [mvarROC{j}{k,1}, mvarROC{j}{k,2}, mvarAUC(j,k), mvarACC{j}{k}] = calcAlzROCcurve(sigCntG1{k,i}, sigCntG2{k,i}, topNum);

            i = i + 1;
            [control, target, meanTarget, stdTarget, meanControl] = getkFoldDataSet(MPCVARECs{j}(:,:,Idx1), MPCVARECs{j}(:,:,Idx2), k, N);
            [B, I, X] = sortAndPairPValues(control, target, MpcvarECsUtP{j}, topNum);
            sigCntG1{k,i} = calcAlzSigmaSubjects(control, meanTarget, stdTarget, meanControl, I, topNum, sigTh);
            sigCntG2{k,i} = calcAlzSigmaSubjects(target, meanTarget, stdTarget, meanControl, I, topNum, sigTh);
            [mpcvarecROC{j}{k,1}, mpcvarecROC{j}{k,2}, mpcvarecAUC(j,k), mpcvarecACC{j}{k}] = calcAlzROCcurve(sigCntG1{k,i}, sigCntG2{k,i}, topNum);

            i = i + 1;
            [control, target, meanTarget, stdTarget, meanControl] = getkFoldDataSet(DL2s{j}(:,:,Idx1), DL2s{j}(:,:,Idx2), k, N);
            [B, I, X] = sortAndPairPValues(control, target, DL2sUtP{j}, topNum);
            sigCntG1{k,i} = calcAlzSigmaSubjects(control, meanTarget, stdTarget, meanControl, I, topNum, sigTh);
            sigCntG2{k,i} = calcAlzSigmaSubjects(target, meanTarget, stdTarget, meanControl, I, topNum, sigTh);
            [dl2ROC{j}{k,1}, dl2ROC{j}{k,2}, dl2AUC(j,k), dl2ACC{j}{k}] = calcAlzROCcurve(sigCntG1{k,i}, sigCntG2{k,i}, topNum);

            i = i + 1;
            [control, target, meanTarget, stdTarget, meanControl] = getkFoldDataSet(DLW2s{j}(:,:,Idx1), DLW2s{j}(:,:,Idx2), k, N);         % replece tr25*s, tr25*s
            [B, I, X] = sortAndPairPValues(control, target, DLW2sUtP{j}, topNum);                                  % replace tr25*sUtP
            sigCntG1{k,i} = calcAlzSigmaSubjects(control, meanTarget, stdTarget, meanControl, I, topNum, sigTh);
            sigCntG2{k,i} = calcAlzSigmaSubjects(target, meanTarget, stdTarget, meanControl, I, topNum, sigTh);
            [dlw2ROC{j}{k,1}, dlw2ROC{j}{k,2}, dlw2AUC(j,k), dlw2ACC{j}{k}] = calcAlzROCcurve(sigCntG1{k,i}, sigCntG2{k,i}, topNum);         % replace *ROC, *AUC

            i = i + 1;
            [control, target, meanTarget, stdTarget, meanControl] = getkFoldDataSet(DLs{j}(:,:,Idx1), DLs{j}(:,:,Idx2), k, N);
            [B, I, X] = sortAndPairPValues(control, target, DLsUtP{j}, topNum);
            sigCntG1{k,i} = calcAlzSigmaSubjects(control, meanTarget, stdTarget, meanControl, I, topNum, sigTh);
            sigCntG2{k,i} = calcAlzSigmaSubjects(target, meanTarget, stdTarget, meanControl, I, topNum, sigTh);
            [dlROC{j}{k,1}, dlROC{j}{k,2}, dlAUC(j,k), dlACC{j}{k}] = calcAlzROCcurve(sigCntG1{k,i}, sigCntG2{k,i}, topNum);

            i = i + 1;
            [control, target, meanTarget, stdTarget, meanControl] = getkFoldDataSet(DLWs{j}(:,:,Idx1), DLWs{j}(:,:,Idx2), k, N);         % replece tr25*s, ad*s
            [B, I, X] = sortAndPairPValues(control, target, DLWsUtP{j}, topNum);                                  % replace tr25*sUtP
            sigCntG1{k,i} = calcAlzSigmaSubjects(control, meanTarget, stdTarget, meanControl, I, topNum, sigTh);
            sigCntG2{k,i} = calcAlzSigmaSubjects(target, meanTarget, stdTarget, meanControl, I, topNum, sigTh);
            [dlwROC{j}{k,1}, dlwROC{j}{k,2}, dlwAUC(j,k), dlwACC{j}{k}] = calcAlzROCcurve(sigCntG1{k,i}, sigCntG2{k,i}, topNum);         % replace *ROC, *AUC
        end

        i = i + 1;
        [control, target, meanTarget, stdTarget, meanControl] = getkFoldDataSet(FCs(:,:,Idx1), FCs(:,:,Idx2), k, N);
        [B, I, X] = sortAndPairPValues(control, target, FCsUtP, topNum);
        sigCntG1{k,i} = calcAlzSigmaSubjects(control, meanTarget, stdTarget, meanControl, I, topNum, sigTh);
        sigCntG2{k,i} = calcAlzSigmaSubjects(target, meanTarget, stdTarget, meanControl, I, topNum, sigTh);
        [fcROC{k,1}, fcROC{k,2}, fcAUC(1,k), fcACC{k}] = calcAlzROCcurve(sigCntG1{k,i}, sigCntG2{k,i}, topNum);
    end

    % save result
    fname = [resultsPath '/' resultsPrefix '-' name1 '-' name2 '-roi' num2str(132) '-result.mat'];
    save(fname, 'cosSim', 'fcAUC','gcAUC','mvarecAUC','mvarAUC','mpcvarecAUC','dlAUC','dlwAUC','dl2AUC','dlw2AUC', ...
        'fcROC','gcROC','mvarecROC','mvarROC','mpcvarecROC','dlROC','dlwROC','dl2ROC','dlw2ROC', ...
        'fcACC','gcACC','mvarecACC','mvarACC','mpcvarecACC','dlACC','dlwACC','dl2ACC','dlw2ACC', ...
        'sigCntG1', 'sigCntG2');

    % show box plot
    AUCs = nan(N,maxLag*2*8+1);
    r = [1:10];
    AUCs(:,r) = gcAUC.'; r=r+10;
    AUCs(:,r) = mvarecAUC.'; r=r+10;
    AUCs(:,r) = mvarAUC.'; r=r+10;
    AUCs(:,r) = mpcvarecAUC.'; r=r+10;
    AUCs(:,r) = dl2AUC.'; r=r+10;
    AUCs(:,r) = dlw2AUC.'; r=r+10;
    AUCs(:,r) = dlAUC.'; r=r+10;
    AUCs(:,r) = dlwAUC.'; r=r+10;
    AUCs(:,r(1)) = fcAUC.'; 
    figure; boxplot(AUCs);
    title(['AUC box plot : ' name1 ' vs ' name2]);

    % show average ROC curves
    figure; 
    hold on;
    for lags=1:maxLag
        plotAverageROCcurve(gcROC{lags}, N, '-', [0.2,0.5,0.2]+(lags*0.1),1.0);
        plotAverageROCcurve(mvarecROC{lags}, N, '-', [0.5,0.2,0.2]+(lags*0.1),1.0);
        plotAverageROCcurve(mvarROC{lags}, N, '--', [0.5,0.2,0.2]+(lags*0.1),1.0);
        plotAverageROCcurve(mpcvarecROC{lags}, N, '-.', [0.5,0.2,0.2]+(lags*0.1),1.0);
        plotAverageROCcurve(dlROC{lags}, N, '-', [0.2,0.2,0.4]+(lags*0.1),1.0);
        plotAverageROCcurve(dl2ROC{lags}, N, '--', [0.2,0.2,0.4]+(lags*0.1),0.4); % linear
        plotAverageROCcurve(dlwROC{lags}, N, '-', [0.2,0.2,0.2]+(lags*0.1),1.0);
        plotAverageROCcurve(dlw2ROC{lags}, N, '--', [0.2,0.2,0.2]+(lags*0.1),0.4); % linear
    end
    plotAverageROCcurve(fcROC, N, '-', [0.5,0.5,0.2],1.0);
    plot([0 1], [0 1],':','Color',[0.5 0.5 0.5]);
    hold off;
    ylim([0 1]);
    xlim([0 1]);
    daspect([1 1 1]);
    title(['averaged ROC curve (without exogenous) : ' name1 ' vs ' name2]);
    xlabel('False Positive Rate')
    ylabel('True Positive Rate')

    % show average ROC curves
    figure; 
    hold on;
    for lags=1:maxLag
        k = lags+5;
        plotAverageROCcurve(gcROC{k}, N, '-', [0.2,0.5,0.2]+(lags*0.1),1.0);
        plotAverageROCcurve(mvarecROC{k}, N, '-', [0.5,0.2,0.2]+(lags*0.1),1.0);
        plotAverageROCcurve(mvarROC{k}, N, '--', [0.5,0.2,0.2]+(lags*0.1),1.0);
        plotAverageROCcurve(mpcvarecROC{k}, N, '-.', [0.5,0.2,0.2]+(lags*0.1),1.0);
        plotAverageROCcurve(dlROC{k}, N, '-', [0.2,0.2,0.4]+(lags*0.1),1.0);
        plotAverageROCcurve(dl2ROC{k}, N, '--', [0.2,0.2,0.4]+(lags*0.1),0.4); % linear
        plotAverageROCcurve(dlwROC{k}, N, '-', [0.2,0.2,0.2]+(lags*0.1),1.0);
        plotAverageROCcurve(dlw2ROC{k}, N, '--', [0.2,0.2,0.2]+(lags*0.1),0.4); % linear
    end
    plotAverageROCcurve(fcROC, N, '-', [0.5,0.5,0.2],1.0);
    plot([0 1], [0 1],':','Color',[0.5 0.5 0.5]);
    hold off;
    ylim([0 1]);
    xlim([0 1]);
    daspect([1 1 1]);
    title(['averaged ROC curve (with exogenous) : ' name1 ' vs ' name2]);
    xlabel('False Positive Rate')
    ylabel('True Positive Rate')
end

function [control, target, meanTarget, stdTarget, meanControl] = getkFoldDataSet(orgControl, orgTarget, k, N)
    un = floor(size(orgControl,3) / N);
    st = (k-1)*un+1;
    ed = k*un;
    if k==N, ed = size(orgControl,3); end
    control = orgControl(:,:,st:ed);
    un = floor(size(orgTarget,3) / N);
    st = (k-1)*un+1;
    ed = k*un;
    if k==N, ed = size(orgTarget,3); end
    target = orgTarget(:,:,st:ed);
    if N > 1
        orgTarget(:,:,st:ed) = [];
    end
    meanTarget = nanmean(orgTarget, 3);
    stdTarget = nanstd(orgTarget, 1, 3);
    meanControl = nanmean(orgControl, 3);
end

function [x, y, auc] = invertROCcurve(inx, iny)
    y = inx;
    x = iny;
    auc = trapz(x, y);
end

function [x, y, auc, accuracy] = calcAlzROCcurve(control, target, start)
    x = [0]; y = [0]; % start from (0,0)
    accuracy = nan(start+1,1);
    tpmax = length(control);
    fpmax = length(target);
    for i=start:-1:0
        tp = length(find(control>=i));
        fp = length(find(target>=i));
        tn = fpmax - fp;
        x = [x fp/fpmax];
        y = [y tp/tpmax];
        accuracy(i+1) = (tp + tn) / (tpmax + fpmax);
    end
    auc = trapz(x, y);
end

function [B, I, X] = sortAndPairPValues(control, target, utestP2, topNum)
    ROINUM = size(control,1);
    [B, I] = sort(utestP2(:));
    X = [];
    for k=1:topNum
        i = floor(mod(I(k)-1,ROINUM) + 1);
        j = floor((I(k)-1)/ROINUM + 1);
        x = squeeze(control(i,j,:));
        y = squeeze(target(i,j,:));
        
        if length(x) > length(y)
            x2 = x;
            y2 = nan(length(x),1);
            y2(1:length(y),1) = y;
        else
            x2 = nan(length(y),1);
            x2(1:length(x),1) = x;
            y2 = y;
        end
        X = [X, x2, y2];
    end
end

function sigCount = calcAlzSigmaSubjects(weights, meanWeights, stdWeights, meanControl, I, topNum, sigTh)
    ROINUM = size(weights,1);
    subjectNum = size(weights,3);
    X = [];
    sigCount = [];
    isControlBig = meanControl - meanWeights;
    for n=1:subjectNum
        w2 = weights(:,:,n);
        w2 = w2 - meanWeights;
        sig = abs(w2 ./ stdWeights);
%        sig = w2 ./ stdWeights;
        s = nan(topNum, 1);
        for k=1:topNum
            i = floor(mod(I(k)-1,ROINUM) + 1);
            j = floor((I(k)-1)/ROINUM + 1);
            s(k) = sig(i, j);
%{
            s2 = sig(i, j);
            if s2 < 0 && isControlBig(i, j) > 0
                s2 = 0;
            elseif s2 > 0 && isControlBig(i, j) < 0
                s2 = 0;
            end
            s(k) = abs(s2);
%}
        end
        X = [X, s];
        sigCount = [sigCount, length(find(s>=sigTh))];
    end
%    figure; boxplot(X);
%    figure; bar(sigCount);
end

function [normalities, normalitiesP] = calculateAlzNormalityTest(weights, roiNames, group, algorithm)
    % constant value
    ROINUM = size(weights,1);

    global resultsPath;
    global resultsPrefix;
    outfName = [resultsPath '/' resultsPrefix '-' algorithm '-' group '-roi' num2str(ROINUM) '-normality.mat'];
    if exist(outfName, 'file')
        load(outfName);
    else
        normalities = nan(ROINUM, ROINUM);
        normalitiesP = nan(ROINUM, ROINUM);
        for i=1:ROINUM
            for j=1:ROINUM
                if i==j, continue; end
                x = squeeze(weights(i,j,:));
                [h, p] = lillietest(x);
                normalities(i,j) = 1 - h;
                normalitiesP(i,j) = p;
            end
        end
        save(outfName, 'normalities', 'normalitiesP', 'roiNames');
    end

    load('test/colormap.mat')
    % show normality test result
    figure; 
    colormap(hvalmap);
    clims = [0,1];
    imagesc(normalities,clims);
    daspect([1 1 1]);
    title([group '-' algorithm ' normality test result']);
    colorbar;
    % normality test p values
    normalitiesP(isnan(normalitiesP)) = 1;
    figure;
    colormap(pvalmap);
    clims = [0,0.5];
    imagesc(normalitiesP,clims);
    daspect([1 1 1]);
    title([group '-' algorithm ' normality test p values']);
    colorbar;
end


function [utestH, utestP, utestP2] = calculateAlzWilcoxonTest(control, target, roiNames, controlGroup, targetGroup, algorithm)
    % constant value
    ROINUM = size(control,1);

    global resultsPath;
    global resultsPrefix;
    outfName = [resultsPath '/' resultsPrefix '-' algorithm '-' controlGroup '_' targetGroup '-roi' num2str(ROINUM) '-utest.mat'];
    if exist(outfName, 'file')
        load(outfName);
    else
        utestH = nan(ROINUM, ROINUM);
        utestP = nan(ROINUM, ROINUM);
        utestP2 = nan(ROINUM, ROINUM);
        for i=1:ROINUM
            for j=1:ROINUM
                if i==j, continue; end
                x = squeeze(control(i,j,:));
                y = squeeze(target(i,j,:));
                if length(x) > length(y)
                    x2 = x;
                    y2 = nan(length(x),1);
                    y2(1:length(y),1) = y;
                else
                    x2 = nan(length(y),1);
                    x2(1:length(x),1) = x;
                    y2 = y;
                end
                if isempty(find(~isnan(x2))) || isempty(find(~isnan(y2))), continue; end
                [p, h] = ranksum(x2,y2);
%                [p, h] = signrank(x2,y2);
                utestH(i,j) = h;
                utestP(i,j) = p;
                if h > 0 && nanmean(x) > nanmean(y)
                    utestP2(i,j) = p;
                end
            end
        end
        save(outfName, 'utestH', 'utestP', 'utestP2', 'roiNames');
    end
    % counting by source region and target region
    countSource = nansum(utestH,1);
    countTarget = nansum(utestH,2);
    save(outfName, 'utestH', 'utestP', 'utestP2', 'roiNames', 'countSource', 'countTarget');

    load('test/colormap.mat')
    % U test result
    figure; 
    colormap(hvalmap);
    clims = [0,1];
    imagesc(utestH,clims);
    daspect([1 1 1]);
    title([controlGroup '-' targetGroup ' : ' algorithm ' : u test result']);
    colorbar;
    % U test p values
    utestP(isnan(utestP)) = 1;
    figure;
    colormap(pvalmap);
    clims = [0,1];
    imagesc(utestP, clims);
    daspect([1 1 1]);
    title([controlGroup '-' targetGroup ' : ' algorithm ' : u test p values']);
    colorbar;
end
