/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.lang;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.*;

// Referenced classes of package com.amarsoft.are.lang:
//            StringX

public class DataElement
    implements Cloneable, Comparable, Serializable
{

    public static final int unnamedInstanceCount()
    {
        return unnamedCount;
    }

    public DataElement()
    {
        isNull = true;
        setType = 0;
        type = 0;
        name = "de_" + String.valueOf(++unnamedCount);
    }

    public DataElement(String name)
    {
        isNull = true;
        setType = 0;
        type = 0;
        this.name = name == null ? "de_" + String.valueOf(++unnamedCount) : name;
    }

    public DataElement(String name, byte type)
    {
        isNull = true;
        setType = 0;
        this.name = name == null ? "de_" + String.valueOf(++unnamedCount) : name;
        this.type = type;
    }

    public final String getName()
    {
        return name;
    }

    public final String getLabel()
    {
        return label != null ? label : name;
    }

    public final void setLabel(String label)
    {
        this.label = label;
    }

    public int getLength()
    {
        return length;
    }

    public void setLength(int length)
    {
        this.length = length;
    }

    public int getScale()
    {
        return scale;
    }

    public void setScale(int scale)
    {
        this.scale = scale;
    }

    public final Date getDate()
    {
        if(!converted && setType != 16)
        {
            typeConvert();
            converted = true;
        }
        return dateValue;
    }

    public final boolean isNull()
    {
        return isNull;
    }

    public final void setNull()
    {
        intValue = 0;
        doubleValue = 0.0D;
        stringValue = null;
        dateValue = null;
        booleanValue = false;
        longValue = 0L;
        converted = true;
        isNull = true;
    }

    public final double getDouble()
    {
        if(!converted && setType != 4)
        {
            typeConvert();
            converted = true;
        }
        return doubleValue;
    }

    public final String getString()
    {
        if(!converted && setType != 0)
        {
            typeConvert();
            converted = true;
        }
        return stringValue;
    }

    public final int getInt()
    {
        if(!converted && setType != 1)
        {
            typeConvert();
            converted = true;
        }
        return intValue;
    }

    public final long getLong()
    {
        if(!converted && setType != 2)
        {
            typeConvert();
            converted = true;
        }
        return longValue;
    }

    public final boolean getBoolean()
    {
        if(!converted && setType != 8)
        {
            typeConvert();
            converted = true;
        }
        return booleanValue;
    }

    public final String toString()
    {
        return getString();
    }

    public Object clone()
    {
        DataElement de = null;
        try
        {
            de = (DataElement)super.clone();
        }
        catch(CloneNotSupportedException e) { }
        return de;
    }

    public final byte getType()
    {
        return type;
    }

    public final void setValue(String x)
    {
        stringValue = x;
        isNull = x == null;
        setType = 0;
        converted = false;
    }

    public final void setValue(int x)
    {
        intValue = x;
        isNull = false;
        setType = 1;
        converted = false;
    }

    public final void setValue(long x)
    {
        longValue = x;
        isNull = false;
        setType = 2;
        converted = false;
    }

    public final void setValue(double x)
    {
        doubleValue = x;
        isNull = false;
        setType = 4;
        converted = false;
    }

    public final void setValue(boolean x)
    {
        booleanValue = x;
        isNull = false;
        setType = 8;
        converted = false;
    }

    public final void setValue(Date x)
    {
        dateValue = x;
        isNull = x == null;
        setType = 16;
        converted = false;
    }

    public final void setValue(DataElement x)
    {
        if(x == null || x.isNull())
        {
            setNull();
            return;
        }
        switch(type)
        {
        case 0: // '\0'
            setValue(x.getString());
            break;

        case 1: // '\001'
            setValue(x.getInt());
            break;

        case 2: // '\002'
            setValue(x.getLong());
            break;

        case 4: // '\004'
            setValue(x.getDouble());
            break;

        case 8: // '\b'
            setValue(x.getBoolean());
            break;

        case 16: // '\020'
            setValue(x.getDate());
            break;

        case 3: // '\003'
        case 5: // '\005'
        case 6: // '\006'
        case 7: // '\007'
        case 9: // '\t'
        case 10: // '\n'
        case 11: // '\013'
        case 12: // '\f'
        case 13: // '\r'
        case 14: // '\016'
        case 15: // '\017'
        default:
            setValue(x.getString());
            break;
        }
    }

    public final Object getValue()
    {
        if(isNull())
            return null;
        Object ret = null;
        switch(type)
        {
        case 0: // '\0'
            ret = getString();
            break;

        case 1: // '\001'
            ret = new Integer(getInt());
            break;

        case 2: // '\002'
            ret = new Long(getLong());
            break;

        case 4: // '\004'
            ret = new Double(getDouble());
            break;

        case 8: // '\b'
            ret = new Boolean(getBoolean());
            break;

        case 16: // '\020'
            ret = getDate();
            break;

        case 3: // '\003'
        case 5: // '\005'
        case 6: // '\006'
        case 7: // '\007'
        case 9: // '\t'
        case 10: // '\n'
        case 11: // '\013'
        case 12: // '\f'
        case 13: // '\r'
        case 14: // '\016'
        case 15: // '\017'
        default:
            ret = getString();
            break;
        }
        return ret;
    }

    public final void setValue(Object value)
    {
        if(value == null)
        {
            setNull();
            return;
        }
        if(value instanceof String)
            setValue((String)value);
        else
        if(value instanceof Integer)
            setValue(((Integer)value).intValue());
        else
        if(value instanceof Long)
            setValue(((Long)value).longValue());
        else
        if(value instanceof Double)
            setValue(((Double)value).doubleValue());
        else
        if(value instanceof Boolean)
            setValue(((Boolean)value).booleanValue());
        else
        if(value instanceof Date)
            setValue((Date)value);
        else
            setValue(value.toString());
    }

    private final void typeConvert()
    {
        if(isNull)
        {
            setNull();
            return;
        }
        switch(setType)
        {
        case 0: // '\0'
            booleanValue = StringX.parseBoolean(stringValue);
            dateValue = StringX.parseDate(stringValue);
            Number n = null;
            try
            {
                n = Double.valueOf(stringValue.replaceAll(",", ""));
            }
            catch(NumberFormatException e1)
            {
                n = new Double(booleanValue ? 1.0D : 0.0D);
            }
            intValue = n.intValue();
            longValue = n.longValue();
            doubleValue = n.doubleValue();
            break;

        case 1: // '\001'
            stringValue = String.valueOf(intValue);
            longValue = intValue;
            doubleValue = intValue;
            booleanValue = intValue != 0;
            dateValue = new Date(intValue);
            break;

        case 2: // '\002'
            stringValue = String.valueOf(longValue);
            intValue = (int)longValue;
            doubleValue = longValue;
            booleanValue = longValue != 0L;
            dateValue = new Date(longValue);
            break;

        case 4: // '\004'
            stringValue = String.valueOf(doubleValue);
            intValue = (int)doubleValue;
            longValue = (long)doubleValue;
            booleanValue = doubleValue != 0.0D;
            dateValue = new Date(longValue);
            break;

        case 8: // '\b'
            stringValue = String.valueOf(booleanValue);
            intValue = booleanValue ? 1 : 0;
            longValue = intValue;
            doubleValue = intValue;
            dateValue = new Date(longValue);
            break;

        case 16: // '\020'
            stringValue = (new SimpleDateFormat("yyyy/MM/dd")).format(dateValue);
            longValue = dateValue.getTime();
            intValue = (int)longValue;
            doubleValue = longValue;
            booleanValue = longValue != 0L;
            break;

        case 3: // '\003'
        case 5: // '\005'
        case 6: // '\006'
        case 7: // '\007'
        case 9: // '\t'
        case 10: // '\n'
        case 11: // '\013'
        case 12: // '\f'
        case 13: // '\r'
        case 14: // '\016'
        case 15: // '\017'
        default:
            booleanValue = StringX.parseBoolean(stringValue);
            dateValue = StringX.parseDate(stringValue);
            Number n0 = null;
            try
            {
                n0 = Double.valueOf(stringValue.replaceAll(",", ""));
            }
            catch(NumberFormatException e1)
            {
                n0 = new Double(booleanValue ? 1.0D : 0.0D);
            }
            intValue = n0.intValue();
            longValue = n0.longValue();
            doubleValue = n0.doubleValue();
            break;
        }
    }

    public int compareTo(Object otherElement)
    {
        if(!(otherElement instanceof DataElement))
            if(isNull())
                return -1;
            else
                return getString().compareTo(otherElement.toString());
        DataElement f = (DataElement)otherElement;
        if(isNull() && f.isNull())
            return 0;
        if(isNull() && !f.isNull())
            return -2147483648;
        if(!isNull() && f.isNull())
            return 2147483647;
        if(type != f.type)
            return getString().compareTo(f.getString());
        int c = 0;
        switch(type)
        {
        case 1: // '\001'
            int ia = getInt();
            int ib = f.getInt();
            if(ia > ib)
            {
                c = 1;
                break;
            }
            if(ia < ib)
                c = -1;
            else
                c = 0;
            break;

        case 2: // '\002'
            long la = getLong();
            long lb = f.getLong();
            if(la > lb)
            {
                c = 1;
                break;
            }
            if(la < lb)
                c = -1;
            else
                c = 0;
            break;

        case 4: // '\004'
            double da = getDouble();
            double db = f.getDouble();
            if(da > db)
            {
                c = 1;
                break;
            }
            if(da < db)
                c = -1;
            else
                c = 0;
            break;

        case 8: // '\b'
            c = getInt() - f.getInt();
            break;

        case 16: // '\020'
            c = getDate().compareTo(f.getDate());
            break;

        default:
            c = getString().compareTo(f.getString());
            break;
        }
        return c;
    }

    public boolean equals(Object otherElement)
    {
        return compareTo(otherElement) == 0;
    }

    public String getProperty(String propName)
    {
        if(extendProperties == null || propName == null)
            return null;
        else
            return extendProperties.getProperty(propName);
    }

    public void setProperty(String propName, String propValue)
    {
        if(extendProperties == null)
            extendProperties = new Properties();
        extendProperties.setProperty(propName, propValue);
    }

    public String[] getProperties()
    {
        String p[] = new String[0];
        if(extendProperties != null)
            p = (String[])extendProperties.keySet().toArray(p);
        return p;
    }

    public static DataElement valueOf(String name, int value)
    {
        DataElement de = new DataElement(name, (byte)1);
        de.setValue(value);
        return de;
    }

    public static DataElement valueOf(String name, long value)
    {
        DataElement de = new DataElement(name, (byte)2);
        de.setValue(value);
        return de;
    }

    public static DataElement valueOf(String name, double value)
    {
        DataElement de = new DataElement(name, (byte)4);
        de.setValue(value);
        return de;
    }

    public static DataElement valueOf(String name, Date value)
    {
        DataElement de = new DataElement(name, (byte)16);
        de.setValue(value);
        return de;
    }

    public static DataElement valueOf(String name, boolean value)
    {
        DataElement de = new DataElement(name, (byte)8);
        de.setValue(value);
        return de;
    }

    public static DataElement valueOf(String name, String value)
    {
        DataElement de = new DataElement(name);
        de.setValue(value);
        return de;
    }

    public static DataElement valueOf(int value)
    {
        return valueOf(null, value);
    }

    public static DataElement valueOf(long value)
    {
        return valueOf(null, value);
    }

    public static DataElement valueOf(double value)
    {
        return valueOf(null, value);
    }

    public static DataElement valueOf(Date value)
    {
        return valueOf(null, value);
    }

    public static DataElement valueOf(String value)
    {
        return valueOf(null, value);
    }

    public static DataElement valueOf(boolean value)
    {
        return valueOf(null, value);
    }

    private static final long serialVersionUID = 1L;
    public static final byte STRING = 0;
    public static final byte INT = 1;
    public static final byte LONG = 2;
    public static final byte DOUBLE = 4;
    public static final byte BOOLEAN = 8;
    public static final byte DATE = 16;
    private String name;
    private byte type;
    private String label;
    private int length;
    private int scale;
    private Properties extendProperties;
    private int intValue;
    private double doubleValue;
    private Date dateValue;
    private String stringValue;
    private boolean booleanValue;
    private long longValue;
    private boolean isNull;
    private boolean converted;
    private byte setType;
    private static int unnamedCount = 0;

}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360тфел\workspace\ALS7\WebRoot\WEB-INF\lib\are-1.0b88-m1_g.jar
	Total time: 166 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/