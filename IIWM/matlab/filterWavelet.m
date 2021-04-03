function [FI] = filterWavelet(Im, varargin_passed)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
        narging_passed = max(size(varargin_passed,2),size(varargin_passed,1));
        %PreIm = (Im);%---Preprocessing Original Image
        PreIm.Ig = Im; 
       % Treating inputs
        if narging_passed==0
            band = 'HH';
            Wname = 'haar';
            level = 1;
        elseif narging_passed == 1
            band = varargin_passed{1};
            Wname = 'haar';
            level = 1;
        elseif narging_passed == 2
            band = varargin_passed{1};
            Wname = varargin_passed{2};
            level = 1;
        elseif narging_passed == 3 
           band = varargin_passed{1};
           Wname = varargin_passed{2};
           level = varargin_passed{3};
        end
        
        % Treating output
        [M,N] = size(PreIm.Ig);
        % Function
        if level==1%---Single level of decomposition
            [cA1,cH1,cV1,cD1] = dwt2(PreIm.Ig,Wname);%---Discrete Wavelet Transform
            switch band
                case 'HL' %---For HL or Vertical 
                    [m n] = size(cV1);%---Get size of HL band image
                    cV1 = zeros(m,n);%---Eliminating HL band image by zero
                    FI = idwt2(cA1,cH1,cV1,cD1,Wname);%---Inverse DWT
                    FI = imresize(FI,[M N]);%---Resizing filtered image to preprocessed image

                case 'LH'%---For LH or Horizontal
                    [m n] = size(cH1);%---Get size of LH band image
                    cH1 = zeros(m,n);%---Eliminating LH band image by zero
                    FI = idwt2(cA1,cH1,cV1,cD1,Wname);%---Inverse DWT
                    FI = imresize(FI,[M N]);%---Resizing filtered image to preprocessed image

                case 'HH'%---For HH or Diagonal
                    [m n] = size(cD1);%---Get size of HH band image
                    cD1 = zeros(m,n);%---Eliminating HH band image by zero
                    FI = idwt2(cA1,cH1,cV1,cD1,Wname);%---Inverse DWT
                    FI = imresize(FI,[M N]);%---Resizing filtered image to preprocessed image

                case 'HL-HH'%---For HL-HH or Vertical and Diagonal
                    [m1 n1] = size(cV1);%---Get size of HL band image
                    [m2 n2] = size(cD1);%---Get size of HH band image
                    cV1 = zeros(m1,n1);%---Eliminating HL band image by zero
                    cD1 = zeros(m2,n2);%---Eliminating HH band image by zero
                    FI = idwt2(cA1,cH1,cV1,cD1,Wname);%---Inverse DWT
                    FI = imresize(FI,[M N]);%---Resizing filtered image to preprocessed image

                case 'LH-HH'%---For LH-HH or Horizontal and Diagonal
                    [m1 n1] = size(cH1);%---Get size of LH band image
                    [m2 n2] = size(cD1);%---Get size of HH band image
                    cH1 = zeros(m1,n1);%---Eliminating LH band image by zero
                    cD1 = zeros(m2,n2);%---Eliminating HH band image by zero
                    FI = idwt2(cA1,cH1,cV1,cD1,Wname);%---Inverse DWT
                    FI = imresize(FI,[M N]);%---Resizing filtered image to preprocessed image

                case 'HL-LH'%---For HL-LH or Vertical and Horizontal
                    [m1 n1] = size(cV1);%---Get size of HL band image
                    [m2 n2] = size(cH1);%---Get size of LH band image
                    cV1 = zeros(m1,n1);%---Eliminating HL band image by zero
                    cH1 = zeros(m2,n2);%---Eliminating LH band image by zero
                    FI = idwt2(cA1,cH1,cV1,cD1,Wname);%---Inverse DWT
                    FI = imresize(FI,[M N]);%---Resizing filtered image to preprocessed image

                case 'HL-LH-HH'%---For HL-LH-HH or Vertical,Horizontal and Diagonal
                    [m1 n1] = size(cV1);%---Get size of HL band image
                    [m2 n2] = size(cH1);%---Get size of LH band image
                    [m3 n3] = size(cD1);%---Get size of HH band image
                    cV1 = zeros(m1,n1);%---Eliminating HL band image by zero
                    cH1 = zeros(m2,n2);%---Eliminating LH band image by zero
                    cD1 = zeros(m3,n3);%---Eliminating HH band image by zero
                    FI = idwt2(cA1,cH1,cV1,cD1,Wname);%---Inverse DWT
                    FI = imresize(FI,[M N]);%---Resizing filtered image to preprocessed image

            end
        elseif level==2%---Second level of decomposition
            [cA1,cH1,cV1,cD1] = dwt2(PreIm.Ig,Wname);%---Discrete Wavelet Transform
            [cA2,cH2,cV2,cD2] = dwt2(cA1,Wname);%---Discrete Wavelet Transform
            switch band
                case 'HL'%---For HL or Vertical 
                    [r c] = size(PreIm.Ig);%---Get size of Preprocessed Image
                    [m n] = size(cV2);%---Get size of HL band image
                    cV2 = zeros(m,n);%---Eliminating HL band image by zero
                    If = idwt2(cA2,cH2,cV2,cD2,Wname);%---Inverse DWT
                    FI = imresize(If,[r c]);%---Resizing filtered image to preprocessed image
                case 'LH'%---For LH or Horizontal
                    [r c] = size(PreIm.Ig);%---Get size of Preprocessed Image
                    [m n] = size(cH2);%---Get size of LH band image
                    cH2 = zeros(m,n);%---Eliminating LH band image by zero
                    If = idwt2(cA2,cH2,cV2,cD2,Wname);%---Inverse DWT
                    FI = imresize(If,[r c]);%---Resizing filtered image to preprocessed image
                case 'HH'%---For HH or Diagonal
                    [r c] = size(PreIm.Ig);%---Get size of Preprocessed Image
                    [m n] = size(cD2);%---Get size of HH band image
                    cD2 = zeros(m,n);%---Eliminating HH band image by zero
                    If = idwt2(cA2,cH2,cV2,cD2,Wname);%---Inverse DWT
                    FI = imresize(If,[r c]);%---Resizing filtered image to preprocessed image
                case 'HL-HH'%---For HL-HH or Vertical and Diagonal
                    [r c] = size(PreIm.Ig);%---Get size of Preprocessed Image
                    [m1 n1] = size(cV2);%---Get size of HL band image
                    [m2 n2] = size(cD2);%---Get size of HH band image
                    cV2 = zeros(m1,n1);%---Eliminating HL band image by zero
                    cD2 = zeros(m2,n2);%---Eliminating HH band image by zero
                    If = idwt2(cA2,cH2,cV2,cD2,Wname);%---Inverse DWT
                    FI = imresize(If,[r c]);%---Resizing filtered image to preprocessed image
                case 'LH-HH'%---For LH-HH or Horizontal and Diagonal
                    [r c] = size(PreIm.Ig);%---Get size of Preprocessed Image
                    [m1 n1] = size(cH2);%---Get size of LH band image
                    [m2 n2] = size(cD2);%---Get size of HH band image
                    cH2 = zeros(m1,n1);%---Eliminating LH band image by zero
                    cD2 = zeros(m2,n2);%---Eliminating HH band image by zero
                    If = idwt2(cA2,cH2,cV2,cD2,Wname);%---Inverse DWT
                    FI = imresize(If,[r c]);%---Resizing filtered image to preprocessed image
                case 'HL-LH'%---For HL-LH or Vertical and Horizontal
                    [r c] = size(PreIm.Ig);%---Get size of Preprocessed Image
                    [m1 n1] = size(cV2);%---Get size of HL band image
                    [m2 n2] = size(cH2);%---Get size of LH band image
                    cV2 = zeros(m1,n1);%---Eliminating HL band image by zero
                    cH2 = zeros(m2,n2);%---Eliminating LH band image by zero
                    If = idwt2(cA2,cH2,cV2,cD2,Wname);%---Inverse DWT
                    FI = imresize(If,[r c]);%---Resizing filtered image to preprocessed image
                case 'HL-LH-HH'%---For HL-LH-HH or Vertical,Horizontal and Diagonal
                    [r c] = size(PreIm.Ig);%---Get size of preprocessed Image
                    [m1 n1] = size(cV2);%---Get size of HL band image
                    [m2 n2] = size(cH2);%---Get size of LH band image
                    [m3 n3] = size(cD2);%---Get size of HH band image
                    cV2 = zeros(m1,n1);%---Eliminating HL band image by zero
                    cH2 = zeros(m2,n2);%---Eliminating LH band image by zero
                    cD2 = zeros(m3,n3);%---Eliminating HH band image by zero
                    If = idwt2(cA2,cH2,cV2,cD2,Wname);%---Inverse DWT
                    FI = imresize(If,[r c]);%---Resizing filtered image to preprocessed image
            end
        else
            disp('Level not allowed: Decompostion upto level 2 only');
        end
    
end

