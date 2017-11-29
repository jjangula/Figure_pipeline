%% Initialization
clearvars
close all

settings = prepareWorkspace;
dataTable = getLabels(settings);
category = categorical(dataTable.Category);
dataTable = dataTable(16:23,:);

settings.xyN = 500;
settings.force = true;
settings.crossType = 'Developmental';

%% Semiautomated data processing
warning('Data must be converted into .mat files for this to work')
% thruSegmentPouch(dataTable, settings); % manual segmentation of axes and pouch
% thruMakeSlices(dataTable, settings); % automatically make orthogonal projections
exportAPDV(dataTable, settings) % automatic generation of data sheets