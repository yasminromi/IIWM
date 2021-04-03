% Volumetric constants
ratioPixelMeter = 6e-3/1000; % 6mm
distanceBetweenLayer = 50e-6;

% PATHS
path_data = 'C:\Users\Renata Baptista\Google Drive\FinalProject\Codes\Data\Normal_C';
output_data = 'C:\Users\Renata Baptista\Google Drive\FinalProject\output\animal\normal_C';


% STRING BASE      
GT_base_name = ['3d00%02d_GT_1.jpg';
                '3d00%02d_GT_2.jpg'];
                          
IMG_base_name = ['3d00%02d.jpg'];

% IMG/ GT constasnta
INITIAL_IMG_NB = 5;
FINAL_IMG_NB = 35;

% Array of names
images_filename = generateFilenamesFromNameBase(IMG_base_name, ...
                                    INITIAL_IMG_NB,...
                                    FINAL_IMG_NB);
GT_filename = generateFilenamesFromNameBase(GT_base_name(IDX_LAYER,:), ...
                                            INITIAL_IMG_NB,...
                                            FINAL_IMG_NB);
                                