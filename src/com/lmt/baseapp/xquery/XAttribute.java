/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.baseapp.xquery;

import java.util.Vector;

import com.lmt.baseapp.util.StringFunction;

public class XAttribute
{

    public XAttribute()
    {
    }

    public static String[][] setAttributeList(String as[][], Vector vector)
    {
        for(int i = 0; i < vector.size(); i++)
        {
            String as1[] = (String[])vector.get(i);
            StringFunction.setAttribute(as, as1[0], as1[1]);
        }

        return as;
    }

    public static String[][] setAttributeValue(String as[][], String s, String s1)
    {
        StringFunction.setAttribute(as, s, s1);
        return as;
    }

    public static String getAttributeValue(String as[][], String s)
    {
        return StringFunction.getAttribute(as, s);
    }
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\CCDSN\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 80 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/