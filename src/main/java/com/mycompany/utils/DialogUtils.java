// https://github.com/fiji/fiji-lib/blob/master/src/main/java/fiji/util/gui/GenericDialogPlus.java
package com.mycompany.utils;

import ij.gui.GenericDialog;

import java.awt.GraphicsEnvironment;
import java.awt.TextField;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Button;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.awt.Panel;
import java.awt.FlowLayout;

import javax.swing.JFileChooser;

public class DialogUtils extends GenericDialog {

  public DialogUtils(String title) {
	super(title);
	this.setCancelLabel("Cancelar");
  }

  private static final long serialVersionUID = 1L;

  public void addDirectoryField(String label, String defaultPath) {
    addDirectoryField(label, defaultPath, 20);
  }

  public void addDirectoryField(String label, String defaultPath, int columns) {
		addStringField(label, defaultPath, columns);
		if (isHeadless()) return;

		TextField text = (TextField)stringField.lastElement();
		GridBagLayout layout = (GridBagLayout)getLayout();
		GridBagConstraints constraints = layout.getConstraints(text);

		Button button = new Button("Pesquisar...");
		DirectoryListener listener = new DirectoryListener("Pesquisar por " + label, text);
		button.addActionListener(listener);
		button.addKeyListener(this);

		Panel panel = new Panel();
		panel.setLayout(new FlowLayout(FlowLayout.LEFT, 0, 0));
		panel.add(text);
		panel.add(button);

		layout.setConstraints(panel, constraints);
		add(panel);
	}

    private static boolean isHeadless() {
      return GraphicsEnvironment.isHeadless();
    
	}
    static class DirectoryListener implements ActionListener {
      String title;
      TextField text;
      int fileSelectionMode;

      public DirectoryListener(String title, TextField text) {
        this(title, text, JFileChooser.DIRECTORIES_ONLY);
      }

      public DirectoryListener(String title, TextField text, int fileSelectionMode) {
        this.title = title;
        this.text = text;
        this.fileSelectionMode = fileSelectionMode;
      }

      @Override
      public void actionPerformed(ActionEvent e) {
        File directory = new File(text.getText());
        while (directory != null && !directory.exists())
          directory = directory.getParentFile();

        JFileChooser fc = new JFileChooser(directory);
        fc.setFileSelectionMode(fileSelectionMode);

        fc.showOpenDialog(null);
        File selFile = fc.getSelectedFile();
        if (selFile != null)
          text.setText(selFile.getAbsolutePath());
      }
    }
}
