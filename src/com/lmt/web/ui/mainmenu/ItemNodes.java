/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.web.ui.mainmenu;

import java.util.ArrayList;

// Referenced classes of package com.amarsoft.web.ui.mainmenu:
//            ItemNode

public class ItemNodes
{

    public ItemNodes()
    {
        nodes = new ArrayList();
        point = 0;
    }

    public void addNode(ItemNode o)
    {
        nodes.add(o);
    }

    public Object getNode(int i)
    {
        if(i >= nodes.size())
            return null;
        else
            return nodes.get(i);
    }

    public Object getNextNode()
    {
        return getNode(point++);
    }

    public boolean hasNextNode()
    {
        return point < getNodesNumber() - 1;
    }

    public int getNodesNumber()
    {
        return nodes.size();
    }

    public void resetPoint()
    {
        point = 0;
    }

    private ArrayList nodes;
    private int point;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\workspace\ALS7\WebRoot\WEB-INF\lib\awe-c2-b90-rc2_g.jar
	Total time: 108 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/