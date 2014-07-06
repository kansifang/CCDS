/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.web.ui.mainmenu;

import java.io.Serializable;

public class MenuItem
    implements Serializable
{

    public MenuItem(String menuID, String sortNo, String menuName, String icon, String url, String urlParam, String accessType, 
            String displayName)
    {
        this(menuID, sortNo, menuName, icon, url, urlParam, accessType, displayName, "", true);
    }

    public MenuItem(String menuID, String sortNo, String menuName, String icon, String url, String urlParam, String accessType, 
            String displayName, String appIcon, boolean visible)
    {
        setMenuID(menuID);
        setSortNo(sortNo);
        setMenuName(menuName);
        setIcon(icon);
        setUrl(url);
        setUrlParam(urlParam);
        setAccessType(accessType);
        setDisplayName(displayName);
        setAppIcon(appIcon);
        setVisible(visible);
    }

    public String getMenuID()
    {
        return menuID;
    }

    public void setMenuID(String menuID)
    {
        this.menuID = menuID;
    }

    public void setSortNo(String sortNo)
    {
        this.sortNo = sortNo;
    }

    public String getSortNo()
    {
        return sortNo;
    }

    public String getMenuName()
    {
        return menuName;
    }

    public void setMenuName(String menuName)
    {
        this.menuName = menuName;
    }

    public String getIcon()
    {
        if(icon == null)
            return "";
        else
            return icon;
    }

    public void setIcon(String icon)
    {
        this.icon = icon;
    }

    public String getAppIcon()
    {
        if(appIcon == null)
            return "";
        else
            return appIcon;
    }

    public void setAppIcon(String appIcon)
    {
        this.appIcon = appIcon;
    }

    public String getUrl()
    {
        return url;
    }

    public void setUrl(String url)
    {
        this.url = url;
    }

    public String getUrlParamClear()
    {
        if(urlParam == null)
            return "IsMenuItem=Y";
        else
            return (new StringBuilder()).append("IsMenuItem=Y&").append(urlParam).toString();
    }

    public String getUrlParam()
    {
        if(urlParam == null)
            return "ToDestroyAllComponent=Y&IsMenuItem=Y";
        else
            return (new StringBuilder()).append("ToDestroyAllComponent=Y&IsMenuItem=Y&").append(urlParam).append("&DisplayName=").append(displayName).toString();
    }

    public void setUrlParam(String urlParam)
    {
        this.urlParam = urlParam;
    }

    public String getAccessType()
    {
        return accessType;
    }

    public void setAccessType(String accessType)
    {
        this.accessType = accessType;
    }

    public String getDisplayName()
    {
        if(displayName == null || displayName.trim().equals(""))
            return getMenuName();
        else
            return displayName;
    }

    public void setDisplayName(String displayName)
    {
        this.displayName = displayName;
    }

    public String getScript()
    {
        return getUrl();
    }

    public String getDescribe()
    {
        return describe;
    }

    public void setDescribe(String describe)
    {
        this.describe = describe;
    }

    public boolean isVisible()
    {
        return visible;
    }

    public void setVisible(boolean visible)
    {
        this.visible = visible;
    }

    public String toString()
    {
        StringBuffer sbf = new StringBuffer();
        sbf.append("MenuID=[");
        sbf.append(getMenuID());
        sbf.append("] SortNo=[");
        sbf.append(getSortNo());
        sbf.append("] MenuName=[");
        sbf.append(getMenuName());
        sbf.append("] Icon=[");
        sbf.append(getIcon());
        sbf.append("] Url=[");
        sbf.append(getUrl());
        sbf.append("] UrlParam=[");
        sbf.append(getUrlParam());
        return sbf.toString();
    }

    private static final long serialVersionUID = 1L;
    private String menuID;
    private String sortNo;
    private String menuName;
    private String icon;
    private String appIcon;
    private String url;
    private String urlParam;
    private String accessType;
    private String displayName;
    private String describe;
    private boolean visible;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\workspace\ALS7\WebRoot\WEB-INF\lib\awe-c2-b90-rc2_g.jar
	Total time: 106 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/