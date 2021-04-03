%init_phantom

% PATHS
path_data = 'C:\Users\Renata Baptista\Google Drive\FinalProject\Codes\Data\Phantom';
output_data = 'C:\Users\Renata Baptista\Google Drive\FinalProject\output\phantom';

% NUMBER IMAGE
INITIAL_MASK_NB = 415;
FINAL_MASK_NB = 424;

% RATIO DISTANTCES
ratioPixelMeter = 10e-3/1667;
distanceBetweenLayer = 50e-6;

% STRING BASE
GT_base_name = ['imagem%d_GT_1.jpg';
                'imagem%d_GT_2.jpg';
                'imagem%d_GT_3.jpg';
                'imagem%d_GT_4.jpg'];

IMG_base_name = ['imagem%d.jpg'];


% FILENAME 
GT_filename = generateFilenamesFromNameBase(GT_base_name(IDX_LAYER,:), ...
                                            INITIAL_MASK_NB,...
                                            FINAL_MASK_NB);
                                        
images_filename = generateFilenamesFromNameBase(IMG_base_name, ...
                                            INITIAL_MASK_NB,...
                                            FINAL_MASK_NB);
