function exportAPDV(dataTable, settings)
%% Initialization
% clearvars
% close all
% settings = prepareWorkspace;
% dataTable = getLabels(settings);
% category = categorical(dataTable.Category);
% 
% %keep = category==categorical({'ms1096-plc21c-RNAi'}) | ...%%%%%%%%%%
% %    category==categorical({'ms1096-RyR-RNAi'});%%%%%%%%%%%%%%
% 
% % keep = logical(keep * 0);
% % keep([1:5]) = 1;
% %dataTable = dataTable(keep,:);%%%%%%%%%%%%%%%
% %dataTable = dataTable([69:79,87:end],:);
% settings.xyN = 500;
% settings.force = true;
% settings.crossType = 'Developmental';
% % dataTable = dataTable(round(rand(1) * 100),:);
% 
% %% Semiautomated data processing
% warning('Data must be converted into .mat files for this to work')
% % thruSegmentPouch(dataTable, settings); % manual segmentation of axes and pouch
% % thruMakeSlices(dataTable, settings); % automatically make orthogonal projections
% % thruSegmentCrossection(dataTable, settings); % manual segmentation of cross sections
% % thruDrawLines(dataTable, settings); % manual determination of cross section orientation
% % thruAnalyzeCuts(dataTable, settings); % automatic extraction of height profiles


% %% More figures
% close all
% toRemove = [];
% for i = 1:size(dataTable,1)
% alreadyExists = matFileExists(dataTable.Path{i}, {'poop'});
%     if alreadyExists && ~settings.force
%         toRemove(end+1) = i;
%     end
% end
% dataTable(toRemove,:) = [];

%% Export Data
for k = 1:size(dataTable,1)
    dataTable.Label{k}
    CurrentFile = strcat(dataTable.Path{k},'\',dataTable.Label{k});
% %     alreadyExists = matFileExists(CurrentFile, {'zProjection','crossDV','crossAP','scale'});
% %     if ~alreadyExists
% %         continue
% %     end
    
    data = load(strcat(CurrentFile,'.mat'),'crossAP','crossDV','ptsPouch','zProjection','scale','ptsAP','ptsDV','AP0','DV0','midAP','midDV','Centroid');
    if data.scale.z == 0
        data.scale.z = 2;
    end
    
    data.scale.x = 0.34;
    data.scale.y = 0.34;
    
    clear zProjection crossAP crossDV ptsAP ptsDV ptsPouch IAP IDV Ecadherin AX cross_AP cross_DV
    
    IAP = find(data.ptsAP(:,1) == 0);
    IDV = find(data.ptsDV(:,1) == 0);
    
    data.ptsAP(IAP, :) = [];
    data.ptsDV(IDV, :) = [];
    
    if size(data.zProjection, 4) == 4
        Ecadherin = squeeze(data.zProjection(:,:,:,4));
    end

    zProjection(:,:,1) = mat2gray(data.zProjection(:,:,:,1));
    zProjection(:,:,2) = mat2gray(data.zProjection(:,:,:,2));
    zProjection(:,:,3) = mat2gray(data.zProjection(:,:,:,3));
    zProjection(:,:,4) = mat2gray(data.zProjection(:,:,:,4));
    
    figure(1)
    clf
    set(gcf,'color','w')
    ptsAP = data.ptsAP * data.scale.x;
    ptsDV = data.ptsDV * data.scale.x;
    ptsPouch = data.ptsPouch * data.scale.x;
    
    subplot(4,4,1);
    imshow(zProjection(:,:,1),'XData', 0:25:175.43, 'YData', 0:.25:174.55)
    hold on
    plot(ptsAP(:,1),ptsAP(:,2), 'c-', 'LineWidth',0.2);
    plot(ptsDV(:,1),ptsDV(:,2), 'm-', 'LineWidth',0.2);
    plot(ptsAP(1,1),ptsAP(1,2), 'b.');
    plot(ptsDV(1,1),ptsDV(1,2), 'b.');
    plot(ptsPouch(1,[1:end,1]),ptsPouch(2,[1:end,1]),'r-', 'LineWidth',0.2);
    title(['Z ' dataTable.CH1{k}])
 
    subplot(4,4,2);
    imshow(zProjection(:,:,2),'XData', 0:25:175.43, 'YData', 0:.25:174.55)
    hold on
    plot(ptsAP(:,1),ptsAP(:,2), 'c-', 'LineWidth',0.2);
    plot(ptsDV(:,1),ptsDV(:,2), 'm-', 'LineWidth',0.2);
    plot(ptsAP(1,1),ptsAP(1,2), 'b.');
    plot(ptsDV(1,1),ptsDV(1,2), 'b.');
    plot(ptsPouch(1,[1:end,1]),ptsPouch(2,[1:end,1]),'r-', 'LineWidth',0.2);
    title(['Z ' dataTable.CH2{k}])
    
    subplot(4,4,3);
    imshow(zProjection(:,:,3),'XData', 0:25:175.43, 'YData', 0:.25:174.55)
    hold on
    plot(ptsAP(:,1),ptsAP(:,2), 'c-', 'LineWidth',0.2);
    plot(ptsDV(:,1),ptsDV(:,2), 'm-', 'LineWidth',0.2);
    plot(ptsAP(1,1),ptsAP(1,2), 'b.');
    plot(ptsDV(1,1),ptsDV(1,2), 'b.');
    plot(ptsPouch(1,[1:end,1]),ptsPouch(2,[1:end,1]),'r-', 'LineWidth',0.2);
    title(['Z ' dataTable.CH3{k}]) 
    
    subplot(4,4,4);
    imshow(zProjection(:,:,4),'XData', 0:25:175.43, 'YData', 0:.25:174.55)
    hold on
    plot(ptsAP(:,1),ptsAP(:,2), 'c-', 'LineWidth',0.2);
    plot(ptsDV(:,1),ptsDV(:,2), 'm-', 'LineWidth',0.2);
    plot(ptsAP(1,1),ptsAP(1,2), 'b.');
    plot(ptsDV(1,1),ptsDV(1,2), 'b.');
    plot(ptsPouch(1,[1:end,1]),ptsPouch(2,[1:end,1]),'r-', 'LineWidth',0.2);
    title(['Z ' dataTable.CH4{k}])
    
    subplot(4,4,5);
    imshow(zProjection(:,:,1),'XData', 0:25:175.43, 'YData', 0:.25:174.55)
    title(['Z ' dataTable.CH1{k}])
 
    subplot(4,4,6);
    imshow(zProjection(:,:,2),'XData', 0:25:175.43, 'YData', 0:.25:174.55)
    title(['Z ' dataTable.CH2{k}])
    
    subplot(4,4,7);
    imshow(zProjection(:,:,3),'XData', 0:25:175.43, 'YData', 0:.25:174.55)
    title(['Z ' dataTable.CH3{k}]) 
    
    subplot(4,4,8);
    imshow(zProjection(:,:,4),'XData', 0:25:175.43, 'YData', 0:.25:174.55)
    title(['Z ' dataTable.CH4{k}])
       
    crossAP(:,:,1) = mat2gray(data.crossAP(:,:,1));
    crossAP(:,:,2) = mat2gray(data.crossAP(:,:,2));
    crossAP(:,:,3) = mat2gray(data.crossAP(:,:,3));
    crossAP(:,:,4) = mat2gray(data.crossAP(:,:,4));
    
    cross_AP(:,:,1) = imresize(crossAP(:,:,1), [(size(crossAP, 1) * data.scale.z), size(crossAP, 2) * data.scale.y]); %/ data.scale.y
    cross_AP(:,:,2) = imresize(crossAP(:,:,2), [(size(crossAP, 1) * data.scale.z), size(crossAP, 2) * data.scale.y]);
    cross_AP(:,:,3) = imresize(crossAP(:,:,3), [(size(crossAP, 1) * data.scale.z), size(crossAP, 2) * data.scale.y]);
    cross_AP(:,:,4) = imresize(crossAP(:,:,4), [(size(crossAP, 1) * data.scale.z), size(crossAP, 2) * data.scale.y]);

    subplot(4,4,9);
    imshow(cross_AP(:,:,1))
    title(['AP ' dataTable.CH1{k}])
    
    subplot(4,4,10);
    imshow(cross_AP(:,:,2))
    title(['AP ' dataTable.CH2{k}])
    
    subplot(4,4,11);
    imshow(cross_AP(:,:,3))
    title(['AP ' dataTable.CH3{k}])
    
    subplot(4,4,12);
    imshow(cross_AP(:,:,4))
    title(['AP ' dataTable.CH4{k}])
    
    crossDV(:,:,1) = mat2gray(data.crossDV(:,:,1));
    crossDV(:,:,2) = mat2gray(data.crossDV(:,:,2));
    crossDV(:,:,3) = mat2gray(data.crossDV(:,:,3));
    crossDV(:,:,4) = mat2gray(data.crossDV(:,:,4));
    
    cross_DV(:,:,1) = imresize(crossDV(:,:,1), [size(crossDV, 1)* data.scale.z, size(crossDV, 2)*data.scale.y]);
    cross_DV(:,:,2) = imresize(crossDV(:,:,2), [size(crossDV, 1)* data.scale.z, size(crossDV, 2)*data.scale.y]);
    cross_DV(:,:,3) = imresize(crossDV(:,:,3), [size(crossDV, 1)* data.scale.z, size(crossDV, 2)*data.scale.y]);
    cross_DV(:,:,4) = imresize(crossDV(:,:,4), [size(crossDV, 1)* data.scale.z, size(crossDV, 2)*data.scale.y]);
   
    subplot(4,4,13)
    imshow(cross_DV(:,:,1))
    title(['DV ' dataTable.CH1{k}])
    
    subplot(4,4,14);
    imshow(cross_DV(:,:,2))
    title(['DV ' dataTable.CH2{k}])
    
    subplot(4,4,15);
    imshow(cross_DV(:,:,3))
    title(['DV ' dataTable.CH3{k}])
    
    subplot(4,4,16);
    imshow(cross_DV(:,:,4))
    title(['DV ' dataTable.CH4{k}])
    
    directory = dataTable.Path{k}(1:end-11);
    mkdir(directory, 'preliminary figures')
    filename = [directory '\preliminary figures\' dataTable.Label{k} '.png'];
    filenamepdf = [directory '\preliminary figures\' dataTable.Category{k} '.pdf'];
    export_fig(filename);
    if exist(filenamepdf, 'file')
        export_fig(filenamepdf, '-append')
    else
        export_fig(filenamepdf);
    end
end
