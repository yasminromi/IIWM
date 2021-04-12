package com.mycompany.utils;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.StringWriter;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.concurrent.ExecutionException;

import javax.imageio.ImageIO;

import com.mathworks.engine.MatlabEngine;
import com.mycompany.model.SegmentationUSImageID;

import net.imagej.ImageJ;
import ij.IJ;
import ij.ImagePlus;
import ij.gui.MessageDialog;
import ij.process.StackConverter;
import ij3d.Content;
import ij3d.Image3DUniverse;

public class MatLab {
	
	
	static String path = new File("").getAbsolutePath();
	
	//static final String MATLAB_PATH = (path + "\\plugins\\IIWM\\matlab");
	static final String MATLAB_PATH = (path + "\\IIWM\\matlab");
	
	static StringWriter writer = new StringWriter();
	static StringWriter writer2 = new StringWriter();
	
	public static void callMatlab(SegmentationUSImageID model, ImageJ ij)  {
		
		try {
			MatlabEngine ml = MatlabEngine.startMatlab();

			ml.eval("cd '" + MATLAB_PATH + "'");
			Object[] variables = {
					model.getOcf(),
					model.getRpm(),
					model.getDbl(),
					getFilesInPath(model.getRootImages()),
					(model.getRootImages().toCharArray()),
					getFilesInPath(model.getRootMask()),
					(model.getRootMask().toCharArray()),
					model.getTypeFilter(),
					model.getLevelProcessing(),
					model.getStringTumorLayer(),
					model.isIdxLayer(),
					model.isSave(),
					(model.getRoot().toCharArray())
			};
			
			ml.feval("segmentationUSImagesIG", writer, writer2, variables);
			new MessageDialog(null, "Resultado da Segmentação", writer.toString());
			
			openImage(model.getRoot() + "\\final.tif", model.getRpm());
			
		} 
		catch (InterruptedException e) {
			e.printStackTrace();
		} catch (ExecutionException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void sumImages( char[] filePath, char[][] masknames, char[] maskPath, char[] savePath, double distance)  {
		System.out.println(distance);
		try {
			MatlabEngine ml = MatlabEngine.startMatlab();

			ml.eval("cd '" + MATLAB_PATH + "'");
			Object[] variables = { filePath, masknames, maskPath, savePath, distance };
			
			ml.feval("sumImages", writer, writer2, variables);
			new MessageDialog(null, "Resultado da Soma de Imagens", writer.toString());
			
		} catch (InterruptedException e) {
			e.printStackTrace();
		} catch (ExecutionException e) {
			e.printStackTrace();
		}
	}
	
	
	private static void openImage(String path, double unit) {
		ImagePlus image = IJ.openImage(path);
		
		image.getCalibration().setUnit("mm");
		image.getCalibration().setXUnit(String.valueOf(unit));
		image.getCalibration().setYUnit(String.valueOf(unit));
		image.getCalibration().setZUnit(String.valueOf(unit));
		
		IJ.run(image, "Scale...", "z=20 interpolation=Bilinear");
		
		ImagePlus imageInterpolated = IJ.getImage();
		imageInterpolated.hide();
		
		new StackConverter(imageInterpolated).convertToGray8();
		Image3DUniverse univ = new Image3DUniverse();
		univ.show();
		
		Content c = univ.addVoltex(imageInterpolated);
	}
    
	public static ByteBuffer convertImage(BufferedImage image) throws IOException
	{     
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		ImageIO.write( image, "TIFF", baos );
		
		return ByteBuffer.wrap(baos.toByteArray());
		
	}

	
	private static char[][] getFilesInPath(String path) {
		ArrayList<char[]> _files = new ArrayList<char[]>();
	
		File folder = new File(path);
		File[] files = folder.listFiles();

		if (files != null) {
			for (File file : files) {
				 if (file != null) {
					 _files.add((file.getName().toCharArray()));
				}
			}
		}

		return _files.toArray(new char[0][0]);
	}

}
