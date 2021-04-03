% init animal
path_data = 'C:\Users\Renata Baptista\Google Drive\FinalProject\Codes\Data\Tumor_C\Ztumor';
output_data = 'C:\Users\Renata Baptista\Google Drive\FinalProject\output\animal\tumor';
  
% Volumetric constants
ratioPixelMeter = 6e-3/1000; % 6mm/1000 pixel
distanceBetweenLayer = 50e-6; % m

% STRING BASE      
GT_base_name = ['mask%04d.jpg'];
                          
IMG_base_name = ['ZTUMOR%04d.jpg'];

% IMG/ GT constasnta
INITIAL_IMG_NB = 42;
FINAL_IMG_NB = 62;
%%
% Array of names
images_filename = generateFilenamesFromNameBase(IMG_base_name, ...
                                    INITIAL_IMG_NB,...
                                    FINAL_IMG_NB);
GT_filename = generateFilenamesFromNameBase(GT_base_name(1,:), ...
                                            INITIAL_IMG_NB,...
                                            FINAL_IMG_NB);
                                