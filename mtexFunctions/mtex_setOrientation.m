% Copyright 2013 Max-Planck-Institut f�r Eisenforschung GmbH
function ori_grain = ...
    mtex_setOrientation(phase, ca_ratio, eulers_angle, varargin)
%% Set orientation of a grain by using MTEX function
% phase = Crystal Structure (CS for MTEX)
% eulers_angle = Euler angles (Bunge) in degrees

% See in http://mtex-toolbox.github.io/

% author: d.mercier@mpie.de

if nargin < 3
    eulers_angle = randBunges;
end

if nargin < 2
    ca_ratio = listLattParam('Ti', 'hcp');
end

if nargin < 1
    phase = 'hcp';
end

% Grain symmetry
if strcmp (phase, 'hcp') == 1
    CS = crystalSymmetry('hexagonal', [1 1 ca_ratio(1)]);
    
elseif strcmp (phase, 'fcc') == 1 || strcmp (phase, 'bcc') == 1
    CS = crystalSymmetry('cubic');
    
elseif strcmp (phase, 'bct') == 1 || strcmp (phase, 'fct') == 1
    CS = crystalSymmetry('tetragonal');
    
end

% Set orientation of grain - MTEX function
ori_grain = orientation('Euler',...
    (eulers_angle(1)/180)*pi,...
    (eulers_angle(2)/180)*pi,...
    (eulers_angle(3)/180)*pi,...
    CS);

end