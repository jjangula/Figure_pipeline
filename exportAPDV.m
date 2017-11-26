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
    
    clear zProjection crossAP crossDV ptsAP ptsDV ptsPouch IAP IDV Ecadherin AX 
    
    IAP = find(data.ptsAP(:,1) == 0);
    IDV = find(data.ptsDV(:,1) == 0);
    
    data.ptsAP(IAP, :) = [];
    data.ptsDV(IDV, :) = [];
    
    if size(data.zProjection, 4) == 4
        Ecadherin = squeeze(data.zProjection(:,:,:,4));
%         imwrite(mat2gray(Ecadherin), [settings.outRough 'Ecadherin_' char(category(i)) '_' num2str(i) '.png']);
    end
    pouchMask = poly2mask(data.ptsPouch(1,:),data.ptsPouch(2,:),size(data.zProjection,1),size(data.zProjection,2));
    stats = regionprops(pouchMask, 'Centroid', 'Orientation');
    dx = cosd(stats.Orientation); dy = -sind(stats.Orientation);
    lineLong = [stats.Centroid'+([-[dx;dy]*1000,[dx;dy]*1000])];
    lineShort = [stats.Centroid'+([-[-dy;dx]*1000,[-dy;dx]*1000])];
    %scale
    zProjection(:,:,1) = mat2gray(data.zProjection(:,:,:,2));
    zProjection(:,:,2) = mat2gray(data.zProjection(:,:,:,1));
    zProjection(:,:,3) = mat2gray(data.zProjection(:,:,:,3));
    
    figure(1)
    clf
    set(gcf,'color','w')
    ptsAP = data.ptsAP * data.scale.x;
    ptsDV = data.ptsDV * data.scale.x;
    ptsPouch = data.ptsPouch * data.scale.x;
%     IntersectAP(:,1) = (data.IntersectAP{1}(:,2) - data.pAP(1)) * data.scale.x;
%     IntersectAP(:,2) = (data.IntersectAP{1}(:,1))  * data.scale.x;
%     IntersectDV(:,1) = (data.IntersectDV{1}(:,2) - data.pDV(1)) * data.scale.x;
%     IntersectDV(:,2) = (data.IntersectDV{1}(:,1)) * data.scale.x;
%     midpointAP(:,1) = (data.midpointAP(:,1) - data.pAP(1)) * data.scale.x;
%     midpointAP(:,2) = data.midpointAP(:,2) * data.scale.x;
%     midpointDV(:,1) = (data.midpointDV(:,1) - data.pDV(1)) * data.scale.x;
%     midpointDV(:,2) = data.midpointDV(:,2) * data.scale.x;
    
    subplot(2,2,1);
    imshow(zProjection,'XData', 0:25:175.43, 'YData', 0:.25:174.55)
    hold on
    plot(ptsAP(:,1),ptsAP(:,2), 'c-', 'LineWidth',2);
    plot(ptsDV(:,1),ptsDV(:,2), 'm-', 'LineWidth',2);
    plot(ptsAP(1,1),ptsAP(1,2), 'yo');
    plot(ptsDV(1,1),ptsDV(1,2), 'yo');
    plot(ptsPouch(1,[1:end,1]),ptsPouch(2,[1:end,1]),'k-', 'LineWidth',2);
    plot(ptsAP(data.midAP,1),ptsAP(data.midAP,2),'r*')
    plot(ptsDV(data.midDV,1),ptsDV(data.midDV,2),'g*')
%     xlabel('x (\mum)')
%     ylabel('y (\mum)')
    title('Z Projection')
%     axis on
    
    interval = 10;
    
    subplot(2,2,2)    
    set(subplot(2,2,2),'Color','k')
    crossAP(:,:,1) = mat2gray(data.crossAP(:,:,2));
    crossAP(:,:,2) = mat2gray(data.crossAP(:,:,1));
    crossAP(:,:,3) = mat2gray(data.crossAP(:,:,3));
    crossAP = imresize(crossAP, [(size(crossAP, 1) * data.scale.z), size(crossAP, 2) * data.scale.y]); %/ data.scale.y
    %crossAP = imresize(crossAP, [(size(crossAP, 1)/ data.scale.y * data.scale.z), size(crossAP, 2)]);
    imshow(crossAP)
%     AX = get(gca,'xlim') - data.pAP(1)*data.scale.y;
%     imshow(crossAP, 'XData',AX(1):AX(2));
    %I2 = imcrop(I, [-20, 80, 40, 80]);
%     hold on
%     plot((data.ptsAPcrossSection(1,:) - data.pAP(1)) * data.scale.x,data.ptsAPcrossSection(2,:) * data.scale.x, 'r-', 'LineWidth',1.5);
%     plot([(data.finalPoints.AP1(1:interval:end,1) - data.pAP(1))*data.scale.y, (data.finalPoints.AP2(1:interval:end,1) - data.pAP(1))*data.scale.y]',[data.finalPoints.AP1(1:interval:end,2)*data.scale.y, data.finalPoints.AP2(1:interval:end,2)*data.scale.y]','w');
%     plot(midpointAP(:,1), midpointAP(:,2), 'g-', 'LineWidth',2)
%     plot(IntersectAP(:,1), IntersectAP(:,2), 'b-', 'LineWidth',2)
%     plot(0, data.pAP(2) * data.scale.x, 'ro')
%     plot([(data.finalPoints.AP1(1:interval:end,1)), (data.finalPoints.AP2(1:interval:end,1))]',[data.finalPoints.AP1(1:interval:end,2), data.finalPoints.AP2(1:interval:end,2)]','w');
    ax1 = gca;
    ax1.Color = [0 0 0];
%     xlabel('AP axis (\mum)')
%     ylabel('z (\mum)')
    title('Projection along AP boundary')
%     axis([-90, 90,0,100])
%     axis on
    
    clearvars AX
    
    subplot(2,2,3)
    crossDV(:,:,1) = mat2gray(data.crossDV(:,:,2));
    crossDV(:,:,2) = mat2gray(data.crossDV(:,:,1));
    crossDV(:,:,3) = mat2gray(data.crossDV(:,:,3));
    crossDV = imresize(crossDV, [size(crossDV, 1)* data.scale.z, size(crossDV, 2)*data.scale.y]);%/ data.scale.y
    %crossDV = imresize(crossDV, [(size(crossDV, 1)/ data.scale.y * data.scale.z), size(crossDV, 2)]);
    imshow(crossDV)
%     AX = get(gca,'xlim') - data.pDV(1)*data.scale.y;
%     imshow(crossDV, 'XData',AX(1):AX(2))
%     hold on
%     plot([(data.finalPoints.DV1(1:interval:end,1) - data.pDV(1))*data.scale.y, (data.finalPoints.DV2(1:interval:end,1) - data.pDV(1))*data.scale.y]',[data.finalPoints.DV1(1:interval:end,2)*data.scale.y, data.finalPoints.DV2(1:interval:end,2)*data.scale.y]','w');
%     plot((data.ptsDVcrossSection(1,:) - data.pDV(1)) * data.scale.x,data.ptsDVcrossSection(2,:) * data.scale.x, 'r-', 'LineWidth',1.5);
%     plot(midpointDV(:,1), midpointDV(:,2), 'g-', 'LineWidth',2)
%     plot(IntersectDV(:,1), IntersectDV(:,2), 'b-', 'LineWidth',2)
%     plot(0, data.pDV(2) * data.scale.x, 'ro')
%     plot([data.finalPoints.DV1(1:interval:end,1)*data.scale.y, data.finalPoints.DV2(1:interval:end,1)*data.scale.y]',[data.finalPoints.DV1(1:interval:end,2)*data.scale.y, data.finalPoints.DV2(1:interval:end,2)*data.scale.y]','w');
    ax2 = gca;
    ax2.Color = [0 0 0];    
    xlabel('DV axis (\mum)')
    ylabel('z (\mum)')
    title('Projection along DV boundary')
%     axis([-120, 120,0,100])
%     axis on
    
    directory = dataTable.Path{k}(1:end-11);
    mkdir(directory, 'preliminary figures')
    filename = [directory '\preliminary figures\' dataTable.Label{k} '.png'];%
    export_fig(filename);
%    print([settings.outRough, dataTable.Label{i}, '.png'],'-dpng','-r600')
end
