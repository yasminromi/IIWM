% Renata Porciuncula Baptista
% 07/09/2019

% Minimum example_ computeVolumeFrom Masks

load phantom_truemasks.mat
init_phantom;

[volTotal, arrayVol] = computeVolumeFromMasks(masksTrue, distanceBetweenLayer, ratioPixelMeter);
fprintf("Vol total: %.2d mm3\n", volTotal*1e9);