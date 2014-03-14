package com.lmt.frameapp.metadata;

public abstract interface TableMetaData extends MetaDataObject
{
  public static final String TABLE = "TABLE";
  public static final String VIEW = "VIEW";

  public abstract ColumnMetaData[] getColumns();

  public abstract ColumnMetaData getColumn(String paramString);

  public abstract ColumnMetaData getColumn(int paramInt);

  public abstract String getType();

  public abstract int getColumnCount();

  public abstract DataSourceMetaData getDataSource();

  public abstract ColumnMetaData[] getPrimaryKey();
}