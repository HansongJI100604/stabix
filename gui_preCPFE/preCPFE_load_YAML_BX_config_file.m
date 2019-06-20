% Copyright 2013 Max-Planck-Institut f�r Eisenforschung GmbH
function preCPFE_load_YAML_BX_config_file(YAML_GB_config_file, interface)
%% Function to import YAML Bicrystal config. file
% YAML_GB_config_file : Name of YAML GB config. to import
% interface: type of interface (1 for SX or 2 for BX meshing interface)
% See in http://code.google.com/p/yamlmatlab/

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

if YAML_GB_config_file == 0
    [YAML_GB_config_file, YAML_GB_config_path] = ...
        uigetfile('*.yaml', 'Get YAML config. file');
    
    YAML_GB_FILE = fullfile(YAML_GB_config_path, YAML_GB_config_file);
    
    % Handle canceled file selection
    if YAML_GB_config_file == 0
        YAML_GB_FILE = '';
    end
    
    if isequal(YAML_GB_config_file, 0) ...
            || strcmp(YAML_GB_config_file, '') == 1
        disp('User selected Cancel');
        if interface == 1
            YAML_GB_FILE = ...
                sprintf('config_gui_SX_defaults.yaml');
        elseif interface == 2
            YAML_GB_FILE = ...
                sprintf('config_gui_BX_defaults.yaml');
        end
    else
        disp(['User selected :', YAML_GB_FILE]);
    end
else
    YAML_GB_FILE = YAML_GB_config_file;
end

%% Loading YAML file
GB_YAML = ReadYaml(YAML_GB_FILE);

%% Fill missing fields
if ~isfield(GB_YAML, 'filenameGF2_BC')
    GB_YAML.filenameGF2_BC = 'user_inputs';
end

if ~isfield(GB_YAML, 'filenameGF2_BC')
    GB_YAML.filenameRB_BC = 'user_inputs';
end

if ~isfield(GB_YAML, 'pathnameGF2_BC')
    GB_YAML.pathnameRB_BC = pwd;
end

if ~isfield(GB_YAML, 'pathnameGF2_BC')
    GB_YAML.pathnameRB_BC = pwd;
end

if ~isfield(GB_YAML, 'pathnameGF2_BC')
    GB_YAML.pathnameRB_BC = pwd;
end

if ~isfield(GB_YAML, 'eulerA')
    GB_YAML.eulerA = [0, 0, 0];
else
    GB_YAML.eulerA = cell2mat(GB_YAML.eulerA);
end
GB_YAML.eulerA_ori = GB_YAML.eulerA;

if ~isfield(GB_YAML, 'GrainA')
    GB_YAML.GrainA = 1;
end

if ~isfield(GB_YAML, 'activeGrain')
    GB_YAML.activeGrain = GB_YAML.GrainA;
end

if ~isfield(GB_YAML, 'Phase_A')
    GB_YAML.Phase_A = 'hcp';
end

if ~isfield(GB_YAML, 'Material_A')
    GB_YAML.Material_A = 'Ti';
end

if ~isfield(GB_YAML, 'ca_ratio_A')
    GB_YAML.ca_ratio_A = listLattParam(GB_YAML.Material_A, GB_YAML.Phase_A);
else
    GB_YAML.ca_ratio_A = cell2mat(GB_YAML.ca_ratio_A);
end

if interface == 2 %BX
    if ~isfield(GB_YAML, 'eulerB')
        GB_YAML.eulerB = [45, 45, 0];
    else
        GB_YAML.eulerB = cell2mat(GB_YAML.eulerB);
    end
    GB_YAML.eulerB_ori = GB_YAML.eulerB;
    
    if ~isfield(GB_YAML, 'GrainB')
        GB_YAML.GrainB = 2;
    end
    
    if ~isfield(GB_YAML, 'Phase_B')
        GB_YAML.Phase_B = 'hcp';
    end
    
    if ~isfield(GB_YAML, 'GB_Inclination')
        GB_YAML.GB_Inclination = randi(40,1) + 70; % 70-110� or round(rand(1)*100)+1 between 0 and 100�
    end
    
    if ~isfield(GB_YAML, 'GB_Trace_Angle')
        GB_YAML.GB_Trace_Angle = 0;
    end
    
    if ~isfield(GB_YAML, 'GB_Number')
        GB_YAML.GB_Number = 1;
    end
    
    if ~isfield(GB_YAML, 'Material_B')
        GB_YAML.Material_B = 'Ti';
    end
    
    if ~isfield(GB_YAML, 'ca_ratio_B')
        GB_YAML.ca_ratio_B = listLattParam(GB_YAML.Material_B, GB_YAML.Phase_B);
    else
        GB_YAML.ca_ratio_B = cell2mat(GB_YAML.ca_ratio_B);
    end
    GB_YAML.active_data = 'BX';
else
    GB_YAML.eulerB = [];
    GB_YAML.eulerB_ori = [];
    GB_YAML.GrainB = [];
    GB_YAML.Phase_B = [];
    GB_YAML.GB_Inclination = [];
    GB_YAML.GB_Trace_Angle = [];
    GB_YAML.GB_Number = [];
    GB_YAML.Material_B = [];
    GB_YAML.ca_ratio_B = [];
    GB_YAML.active_data = 'SX';
end

if interface == 1
    GB_YAML.number_phase = 1;
else
    if ~isfield(GB_YAML, 'number_phase')
        if strcmp(GB_YAML.Phase_A, GB_YAML.Phase_B) == 1
            GB_YAML.number_phase = 1;
        else
            GB_YAML.number_phase = 2;
        end
    end
end

%% Setting of grains Euler angles when only misorientation and mis. axis are given
if interface == 2
    if isfield(GB_YAML, 'Misorientation_angle') ...
            && isfield(GB_YAML, 'Misorientation_axis')
        GB_YAML.Misorientation_axis = cell2mat(GB_YAML.Misorientation_axis);
        GB_YAML.eulerA = [0 0 0];
        GB_YAML.eulerA_ori = GB_YAML.eulerA;
        GB_YAML.Misorientation_vect = ...
            [1 1 1 1; GB_YAML.Misorientation_axis];
        GB_YAML.Misorientation_vect_cs = ...
            slip_vectors_normalization(GB_YAML. Phase_B, ...
            GB_YAML.ca_ratio_B, GB_YAML.Misorientation_vect);
        GB_YAML.rot_mat = axisang2g(GB_YAML.Misorientation_vect_cs(2,:), ...
            GB_YAML.Misorientation_angle);
        %GB.Misorientation_vect = millerbravaisdir2cart(GB.Misorientation_axis, GB.ca_ratio_B(1));
        %GB.rot_mat = axisang2g(GB.Misorientation_vect, GB.Misorientation_angle);
        GB_YAML.eulerB = g2eulers(GB_YAML.rot_mat);
        GB_YAML.eulerB_ori = GB_YAML.eulerB;
    end
end

gui.GB = GB_YAML;
guidata(gcf, gui);

end