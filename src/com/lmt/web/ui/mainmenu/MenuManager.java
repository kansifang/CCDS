/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.web.ui.mainmenu;

import java.util.ArrayList;

import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

// Referenced classes of package com.amarsoft.web.ui.mainmenu:
//            MenuItem

public class MenuManager
{

    public MenuManager()
    {
    }

    public static boolean isRole(String sUserRole, String sMenuRole)
    {
        ArrayList list = new ArrayList();
        String roles[] = sUserRole.split(",");
        for(int i = 0; i < roles.length; i++)
            list.add(roles[i]);

        return isRole(list, sMenuRole);
    }

    public static boolean isRole(ArrayList roleList, String sMenuRole)
    {
        for(int i = 0; i < roleList.size(); i++)
        {
            String role = (String)roleList.get(i);
            if(sMenuRole.indexOf(role) != -1)
                return true;
        }

        return false;
    }

    public static ArrayList getRoles(String sUserID, Transaction Sqlca)
        throws Exception
    {
        String sSql = (new StringBuilder()).append(" Select RoleId From USER_ROLE Where UserID='").append(sUserID).append("' ").toString();
        ArrayList list = new ArrayList();
        ASResultSet rs;
        for(rs = Sqlca.getResultSet(sSql); rs.next(); list.add(rs.getString(1)));
        rs.getStatement().close();
        return list;
    }

    public static ArrayList genMenu(String sUserID, String sRightCond, Transaction Sqlca)
        throws Exception
    {
        String sMenuSql = " select MenuID,MenuName,IsInUse,SortNo,CompID,Path,Parameter,Target,Style,attribute1,attribute2 as Icon,attribute3 as AppIcon,IsInUse From SYSTEM_MENU Where 1=1 ";
        String sOrderByClause = " Order by SortNo asc";
        return genMenu(sMenuSql, sRightCond, sUserID, sOrderByClause, Sqlca);
    }

    public static ArrayList genMenu(String sMenuSql, String sRightCond, String sUserID, String sOrderByClause, Transaction Sqlca)
        throws Exception
    {
        ArrayList itemList = new ArrayList();
        ArrayList list = getRoles(sUserID, Sqlca);
        String sRightCondNew = "";
        if(sRightCond != null && sRightCond != "")
            sRightCondNew = (new StringBuilder()).append(" and (").append(sRightCond).append(")  ").toString();
        String sSql = (new StringBuilder()).append(sMenuSql).append(sRightCondNew).append(sOrderByClause).toString();
        ASResultSet rs;
        MenuItem menuItem;
        for(rs = Sqlca.getResultSet(sSql); rs.next(); itemList.add(menuItem))
        {
            String sortColumn = rs.getString("SortNo");
            String idColumn = rs.getString("MenuID");
            String labelColumn = rs.getString("MenuName");
            String visiableColunm = rs.getString("IsInUse");
            String attribute = rs.getString("attribute1");
            String icon = rs.getString("Icon");
            String appIcon = rs.getString("AppIcon");
            String compID = rs.getString("CompID");
            String path = rs.getString("Path");
            String parameter = rs.getString("Parameter");
            String target = rs.getString("Target");
            String style = rs.getString("Style");
            String isInUse = rs.getString("IsInUse");
            boolean visible = "1".equals(isInUse);
            compID = compID != null ? compID : "";
            path = path != null ? path : "";
            parameter = parameter != null ? (new StringBuilder()).append(parameter).append("").toString() : "";
            target = target != null ? target : "self";
            style = style != null ? style : "";
            String scriptColumn = null;
            if(compID.length() > 0 || path.length() > 0)
                scriptColumn = (new StringBuilder()).append("OpenComp(\"").append(compID).append("\",\"").append(path).append("\",\"").append(parameter).append("\",\"").append(target).append("\",\"").append(style).append("\")").toString();
            else
                scriptColumn = "";
            if(attribute == null)
                attribute = "";
            if(!isRole(list, attribute))
            {
                if(!visible);
                visible = false;
            } else
            {
                visible = visible;
            }
            sortColumn = sortColumn != null ? sortColumn : "";
            idColumn = idColumn != null ? idColumn : "";
            labelColumn = labelColumn != null ? labelColumn : "";
            visiableColunm = visiableColunm != null ? visiableColunm : "";
            scriptColumn = scriptColumn != null ? scriptColumn : "";
            attribute = attribute != null ? attribute : "";
            menuItem = new MenuItem(idColumn, sortColumn, labelColumn, icon, scriptColumn, "", "", labelColumn, appIcon, visible);
        }

        rs.getStatement().close();
        return itemList;
    }
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\workspace\ALS7\WebRoot\WEB-INF\lib\awe-c2-b90-rc2_g.jar
	Total time: 108 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/