/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.baseapp.xquery;

import java.util.Vector;

// Referenced classes of package com.amarsoft.xquery:
//            XDataObject, XAttribute

class XRelatedDataObject
{

    public XRelatedDataObject(Vector vector, String s)
        throws Exception
    {
        attributes = XAttribute.setAttributeList(attributes, vector);
        dataObject = new XDataObject(s, XAttribute.getAttributeValue(attributes, "dataObjectName"));
    }

    public String getFromItem()
        throws Exception
    {
        String s = XAttribute.getAttributeValue(attributes, "joinType") + " " + XAttribute.getAttributeValue(attributes, "dataObjectName") + " " + XAttribute.getAttributeValue(attributes, "name");
        return s;
    }

    public String attributes[][] = {
        {
            "name", ""
        }, {
            "caption", ""
        }, {
            "dataObjectName", ""
        }, {
            "type", ""
        }, {
            "joinType", ""
        }
    };
    public XDataObject dataObject;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\CCDSN\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 76 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/