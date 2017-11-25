%% Initialization
clearvars
close all

settings = prepareWorkspace;
dataTable = getLabels(settings);
category = categorical(dataTable.Category);

% up to here everything works (DO NOT CHANGE Previous code)

%  keep = category==categorical({'ms1096-RyR-RNAi'}) | ...%%%%%%%%%%%%%%    
%     category==categorical({'ms1096-plc21c-RNAi'}) | ...%;%%%%%%%%%%%%%%%%
%     category==categorical({'ms1096-IP3R RNAi phospho myosin II'}) | ...
%     category==categorical({'ms1096-SERCA RNAi phospho Myosin II'});
% % keep([4,21,22,26,28:40,42]) = 0;
% % % keep = logical(keep * 0);
% % % keep([1:5]) = 1;
% % dataTable([1,9,12,16,20,23,25,28,30],:) = [];%16,20,30
% dataTable = dataTable(keep,:); %%%%%%%%%%%%%%%%%%
% 
% %dataTable = dataTable([end],:);
% %dataTable = dataTable([1],:);%5,7,10,11,17,19,29
% 
% % good ones
% dataTable = dataTable([1,2,6,7,9,23,(25:41),43,(46:49),(52:56),(58:61),(63:64)], :);
% %%dataTable([1,20,23,24,30,32,34,38],:) = []; % 23, 24, 30, 34, & ... did not work
% %dataTable = dataTable([20,23,24,30,33], :);
% % % dataTable = dataTable([2,7,14,23,25,26,28,30,31,32,36,37,38,40,41,42], :);
% % % dataTable = dataTable([1,3,5,6,8,12,14,15,16], :);
% % % dataTable([25,26,40],:) = [];

settings.xyN = 500;
settings.force = true;
settings.crossType = 'Developmental';
% dataTable = dataTable(round(rand(1) * 100),:);

%% Semiautomated data processing
warning('Data must be converted into .mat files for this to work')
thruSegmentPouch(dataTable, settings); % manual segmentation of axes and pouch
thruMakeSlices(dataTable, settings); % automatically make orthogonal projections
% thruSegmentCrossection(dataTable, settings); % manual segmentation of cross sections
% thruDrawLines(dataTable, settings); % manual determination of cross section orientation
% thruAnalyzeCuts(dataTable, settings); % automatic extraction of height profiles
% defineIntersection(dataTable, settings); % manual determination of AP & DV intersection
getOrganizedProjections(dataTable, settings); % automatic compilation of high resolution z-stacks & orthogonal projections
% updateAxis(dataTable, settings)
% exportAPDV(dataTable, settings) % automatic generation of data sheets
% %getProjections(dataTable, settings)
%% Visualization
%%heightAP = nan(499,size(dataTable,1));
% % % heightDV = nan(499,size(dataTable,1));
% % % xy_positionAP = nan(499,size(dataTable,1));
% % % xy_positionDV = nan(499,size(dataTable,1));
% % % 
% % % for i = 1:size(dataTable,1)
% % % data = load(dataTable.Path{i},'finalPoints','heightAP','heightDV','xy_positionAP_pixels','xy_positionDV_pixels','scale','pAP','pDV');
% % % %data = load(dataTable.Path{i},'Centroid','finalPointsMajorMinor','heightMinor','heightMajor','xy_positionMinor_pixels','xy_positionMajor_pixels','scale');
% % % 
% % % % data.heightAP = data.heightMinor;
% % % % data.heightDV = data.heightMajor;
% % % % data.xy_positionAP_pixels = data.xy_positionMinor_pixels;
% % % % data.xy_positionDV_pixels = data.xy_positionMajor_pixels;
% % % 
% % % % figure(1); clf;
% % % heightAP(1:499,i) = data.heightAP(1:499) * data.scale.x;
% % % xy_positionAP(1:499,i) = data.xy_positionAP_pixels(1:499) * data.scale.x;
% % % % 
% % % % plot(xy_positionAP, heightAP)
% % % % xlabel('Distance from DV boundary (\mum)')
% % % % ylabel('Thickness (\mum)')
% % % % ylim([0,80])
% % % % 
% % % % figure(2); clf;
% % % heightDV(1:499,i) = data.heightDV(1:499) * data.scale.x;
% % % xy_positionDV(1:499,i) = data.xy_positionDV_pixels(1:499) * data.scale.x;
% % % % 
% % % % plot(xy_positionDV, heightDV)
% % % % xlabel('Distance from AP boundary (\mum)')
% % % % ylabel('Thickness (\mum)')
% % % % ylim([0,80])
% % % 
% % % %data = load(dataTable.Path{i},'finalPoints','heightAP','heightDV','xy_positionAP_pixels','xy_positionDV_pixels','scale');
% % % % % figure(1); clf;
% % % % % plot([(data.finalPoints.AP1(:,1) - data.pAP(1))*data.scale.y, (data.finalPoints.AP2(:,1) - data.pAP(1))*data.scale.y]',[data.finalPoints.AP1(:,2)*data.scale.y, data.finalPoints.AP2(:,2)*data.scale.y]');
% % % % % axis([-inf,inf,0,120])
% % % % % set(gca,'YDir','reverse')
% % % % % title(['AP ', dataTable.Label{i}])
% % % % % xlabel('AP (\mum)')
% % % % % ylabel('z (\mum)')
% % % % % axis equal
% % % % %     filename = ['D:/Documents/Matlab Figures2/APlines_' dataTable.Label{i} '.png'];
% % % % %     saveas(figure(1),filename)
% % % % %     
% % % % % figure(2); clf;
% % % % % plot([(data.finalPoints.DV1(:,1) - data.pDV(1))*data.scale.y, (data.finalPoints.DV2(:,1) - data.pDV(1))*data.scale.y]',[data.finalPoints.DV1(:,2)*data.scale.y, data.finalPoints.DV2(:,2)*data.scale.y]');
% % % % % axis([-inf,inf,0,120])
% % % % % set(gca,'YDir','reverse')
% % % % % title(['DV ', dataTable.Label{i}])
% % % % % xlabel('DV (\mum)')
% % % % % ylabel('z (\mum)')
% % % % % axis equal
% % % % %     filename = ['D:/Documents/Matlab Figures2/DVlines_' dataTable.Label{i} '.png'];
% % % % %     saveas(figure(2),filename)
% % % end
% % % %% More figures
% % % % %close all
% % % % toRemove = [];
% % % % for i = 1:size(dataTable,1)
% % % %     alreadyExists = matFileExists(dataTable.Path{i}, {'poop'});
% % % %     if alreadyExists && ~settings.force
% % % %         toRemove(end+1) = i;
% % % %     end
% % % % %     data = load(dataTable.Path{i},'ptsPouch','scale');
% % % % %     pouchMask = poly2mask(data.ptsPouch(1,:),data.ptsPouch(2,:),512,512);
% % % % %     pouchSize = (sum(pouchMask(:))) / data.scale.x / data.scale.y;
% % % % %     if ~(pouchSize>7e5&&pouchSize<10e5)
% % % % %         toRemove(end+1) = i;
% % % % %     end
% % % % end
% % % % dataTable(toRemove,:) = [];
% % % % 
% % % % heightAP = nan(499,size(dataTable,1));
% % % % heightDV = nan(499,size(dataTable,1));
% % % % xy_positionAP = nan(499,size(dataTable,1));
% % % % xy_positionDV = nan(499,size(dataTable,1));
% % % % 
% % % for i = 1:size(dataTable,1)
% % %     data = load(dataTable.Path{i},'finalPoints','heightAP','heightDV','xy_positionAP_pixels','xy_positionDV_pixels','scale');
% % % %    %data = load(dataTable.Path{i},'ptsPouch','Centroid','finalPoints','heightAP','heightDV','xy_positionAP_pixels','xy_positionDV_pixels','scale');
% % % %     
% % % %     %data.heightAP = data.heightMinor;
% % % %     %data.heightDV = data.heightMajor;
% % % %     %data.xy_positionAP_pixels = data.xy_positionMinor_pixels;
% % % %     %data.xy_positionDV_pixels = data.xy_positionMajor_pixels;
% % % %     
% % %     heightAP(1:499,i) = data.heightAP(1:499) * data.scale.x;
% % %     xy_positionAP(1:499,i) = data.xy_positionAP_pixels(1:499) * data.scale.x;
% % %     
% % %     heightDV(1:499,i) = data.heightDV(1:499) * data.scale.x;
% % %     xy_positionDV(1:499,i) = data.xy_positionDV_pixels(1:499) * data.scale.x;
% % % end
% % % % 
% % % % % % category = categorical(dataTable.Category);
% % % % % % catList = unique(category);
% % % 
% % % colorList = {'k-','k--','r-'};
% % % % 
% % % % % Figures for individual thicknesses
% % % % figure(3)
% % % % for i = 1:length(catList)
% % % %     plot(xy_positionAP(:,category==catList(i)),heightAP(:,category==catList(i)),colorList{i})
% % % %     hold on
% % % % end
% % % % 
% % % % xlabel('Position (\mum)')
% % % % ylabel('Thickness (\mum)')
% % % % axis([-inf,inf,0,80])
% % % % legend(cellstr(catList)')
% % % % title('AP thickness')
% % % % axis equal
% % % %     filename = ['D:/Documents/Matlab Figures2/APheight_' dataTable.Label{i} '.png'];
% % % %     saveas(figure(3),filename)
% % % % 
% % % % figure(4)
% % % % for i = 1:length(catList)
% % % %     plot(xy_positionDV(:,category==catList(i)),heightDV(:,category==catList(i)),colorList{i})
% % % %     hold on
% % % % end
% % % % 
% % % % xlabel('Position (\mum)')
% % % % ylabel('Thickness (\mum)')
% % % % axis([-inf,inf,0,80])
% % % % legend(cellstr(catList)')
% % % % title('DV thickness')
% % % % axis equal
% % % %     filename = ['D:/Documents/Matlab Figures2/DVheight_' dataTable.Label{i} '.png'];
% % % %     saveas(figure(4),filename)
% % % % %% Figures for Average Thicknesses
% % % figure
% % % axisLimits = [nanmin(xy_positionAP(:)), nanmax(xy_positionAP(:))];
% % % x_new_AP = linspace(axisLimits(1),axisLimits(2),5000);
% % % for i = 1%:length(category)
% % %     height_new(:,i) = interp1(xy_positionAP(:,i),heightAP(:,i),x_new_AP, 'linear');
% % %     oldRange = [min(xy_positionAP(:,i)),max(xy_positionAP(:,i))];
% % %     leftRemove = round((oldRange(1) - axisLimits(1)) / 5000);
% % %     rightRemove = round((-oldRange(2) + axisLimits(2)) / 5000);
% % %     height_new([1:leftRemove,end-rightRemove:end],i) = NaN;
% % % end
% % % 
% % % style(1).col = {[0,0,0]};
% % % style(2).col = {[1,0,0]};
% % % style(3).col = {[1,0,0]};
% % % style(1).style = '-';
% % % style(2).style = '--';
% % % style(3).style = '-';
% % % style(1).width = 1;
% % % style(2).width = 1;
% % % style(3).width = 1;
% % % for i = 1%,2]%
% % %     height_new_cat = nanmean(height_new(:,category==catList(i)),2);
% % %     height_new_cat_std = nanstd(height_new(:,category==catList(i)),[],2);
% % %     n = sum(~isnan(height_new(:,category==catList(i))),2);
% % % %     height_new_cat(n<4,category==catList(i)) = nan;
% % % %     plot(x_new,height_new_cat,colorList{i})
% % %     mseb(x_new_AP,height_new_cat',height_new_cat_std',style(i),1);
% % %     hold on
% % % end
% % % 
% % % xlabel('Distance centroid (\mum)')
% % % ylabel('Thickness (\mum)')
% % % axis([-80,80,0,80])
% % % legend(cellstr(catList([1]))')%,2
% % % title('Average Thickness, AP view')
% % % 
% % % figure
% % % axisLimits = [nanmin(xy_positionDV(:)), nanmax(xy_positionDV(:))];
% % % x_new_DV = linspace(axisLimits(1),axisLimits(2),5000);
% % % anteriorID = find(x_new_DV > 0);
% % % posteriorID = find(x_new_DV < 0);
% % % for i = 1:length(category)
% % %     height_new(:,i) = interp1(xy_positionDV(:,i),heightDV(:,i),x_new_DV, 'linear');
% % %     oldRange = [min(xy_positionDV(:,i)),max(xy_positionDV(:,i))];
% % %     leftRemove = round((oldRange(1) - axisLimits(1)) / 5000);
% % %     rightRemove = round((-oldRange(2) + axisLimits(2)) / 5000);
% % %     height_new([1:leftRemove,end-rightRemove:end],i) = NaN;
% % % end
% % % 
% % % style(1).col = {[0,0,0]};
% % % style(2).col = {[1,0,0]};
% % % style(3).col = {[1,0,0]};
% % % style(1).style = '-';
% % % style(2).style = '--';
% % % style(3).style = '-';
% % % style(1).width = 1;
% % % style(2).width = 1;
% % % style(3).width = 1;
% % % for i = 1%,2]%
% % %     height_new_cat = nanmean(height_new(:,category==catList(i)),2);
% % %     height_new_cat_std = nanstd(height_new(:,category==catList(i)),[],2);
% % %     n = sum(~isnan(height_new(:,category==catList(i))),2);
% % % %     height_new_cat(n<4,category==catList(i)) = nan;
% % % %     plot(x_new,height_new_cat,colorList{i})
% % %     mseb(x_new_DV,height_new_cat',height_new_cat_std',style(i),1);
% % % %     mseb(-1 * x_new_DV(anteriorID),height_new_cat(anteriorID)',height_new_cat_std(anteriorID)',style(1),1);
% % % %     hold on
% % % %     mseb(x_new_DV(posteriorID),height_new_cat(posteriorID)',height_new_cat_std(posteriorID)',style(2),1);
% % % end
% % % 
% % % xlabel('Distance centroid (\mum)')
% % % ylabel('Thickness (\mum)')
% % % axis([-80,80,0,80])
% % % %legend(cellstr(catList([1,2]))')
% % % legend('anterior', 'posterior')
% % % %title('Average Thickness, DV view')
% % % title('nub-gcamp Anterior vs Posterior, DV view')
% % % %% Export Data
% % % mkdir(settings.outRough);