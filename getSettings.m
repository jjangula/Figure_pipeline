% This function creates the settings structure used in the rest of the
% analysis tools. This makes it easier to keep track of all of the input
% and output files, as well as throughput data that is generated once and
% used many times.

function settings = getSettings()
%% Get root directories
[activeDir, ~, ~] = fileparts(mfilename('fullpath'));
settings.activeDir = [activeDir filesep];
settings.rootData = [activeDir filesep 'Analysis' filesep];
settings.output = [activeDir filesep 'Output' filesep];

%% Get input directories
settings.inExperimentalData = [settings.activeDir 'Data' filesep];
settings.inTables = [settings.activeDir 'inputs' filesep];
settings.labelTabel = [settings.inTables 'labels.xlsx'];%labelTable.xlsx

%% Get output directories
settings.outRough = settings.output;

%% Get dependency directories
settings.depExt = [settings.activeDir 'Dependencies' filesep];
settings.depInt = [settings.activeDir 'Modules' filesep];

%% Add dependancy folders to path
addpath(genpath(settings.depExt))
addpath(genpath(settings.depInt))

%% Generate unique identifier for analysis
currentTime = now();
timeString = datestr(currentTime);
settings.uniqueIdentifier = strrep(timeString,':','-');

%% Set analysis settings
settings.force = false;
settings.pouchRange = 20; % range outside of pouch to segment in pixels

end