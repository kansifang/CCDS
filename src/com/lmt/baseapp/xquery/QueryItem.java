/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.baseapp.xquery;


class QueryItem
{

    public QueryItem(String s)
    {
        Order = 0;
        Name = s;
    }

    public QueryItem(String s, String s1, String s2, String s3, String s4, String s5, int i)
    {
        Order = 0;
        Name = s;
        Value = s1;
        Type = s2;
        Usage = s3;
        Operator = s4;
        Content = s5;
        Order = i;
    }

    public String Name;
    public String Value;
    public String Type;
    public String Usage;
    public String Operator;
    public String Content;
    public int Order;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\CCDSN\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 72 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/