function models = loadworld(filename, includeground)
% ===============================================================
% loadworld(filename, includeground)
%
% Input: 
%   filename = world file name
%   includeground = 1 to include the ground plane in the output
%   by default, includeground = 0
%
% Output: 
%   a list of models structs in the world file
%   each model has the properties name, size, position, orientation
% ===============================================================

if nargin == 1
    includeground = 0;
end

data = textread(filename,'%s','delimiter','\n');
models = [];        % list containing model structures
curmodel = 0;       % models index to process
instateworld = 0;     % change from getting sizes to getting poses
state_world_index = [0 0];

for i = 1:size(data,1)
    
    % read the current line
    line = data(i);
    line = line{1};
    
    % initialize models and get names and sizes
    if instateworld == 0
        
        % create new structure and append it to models list
        if isempty(findstr(line,'model name')) == 0
            [si,ei] = regexp(line,'''(.*)''');
            name = line(si+1:ei-1);
            curmodel = curmodel + 1;
            curstruct = struct('name','','size','','position','','orientation','');
            models = [models curstruct];
            models(curmodel).name = name;
        end
        
        % update the size of the current model being processed
        if isempty(findstr(line,'<size>')) == 0
            [si,ei] = regexp(line,'>(.*)<');
            msize = str2num(line(si+1:ei-1));
            if size(msize,2) == 2
                msize = [msize 0];
            end
            models(curmodel).size = msize;
        end
        
        % entered the state world lines
        % save their indexes and process them later
        if isempty(findstr(line,'<state world_name')) == 0
            instateworld = 1;
            state_world_index(1) = i;
        end
    else
        % return to making new models
        if isempty(findstr(line,'</state>')) == 0
            instateworld = 0;
            state_world_index(2) = i;
        end
    end
end

curmodel = 0;
for i=state_world_index(1):state_world_index(2)
    
    % read the current line
    line = data(i);
    line = line{1};
    
    
    if isempty(findstr(line,'model name')) == 0
        [si,ei] = regexp(line,'''(.*)''');
        name = line(si+1:ei-1);
        
        % order of the models is not preserved in the file which is why
        % this for loop is needed
        for j=1:size(models,2)
            if strcmp(models(j).name,name)
                curmodel = j;
                break
            end
        end
        
    end
    
    % get the pose of the current model
    if isempty(findstr(line,'pose frame')) == 0
        [si,ei] = regexp(line,'>(.*)<');
        pose = str2num(line(si+1:ei-1));
        models(curmodel).position = pose(1:3);
        models(curmodel).orientation = pose(4:6);
        
    end
end

if includeground == 0
    for i = 1:size(models,2)
        if strcmp(models(i).name,'ground_plane')
            models(i) = [];
            break
        end
    end
end

end
