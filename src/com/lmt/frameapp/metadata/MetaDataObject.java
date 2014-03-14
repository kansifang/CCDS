package com.lmt.frameapp.metadata;

public abstract interface MetaDataObject
{
  public abstract String getName();

  public abstract String getLabel();

  public abstract String getDescribe();

  public abstract String getProperty(String paramString);

  public abstract String[] getProperties();
}