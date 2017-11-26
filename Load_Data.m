clearvars
table = readtable('ms1096_Table.xlsx');
table = table(5,:);
paths = table.Path;
x = 0.3425;
y = 0.3409;
z = 1;
clear scale

for i = [1]%length(paths):-1:1
    scale.x = x;
    scale.y = y;
    scale.z = 0.2;
    data = load(paths{i}, 'scale');
save(paths{i}, 'scale','-append');
%     scale(i) = data.scale;
    
end

%load('SERCA_Table.xlsx');
