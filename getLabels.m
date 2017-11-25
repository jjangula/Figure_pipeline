function dataTable = getLabels(settings)
if nargin < 1
    settings = getSettings;
end

dataTable = readtable(settings.labelTabel);