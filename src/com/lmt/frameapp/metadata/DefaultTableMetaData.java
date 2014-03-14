/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.metadata;

import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;

import com.lmt.frameapp.sql.SQLConstants;

// Referenced classes of package com.amarsoft.are.metadata:
//            DefaultMetaDataObject, DefaultColumnMetaData, TableMetaData, DataSourceMetaData, 
//            ColumnMetaData

public class DefaultTableMetaData extends DefaultMetaDataObject
    implements TableMetaData
{

    public DefaultTableMetaData(String s, String s1, DefaultColumnMetaData adefaultcolumnmetadata[])
    {
        super(s);
        columnCount = 0;
        findContextInited = false;
        primaryKey = null;
        type = s1;
        columnCount = adefaultcolumnmetadata.length;
        columns = new DefaultColumnMetaData[columnCount];
        for(int i = 0; i < columnCount; i++)
        {
            adefaultcolumnmetadata[i].setTable(this);
            columns[adefaultcolumnmetadata[i].getIndex() - 1] = adefaultcolumnmetadata[i];
        }

    }

    public DefaultTableMetaData(ResultSetMetaData resultsetmetadata)
        throws SQLException
    {
        super(resultsetmetadata.getTableName(1));
        columnCount = 0;
        findContextInited = false;
        primaryKey = null;
        type = "TABLE";
        setLabel(resultsetmetadata.getSchemaName(1));
        columnCount = resultsetmetadata.getColumnCount();
        columns = new DefaultColumnMetaData[columnCount];
        for(int i = 0; i < columnCount; i++)
        {
            int j = i + 1;
            columns[i] = new DefaultColumnMetaData(j, resultsetmetadata.getColumnName(j), resultsetmetadata.getColumnType(j), resultsetmetadata.getColumnLabel(j), resultsetmetadata.getPrecision(j), resultsetmetadata.getScale(j), resultsetmetadata.getColumnDisplaySize(j));
            columns[i].setTable(this);
            columns[i].setAutoIncrement(resultsetmetadata.isAutoIncrement(j));
            columns[i].setCaseSensitive(resultsetmetadata.isCaseSensitive(j));
            columns[i].setNullable(resultsetmetadata.isNullable(j) == 1);
            columns[i].setSearchable(resultsetmetadata.isSearchable(j));
            columns[i].setReadOnly(resultsetmetadata.isReadOnly(j));
            columns[i].setSchemaName(resultsetmetadata.getSchemaName(j));
            if(SQLConstants.SQLTypeToBaseType(columns[i].getType()) == 16)
                columns[i].setFormat("yyyy/MM/dd");
        }

    }

    public ColumnMetaData[] getColumns()
    {
        return columns;
    }

    public ColumnMetaData getColumn(int i)
    {
        return columns[i - 1];
    }

    public ColumnMetaData getColumn(String s)
    {
        return getColumn(findColumn(s));
    }

    public String getType()
    {
        return type;
    }

    public int getColumnCount()
    {
        return columnCount;
    }

    public DataSourceMetaData getDataSource()
    {
        return dataSource;
    }

    public void setDataSource(DataSourceMetaData datasourcemetadata)
    {
        dataSource = datasourcemetadata;
    }

    public void setType(String s)
    {
        type = s;
    }

    public int findColumn(String s)
    {
        if(!findContextInited)
            initFindColumnContext();
        int i = Arrays.binarySearch(columnNames, s.toUpperCase());
        if(i < 0 || i > columnCount)
            return i;
        else
            return columnIndexes[i] + 1;
    }

    private void initFindColumnContext()
    {
        columnNames = new String[columnCount];
        columnIndexes = new int[columnCount];
        for(int i = 0; i < columnCount; i++)
            columnNames[i] = columns[i].getName().toUpperCase();

        Arrays.sort(columnNames);
        for(int j = 0; j < columnCount; j++)
            columnIndexes[Arrays.binarySearch(columnNames, columns[j].getName().toUpperCase())] = j;

        findContextInited = true;
    }

    public ColumnMetaData[] getPrimaryKey()
    {
        if(primaryKey == null)
        {
            ArrayList arraylist = new ArrayList();
            for(int i = 0; i < columns.length; i++)
                if(columns[i].isPrimaryKey())
                    arraylist.add(columns[i]);

            primaryKey = (DefaultColumnMetaData[])arraylist.toArray(new DefaultColumnMetaData[0]);
        }
        return primaryKey;
    }

    private String type;
    private DefaultColumnMetaData columns[];
    private int columnCount;
    private DataSourceMetaData dataSource;
    private String columnNames[];
    private int columnIndexes[];
    private boolean findContextInited;
    private DefaultColumnMetaData primaryKey[];
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360тфел\workspace\SXJS\WebRoot\WEB-INF\lib\are-0.2.jar
	Total time: 369 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/