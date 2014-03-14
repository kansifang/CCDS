/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.baseapp.xquery;

import java.util.Vector;

// Referenced classes of package com.amarsoft.xquery:
//            XAttribute

class XJoinClause
{

    public XJoinClause(Vector vector)
    {
        attributes = XAttribute.setAttributeList(attributes, vector);
    }

    public String getJoinItem()
        throws Exception
    {
        StringBuffer stringbuffer = new StringBuffer();
        String s = XAttribute.getAttributeValue(attributes, "srcRelatedDataObjectName");
        if(s != null && s.length() > 0)
            stringbuffer.append(s + ".");
        stringbuffer.append(XAttribute.getAttributeValue(attributes, "srcColumnName"));
        stringbuffer.append(" ");
        stringbuffer.append(XAttribute.getAttributeValue(attributes, "operator"));
        stringbuffer.append(" ");
        String s1 = XAttribute.getAttributeValue(attributes, "desRelatedDataObjectName");
        if(s1 != null && s1.length() > 0)
            stringbuffer.append(s1 + ".");
        stringbuffer.append(XAttribute.getAttributeValue(attributes, "desColumnName"));
        return stringbuffer.toString();
    }

    public String attributes[][] = {
        {
            "srcRelatedDataObjectName", ""
        }, {
            "srcColumnName", ""
        }, {
            "operator", ""
        }, {
            "desRelatedDataObjectName", ""
        }, {
            "desColumnName", ""
        }
    };
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\CCDSN\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 75 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/