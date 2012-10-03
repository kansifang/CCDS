<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: RCZhu 2003.7.18
 * Tester:
 *
 * Content: ��ҳ���Top
 * Input Param:
 * Output param:
 *              Type:  ���ٲ�ѯ������
 *                     Customer      �����Ŵ��ͻ���Ϣ���ٲ�ѯ
 *                     Business      �����Ŵ�ҵ����Ϣ���ٲ�ѯ
 *                     Classify      ���շ�����Ϣ��ѯ
 *                      
 * History Log: 2003.07.18 RCZhu
 *              2003.08.10 XDHou
 *              2003.09.23 XDHou     ����subMenu��length����showlayer
 *              2004.01.14 FXie      ���ι������Ϲ���
 *		        2004.02.09 zbdeng    ɾ���ʲ���ȫ�����������ǵĲ˵������ҳ��
 *              2004.02.15 FXie      ����ۺ�ͳ��ģ��-�̶������ѯ,���ͳ�Ʋ�ѯ
 *              2004-5-13  cwzhan    ������������̨�ˡ���Ϊ������������� ,�ڡ��ۺ�ͳ�Ʋ�ѯ������������ծ�ʲ���ѯ���͡�������ѯ��
 */
%>
<%!
	public static boolean isRole(String sUserRole, String sMenuRole)
	{
		List  list = new ArrayList();
		String [] roles = sUserRole.split(",");
		for (int i =0; i < roles.length; i ++) {
			list.add(roles[i]);
		}
		return isRole(list,sMenuRole);
	}
	
	public static boolean isRole(List  roleList, String sMenuRole)
	{
		//System.out.println("isRole="+roleList);
		
		for (int i =0; i < roleList.size(); i ++) {
			String role = (String) roleList.get(i);
			if (sMenuRole.indexOf(role) != -1) {
				return true;
			}
		}
		return false;
	}

	public static List getRoles(String sUserID,Transaction Sqlca) throws Exception
	{
		String sSql =	" Select RoleId From USER_ROLE Where UserID='"+sUserID+"' ";
		List  list = new ArrayList();
		ASResultSet rs1 = Sqlca.getResultSet(sSql);
		while(rs1.next())
		{
			list.add(rs1.getString(1));
			//System.out.println(rs1.getString(1));
		}
		rs1.getStatement().close();			
		return list;
	}

	public static Vector genMenu(String sRightCond,String sUserID,Transaction Sqlca) throws Exception
	{
		String sMenuSql =	" Select  SortNo as OrderNo, ItemName as ModelName,ItemDescribe as MenuTarget,ItemNo as ModelID, RelativeCode  From CODE_LIBRARY Where CodeNo='MainMenu' ";
		String sOrderByClause = " Order by SortNo";
		return genMenu(sMenuSql,sUserID, sRightCond,sOrderByClause,Sqlca);
	}

	public static Vector genMenu(String sMenuSql,String sUserID,String sRightCond,String sOrderByClause,Transaction Sqlca) throws Exception
	{
		Vector vMenu = new Vector();
		String sSql1="";			
		ASResultSet rs1 = null;
		int iSelected=0,iSubCount1 =0,iMenu1=0;
		String sOrderNo1,sModelName1,sMenuTarget1;
	
		List list = getRoles(sUserID,Sqlca);
		String sRightCondNew = "";
		if(sRightCond!=null && sRightCond!="")
			sRightCondNew = " and (" + sRightCond + ")  ";
		
		vMenu.add("<script language=javascript> ");
		
		sSql1 =	sMenuSql + sRightCondNew + sOrderByClause;
		rs1 = Sqlca.getResultSet(sSql1);
		String sRunMode=ASConfigure.getASConfigure().getConfigure("RunMode");
		while(rs1.next())
		{
			//id,modelname,bSelect,onClick,haveSubCount
			sOrderNo1 = rs1.getString("OrderNo");
			sModelName1 = rs1.getString("ModelName");
			sMenuTarget1 = rs1.getString("MenuTarget");	

			if (!isRole(list,rs1.getString("RelativeCode"))) {
				if(!sRunMode.equals("Demonstration")){
					//������������еĲ˵��������������
					continue;
				}
			}
			
			vMenu.add("amarMenu["+iMenu1+"]=new Array('"+sOrderNo1+"','"+sModelName1+"',"+iSelected+",'"+sMenuTarget1+"',"+iSubCount1+");");	
			iMenu1++;
		}			
		rs1.getStatement().close();	
		
		vMenu.add("</script> ");

		return vMenu;
	}
%>
<%
java.util.Vector vMenu;
if(CurARC.getAttribute("SystemMenu")==null)
{	
	//�˵�Ȩ������
	vMenu = genMenu(" (isinuse is null or isinuse<>'2')", CurUser.UserID, Sqlca);
	CurARC.setAttribute("SystemMenu",vMenu);
}
else
	vMenu = (Vector)CurARC.getAttribute("SystemMenu");

for(int iMenu=0;iMenu<vMenu.size();iMenu++) 
	out.print((String)vMenu.get(iMenu));
%>

<table width="100%" border="0" cellspacing="0" cellpadding="0">  
  <tr align="center" > 
    <td colspan="2">
	<table border='0' cellspacing="0" cellpadding="0" width=100% class="menubgtable">
	  <tr>
	    <td valign="middle" class=menu6bg> 
		  <table border='0' cellpadding="0" cellspacing="0">
	      <tr> 
	        <td onMouseOver="showlayer(0,this)" class="menuTdLeft" > &nbsp;</td>
	          <td  class="menuTd" width="1">
				<script>
					genMenu();
				</script>				
		     </td>
	         <td class="menuTdRight"></td>
	      </tr>
	      </table>
	    </td>
	    <td onMouseOver="showlayer(0,this)">
	    <img class=menu6bg_right src="<%=sResourcesPath%>/1x1.gif" width="1" height="1">
	    </td>
	 </tr>
	</table>
    </td>
    <td id="coverselect">
    </td>
  </tr>
  <tr>  
            
    <td class=SystemArea valign="top" onMouseOver="showlayer(0,this)" width=1> 
      <%@include file="SystemArea.jsp"%>
    </td>
    <td class=SystemArea valign="top">
    	<iframe name=myrefresh0 frameborder=0 width=1 height=1 src="<%=sWebRootPath%>/SessionClose.jsp" style="display:none"> </iframe>
    </td>
            
  </tr>
</table>


