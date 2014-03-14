/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.baseapp.xquery;

import java.util.Vector;

// Referenced classes of package com.amarsoft.xquery:
//            XAttribute

class XConditionColumn
{

    public XConditionColumn(Vector vector)
    {
        attributes = XAttribute.setAttributeList(attributes, vector);
    }

    public String attributes[][] = {
        {
            "position", ""
        }, {
            "relatedDataObject", ""
        }, {
            "columnName", ""
        }, {
            "colspan", ""
        }, {
            "exceptcolumnName", ""
        }
    };
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\CCDSN\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 76 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/