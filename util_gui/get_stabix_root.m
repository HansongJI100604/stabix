% Copyright 2013 Max-Planck-Institut f�r Eisenforschung GmbH
function stabix_root = get_stabix_root
%% Get environment variable for STABiX

% author: c.zambaldi@mpie.de

stabix_root = getenv('SLIP_TRANSFER_TBX_ROOT');

if isempty(stabix_root)
    msg = 'Run the path_management.m script !';
    commandwindow;
    disp(msg);
    %errordlg(msg, 'File Error');
    error(msg);
end

end