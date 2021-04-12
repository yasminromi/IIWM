package com.mycompany.imagej;

import java.io.File;
import java.util.ArrayList;

import com.mycompany.listener.ImageListener;
import com.mycompany.model.SegmentationUSImageID;
import com.mycompany.utils.DialogUtils;
import com.mycompany.utils.MatLab;

import ij.IJ;
import net.imagej.ImageJ;

import ij.ImagePlus;

import org.scijava.command.Command;
import org.scijava.plugin.Plugin;

@Plugin(type = Command.class, headless = true, menuPath = "Plugins>IIWM")
public class Process_Pixels implements Command  {

	private ArrayList<String> filesList;
	private Integer currentImage = null;
	private final Integer SKIP_IMAGES = 10;
	private SegmentationUSImageID model;
	static ImageJ ij;


	private SegmentationUSImageID showDialog() {
		DialogUtils gd = new DialogUtils("IIWM");

		gd.addChoice("Opção de Função de Fechamento", new String[] { "hull", "linear" }, "hull");
		gd.addNumericField("Metro de Pixel", 6E-6, 0);
		gd.addNumericField("Distância entre Rótulo", 25E-6, 0);
		gd.addDirectoryField("Imagens", "");
		gd.addDirectoryField("Imagens com Máscara", "");
		gd.addChoice("Tipo do Filtro", new String[] { "None", "Median", "Wavelet" }, "None");
		gd.addStringField("Nível de Processamento", "2");
		gd.addStringField("Camada do Tumor", "Tumor");
		gd.addCheckbox("Index da Camada", true);
		gd.addCheckbox("Salvar Conteúdo", true);
		gd.addCheckbox("Editar máscaras com LiveWire", true);
		gd.addDirectoryField("Pasta para Salvar", "");

		gd.showDialog();
		if (gd.wasCanceled()) {
			return null;
		}

		return getParams(gd);
	}

	private SegmentationUSImageID getParams(DialogUtils gd) {
		SegmentationUSImageID model = new SegmentationUSImageID();

		model.setOcf(gd.getNextChoice());
		model.setRpm(gd.getNextNumber());
		model.setDbl(gd.getNextNumber());
		model.setRootImages(gd.getNextString());
		model.setRootMask(gd.getNextString());
		model.setTypeFilter(gd.getNextChoice());
		model.setLevelProcessing(gd.getNextString());
		model.setStringTumorLayer(gd.getNextString());
		model.setIdxLayer(gd.getNextBoolean());
		model.setSave(gd.getNextBoolean());
		model.setOpenLiveWire(gd.getNextBoolean());
		model.setRoot(gd.getNextString());

		return model;
	}

	private void callMatlab()  {

		try {
			
			MatLab.callMatlab(model, ij);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void openNextImage() {
		if(currentImage == null) {
			currentImage = 0;
		}
		if(filesList != null) {
			if (currentImage >= filesList.size()) {
			
				callMatlab();
			} else {
				openImage(filesList.get(currentImage));
				currentImage+= SKIP_IMAGES;
			}
		}
	}

	private void openImage(String path) {
		ImagePlus image = IJ.openImage(path);
		image.show();
	}

	private void execute() {
			if (model.getOpenLiveWire()) {
				filesList = getFilesInPathAsList(model.getRootImages());
				openNextImage();
			} else {
				callMatlab();
			}
	}
	
	private ArrayList<String> getFilesInPathAsList(String path) {
		ArrayList<String> _files = new ArrayList<String>();
	
		File folder = new File(path);
		File[] files = folder.listFiles();

		if (files != null) {
			for (File file : files) {
				 if (file != null) {
					 _files.add(path + "\\" + (file.getName()));
				}
			}
		}

		return _files;
	}
	
	public static void main(String[] args) throws Exception {
		ij = new ImageJ();
		ij.launch(args);

		ij.command().run(Process_Pixels.class, true);
	}

	@Override
	public void run() {
		model = showDialog();

		ImageListener listener = new ImageListener(this, model);
		ImagePlus.addImageListener(listener);

		 if (model != null) {
			execute();
		}
		
	}
}
