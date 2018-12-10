% Copyright 2013 Max-Planck-Institut f�r Eisenforschung GmbH
function save_data(pathname_sav_data, current_data, varargin)
%% Function to save data as a YAML file from the GUI
% path : path used to save the figure
% current_data : data to save
% See in http://code.google.com/p/yamlmatlab/

% author : d.mercier@mpie.de

if nargin < 2
    current_data = 'NaN';
end

if nargin < 1
    pathname_sav_data = pwd;
end


%% Modification of the path if needed (manual or random inputs)
if strcmp(pathname_sav_data,'random_inputs') == 1 || strcmp(pathname_sav_data,'manual_inputs') == 1
    pathname_sav_data = pwd;
end

%% Select directory to save the data file
[filename_sav_data, pathname_sav_data] = uiputfile({'*.yaml'}, 'Save Data As', ...
    pathname_sav_data);

if isequal(filename_sav_data,0)
    disp('User selected Cancel');
else
    %date_str = strcat(datestr(now,'yyyy-mmm-dd_HH'),'H',datestr(now,'MM'),'min',datestr(now,'ss'),'s');

    %% Exportation of data in a .yaml format
    WriteYaml(fullfile(pathname_sav_data, filename_sav_data), current_data);
    disp(strcat('Data saved in the file: ', filename_sav_data));
    
end

end