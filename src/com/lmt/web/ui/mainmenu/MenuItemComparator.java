/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.web.ui.mainmenu;

import java.io.Serializable;
import java.util.Comparator;

// Referenced classes of package com.amarsoft.web.ui.mainmenu:
//            MenuItem

class MenuItemComparator
    implements Comparator, Serializable
{

    MenuItemComparator()
    {
    }

    public int compare(MenuItem item1, MenuItem item2)
    {
        String sortNo1 = item1.getSortNo();
        String sortNo2 = item2.getSortNo();
        return sortNo1.compareTo(sortNo2);
    }

    public  int compare(Object x0, Object x1)
    {
        return compare((MenuItem)x0, (MenuItem)x1);
    }

    private static final long serialVersionUID = 1L;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\workspace\ALS7\WebRoot\WEB-INF\lib\awe-c2-b90-rc2_g.jar
	Total time: 108 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/