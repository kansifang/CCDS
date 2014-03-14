package com.lmt.frameapp.metadata;

public abstract interface ColumnMetaData extends MetaDataObject
{
  public abstract int getType();

  public abstract String getTypeName();

  public abstract int getPrecision();

  public abstract int getScale();

  public abstract int getDisplaySize();

  public abstract String getFormat();

  public abstract String getSchemaName();

  public abstract TableMetaData getTable();

  public abstract int getIndex();

  public abstract Object getDefaultValue();

  public abstract ColumnUIMetaData getDefaultUIMetaData();

  public abstract ColumnUIMetaData getUIMetaData(String paramString);

  public abstract boolean isAutoIncrement();

  public abstract boolean isCaseSensitive();

  public abstract boolean isNullable();

  public abstract boolean isSearchable();

  public abstract boolean isPrimaryKey();

  public abstract boolean isReadOnly();
}