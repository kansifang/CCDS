/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.baseapp.xquery;

import java.util.Vector;
import org.w3c.dom.Node;

// Referenced classes of package com.amarsoft.xquery:
//            XmlDocument, XConditionColumn, XAttribute

public class XConditionMap extends XmlDocument
{

    public XConditionMap(Vector vector, Node node)
        throws Exception
    {
        super(node);
        conditionColumns = new Vector();
        attributes = XAttribute.setAttributeList(attributes, vector);
        Vector vector1 = super.getNodeList("ConditionColumns", "ConditionColumn", node);
        for(int i = 0; i < vector1.size(); i++)
        {
            Node node1 = (Node)vector1.get(i);
            vector = getAttributeList(node1);
            conditionColumns.addElement(new XConditionColumn(vector));
        }

    }

    private static final long serialVersionUID = 1L;
    public String attributes[][] = {
        {
            "caption", ""
        }, {
            "totalColumns", "6"
        }, {
            "defaultColspan", "2"
        }, {
            "defaultColspanForLongType", "4"
        }, {
            "defaultPosition", ""
        }
    };
    public Vector conditionColumns;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\CCDSN\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 76 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/