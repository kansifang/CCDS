/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.amarsoft.web.ui.mainmenu;

import java.io.Serializable;
import java.util.ArrayList;

// Referenced classes of package com.amarsoft.web.ui.mainmenu:
//            MenuItem

public class ItemNode
    implements Serializable
{

    public ItemNode(MenuItem item)
    {
        childCursor = 0;
        childNodes = new ArrayList();
        this.item = item;
    }

    public int getChildsNumber()
    {
        return childNodes.size();
    }

    public ItemNode addChildNode(ItemNode m)
    {
        childNodes.add(m);
        return this;
    }

    public ItemNode removeChild(int index)
    {
        ItemNode item = null;
        if(index < getChildsNumber())
            item = (ItemNode)childNodes.remove(index);
        return item;
    }

    public ItemNode getChildNode(int index)
    {
        ItemNode item = null;
        if(index < getChildsNumber())
            item = (ItemNode)childNodes.get(index);
        return item;
    }

    public ItemNode getNextChildNode()
    {
        ItemNode item = null;
        if(childCursor < getChildsNumber())
            return getChildNode(childCursor++);
        else
            return item;
    }

    public boolean hasNextChildNode()
    {
        return childCursor < getChildsNumber() - 1;
    }

    public String getId()
    {
        return item.getMenuID();
    }

    public String getLabel()
    {
        return item.getMenuName();
    }

    public String getIcon()
    {
        return item.getIcon();
    }

    public String getScript()
    {
        return item.getScript();
    }

    MenuItem getMenuItem()
    {
        return item;
    }

    public String toString()
    {
        return item.toString();
    }

    private static final long serialVersionUID = 1L;
    MenuItem item;
    private int childCursor;
    private ArrayList childNodes;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\workspace\ALS7\WebRoot\WEB-INF\lib\awe-c2-b90-rc2_g.jar
	Total time: 122 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/