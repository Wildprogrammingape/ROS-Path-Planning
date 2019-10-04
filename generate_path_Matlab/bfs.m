clear all
close all

filename = 'exampleflyaround.world';


% extra distance from the size of objects
extradistance = [0.7 0.7 0.7];

% start and goal positions
start = [1 1 1];
goal = [3 8 2];

% Search Space Setup
searchdims = [1, 6;    
              1, 8;
              1, 4];

models = loadworld(filename);


figure(1)
hold on
% draw all the boxes 
for i = 1:size(models,2)  
     box = models (i);
     if strcmp(box.name,'ground_plane')
        continue
     end  
     draw3dRect(box.position,box.size,box.orientation)
end

hold off


spaceresolution = 0.25;

X = searchdims(1,1):spaceresolution:searchdims(1,2);
Y = searchdims(2,1):spaceresolution:searchdims(2,2);
Z = searchdims(3,1):spaceresolution:searchdims(3,2);

[X,Y,Z] = meshgrid(X,Y,Z);
npoints = prod(size(X));
space = [reshape(X,[npoints,1]), reshape(Y,[npoints,1]), reshape(Z,[npoints,1])];

% this is a map that will later be breadth first filled
spacemap = containers.Map;

% this is the heuristic map for guiding A*
%heuristicmap = containers.Map;



figure(2)
hold on

% setup the boundaries for the search space
for i=1:size(space,1)
    
    point = space(i,:);
    pointstr = sprintf('%.2f %.2f %.2f', point);
    
    spacemap(pointstr) = 0;
    
    %heuristicmap(pointstr) = 0.5*sqrt(sum((point - goal).^2));
    
    for m=1:size(models,2)

      if strcmp(models(m).name,'ground_plane')
        continue
      end
    
        box = models(m);
        distance = point - box.position;
        rotm =  eul2rotm(flip(box.orientation));
        distance = abs((rotm'*distance')');
    
        if sum((distance - box.size/2 - extradistance) < 0) == 3
            spacemap(pointstr) = inf;
        end
    end
    
    if spacemap(pointstr) == inf
        plot3(point(1),point(2),point(3),'r.')
    end
    
    
end
hold off

% starting at the goal, perform wavefront propagation
nodequeue = [goal];
spacemap(sprintf('%.2f %.2f %.2f', goal)) = 1;

while size(nodequeue,1) ~= 0

    % pop the queue
    currentnode = nodequeue(1,:);
    nodequeue(1,:) = [];

    % find neighbours
    neighbours = neighbours3d(currentnode,spaceresolution);
    
    currentnode = sprintf('%.2f %.2f %.2f', currentnode);
    
    % check neighbours and push onto queue
    for n = neighbours'
        nstr = sprintf('%.2f %.2f %.2f', n');
        try
            if spacemap(nstr) == 0
                    spacemap(nstr) = spacemap(currentnode) + 1;
                    nodequeue = [nodequeue ; n'];         
            end
        end
    end
end

% find the optimal path
pathlist = [start];
steps = 0;


while (sum(pathlist(size(pathlist,1),:) == goal) ~= 3) 
    % while the goal isn't reached
    
     if (steps > spacemap(sprintf('%.2f %.2f %.2f', start)))
         disp('no path found')
         break;
     end
    
    neighbours = neighbours3d(pathlist(size(pathlist,1),:), spaceresolution);
    
    bestfvalue = inf;
    for n = neighbours'
        
        nstr = sprintf('%.2f %.2f %.2f', n');
        try
            if spacemap(nstr) < bestfvalue
                    bestfvalue = spacemap(nstr);
                    nextnode = n';         
            end
        end
    end
    
    pathlist = [pathlist;nextnode];
    steps = steps + 1;
end

figure(1)
hold on
plot3(pathlist(:,1),pathlist(:,2),pathlist(:,3),'g--*')
hold off

path.time = [];
path.signals.values = pathlist;
path.signals.dimensions = 3;

