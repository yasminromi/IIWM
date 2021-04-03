load('test.mat')
    stepOption = [3,9];
%filter, closeoption, step, layer
for idx_l =1:size(meanScoresIou,1)
    result_lay_i = squeeze(meanScoresIou(:,:,:,idx_l));
    results = reshape(result_lay_i, [], size(meanScoresIou,3))
    figure(idx_l)
    plot(stepOption, results,'--o');
    legend('A','B','C','D','E','F')
    
    xlabel('k') 
    ylabel('Iou') 


end