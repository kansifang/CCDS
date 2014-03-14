/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.metadata;

import java.sql.Date;
import java.util.Arrays;
import java.util.BitSet;
import java.util.HashMap;

import com.lmt.frameapp.sql.SQLConstants;

// Referenced classes of package com.amarsoft.are.metadata:
//            DefaultMetaDataObject, DefaultColumnUIMetaData, ColumnUIMetaData, ColumnMetaData, 
//            TableMetaData

public class DefaultColumnMetaData extends DefaultMetaDataObject
    implements ColumnMetaData
{

    public DefaultColumnMetaData(int i)
    {
        super("COLUMN_" + i);
        bitSet = new BitSet(8);
        displaySize = 20;
        format = "";
        indexInTable = 0;
        precision = 0;
        scale = 0;
        schemaName = "";
        type = 1;
        defaultValue = null;
        defaultUIMetaData = null;
        uimetadata = null;
        indexInTable = i;
        bitSet.set(1);
        bitSet.set(4);
    }

    public DefaultColumnMetaData(int i, String s)
    {
        super(s);
        bitSet = new BitSet(8);
        displaySize = 20;
        format = "";
        indexInTable = 0;
        precision = 0;
        scale = 0;
        schemaName = "";
        type = 1;
        defaultValue = null;
        defaultUIMetaData = null;
        uimetadata = null;
        indexInTable = i;
        bitSet.set(1);
        bitSet.set(4);
    }

    public DefaultColumnMetaData(int i, String s, int j)
    {
        super(s);
        bitSet = new BitSet(8);
        displaySize = 20;
        format = "";
        indexInTable = 0;
        precision = 0;
        scale = 0;
        schemaName = "";
        type = 1;
        defaultValue = null;
        defaultUIMetaData = null;
        uimetadata = null;
        type = j;
        indexInTable = i;
        bitSet.set(1);
        bitSet.set(4);
    }

    public DefaultColumnMetaData(int i, String s, int j, int k, int l)
    {
        super(s);
        bitSet = new BitSet(8);
        displaySize = 20;
        format = "";
        indexInTable = 0;
        precision = 0;
        scale = 0;
        schemaName = "";
        type = 1;
        defaultValue = null;
        defaultUIMetaData = null;
        uimetadata = null;
        indexInTable = i;
        type = j;
        precision = k;
        scale = l;
        bitSet.set(1);
        bitSet.set(4);
    }

    public DefaultColumnMetaData(int i, String s, int j, String s1, int k, int l, int i1)
    {
        super(s, s1);
        bitSet = new BitSet(8);
        displaySize = 20;
        format = "";
        indexInTable = 0;
        precision = 0;
        scale = 0;
        schemaName = "";
        type = 1;
        defaultValue = null;
        defaultUIMetaData = null;
        uimetadata = null;
        indexInTable = i;
        type = j;
        precision = k;
        scale = l;
        displaySize = i1;
        bitSet.set(1);
        bitSet.set(4);
    }

    public ColumnUIMetaData getDefaultUIMetaData()
    {
        if(defaultUIMetaData == null)
            return getPooledUIMetaData();
        else
            return defaultUIMetaData;
    }

    private ColumnUIMetaData getPooledUIMetaData()
    {
        if(defaultUIMetaDataPool == null)
            defaultUIMetaDataPool = new DefaultColumnUIMetaData[5];
        byte byte0 = 0;
        int i = SQLConstants.SQLTypeToBaseType(type);
        switch(i)
        {
        case 0: // '\0'
            byte0 = 0;
            break;

        case 1: // '\001'
            byte0 = 1;
            break;

        case 2: // '\002'
            byte0 = 2;
            break;

        case 4: // '\004'
            byte0 = 3;
            break;

        case 16: // '\020'
            byte0 = 4;
            break;

        case 8: // '\b'
            byte0 = 5;
            break;
        }
        if(defaultUIMetaDataPool[byte0] == null)
            defaultUIMetaDataPool[byte0] = new DefaultColumnUIMetaData();
        defaultUIMetaDataPool[byte0].setKey(isPrimaryKey());
        defaultUIMetaDataPool[byte0].setReadOnly(isReadOnly());
        defaultUIMetaDataPool[byte0].setRequried(isNullable());
        defaultUIMetaDataPool[byte0].setSortable(getDisplaySize() > 100);
        if(byte0 == 3)
        {
            StringBuffer stringbuffer = new StringBuffer("##,###,##0");
            if(scale > 0)
            {
                char ac[] = new char[scale];
                Arrays.fill(ac, '0');
                stringbuffer.append('.').append(ac);
            }
            defaultUIMetaDataPool[byte0].setDisplayFormat(stringbuffer.toString());
        }
        return defaultUIMetaDataPool[byte0];
    }

    public Object getDefaultValue()
    {
        return defaultValue;
    }

    public int getDisplaySize()
    {
        return displaySize;
    }

    public String getFormat()
    {
        return format;
    }

    public int getIndex()
    {
        return indexInTable;
    }

    public int getPrecision()
    {
        return precision;
    }

    public int getScale()
    {
        return scale;
    }

    public String getSchemaName()
    {
        return schemaName;
    }

    public TableMetaData getTable()
    {
        return table;
    }

    public int getType()
    {
        return type;
    }

    public String getTypeName()
    {
        return SQLConstants.getSQLDataTypeName(getType());
    }

    public boolean isAutoIncrement()
    {
        return bitSet.get(0);
    }

    public boolean isCaseSensitive()
    {
        return bitSet.get(1);
    }

    public boolean isNullable()
    {
        return bitSet.get(2);
    }

    public boolean isPrimaryKey()
    {
        return bitSet.get(3);
    }

    public boolean isSearchable()
    {
        return bitSet.get(4);
    }

    public boolean isReadOnly()
    {
        return bitSet.get(5);
    }

    public void setAutoIncrement(boolean flag)
    {
        if(flag)
            bitSet.set(0);
        else
            bitSet.clear(0);
    }

    public void setCaseSensitive(boolean flag)
    {
        if(flag)
            bitSet.set(1);
        else
            bitSet.clear(1);
    }

    public void setNullable(boolean flag)
    {
        if(flag)
            bitSet.set(2);
        else
            bitSet.clear(2);
    }

    public void setPrimaryKey(boolean flag)
    {
        if(flag)
            bitSet.set(3);
        else
            bitSet.clear(3);
    }

    public void setSearchable(boolean flag)
    {
        if(flag)
            bitSet.set(4);
        else
            bitSet.clear(4);
    }

    public void setDisplaySize(int i)
    {
        displaySize = i;
    }

    public void setFormat(String s)
    {
        format = s;
    }

    public void setIndex(int i)
    {
        indexInTable = i;
    }

    public void setPrecision(int i)
    {
        precision = i;
    }

    public void setReadOnly(boolean flag)
    {
        if(flag)
            bitSet.set(5);
        else
            bitSet.clear(5);
    }

    public void setScale(int i)
    {
        scale = i;
    }

    public void setSchemaName(String s)
    {
        schemaName = s;
    }

    public void setDefaultValue(String s)
    {
        defaultValue = s;
    }

    public void setDefaultValue(Date date)
    {
        defaultValue = date;
    }

    public void setDefaultValue(int i)
    {
        defaultValue = new Integer(i);
    }

    public void setDefaultValue(long l)
    {
        defaultValue = new Long(l);
    }

    public void setDefaultValue(double d)
    {
        defaultValue = new Double(d);
    }

    public void setDefaultValue(boolean flag)
    {
        defaultValue = new Boolean(flag);
    }

    public void setTable(TableMetaData tablemetadata)
    {
        table = tablemetadata;
    }

    public void setType(int i)
    {
        type = i;
    }

    public void setDefaultUIMetaData(ColumnUIMetaData columnuimetadata)
    {
        defaultUIMetaData = columnuimetadata;
    }

    public ColumnUIMetaData getUIMetaData(String s)
    {
        if(uimetadata == null || s == null)
            return null;
        else
            return (ColumnUIMetaData)uimetadata.get(s.toUpperCase());
    }

    public void addUIMetaData(String s, ColumnUIMetaData columnuimetadata)
    {
        if(uimetadata == null)
            uimetadata = new HashMap();
        uimetadata.put(s.toUpperCase(), columnuimetadata);
        if(defaultUIMetaData == null)
            defaultUIMetaData = columnuimetadata;
    }

    BitSet bitSet;
    private int displaySize;
    private String format;
    private int indexInTable;
    private int precision;
    private int scale;
    private String schemaName;
    private TableMetaData table;
    private int type;
    private Object defaultValue;
    private ColumnUIMetaData defaultUIMetaData;
    private HashMap uimetadata;
    private static DefaultColumnUIMetaData defaultUIMetaDataPool[] = null;

}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360тфел\workspace\SXJS\WebRoot\WEB-INF\lib\are-0.2.jar
	Total time: 177 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/