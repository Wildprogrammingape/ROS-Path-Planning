function n = neighbours3d(node, resolution)
% ===============================================================
% neighbours3d(node, resolution)
% Returns all neighouring points for a node(x,y,z)
% The neighours are a 3x3x3 box with node(x,y,z) at the center
% The distance is specified by resolution
%
% Output: a list of all neighbouring points
% ===============================================================

X = node(1)-resolution:resolution:node(1)+resolution;
Y = node(2)-resolution:resolution:node(2)+resolution;
Z = node(3)-resolution:resolution:node(3)+resolution;

[X,Y,Z] = meshgrid(X,Y,Z);
npoints = prod(size(X));
n = [reshape(X,[npoints,1]), reshape(Y,[npoints,1]), reshape(Z,[npoints,1])];

n(14,:) = [];
end