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
    clear zProjection crossAP crossDV ptsAP ptsDV ptsPouch IAP IDV cross_AP cross_DV    
    dataTable.Label{k}
    CurrentFile = strcat(dataTable.Path{k},'\',dataTable.Label{k});
    
    data = load(strcat(CurrentFile,'.mat'),'crossAP','crossDV','ptsPouch','zProjection','scale','ptsAP','ptsDV','AP0','DV0','midAP','midDV','Centroid');
    if data.scale.z == 0
        data.scale.z = 2;
    end
    
    directory = dataTable.Path{k}(1:end-11);
    mkdir(directory, 'preliminary figures')
    filename = [directory '\preliminary figures\' dataTable.Label{k} '.png'];
    filenamepdf = [directory '\preliminary figures\' dataTable.Category{k} '.pdf'];
    
    data.scale.x = 0.34;
    data.scale.y = 0.34;
    data.scale.z = 1;
    
    IAP = find(data.ptsAP(:,1) == 0);
    IDV = find(data.ptsDV(:,1) == 0);
    
    data.ptsAP(IAP, :) = [];
    data.ptsDV(IDV, :) = [];
    
%     for q = 1:4
%     zProjection(:,:,q) = data.zProjection(:,:,:,1) .* 0;
%     crossAP = squeeze(data.zProjection) .* 0;

    ChN = 1; % Current channel number
    
    if ~isempty(dataTable.CH1{k}) 
        zProjection(:,:,1) = mat2gray(data.zProjection(:,:,:,ChN));
        z_Projection(:,:,1) = imresize(zProjection(:,:,ChN), [(size(zProjection, 1) * data.scale.x), size(zProjection, 2) * data.scale.y]);
        crossAP(:,:,1) = mat2gray(data.crossAP(:,:,ChN));
        cross_AP(:,:,1) = imresize(crossAP(:,:,ChN), [(size(crossAP, 1) * data.scale.z), size(crossAP, 2) * data.scale.y]);
        crossDV(:,:,1) = mat2gray(data.crossDV(:,:,ChN));
        cross_DV(:,:,1) = imresize(crossDV(:,:,ChN), [size(crossDV, 1)* data.scale.z, size(crossDV, 2)*data.scale.y]);
        
        ChN = ChN + 1;
    end
    if ~isempty(dataTable.CH2{k})
        zProjection(:,:,2) = mat2gray(data.zProjection(:,:,:,ChN));
        z_Projection(:,:,2) = imresize(zProjection(:,:,2), [(size(zProjection, 1) * data.scale.x), size(zProjection, 2) * data.scale.y]);
        crossAP(:,:,2) = mat2gray(data.crossAP(:,:,ChN));
        cross_AP(:,:,2) = imresize(crossAP(:,:,2), [(size(crossAP, 1) * data.scale.z), size(crossAP, 2) * data.scale.y]);
        crossDV(:,:,2) = mat2gray(data.crossDV(:,:,ChN));
        cross_DV(:,:,2) = imresize(crossDV(:,:,2), [size(crossDV, 1)* data.scale.z, size(crossDV, 2)*data.scale.y]);
        
        ChN = ChN + 1;
    end
    if ~isempty(dataTable.CH3{k})
        zProjection(:,:,3) = mat2gray(data.zProjection(:,:,:,ChN));
        z_Projection(:,:,3) = imresize(zProjection(:,:,3), [(size(zProjection, 1) * data.scale.x), size(zProjection, 2) * data.scale.y]);
        crossAP(:,:,3) = mat2gray(data.crossAP(:,:,ChN));
        cross_AP(:,:,3) = imresize(crossAP(:,:,3), [(size(crossAP, 1) * data.scale.z), size(crossAP, 2) * data.scale.y]);
        crossDV(:,:,3) = mat2gray(data.crossDV(:,:,ChN));
        cross_DV(:,:,3) = imresize(crossDV(:,:,3), [size(crossDV, 1)* data.scale.z, size(crossDV, 2)*data.scale.y]);
        
        ChN = ChN + 1;
    end
    if ~isempty(dataTable.CH4{k})
        zProjection(:,:,4) = mat2gray(data.zProjection(:,:,:,ChN));
        z_Projection(:,:,4) = imresize(zProjection(:,:,4), [(size(zProjection, 1) * data.scale.x), size(zProjection, 2) * data.scale.y]);
        crossAP(:,:,4) = mat2gray(data.crossAP(:,:,ChN));
        cross_AP(:,:,4) = imresize(crossAP(:,:,4), [(size(crossAP, 1) * data.scale.z), size(crossAP, 2) * data.scale.y]); 
        crossDV(:,:,4) = mat2gray(data.crossDV(:,:,ChN));
        cross_DV(:,:,4) = imresize(crossDV(:,:,4), [size(crossDV, 1)* data.scale.z, size(crossDV, 2)*data.scale.y]);
    end
                
    figure('units','inches','InnerPosition',[22 0.5 8.5 11.5], 'OuterPosition',[21,0,9,12])
    clf
    set(gcf,'color','w')
    ptsAP = data.ptsAP * data.scale.x;
    ptsDV = data.ptsDV * data.scale.x;
    ptsPouch = data.ptsPouch * data.scale.x;
    
    n = size(data.zProjection,4); % number of channels imaged
    N = 1; % subplot number: will vary depending on the number of channels used
    Spac = 0.1/4; % Spacing of figures
    W = 0.9/4; % Width of figures 
    gap = W + Spac;
    
    if ~isempty(dataTable.CH1{k})
        subplot('Position',[0,1-W,W,W]);
        imshow(z_Projection(:,:,1))%,'XData', 0:25:175.43, 'YData', 0:.25:174.55)
        drawnow
        hold on
        plot(ptsAP(:,1),ptsAP(:,2), 'c-', 'LineWidth',0.2);
        plot(ptsDV(:,1),ptsDV(:,2), 'm-', 'LineWidth',0.2);
        plot(ptsAP(1,1),ptsAP(1,2), 'b.');
        plot(ptsDV(1,1),ptsDV(1,2), 'b.');
        plot(ptsPouch(1,[1:end,1]),ptsPouch(2,[1:end,1]),'r-', 'LineWidth',0.2);
               
        xlim = get(gca, 'xlim');      
        ylim = get(gca, 'ylim');
        text(xlim(1),ylim(1),dataTable.CH1{k},'FontSize',10,'Color','white','VerticalAlignment','top','HorizontalAlignment','left')
        xgap = 0.05 * (xlim(2) - xlim(1));
        ygap = 0.05 * (ylim(2) - ylim(1));
        x = [xlim(2)-50-xgap,xlim(2)-xgap];
        y = [ylim(2)-ygap, ylim(2)-ygap];
        plot(x,y, 'w-', 'LineWidth', 3)
        title(dataTable.Category{k},'position', [1,1],'HorizontalAlignment','left','FontSize',11)
        
        N = N + 1;
    end
    
    if ~isempty(dataTable.CH2{k})
        subplot('Position',[gap,1-W,W,W]);
        imshow(z_Projection(:,:,2))
        hold on
        plot(ptsAP(:,1),ptsAP(:,2), 'c-', 'LineWidth',0.2);
        plot(ptsDV(:,1),ptsDV(:,2), 'm-', 'LineWidth',0.2);
        plot(ptsAP(1,1),ptsAP(1,2), 'b.');
        plot(ptsDV(1,1),ptsDV(1,2), 'b.');
        plot(ptsPouch(1,[1:end,1]),ptsPouch(2,[1:end,1]),'r-', 'LineWidth',0.2);
        
        xlim = get(gca, 'xlim');
        ylim = get(gca, 'ylim');
        text(xlim(1),ylim(1),dataTable.CH2{k},'FontSize',10,'Color','white','VerticalAlignment','top','HorizontalAlignment','left')
        xgap = 0.05 * (xlim(2) - xlim(1));
        ygap = 0.05 * (ylim(2) - ylim(1));
        x = [xlim(2)-50-xgap,xlim(2)-xgap];
        y = [ylim(2)-ygap, ylim(2)-ygap];
        plot(x,y, 'w-', 'LineWidth', 3)
        
        N = N + 1;
    end
    
    if ~isempty(dataTable.CH3{k})
        subplot('Position',[2*gap,1-W,W,W]);
        imshow(z_Projection(:,:,3))
        hold on
        plot(ptsAP(:,1),ptsAP(:,2), 'c-', 'LineWidth',0.2);
        plot(ptsDV(:,1),ptsDV(:,2), 'm-', 'LineWidth',0.2);
        plot(ptsAP(1,1),ptsAP(1,2), 'b.');
        plot(ptsDV(1,1),ptsDV(1,2), 'b.');
        plot(ptsPouch(1,[1:end,1]),ptsPouch(2,[1:end,1]),'r-', 'LineWidth',0.2);
        
        xlim = get(gca, 'xlim');
        ylim = get(gca, 'ylim');
        text(xlim(1),ylim(1),dataTable.CH3{k},'FontSize',10,'Color','white','VerticalAlignment','top','HorizontalAlignment','left')
        xgap = 0.05 * (xlim(2) - xlim(1));
        ygap = 0.05 * (ylim(2) - ylim(1));
        x = [xlim(2)-50-xgap,xlim(2)-xgap];
        y = [ylim(2)-ygap, ylim(2)-ygap];
        plot(x,y, 'w-', 'LineWidth', 3)
        
        N = N + 1;
    end
    
    if ~isempty(dataTable.CH4{k})
        subplot('Position',[3*gap,1-W,W,W]);
        imshow(z_Projection(:,:,4))
        hold on
        plot(ptsAP(:,1),ptsAP(:,2), 'c-', 'LineWidth',0.2);
        plot(ptsDV(:,1),ptsDV(:,2), 'm-', 'LineWidth',0.2);
        plot(ptsAP(1,1),ptsAP(1,2), 'b.');
        plot(ptsDV(1,1),ptsDV(1,2), 'b.');
        plot(ptsPouch(1,[1:end,1]),ptsPouch(2,[1:end,1]),'r-', 'LineWidth',0.2);
        
        xlim = get(gca, 'xlim');
        ylim = get(gca, 'ylim');
        text(xlim(1),ylim(1),dataTable.CH4{k},'FontSize',10,'Color','white','VerticalAlignment','top','HorizontalAlignment','left')
        xgap = 0.05 * (xlim(2) - xlim(1));
        ygap = 0.05 * (ylim(2) - ylim(1));
        x = [xlim(2)-50-xgap,xlim(2)-xgap];
        y = [ylim(2)-ygap, ylim(2)-ygap];
        plot(x,y, 'w-', 'LineWidth', 3)

        N = N + 1;
    end
    
    if ~isempty(dataTable.CH1{k})
        subplot('Position',[0,1-W-gap,W,W]);
        imshow(z_Projection(:,:,1));
        hold on
        xlim = get(gca, 'xlim');
        ylim = get(gca, 'ylim');
        text(xlim(1),ylim(1),dataTable.CH1{k},'FontSize',10,'Color','white','VerticalAlignment','top','HorizontalAlignment','left')
        xgap = 0.05 * (xlim(2) - xlim(1));
        ygap = 0.05 * (ylim(2) - ylim(1));
        x = [xlim(2)-50-xgap,xlim(2)-xgap];
        y = [ylim(2)-ygap, ylim(2)-ygap];
        plot(x,y, 'w-', 'LineWidth', 3)

        N = N + 1;
    end

    if ~isempty(dataTable.CH2{k})
        subplot('Position',[gap,1-W-gap,W,W]);
        imshow(z_Projection(:,:,2))%,'XData', 0:25:175.43, 'YData', 0:.25:174.55)
        hold on
        xlim = get(gca, 'xlim');
        ylim = get(gca, 'ylim');
        text(xlim(1),ylim(1),dataTable.CH2{k},'FontSize',10,'Color','white','VerticalAlignment','top','HorizontalAlignment','left')
        xgap = 0.05 * (xlim(2) - xlim(1));
        ygap = 0.05 * (ylim(2) - ylim(1));
        x = [xlim(2)-50-xgap,xlim(2)-xgap];
        y = [ylim(2)-ygap, ylim(2)-ygap];
        plot(x,y, 'w-', 'LineWidth', 3)

        N = N + 1;
    end
    
    if ~isempty(dataTable.CH3{k})
        subplot('Position',[2*gap,1-W-gap,W,W]);
        imshow(z_Projection(:,:,3))%,'XData', 0:25:175.43, 'YData', 0:.25:174.55)
        hold on
        xlim = get(gca, 'xlim');
        ylim = get(gca, 'ylim');
        text(xlim(1),ylim(1),dataTable.CH3{k},'FontSize',10,'Color','white','VerticalAlignment','top','HorizontalAlignment','left')
        xgap = 0.05 * (xlim(2) - xlim(1));
        ygap = 0.05 * (ylim(2) - ylim(1));
        x = [xlim(2)-50-xgap,xlim(2)-xgap];
        y = [ylim(2)-ygap, ylim(2)-ygap];
        plot(x,y, 'w-', 'LineWidth', 3)

        N = N + 1;
    end
    
    if ~isempty(dataTable.CH4{k})
        subplot('Position',[3*gap,1-W-gap,W,W]);
        imshow(z_Projection(:,:,4))%,'XData', 0:25:175.43, 'YData', 0:.25:174.55)
        hold on
        xlim = get(gca, 'xlim');
        ylim = get(gca, 'ylim');
        text(xlim(1),ylim(1),dataTable.CH4{k},'FontSize',10,'Color','white','VerticalAlignment','top','HorizontalAlignment','left')
        xgap = 0.05 * (xlim(2) - xlim(1));
        ygap = 0.05 * (ylim(2) - ylim(1));
        x = [xlim(2)-50-xgap,xlim(2)-xgap];
        y = [ylim(2)-ygap, ylim(2)-ygap];
        plot(x,y, 'w-', 'LineWidth', 3)
        hold on
        N = N + 1;
    end
    
    if ~isempty(dataTable.CH1{k})
        subplot('Position',[0,1-W-2*gap,W,W]);
        imshow(cross_AP(:,:,1))
        hold on
        xlim = get(gca, 'xlim');
        ylim = get(gca, 'ylim');
        text(xlim(1),ylim(1),dataTable.CH1{k},'FontSize',10,'Color','white','VerticalAlignment','top','HorizontalAlignment','left')
        xgap = 0.05 * (xlim(2) - xlim(1));
        ygap = 0.05 * (ylim(2) - ylim(1));
        x = [xlim(2)-50-xgap,xlim(2)-xgap];
        y = [ylim(2)-ygap, ylim(2)-ygap];
        plot(x,y, 'w-', 'LineWidth', 3)
        title('AP bdry', 'FontSize', 12)

        N = N + 1;
    end
    
    if ~isempty(dataTable.CH2{k})
        subplot('Position',[1*gap,1-W-2*gap,W,W]);
        imshow(cross_AP(:,:,2))
        hold on
        xlim = get(gca, 'xlim');
        ylim = get(gca, 'ylim');
        text(xlim(1),ylim(1),dataTable.CH2{k},'FontSize',10,'Color','white','VerticalAlignment','top','HorizontalAlignment','left')
        xgap = 0.05 * (xlim(2) - xlim(1));
        ygap = 0.05 * (ylim(2) - ylim(1));
        x = [xlim(2)-50-xgap,xlim(2)-xgap];
        y = [ylim(2)-ygap, ylim(2)-ygap];
        plot(x,y, 'w-', 'LineWidth', 3)

        N = N + 1;
    end
    
    if ~isempty(dataTable.CH3{k})
        subplot('Position',[2*gap,1-W-2*gap,W,W]);
        imshow(cross_AP(:,:,3))
        hold on
        xlim = get(gca, 'xlim');
        ylim = get(gca, 'ylim');
        text(xlim(1),ylim(1),dataTable.CH3{k},'FontSize',10,'Color','white','VerticalAlignment','top','HorizontalAlignment','left')
        xgap = 0.05 * (xlim(2) - xlim(1));
        ygap = 0.05 * (ylim(2) - ylim(1));
        x = [xlim(2)-50-xgap,xlim(2)-xgap];
        y = [ylim(2)-ygap, ylim(2)-ygap];
        plot(x,y, 'w-', 'LineWidth', 3)

        N = N + 1;
    end
    
    if ~isempty(dataTable.CH4{k})
        subplot('Position',[3*gap,1-W-2*gap,W,W]);
        imshow(cross_AP(:,:,4))
        hold on
        xlim = get(gca, 'xlim');
        ylim = get(gca, 'ylim');
        text(xlim(1),ylim(1),dataTable.CH4{k},'FontSize',10,'Color','white','VerticalAlignment','top','HorizontalAlignment','left')
        xgap = 0.05 * (xlim(2) - xlim(1));
        ygap = 0.05 * (ylim(2) - ylim(1));
        x = [xlim(2)-50-xgap,xlim(2)-xgap];
        y = [ylim(2)-ygap, ylim(2)-ygap];
        plot(x,y, 'w-', 'LineWidth', 3)

        N = N + 1;
    end

    if ~isempty(dataTable.CH1{k})
        subplot('Position',[0*gap,1-W-3*gap,W,W]);
        imshow(cross_DV(:,:,1))
        hold on
        xlim = get(gca, 'xlim');
        ylim = get(gca, 'ylim');
        text(xlim(1),ylim(1),dataTable.CH1{k},'FontSize',10,'Color','white','VerticalAlignment','top','HorizontalAlignment','left')
        xgap = 0.05 * (xlim(2) - xlim(1));
        ygap = 0.05 * (ylim(2) - ylim(1));
        x = [xlim(2)-50-xgap,xlim(2)-xgap];
        y = [ylim(2)-ygap, ylim(2)-ygap];
        plot(x,y, 'w-', 'LineWidth', 3)
        title('DV bdry', 'FontSize', 12)
        N = N + 1;
    end
    
    if ~isempty(dataTable.CH2{k})
        subplot('Position',[1*gap,1-W-3*gap,W,W]);
        imshow(cross_DV(:,:,2))
        hold on
        xlim = get(gca, 'xlim');
        ylim = get(gca, 'ylim');
        text(xlim(1),ylim(1),dataTable.CH2{k},'FontSize',10,'Color','white','VerticalAlignment','top','HorizontalAlignment','left')
        xgap = 0.05 * (xlim(2) - xlim(1));
        ygap = 0.05 * (ylim(2) - ylim(1));
        x = [xlim(2)-50-xgap,xlim(2)-xgap];
        y = [ylim(2)-ygap, ylim(2)-ygap];
        plot(x,y, 'w-', 'LineWidth', 3)

        N = N + 1;
    end
    
    if ~isempty(dataTable.CH3{k})
        subplot('Position',[2*gap,1-W-3*gap,W,W]);
        imshow(cross_DV(:,:,3))
        hold on
        xlim = get(gca, 'xlim');
        ylim = get(gca, 'ylim');
        text(xlim(1),ylim(1),dataTable.CH3{k},'FontSize',10,'Color','white','VerticalAlignment','top','HorizontalAlignment','left')
        xgap = 0.05 * (xlim(2) - xlim(1));
        ygap = 0.05 * (ylim(2) - ylim(1));
        x = [xlim(2)-50-xgap,xlim(2)-xgap];
        y = [ylim(2)-ygap, ylim(2)-ygap];
        plot(x,y, 'w-', 'LineWidth', 3)

        N = N + 1;
    end
    
    if ~isempty(dataTable.CH4{k})
        subplot('Position',[3*gap,1-W-3*gap,W,W]);
        imshow(cross_DV(:,:,4))
        hold on
        xlim = get(gca, 'xlim');
        ylim = get(gca, 'ylim');
        text(xlim(1),ylim(1),dataTable.CH4{k},'FontSize',10,'Color','white','VerticalAlignment','top','HorizontalAlignment','left')
        xgap = 0.05 * (xlim(2) - xlim(1));
        ygap = 0.05 * (ylim(2) - ylim(1));
        x = [xlim(2)-50-xgap,xlim(2)-xgap];
        y = [ylim(2)-ygap, ylim(2)-ygap];
        plot(x,y, 'w-', 'LineWidth', 3)
    end

    export_fig(filename);
    if exist(filenamepdf, 'file')
        export_fig(filenamepdf, '-append')
    else
        export_fig(filenamepdf);
    end
end
