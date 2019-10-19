function listFile = loadData(path)

% generating image path
directory = dir(path);

if (size(directory,1) == 0)
    error('Make sure your image data is in their directory');
else
    nFiles = size(directory,1);
    % allocate an array
    listFile = cell(nFiles,1);
    % for 2 object
    for i = 1:nFiles
        % saving absolute path of image data
        listFile{i,:} = fullfile(directory(i).folder, directory(i).name);
    end
end