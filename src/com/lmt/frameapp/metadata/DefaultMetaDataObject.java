/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.metadata;

import java.util.Properties;
import java.util.Set;

// Referenced classes of package com.amarsoft.are.metadata:
//            MetaDataObject

public class DefaultMetaDataObject
    implements MetaDataObject
{

    protected DefaultMetaDataObject()
    {
        name = "unnamed";
        label = "no label";
        describe = "no describe";
    }

    protected DefaultMetaDataObject(String s)
    {
        this(s, s, s);
    }

    protected DefaultMetaDataObject(String s, String s1)
    {
        this(s, s1, s1);
    }

    protected DefaultMetaDataObject(String s, String s1, String s2)
    {
        name = s;
        label = s;
        describe = s;
    }

    public final String getName()
    {
        return name;
    }

    public final void setName(String s)
    {
        name = s;
    }

    public final String getDescribe()
    {
        return describe;
    }

    public final void setDescribe(String s)
    {
        describe = s;
    }

    public final String getLabel()
    {
        return label;
    }

    public final void setLabel(String s)
    {
        label = s;
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

    public String[] getProperties()
    {
        String as[] = new String[0];
        if(extendProperties != null)
            as = (String[])extendProperties.keySet().toArray(as);
        return as;
    }

    private String name;
    private String label;
    private String describe;
    private Properties extendProperties;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360тфел\workspace\SXJS\WebRoot\WEB-INF\lib\are-0.2.jar
	Total time: 170 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/