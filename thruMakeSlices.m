% Orthogonal slices are made along the A/P and D/V axes within the pouch. 
% This is skipped for pouches that have already been processed.

function thruMakeSlices(dataTable, settings)

% Loop over all of the selected datafiles
for i = 1:size(dataTable, 1)
    i
    CurrentFile = strcat(dataTable.Path{i},'\',dataTable.Label{i});
    % Skip the analysis if processing has already occurred
    if strcmp(settings.crossType, 'Developmental')
    alreadyExists = matFileExists(CurrentFile, {'crossAP','crossDV','AP0','DV0','crossLong','crossShort','coordLong','coordShort','Centroid'});
    else
    alreadyExists = matFileExists(CurrentFile, {'crossLong','crossShort','coordLong','coordShort','Centroid'});
    end
    if alreadyExists && ~settings.force
        continue
    end
    
    disp(['Processing ' dataTable.Label{i}])
    data = load(strcat(CurrentFile,'.mat'), 'ptsPouch', 'ptsAP','ptsDV','hyperstack');
    
    % Obtain relevant axes region
    pouchMask = poly2mask(data.ptsPouch(1,:),data.ptsPouch(2,:),size(data.hyperstack,1),size(data.hyperstack,2));
    pouchRange = imdilate(pouchMask, strel('disk', settings.pouchRange));
    pouchPoly = mask2poly(pouchRange, 'Exact', 'MINDIST');
    pouchPoly(1,:) = [];
    
    IAP = find(data.ptsAP(:,1) == 0);
    IDV = find(data.ptsDV(:,1) == 0);
    
    data.ptsAP(IAP, :) = [];
    data.ptsDV(IDV, :) = [];
    
    % Obtain cross section of AP and DV compartment boundary
    if strcmp(settings.crossType, 'Developmental')
    [crossAP, ptAP] = findCrossSections(data.ptsAP',data.hyperstack,pouchPoly');
    [crossDV, ptDV] = findCrossSections(data.ptsDV',data.hyperstack,pouchPoly');
    
   
    % Determine axes intersection to be set to 0 um
    p = InterX(ptAP, ptDV)';
    [~, ~, AP_fract] = distance2curve(ptAP',p,'spline');
    AP0 = round(AP_fract * size(ptAP,2));
    [~, ~, DV_fract] = distance2curve(ptDV',p,'spline');
    DV0 = round(DV_fract * size(ptDV,2));
     
    [IDX,~] = knnsearch(data.ptsAP,p,'K',2);
    IDX = unique(IDX,'rows');
    ptsAP = zeros(size(data.ptsAP,1)+1,size(data.ptsAP,2));
    ptsAP(max(IDX)+1:end,:) = data.ptsAP(max(IDX):end,:);
    ptsAP(1:min(IDX),:) = data.ptsAP(1:min(IDX),:);
    ptsAP(max(unique(max(IDX))),:) = p(1,:);
    
    midAP = max(unique(max(IDX)));
    
    [IDX,~] = knnsearch(data.ptsDV,p,'K',2);
    IDX = unique(IDX,'rows');
    ptsDV = zeros(size(data.ptsDV,1)+1,size(data.ptsDV,2));
    ptsDV(max(IDX)+1:end,:) = data.ptsDV(max(IDX):end,:);
    ptsDV(1:min(IDX),:) = data.ptsDV(1:min(IDX),:);
    ptsDV(max(unique(max(IDX))),:) = p(1,:);
    
    midDV = max(unique(max(IDX)));
     save(strcat(CurrentFile,'.mat'), 'crossAP','crossDV','AP0','DV0','DV0','midAP','midDV','ptsAP','ptsDV','-append');
    end
    % Obtain cross section of long and short axis
    stats = regionprops(pouchMask, 'Centroid', 'Orientation');
    dx = cosd(stats.Orientation); dy = -sind(stats.Orientation);
    lineLong = [stats.Centroid'+([-[dx;dy]*1000,[dx;dy]*1000])];
    lineShort = [stats.Centroid'+([-[-dy;dx]*1000,[-dy;dx]*1000])];
    [crossLong, coordLong] = findCrossSections(lineLong,data.hyperstack,pouchPoly');
    [crossShort, coordShort] = findCrossSections(lineShort,data.hyperstack,pouchPoly');    
    Centroid = stats.Centroid;
    
    save(strcat(CurrentFile,'.mat'), 'crossLong','crossShort','coordLong','coordShort','Centroid','-append')
   
end


