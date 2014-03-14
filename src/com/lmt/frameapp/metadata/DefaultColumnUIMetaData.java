/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.metadata;

import java.util.Properties;

// Referenced classes of package com.amarsoft.are.metadata:
//            DefaultMetaDataObject, ColumnUIMetaData, ColumnMetaData

public class DefaultColumnUIMetaData extends DefaultMetaDataObject
    implements ColumnUIMetaData
{

    public DefaultColumnUIMetaData()
    {
        bitSet = 0;
        hAlignment = 1;
        vAlignment = 4;
        valueCharacter = 0;
        inputMask = null;
        displayFormat = null;
        css = null;
        bitSet = 28;
    }

    public DefaultColumnUIMetaData(ColumnMetaData columnmetadata)
    {
        this();
        int i = columnmetadata.getType();
        switch(i)
        {
        case 1: // '\001'
        case 2: // '\002'
            hAlignment = 2;
            inputMask = "000000";
            displayFormat = "##,###,##0";
            break;

        case 4: // '\004'
            hAlignment = 2;
            inputMask = "000000";
            displayFormat = "##,###,##0.00";
            break;

        case 16: // '\020'
            hAlignment = 0;
            valueCharacter = 1;
            inputMask = "0000/00/00";
            displayFormat = "yyyy/MM/dd";
            break;

        case 8: // '\b'
            hAlignment = 0;
            valueCharacter = 3;
            break;
        }
    }

    public void setKey(boolean flag)
    {
        setBit(1, flag);
    }

    public void setReadOnly(boolean flag)
    {
        setBit(2, flag);
    }

    public void setVisible(boolean flag)
    {
        setBit(4, flag);
    }

    public void setRequried(boolean flag)
    {
        setBit(8, flag);
    }

    public void setSortable(boolean flag)
    {
        setBit(16, flag);
    }

    public boolean isKey()
    {
        return getBit(1);
    }

    public boolean isReadOnly()
    {
        return getBit(2);
    }

    public boolean isVisible()
    {
        return getBit(4);
    }

    public boolean isRequired()
    {
        return getBit(8);
    }

    public boolean isSortable()
    {
        return getBit(16);
    }

    private void setBit(int i, boolean flag)
    {
        if(flag)
            bitSet = bitSet | i;
        else
            bitSet = bitSet & (i ^ 31);
    }

    private boolean getBit(int i)
    {
        return (i & bitSet) > 0;
    }

    public int getHAlignment()
    {
        return hAlignment;
    }

    public int getVAlignment()
    {
        return vAlignment;
    }

    public int getValueCharacter()
    {
        return valueCharacter;
    }

    public String getInputMask()
    {
        return inputMask;
    }

    public boolean matchMask(String s)
    {
        return false;
    }

    public String getDisplayFormat()
    {
        return displayFormat;
    }

    public String getCSS()
    {
        return css;
    }

    public String getProperty(String s)
    {
        if(extendProperties == null || s == null)
            return null;
        else
            return extendProperties.getProperty(s);
    }

    public void setProperty(String s, String s1)
    {
        if(extendProperties == null)
            extendProperties = new Properties();
        extendProperties.setProperty(s, s1);
    }

    public final void setCss(String s)
    {
        css = s;
    }

    public final void setDisplayFormat(String s)
    {
        displayFormat = s;
    }

    public final void setHAlignment(int i)
    {
        hAlignment = i;
    }

    public final void setInputMask(String s)
    {
        inputMask = s;
    }

    public final void setVAlignment(int i)
    {
        vAlignment = i;
    }

    public final void setValueCharacter(int i)
    {
        valueCharacter = i;
    }

    public final String getValueCodetable()
    {
        return valueCodetable;
    }

    public final void setValueCodetable(String s)
    {
        valueCodetable = s;
    }

    public final String getValueList()
    {
        return valueList;
    }

    public final void setValueList(String s)
    {
        valueList = s;
    }

    public final String getValueRange()
    {
        return valueRange;
    }

    public final void setValueRange(String s)
    {
        valueRange = s;
    }

    private int bitSet;
    private int hAlignment;
    private int vAlignment;
    private int valueCharacter;
    private String inputMask;
    private String displayFormat;
    private String css;
    private String valueCodetable;
    private String valueRange;
    private String valueList;
    private Properties extendProperties;
    private static final int BIT_KEY = 1;
    private static final int BIT_READONLY = 2;
    private static final int BIT_VISIBLE = 4;
    private static final int BIT_REQUIRED = 8;
    private static final int BIT_SORTABLE = 16;
    private static final int BIT_ALL = 31;
    private static final int BIT_NONE = 0;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360тфел\workspace\SXJS\WebRoot\WEB-INF\lib\are-0.2.jar
	Total time: 183 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/