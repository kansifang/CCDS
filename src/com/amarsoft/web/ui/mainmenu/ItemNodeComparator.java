/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.amarsoft.web.ui.mainmenu;

import java.io.Serializable;
import java.util.Comparator;

// Referenced classes of package com.amarsoft.web.ui.mainmenu:
//            ItemNode, MenuItem

class ItemNodeComparator
    implements Comparator, Serializable
{

    ItemNodeComparator()
    {
    }

    public int compare(ItemNode item1, ItemNode item2)
    {
        String sortNo1 = item1.getMenuItem().getSortNo();
        String sortNo2 = item2.getMenuItem().getSortNo();
        return sortNo1.compareTo(sortNo2);
    }

    public  int compare(Object x0, Object x1)
    {
        return compare((ItemNode)x0, (ItemNode)x1);
    }

    private static final long serialVersionUID = 1L;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\workspace\ALS7\WebRoot\WEB-INF\lib\awe-c2-b90-rc2_g.jar
	Total time: 104 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/