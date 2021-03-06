% Copyright 2013 Max-Planck-Institut f�r Eisenforschung GmbH
function h_popup = preCPFE_python_popup(pos)
%% Function for a popup menu to select python code to use
% pos: Position of the popup window [x0 h0 width height]

% author: c.zambaldi@mpie.de

gui = guidata(gcf);

h_popup = uicontrol( ...
    'Units', 'normalized', ...
    'Position', pos, ...
    'Style', 'popup', ...
    'String', gui.config.CPFEM.python_executables, ...
    'BackgroundColor', [0.9 0.9 0.9],...
    'FontWeight', 'bold', ...
    'FontSize', 10, ...
    'HorizontalAlignment', 'center', ...
    'Callback', ['gui = guidata(gcf); ' ...
    '[gui.config.CPFEM.python_executable, gui_SX.config.CPFEM.python]= ' ...
    'preCPFE_python_select(gui.handles.pm_Python); ' ...
    'guidata(gcf, gui)']);

end