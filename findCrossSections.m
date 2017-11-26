function [crossections, pt] = findCrossSections(ptsAxis,hyperstack,pouchPoly)
segAPx = ptsAxis(1,:);
segAPy = ptsAxis(2,:);
apLength = arclength(segAPx,segAPy);
tmp = (segAPx*1000+segAPy)';
u=unique(tmp);
n=histc(tmp,u);
duplicates = find(n>1);
for i = length(duplicates):-1:1
    toRemove = round(segAPx) == round(u(duplicates(i))/1000) & ...
        round(segAPy) == round(u(duplicates(i)) - 1000 * floor(u(duplicates(i))/1000));
    segAPx(toRemove)=[];
    segAPy(toRemove)=[];
    warning('probably broken')
end
pt = interparc(linspace(0,1,round(apLength)),segAPx,segAPy);
idx = ~inpolygon(pt(:,1), pt(:,2), pouchPoly(1,:), pouchPoly(2,:));
pt(idx,:) = [];

%% Interpolate orthogonal section through AP axis
Z = size(hyperstack, 3);
C = size(hyperstack, 4); 

Xs = repmat(pt(:,1), [1, Z]);
Ys = repmat(pt(:,2), [1, Z]);
Zs = repmat(1:Z, [size(pt,1), 1]);

pt = pt';
%pt = pt(:,end:-1:1);

for i = 1:C
    crossections(:,:,i) = interp3(squeeze(double(hyperstack(:,:,:,i))),Xs,Ys,Zs)';
end
%crossections = fliplr(crossections);