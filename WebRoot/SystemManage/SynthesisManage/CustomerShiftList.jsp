<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Describe: �ͻ�����_List
			Input Param:
		              --sComponentName:�������
			Output Param:
			
			HistoryLog:
			--fbkang on 2005/08/14 
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "�ͻ�����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������壺SQL���
	 String sSql = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	//�����б���ʾ����			
	String sHeaders[][] = {
					{"Status","�Ƿ񽻽�"},
					{"CustomerID","�ͻ����"},								
					{"CustomerName","�ͻ�����"},
					{"CustomerType","�ͻ�����"},
					{"OrgName","�ܻ�����"},
					{"UserName","�ܻ��ͻ�����"}							
		          };
   
   sSql = " select '' as Status,CI.CustomerID,CI.CustomerName,CB.OrgID, "+
   		  " getItemName('CustomerType',CI.CustomerType) as CustomerType, "+
   		  " getOrgName(CB.OrgID) as OrgName,CB.UserID,getUserName(CB.UserID) as UserName "+
          " from CUSTOMER_BELONG CB, CUSTOMER_INFO CI where CB.CustomerID = CI.CustomerID "+
          " and exists (select OI.OrgID from ORG_INFO OI where OI.OrgID = CB.OrgID "+
          " and OI.SortNo like '"+CurOrg.SortNo+"%') and CB.BelongAttribute = '1' ";

  	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ÿɸ���Ŀ���
	doTemp.UpdateTable = "CUSTOMER_INFO";
	//��������
	doTemp.setKey("CustomerID",true);
	//�����ֶ��Ƿ�ɼ�
	doTemp.setVisible("OrgID,UserID",false);
	
	//����html���
	doTemp.setAlign("Status","2");
	//doTemp.setHTMLStyle("Status","style={width:60px}  oncontextmenu=\"javascript:parent.onRightClickStatus()\"");
	doTemp.appendHTMLStyle("Status"," style={width:60px} ondblclick=\"javascript:parent.onDBClick()\" ");	
    doTemp.setHTMLStyle("CustomerName"," style={width:200px}");
		
	//���ɲ�ѯ����
	doTemp.setColumnAttribute("CustomerName,CustomerID,UserName,OrgName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/
%>
	<%
		//����Ϊ��
			//0.�Ƿ���ʾ
			//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
			//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
			//3.��ť����
			//4.˵������
			//5.�¼�
			//6.��ԴͼƬ·��
		String sButtons[][] = {
		{"true","","Button","����","���ӿͻ���Ϣ","transferCustomer()",sResourcesPath},
		{"true","","PlainText","(˫�����ѡ��/ȡ�� �Ƿ񽻽�)","(˫�����ѡ���ȡ�� �Ƿ񽻽�)","style={color:red}",sResourcesPath}		
			};
	%> 
<%
 	/*~END~*/
 %>


<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
<script language="javascript">
	
	/*~[Describe=�һ�ѡ���轻�ӵĿͻ�;InputParam=��;OutPutParam=��;]~*/
	function onDBClick()
	{
		sStatus = getItemValue(0,getRow(),"Status") ;
		if (typeof(sStatus)=="undefined" || sStatus=="")
			setItemValue(0,getRow(),"Status","��");
		else
			setItemValue(0,getRow(),"Status","");

	}
	
	/*~[Describe=ѡ���¼;InputParam=��;OutPutParam=��;]~*/
	function selectRecord()
	{
		var b = getRowCount(0);
		var iCount = 0;				
		for(var i = 0 ; i < b ; i++)
		{
			var a = getItemValue(0,i,"Status");
			if(a == "��")
				iCount = iCount + 1;
		}
		
		if(iCount == 0)
		{
			alert(getHtmlMessage('24'));//������ѡ��һ����Ϣ��
			return false;
		}
		
		return true;
	}

	/*~[Describe=���ӿͻ�;InputParam=��;OutPutParam=��;]~*/
	function transferCustomer()
    {    	
    	if(!selectRecord()) return;
    	if (confirm(getBusinessMessage("942")))//ȷ�Ͻ��Ӹÿͻ���
    	{			
			var sCustomerID = "";
			var sFromOrgID = "";
			var sFromOrgName = "";
			var sFromUserID = "";
			var sFromUserName = "";
			var sToUserID = "";
			var sToUserName = "";
			//��ȡ�����û�			
			sSortNo = "<%=CurOrg.SortNo%>";
			sParaStr = "SortNo,"+sSortNo;
			sUserInfo = setObjectValue("SelectUserInOrg",sParaStr,"",0,0);		
		    if(sUserInfo == "" || sUserInfo == "_CANCEL_" || sUserInfo == "_NONE_" || sUserInfo == "_CLEAR_" || typeof(sUserInfo) == "undefined") 
		    {
			    //alert(getBusinessMessage("943"));//��ѡ�񽻽Ӻ�Ŀͻ�����
			    return;
		    }else
		    {
			    sUserInfo = sUserInfo.split('@');
			    sToUserID = sUserInfo[0];
			    sToUserName = sUserInfo[1];			    
		   
				//��ȡ������Ϣ����,����ͬʱѡ�������¼���ӵģ��˴�ѡ��ֻ����һ��	
				sChangeObject = PopPage("/SystemManage/SynthesisManage/CustomerShiftDialog.jsp","","dialogWidth=24;dialogHeight=16;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 					
				if(sChangeObject != "_CANCEL_" && typeof(sChangeObject) != "undefined")
				{
					//���ж��Ƿ�������һ���ͻ���ѡ���������ˡ����е��ҳ���
					var b = getRowCount(0);
					for(var i = 0 ; i < b ; i++)
					{
						var a = getItemValue(0,i,"Status");
						if(a == "��")
						{
							sCustomerID = getItemValue(0,i,"CustomerID");	
							sFromOrgID = getItemValue(0,i,"OrgID");
							sFromOrgName = getItemValue(0,i,"OrgName");
							sFromUserID = getItemValue(0,i,"UserID");
							sFromUserName = getItemValue(0,i,"UserName");
							if(sFromUserID == sToUserID)
							{
								alert(getBusinessMessage("944"));//��������ͬһ�ͻ��������пͻ����Ӳ�����������ѡ�񽻽Ӻ�Ŀͻ�����
								return;						
							}
						
							//����ҳ�����
							sReturn = PopPage("/SystemManage/SynthesisManage/CustomerShiftAction.jsp?CustomerID="+sCustomerID+"&FromOrgID="+sFromOrgID+"&FromOrgName="+sFromOrgName+"&FromUserID="+sFromUserID+"&FromUserName="+sFromUserName+"&ToUserID="+sToUserID+"&ToUserName="+sToUserName+"&ChangeObject="+sChangeObject,"","dialogWidth=21;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 
							if(sReturn == "TRUE")
								alert("�ͻ����("+sCustomerID+"),"+getBusinessMessage("945"));//�ͻ����ӳɹ���
							else if(sReturn == "FALSE")
								alert("�ͻ����("+sCustomerID+"),"+getBusinessMessage("946"));//�ͻ�����ʧ�ܣ�
							else if(sReturn == "UNFINISHAPPLY")
								alert("�ͻ����("+sCustomerID+")��������;ҵ������,"+getBusinessMessage("957"));//���ȴ�������;ҵ�������ٽ��пͻ����ӣ�
						}	
					}
				}
				reloadSelf();
			}
		}
	}	

</script>

<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%
	/*~END~*/
%>


<%@ include file="/IncludeEnd.jsp"%>
