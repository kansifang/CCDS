<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   slliu 2004.11.22
		Tester:
		Content: �����˱��������Ϣ
		Change Param:
				ObjectNo: ������
				ObjectType����������
				SerialNo�������¼��ˮ��
				ManageUserID��ԭ������
				ManageOrgID��ԭ�������		       		
		Output param:
		               
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����˱��������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	String sSerialNo = "";  	//��¼��ˮ��
	String sManageUserID = ""; 	//ԭ������
	String sManageOrgID = "";	//ԭ�������
	String sUserName = "";  	//ԭ����������
	String sOrgName = "";	//ԭ�����������
	String sObjectNo = "";	//������
	String sObjectType = "";	//��������
	String sTableName = "";
	
	//���ҳ�����
	//�����¼��ˮ��
	sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));  
	//ԭ������,ԭ�������
	sManageUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ManageUserID"));  
	sManageOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ManageOrgID"));  
    //ԭ����������,ԭ�����������
	sUserName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserName"));  
	sOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgName"));  
    //�����ţ�������ţ�,��������
	sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	String sFlag = DataConvert.toRealString(iPostChange,request.getParameter("Flag"));
	
	if(sFlag==null) sFlag="";
		
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = { 		
	    					{"SerialNo","�����¼��ˮ��"},
	    					{"OldUserName","ԭ������Ա"},
	    					{"OldOrgName","ԭ�������"},  					
							{"NewUserName","�ֹ�����Ա"},
							{"NewOrgName","�ֹ������"}, 					
							{"ChangeReason","���ԭ��"},
							{"ChangeDate","�������"},
							{"Remark","��ע"},
							{"ChangeUserName","�����"},
							{"ChangeOrgName","�������"},
							{"ChangeTime","�������"}						
						}; 

	sSql = 	" select SerialNo,ObjectNo,ObjectType, "+
			" OldUserID,getUserName(OldUserID) as OldUserName, "+
			" OldOrgID,getOrgName(OldOrgID) as OldOrgName, "+
			" NewUserID,getUserName(NewUserID) as NewUserName, "+
			" NewOrgID,getOrgName(NewOrgID) as NewOrgName, "+
			" ChangeReason,Remark, "+
			" ChangeUserID,getUserName(ChangeUserID) as ChangeUserName, "+
			" ChangeOrgID,getOrgName(ChangeOrgID) as ChangeOrgName,ChangeTime "+
			" from MANAGE_CHANGE "+
			" where SerialNo = '"+sSerialNo+"'  "+
			" and ObjectNo = '"+sObjectNo+"'  "+	//�����ţ�������Ż��ծ�ʲ���ţ�
			" and ObjectType = '"+sObjectType+"' ";	//�������ͣ�����ΪLawcaseInfo��
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "MANAGE_CHANGE";	
	doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);	 //���ùؼ���
	
	//���ò��ɸ���
	doTemp.setUpdateable("ChangeUserName,ChangeOrgName,NewOrgName,NewUserName",false);
	doTemp.setUpdateable("OldUserName,OldOrgName",false);	
	//��������
	doTemp.setCheckFormat("ChangDate,ChangeDate","3");
	//���ù��ø�ʽ
	doTemp.setVisible("OldUserID,OldOrgID,NewUserID,NewOrgID",false);
	doTemp.setVisible("ChangeUserID,ChangeOrgID",false);
	doTemp.setVisible("SerialNo,ObjectNo,ObjectType",false);
	//����ֻ��
	doTemp.setReadOnly("SerialNo,OldUserName,OldOrgName,ChangeUserName,ChangeOrgName,NewUserName,NewOrgName,ChangeTime",true);
	//���ñ�����
	doTemp.setRequired("NewUserName,NewMOrgName,ChangeReason",true);	
	//���ó���
	doTemp.setLimit("Remark",100);
	doTemp.setLimit("ChangeReason",100);
	//���ñ༭��ʽ����ı���
	doTemp.setEditStyle("ChangeReason","3");
	doTemp.setEditStyle("Remark","3");	
	//ѡ�����û�
	doTemp.setUnit("NewUserName"," <input type=button class=inputDate  value=... name=button onClick=\"javascript:parent.getNewUserName()\">");
	doTemp.appendHTMLStyle("NewUserName","  style={cursor:hand;background=\"#EEEEff\"} ondblclick=\"javascript:parent.getNewUserName()\" ");
	//����ѡ���п�
	doTemp.setHTMLStyle("OldUserName,NewUserName,ChangeDate,ChangeUserName,ChangeTime"," style={width:80px} ");
	doTemp.setHTMLStyle("OldOrgName,ChangeOrgName"," style={width:250px} ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����ʱ�����¼�
	//��������¼���Ҫ����ı�
	sTableName = "LAWCASE_INFO";
	dwTemp.setEvent("AfterInsert","!BusinessManage.ChangeManagerAction("+sObjectNo+",#NewUserID,#NewOrgID,"+sTableName+")");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo+","+sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
		
	if(sFlag.equals("Y")) 
	{
		sButtons[0][0]="false";
	}
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	
	<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;ChangeParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		
	}
	
	/*~[Describe=�����б�ҳ��;ChangeParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		var Flag="<%=sFlag%>";
		if(Flag=='Y') 
			OpenPage("/RecoveryManage/LawCaseManage/LawCaseHistoryChangeList.jsp","right","");
		else
			OpenPage("/RecoveryManage/LawCaseManage/LawCaseManagerChangeList.jsp","right","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;ChangeParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{
		sOldUserID = getItemValue(0,getRow(),"OldUserID");//ԭ������Ա			
		sNewUserID = getItemValue(0,getRow(),"NewUserID");//�ֹ�����Ա
		if(typeof(sOldUserID) != "undefined" && sOldUserID != "" && 
		typeof(sNewUserID) != "undefined" && sNewUserID != "")
		{
			if(sOldUserID == sNewUserID)
			{
				alert(getBusinessMessage("750"))//�ֹ�����Ա������ԭ������Ա��ͬ��
				return false;
			}
		}
		return true;
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;ChangeParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼			
			//��¼��ˮ��
			setItemValue(0,0,"SerialNo","<%=sSerialNo%>");			
			//�����š���������
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");			
			//ԭ�����ˡ�ԭ���������ơ�ԭ���������ԭ�����������
			setItemValue(0,0,"OldUserID","<%=sManageUserID%>");
			setItemValue(0,0,"OldUserName","<%=sUserName%>");
			setItemValue(0,0,"OldOrgID","<%=sManageOrgID%>");
			setItemValue(0,0,"OldOrgName","<%=sOrgName%>");		
			//�Ǽ��ˡ��Ǽ������ơ��Ǽǻ������Ǽǻ�������
			setItemValue(0,0,"ChangeUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"ChangeUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"ChangeOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"ChangeOrgName","<%=CurOrg.OrgName%>");			
			//�Ǽ�����						
			setItemValue(0,0,"ChangeTime","<%=StringFunction.getToday()%>");			
		}
    }
    	
    /*~[Describe=�����û�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/	
	function getNewUserName()
	{
		sParaString = "BelongOrg"+","+"<%=CurOrg.OrgID%>";
		setObjectValue("SelectUserLaw",sParaString,"@NewUserID@0@NewUserName@1@NewOrgID@2@NewOrgName@3",0,0,"");
	}

	</script>
	
	

<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

