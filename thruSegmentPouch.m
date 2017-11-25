% The user manually identifies the boundaries of the pouch and the
% positions of the A/P and D/V axis. This is skipped for pouches that have
% already been processed.

function thruSegmentPouch(dataTable, settings)
% Loop over all of the selected datafiles
for i = 1:(size(dataTable, 1))%%randperm(size(dataTable, 1))
    dataTable.Label{i}
    CurrentFile = strcat(dataTable.Path{i},'\',dataTable.Label{i});
    % Skip the analysis if processing has already occurred
    if strcmp(settings.crossType, 'Developmental')
    alreadyExists = matFileExists(CurrentFile, {'ptsPouch','ptsAP','ptsDV'});
    else
        alreadyExists = matFileExists(CurrentFile, {'ptsPouch'});
    end
    if alreadyExists && ~settings.force
        continue
    end
    
    % Segment pouch mask
    clearvars zProjection
    data = load(strcat(CurrentFile,'.mat'), 'zProjection', 'scale');
    if size(data.zProjection, 4) == 3
        channels = [2,2];
    else
        channels = [1,2];
    end
    composite = imfuse(data.zProjection(:,:,:,channels(1)), data.zProjection(:,:,:,channels(2)));
    for q = 1:size(data.zProjection, 4)
        zProjection(:,:,q) = mat2gray(data.zProjection(:,:,:,q));
    end
    
    flag = 2;
    figure(1); clf; 
    q = 1;
    while (flag == 2  || flag == 3)  
        if q <= size(data.zProjection, 4)
            imshow(zProjection(:,:,q));
        else
            imshow(composite);
        end
        if flag == 3 
            hold on
            plot(ptsPouch(1,:), ptsPouch(2,:), 'c', 'LineWidth',2)
        end
        title('Drag an outline around the pouch. "s" > skip, "n" > accept, "r" > reset, "c" > channel.')
        if flag == 2
            hPouch = imfreehand;
            ptsPouch = hPouch.getPosition';
        end
        flag = confirm(strcat(CurrentFile,'.mat')); % this is where you left off (11/24/17)
        if flag == 3
            if q <= size(data.zProjection, 4)
                q = q+1;
            else
                q = 1;
            end
        end
    end
    if flag == 1
        continue
    end
    
   save(strcat(CurrentFile,'.mat'), 'ptsPouch','-append');
    
    if strcmp(settings.crossType, 'Developmental')
    % Segment A/P axis
    flag = 2;
    q = 1;
    while (flag == 2  || flag == 3)
        if q <= size(data.zProjection, 4)
            imshow(zProjection(:,:,q));
        else
            imshow(composite);
        end
        if flag == 3 
            hold on
            plot(ptsAP(:,1), ptsAP(:,2), 'r', 'LineWidth',2)
        end
        hold on
        plot(ptsPouch(1,:), ptsPouch(2,:), 'c', 'LineWidth',2)
        title('Drag a line across the AP boundary. "s" > skip, "n" > accept, "r" > reset, "c" > channel.')
        if flag == 2
            freehand = imfreehand('Closed',false);
            ptsAP = freehand.getPosition;
        end
        flag = confirm(strcat(CurrentFile,'.mat'));
        if flag == 3
            if q <= size(data.zProjection, 4)
                q = q+1;
            else
                q = 1;
            end   
        end
    end
    if flag == 1
        continue
    end
    IN = inpolygon(ptsAP(:,1),ptsAP(:,2),ptsPouch(1,:),ptsPouch(2,:));
    ptsAP(~IN,:) = [];
    
    % Segment D/V axis
    flag = 2;
    q = 1;
    while (flag == 2  || flag == 3)
        if q <= size(data.zProjection, 4)
            imshow(zProjection(:,:,q));
        else
            imshow(composite);
        end
        if flag == 3 
            hold on
            plot(ptsDV(:,1), ptsDV(:,2), 'm', 'LineWidth',2)
        end
        hold on
        plot(ptsPouch(1,:), ptsPouch(2,:), 'c', 'LineWidth',2)
        plot(ptsAP(:,1), ptsAP(:,2), 'r', 'LineWidth',2)
        title('Drag a line across the DV boundary. "s" > skip, "n" > accept, "r" > reset, "c" > channel.')
        if flag == 2
            freehand = imfreehand('Closed',false);
            ptsDV = freehand.getPosition;
        end
        flag = confirm(strcat(CurrentFile,'.mat'));
        if flag == 3
            if q <= size(data.zProjection, 4)
                q = q+1;
            else
                q = 1;
            end
        end
    end
    if flag == 1
        continue
    end
    IN = inpolygon(ptsDV(:,1),ptsDV(:,2),ptsPouch(1,:),ptsPouch(2,:));
    ptsDV(~IN,:) = [];
    
   save(strcat(CurrentFile,'.mat'), 'ptsAP','ptsDV','-append');
    end
    
    
end
end

function stoploop = confirm(path)
stoploop = 0;
currkey = 0;
while currkey==0
    pause; % wait for a keypress
    currkey=get(gcf,'CurrentKey');
    if strcmp(currkey, 'n') % You also want to use strcmp here.
        currkey = 1;
    elseif strcmp(currkey, 's')
        currkey = 2;
    elseif strcmp(currkey, 'c')
        currkey = 4;
    elseif strcmp(currkey, 'r')
        currkey = 3;
    else
        currkey = 3;
    end
end
if currkey == 2
    flag = 0;
    save(path, 'flag','-append');
    stoploop = 1;
end
if currkey == 3
    stoploop = 2;
end
if currkey == 4
    stoploop = 3;
end
end