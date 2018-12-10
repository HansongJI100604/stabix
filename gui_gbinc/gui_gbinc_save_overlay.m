% Copyright 2013 Max-Planck-Institut f�r Eisenforschung GmbH
function gui_gbinc_save_overlay
%% Function to save overlay of picture

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

im = screencapture(gcf);

if ~isfield(gui.config_map, 'cpfilename')
    path4overlay = pwd;
else
    path4overlay = gui.config_map.cpfilename;
end

name4overlay = [path4overlay, timestamp_make, 'overlay.png'];

imwrite(im, name4overlay, 'png');
disp(['Overlay saved in ', name4overlay]);

end