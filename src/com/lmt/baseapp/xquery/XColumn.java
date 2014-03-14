/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.baseapp.xquery;

import java.util.Vector;

import com.lmt.baseapp.util.StringFunction;

// Referenced classes of package com.amarsoft.xquery:
//            XAttribute

class XColumn
{

    public XColumn(Vector vector)
    {
        attributes = XAttribute.setAttributeList(attributes, vector);
    }

    public boolean isFuncOrSP()
        throws Exception
    {
        String s = XAttribute.getAttributeValue(attributes, "name");
        return StringFunction.indexOf(s, ".", "'", "'", 0) > 0;
    }

    public String attributes[][] = {
        {
            "name", ""
        }, {
            "alias", ""
        }, {
            "type", ""
        }, {
            "header", ""
        }, {
            "dataType", "String"
        }, {
            "tag", ""
        }, {
            "code", ""
        }
    };
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\CCDSN\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 71 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/