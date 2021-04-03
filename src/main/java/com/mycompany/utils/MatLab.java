package com.mycompany.utils;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.StringWriter;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;

import javax.imageio.ImageIO;

import com.mathworks.engine.MatlabEngine;
import com.mycompany.model.SegmentationUSImageID;

import clearvolume.renderer.ClearVolumeRendererInterface;
import clearvolume.renderer.factory.ClearVolumeRendererFactory;
import clearvolume.transferf.TransferFunctions;
import clearvolume.volume.Volume;
import clearvolume.volume.VolumeManager;
import clearvolume.volume.sink.NullVolumeSink;
import clearvolume.volume.sink.VolumeSinkInterface;
import clearvolume.volume.sink.filter.ChannelFilterSink;
import clearvolume.volume.sink.filter.gui.ChannelFilterSinkJFrame;
import clearvolume.volume.sink.renderer.ClearVolumeRendererSink;
import clearvolume.volume.sink.timeshift.TimeShiftingSink;
import coremem.enums.NativeTypeEnum;
import ij.gui.MessageDialog;

public class MatLab {
	
	
	static String path = new File("").getAbsolutePath();
	
	static final String MATLAB_PATH = (path + "\\IIWM\\matlab");
	
	static StringWriter writer = new StringWriter();
	static StringWriter writer2 = new StringWriter();
	
	public static void callMatlab(SegmentationUSImageID model)  {
		
		try {
			MatlabEngine ml = MatlabEngine.startMatlab();

			ml.eval("cd '" + MATLAB_PATH + "'");
			Object[] variables = {
					"hull",
					6E-6,
					2.5E-5,
					getFilesInPath(model.getRootImages()),
					(model.getRootImages().toCharArray()),
					getFilesInPath(model.getRootMask()),
					(model.getRootMask().toCharArray()),
					"None",
					2,
					"Tumor",
					false,
					0,
					(model.getRoot().toCharArray())
			};
			
			ml.feval("segmentationUSImagesIG", writer, writer2, variables);
			new MessageDialog(null, "Resultado da Segmentação", writer.toString());
			
			sumImages(
					(model.getRootImages().toCharArray()),
					getFilesInPath(model.getRootMask()),
					(model.getRootMask().toCharArray()),
					(model.getRoot().toCharArray())
			);
			callClearVolume(model);
			
		} 
		catch (InterruptedException e) {
			e.printStackTrace();
		} catch (ExecutionException e) {
			e.printStackTrace();
		} 
		catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public static void sumImages( char[] filePath, char[][] masknames, char[] maskPath, char[] savePath)  {
		
		try {
			MatlabEngine ml = MatlabEngine.startMatlab();

			ml.eval("cd '" + MATLAB_PATH + "'");
			Object[] variables = { filePath, masknames, maskPath, savePath };
			
			ml.feval("sumImages", writer, writer2, variables);
			new MessageDialog(null, "Resultado da Soma de Imagens", writer.toString());
			
		} catch (InterruptedException e) {
			e.printStackTrace();
		} catch (ExecutionException e) {
			e.printStackTrace();
		}
	}
	
	private static void callClearVolume(SegmentationUSImageID model) throws IOException {
		
		final ClearVolumeRendererInterface lClearVolumeRenderer = ClearVolumeRendererFactory.newBestRenderer("Tumor 3D",768,768,NativeTypeEnum.UnsignedShort,768,768);

		//lClearVolumeRenderer.setTransferFunction(TransferFunctions.getGrayLevel());
		lClearVolumeRenderer.setVisible(true);
		
	    final VolumeManager lManager = lClearVolumeRenderer.createCompatibleVolumeManager(200);
	    final ClearVolumeRendererSink lClearVolumeRenderSink = new ClearVolumeRendererSink(lClearVolumeRenderer, lManager, 100, TimeUnit.MILLISECONDS);
	    lClearVolumeRenderSink.setRelaySink(new NullVolumeSink());
	    //final TimeShiftingSink lTimeShiftingSink = new TimeShiftingSink(50, 100);

	    final ChannelFilterSink lChanelFilterSink = new ChannelFilterSink();
	    ChannelFilterSinkJFrame.launch(lChanelFilterSink);
	    lChanelFilterSink.setRelaySink(lClearVolumeRenderSink);
	    
	    final VolumeManager lVManager = lChanelFilterSink.getManager();
	    
	    final Volume lVolume = lVManager.requestAndWaitForVolume(10000, TimeUnit.MILLISECONDS, NativeTypeEnum.UnsignedByte, 1, 1000, 1000, 1000);
      final int lTimePoint = 2;
      final int lChannel = 4;
      lVolume.setTimeIndex(lTimePoint);
      lVolume.setChannelID(lChannel);
      FileInputStream fis = new FileInputStream(new File(model.getRoot() + "final.tif"));
      
      BufferedImage image = ImageIO.read(fis);
//
      lVolume.copyDataFrom(convertImage(image));
      System.out.println("Done");
//      
      lChanelFilterSink.sendVolume(lVolume);
	    
	    
	   // @SuppressWarnings("resource")
//		final TimeShiftingSink lTimeShiftingSink = new TimeShiftingSink(1000, 1000);
//	    lTimeShiftingSink.setRelaySink(lVolumeSinkInterface);
//	    //final VolumeManager lManager = lTimeShiftingSink.getManager();
//	    
//        final Volume lVolume = lManager.requestAndWaitForVolume(10000, TimeUnit.MILLISECONDS, NativeTypeEnum.UnsignedByte, 1, 1000, 1000, 1000);
//        final int lTimePoint = 2;
//        final int lChannel = 4;
//        lVolume.setTimeIndex(lTimePoint);
//        lVolume.setChannelID(lChannel);
//
//        FileInputStream fis = new FileInputStream(new File(model.getRoot() + "final.tif"));
//        
//        BufferedImage image = ImageIO.read(fis);
//
//        lVolume.copyDataFrom(convertImage(image));
//        System.out.println("Done");
//        
//        lTimeShiftingSink.sendVolume(lVolume);
	    

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
