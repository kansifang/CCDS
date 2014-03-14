/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.metadata;

import java.sql.SQLException;
import java.util.*;

// Referenced classes of package com.amarsoft.are.metadata:
//            DefaultMetaDataObject, TableMetaData, ColumnMetaData, DataSourceMetaData

public class DefaultDataSourceMetaData extends DefaultMetaDataObject
    implements DataSourceMetaData
{

    public DefaultDataSourceMetaData()
    {
        encoding = "GBK";
        tables = new TreeMap();
        columns = new TreeMap();
    }

    public DefaultDataSourceMetaData(String s, String s1)
    {
        super(s);
        encoding = "GBK";
        tables = new TreeMap();
        columns = new TreeMap();
        encoding = s1;
    }

    public ColumnMetaData[] getColumns()
        throws SQLException
    {
        return (ColumnMetaData[])columns.values().toArray();
    }

    public String getEncoding()
    {
        return encoding;
    }

    public String getProductName()
    {
        return productName;
    }

    public String getProductVersion()
    {
        return productVersion;
    }

    public String getProviderName()
    {
        return providerName;
    }

    public TableMetaData[] getTables()
        throws SQLException
    {
        return (TableMetaData[])tables.values().toArray(new TableMetaData[0]);
    }

    public void setEncoding(String s)
    {
        encoding = s;
    }

    public TableMetaData getTable(String s)
        throws SQLException
    {
        TableMetaData tablemetadata = (TableMetaData)tables.get(s.toUpperCase());
        if(tablemetadata == null)
            throw new SQLException("Object not exists: " + s);
        else
            return tablemetadata;
    }

    public ColumnMetaData getColumn(String s, String s1)
        throws SQLException
    {
        ColumnMetaData columnmetadata = (ColumnMetaData)columns.get(s.toUpperCase() + "." + s1.toUpperCase());
        if(columnmetadata == null)
            throw new SQLException("Object not exists: " + s + "." + s1);
        else
            return columnmetadata;
    }

    public void setProductName(String s)
    {
        productName = s;
    }

    public void setProductVersion(String s)
    {
        productVersion = s;
    }

    public void setProviderName(String s)
    {
        providerName = s;
    }

    public void addTable(TableMetaData tablemetadata)
    {
        tables.put(tablemetadata.getName().toUpperCase(), tablemetadata);
        String s = tablemetadata.getName().toUpperCase() + ".";
        ColumnMetaData acolumnmetadata[] = tablemetadata.getColumns();
        if(acolumnmetadata != null)
        {
            for(int i = 0; i < acolumnmetadata.length; i++)
                columns.put(s + acolumnmetadata[i].getName().toUpperCase(), acolumnmetadata[i]);

        }
    }

    private String encoding;
    private String productName;
    private String productVersion;
    private String providerName;
    private SortedMap tables;
    private SortedMap columns;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360тфел\workspace\SXJS\WebRoot\WEB-INF\lib\are-0.2.jar
	Total time: 195 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/