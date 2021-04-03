package com.mycompany.model;

public class SegmentationUSImageID {

  private String ocf;
  private double rpm;
  private double dbl;
  private String rootImages;
  private String rootMask;
  private String typeFilter;
  private String levelProcessing;
  private String stringTumorLayer;
  private boolean idxLayer;
  private boolean save;
  private boolean openLiveWire;
  private String root;

  public String getRootMask() {
    return rootMask;
  }

  public String getRoot() {
    return root;
  }

  public void setRoot(String root) {
    this.root = root;
  }

  public boolean isSave() {
    return save;
  }

  public void setSave(boolean save) {
    this.save = save;
  }

  public boolean isIdxLayer() {
    return idxLayer;
  }

  public void setIdxLayer(boolean idxLayer) {
    this.idxLayer = idxLayer;
  }

  public String getStringTumorLayer() {
    return stringTumorLayer;
  }

  public void setStringTumorLayer(String stringTumorLayer) {
    this.stringTumorLayer = stringTumorLayer;
  }

  public String getLevelProcessing() {
    return levelProcessing;
  }

  public void setLevelProcessing(String levelProcessing) {
    this.levelProcessing = levelProcessing;
  }

  public String getTypeFilter() {
    return typeFilter;
  }

  public void setTypeFilter(String typeFilter) {
    this.typeFilter = typeFilter;
  }

  public String getRootImages() {
    return rootImages;
  }

  public void setRootImages(String rootImages) {
    this.rootImages = rootImages;
  }

  public double getDbl() {
    return dbl;
  }

  public void setDbl(double dbl) {
    this.dbl = dbl;
  }

  public double getRpm() {
    return rpm;
  }

  public void setRpm(double rpm) {
    this.rpm = rpm;
  }

  public String getOcf() {
    return ocf;
  }

  public void setOcf(String ocf) {
    this.ocf = ocf;
  }

  public void setRootMask(String rootMask) {
    this.rootMask = rootMask;
  }
  
  public boolean getOpenLiveWire() {
	  return this.openLiveWire;
  }
  
  public void setOpenLiveWire(boolean openLiveWire) {
	  this.openLiveWire = openLiveWire;
  }

}
