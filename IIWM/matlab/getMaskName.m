function [maskFilename] = getMaskName(filename)

    if isstring(filename)
        filename = convertStringsToChars(filename);
    end
    splited = split(filename,'.');
    maskFilename = strcat(splited{1}, '_mask.', splited{2});
    
end

