package com.lmt.frameapp.metadata;

import java.sql.SQLException;

public abstract interface DataSourceMetaData extends MetaDataObject
{
  public abstract String getProductName();

  public abstract String getProductVersion();

  public abstract String getProviderName();

  public abstract String getEncoding();

  public abstract TableMetaData[] getTables()
    throws SQLException;

  public abstract TableMetaData getTable(String paramString)
    throws SQLException;

  public abstract ColumnMetaData[] getColumns()
    throws SQLException;

  public abstract ColumnMetaData getColumn(String paramString1, String paramString2)
    throws SQLException;
}