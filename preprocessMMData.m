function pathList = preprocessMMData
clearvars
close all
settings = prepareWorkspace;
settings.force = true;

%list = dir(['D:/wingdischeights' '/**/Raw Data/**/*.nd']);
list = dir(['D:/imaging/Staining' '/**/raw data/**/*.nd']);
pathList = {};
j = 1;
for i = 1:length(list)
    inPath = [list(i).folder filesep list(i).name];
    
    
    outPath = strrep(inPath,'Raw Data','Hyperstack');
    outPath = strrep(outPath, '.nd', '');
    
    if ~settings.force && matFileExists([outPath '.mat'], {'hyperstack', 'scale', 'zProjection'})
        pathList{j} = [outPath '.mat'];
        j = j + 1;
        continue
    end
    
    data = bfopen(inPath);
    S = size(data, 1);
    
    for s = 1:S
        if S == 1
            outPathStage = [outPath '.mat'];
        else
            outPathStage = [outPath '_s' num2str(s) '.mat'];
        end
        
        if ~settings.force && matFileExists(outPathStage, {'hyperstack', 'scale', 'zProjection'})
            j = j + 1;
            continue
        end
        
        [hyperstack, scale] = assembleHyperstack(data(s,:));
        zProjection = max(hyperstack, [], 3);
        
        mkdir(fileparts(outPathStage))
%         save(outPathStage, 'hyperstack', 'scale', 'zProjection')
        
        pathList{j} = outPathStage;
        j = j + 1;
    end
end

end

function [hyperstack, scale] = assembleHyperstack(data)

omeMeta = data{1, 4};
X = omeMeta.getPixelsSizeX(0).getValue(); % image width, pixels
Y = omeMeta.getPixelsSizeY(0).getValue(); % image height, pixels
Z = omeMeta.getPixelsSizeZ(0).getValue(); % number of Z slices
C = omeMeta.getPixelsSizeC(0).getValue(); % number of Z slices

originalMeta = data{1,2};

hyperstack = zeros(X, Y, Z, C, 'uint16');

j = 1;
for c = 1:C
    for z = 1:Z
        hyperstack(:,:,z,c) = data{1}{j};
        j = j + 1;
    end
end

scale.x = omeMeta.getPixelsPhysicalSizeX(0).value();
scale.y = omeMeta.getPixelsPhysicalSizeY(0).value();
scale.z = str2double(originalMeta.get('Global ZStepSize'));

end