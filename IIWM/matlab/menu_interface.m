% Interface
% 
% U need mij instaal
% Installation
% 1) Put mij.jar into the java directory of Matlab (e.g for Window Machine 'C:\Program Files\MATLAB\R2009b\java\').
% 2) Copy also ij.jar (ImageJ) in the java directory of Matlab. Get this file from the ImageJ website: http://rsb.info.nih.gov/ij/
% 3) Extend the java classpath to mij.jar, e.g using the Matlab command: javaaddpath 'C:\Program Files\MATLAB\R2009b\java\mij.jar'.
% 4) Extend the java classpath to ij.jar, e.g using the Matlab command: javaaddpath 'C:\Program Files\MATLAB\R2009b\java\ij.jar'.
% 5) Start MIJ by running the Matlab command: MIJ.start; or MIJ.start("imagej-path");

javaaddpath 'C:\Program Files\MATLAB\R2018b\java\mij.jar'
javaaddpath 'C:\Program Files\MATLAB\R2018b\java\ij.jar'

MIJ.start