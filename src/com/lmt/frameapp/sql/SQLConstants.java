/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.sql;


public final class SQLConstants
{

    public SQLConstants()
    {
    }

    public static final int getSQLDataType(String s)
    {
        String s1 = s.toUpperCase();
        if(s1.equals("BIGINT"))
            return -5;
        if(s1.equals("BINARY"))
            return -2;
        if(s1.equals("BIT"))
            return -7;
        if(s1.equals("BLOB"))
            return 2004;
        if(s1.equals("BOOLEAN"))
            return 16;
        if(s1.equals("CHAR"))
            return 1;
        if(s1.equals("CLOB"))
            return 2005;
        if(s1.equals("DATALINK"))
            return 70;
        if(s1.equals("DATE"))
            return 91;
        if(s1.equals("DATETIME"))
            return 91;
        if(s1.equals("DECIMAL"))
            return 3;
        if(s1.equals("DISTINCT"))
            return 2001;
        if(s1.equals("DOUBLE"))
            return 8;
        if(s1.equals("FLOAT"))
            return 6;
        if(s1.equals("INT"))
            return 4;
        if(s1.equals("INTEGER"))
            return 4;
        if(s1.equals("JAVA_OBJECT"))
            return 2000;
        if(s1.equals("LONGVARBINARY"))
            return -4;
        if(s1.equals("LONGVARCHAR"))
            return -1;
        if(s1.equals("NULL"))
            return 0;
        if(s1.equals("NUMBER"))
            return 2;
        if(s1.equals("NUMERIC"))
            return 2;
        if(s1.equals("OTHER"))
            return 1111;
        if(s1.equals("REAL"))
            return 7;
        if(s1.equals("REF"))
            return 2006;
        if(s1.equals("SMALLINT"))
            return 5;
        if(s1.equals("STRUCT"))
            return 2002;
        if(s1.equals("TIME"))
            return 92;
        if(s1.equals("TIMESTAMP"))
            return 93;
        if(s1.equals("TINYINT"))
            return -6;
        if(s1.equals("VARBINARY"))
            return -3;
        if(s1.equals("VARCHAR"))
            return 12;
        if(s1.equals("VARCHAR2"))
            return 12;
        return !s1.equals("VCHAR") ? 1 : 12;
    }

    public static final String getSQLDataTypeName(int i)
    {
        if(i == -5)
            return "BIGINT";
        if(i == -2)
            return "BINARY";
        if(i == -7)
            return "BIT";
        if(i == 2004)
            return "BLOB";
        if(i == 16)
            return "BOOLEAN";
        if(i == 1)
            return "CHAR";
        if(i == 2005)
            return "CLOB";
        if(i == 70)
            return "DATALINK";
        if(i == 91)
            return "DATE";
        if(i == 3)
            return "DECIMAL";
        if(i == 2001)
            return "DISTINCT";
        if(i == 8)
            return "DOUBLE";
        if(i == 6)
            return "FLOAT";
        if(i == 4)
            return "INTEGER";
        if(i == 2000)
            return "JAVA_OBJECT";
        if(i == -4)
            return "LONGVARBINARY";
        if(i == -1)
            return "LONGVARCHAR";
        if(i == 0)
            return "NULL";
        if(i == 2)
            return "NUMERIC";
        if(i == 1111)
            return "OTHER";
        if(i == 7)
            return "REAL";
        if(i == 2006)
            return "REF";
        if(i == 5)
            return "SMALLINT";
        if(i == 2002)
            return "STRUCT";
        if(i == 92)
            return "TIME";
        if(i == 93)
            return "TIMESTAMP";
        if(i == -6)
            return "TINYINT";
        if(i == -3)
            return "VARBINARY";
        if(i == 12)
            return "VARCHAR";
        else
            return "CHAR";
    }

    public static final int getBaseDataType(String s)
    {
        String s1 = s.toUpperCase();
        if(s1.equals("CHAR"))
            return 0;
        if(s1.equals("VARCHAR"))
            return 0;
        if(s1.equals("STRING"))
            return 0;
        if(s1.equals("INT"))
            return 1;
        if(s1.equals("INTEGER"))
            return 1;
        if(s1.equals("LONG"))
            return 2;
        if(s1.equals("DOUBLE"))
            return 4;
        if(s1.equals("BOOLEAN"))
            return 8;
        if(s1.equals("BOOL"))
            return 8;
        if(s1.equals("DATE"))
            return 16;
        if(s1.equals("DATETIME"))
            return 16;
        return !s1.equals("OBJECT") ? 0 : 32;
    }

    public static final String getBaseDataTypeName(int i)
    {
        String s = "CHAR";
        switch(i)
        {
        case 1: // '\001'
            s = "INT";
            break;

        case 2: // '\002'
            s = "LONG";
            break;

        case 4: // '\004'
            s = "DOUBLE";
            break;

        case 8: // '\b'
            s = "BOOL";
            break;

        case 16: // '\020'
            s = "DATE";
            break;

        case 32: // ' '
            s = "OBJECT";
            break;
        }
        return s;
    }

    public static final int SQLTypeToBaseType(int i)
    {
        byte byte0 = 0;
        switch(i)
        {
        case -6: 
        case 4: // '\004'
        case 5: // '\005'
            byte0 = 1;
            break;

        case -5: 
            byte0 = 2;
            break;

        case 2: // '\002'
        case 3: // '\003'
        case 6: // '\006'
        case 7: // '\007'
        case 8: // '\b'
            byte0 = 4;
            break;

        case 91: // '['
        case 92: // '\\'
        case 93: // ']'
            byte0 = 16;
            break;

        case 16: // '\020'
            byte0 = 8;
            break;

        default:
            byte0 = 0;
            break;
        }
        return byte0;
    }

    public static final byte SQL_TYPE_SELECT = 0;
    public static final byte SQL_TYPE_UPDATE = 1;
    public static final byte SQL_TYPE_INSERT = 2;
    public static final byte SQL_TYPE_DELETE = 3;
    public static final byte SQL_TYPE_CREATE = 4;
    public static final byte SQL_TYPE_DROP = 5;
    public static final byte SQL_TYPE_ALTER = 6;
    public static final byte SQL_TYPE_COMMIT = 7;
    public static final byte SQL_TYPE_ROLLBACK = 8;
    public static final byte SQL_TYPE_CONNECT = 100;
    public static final byte SQL_TYPE_DISCONNECT = 101;
    public static final byte SQL_TYPE_SET_AUTOCOMMIT = 110;
    public static final byte SQL_TYPE_SET_TRANSACTION_ISOLATION = 111;
    public static final byte SQL_TYPE_HELP = 120;
    public static final byte SQL_TYPE_INVALID = -1;
    public static final byte RENDERER_DEFAULT = 0;
    public static final byte RENDERER_BOOLEAN = 2;
    public static final byte RENDERER_INTEGER = 3;
    public static final byte RENDERER_DOUBLE = 4;
    public static final byte RENDERER_STRING = 5;
    public static final byte RENDERER_PASSWORD = 6;
    public static final byte RENDERER_DATE = 7;
    public static final byte RENDERER_DATETIME = 8;
    public static final byte RENDERER_CODETABLE = 9;
    public static final byte RENDERER_CHECKBOX = 10;
    public static final byte RENDERER_CUSTOM = 100;
    public static final byte EDITOR_DEFAULT = 0;
    public static final byte EDITOR_BOOLEAN = 2;
    public static final byte EDITOR_INTEGER = 3;
    public static final byte EDITOR_DOUBLE = 4;
    public static final byte EDITOR_STRING = 5;
    public static final byte EDITOR_PASSWORD = 6;
    public static final byte EDITOR_DATE = 7;
    public static final byte EDITOR_DATETIME = 8;
    public static final byte EDITOR_CODETABLE = 9;
    public static final byte EDITOR_CHECKBOX = 10;
    public static final byte EDITOR_CUSTOM = 100;
    public static final int BASE_DATA_TYPE_STRING = 0;
    public static final int BASE_DATA_TYPE_INT = 1;
    public static final int BASE_DATA_TYPE_LONG = 2;
    public static final int BASE_DATA_TYPE_DOUBLE = 4;
    public static final int BASE_DATA_TYPE_BOOLEAN = 8;
    public static final int BASE_DATA_TYPE_DATE = 16;
    public static final int BASE_DATA_TYPE_OBJECT = 32;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360тфел\workspace\SXJS\WebRoot\WEB-INF\lib\are-0.2.jar
	Total time: 273 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/