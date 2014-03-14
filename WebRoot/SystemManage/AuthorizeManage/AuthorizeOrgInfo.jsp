<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: wwhe	2006-09-04
			Tester:
			Describe: ������Ȩά��
			Input Param:
					OrgID:		������
					RoleID:		��ɫ��
					ObjectNo:	��Ȩ�������к�
			Output Param:
			HistoryLog: 
				 
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "ҵ��Ʒ��ȷ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql = "";
	
	//���ҳ�����
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgID"));
	String sRoleID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RoleID"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	
	//����ֵת��Ϊ���ַ���
	if(sOrgID == null) sOrgID = "";
	if(sRoleID == null) sRoleID = "";
	if(sObjectNo == null) sObjectNo = "";
	
	String sAType= DataConvert.toRealString(iPostChange,(String)CurComp.compParentComponent.getParameter("AType"));//added bllou 2011-09-08 ���ӶԿͻ����ر���Ȩ
	if(sAType==null)sAType="NotSpecial";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
	<%
		String sHeaders[][] = 	{ 
						{"OrgID","��Ȩ����"},
						{"RoleID","��ɫ����"},
						{"ObjectNo","��Ȩ����"},
						{"CustomerName","�ر���Ȩ�ͻ�����"},
						{"UserID","��Ա��"},
						{"AuthorizeOrgLevel","��Ա��ɫ����"},
						{"FlowNo","��������"},
						{"PhaseNo","���̽׶�"},
						{"NextPhaseNo","�����½׶α��"},
						{"OperateCode1","ȫ�����������"},
						{"Balance1","ȫ������"},
						{"OperateCode2","ȫ��ʽ�������"},
						{"Balance2","ȫ��ʽ��"},
						{"OperateCode3","���ڵ�����������"},
						{"Balance3","���ڵ������"},
						{"OperateCode4","���ڵ��ʽ�������"},
						{"Balance4","���ڵ��ʽ��"},
						{"InputOrgName","¼�����"},
						{"InputUserName","¼����Ա"},
						{"InputDate","�Ǽ�����"},
						{"Remark","��ע"},
						{"FinalOrgName","��Ȩ����"}
		   				};		   		
		//added bllou 2011-09-08 ���ӶԿͻ����ر���Ȩ
		if("Special".equals(sAType)){
			sHeaders[2][1]="�ر���Ȩ�ͻ����";
		}
		sSql =  " select OrgID,getOrgName(OrgID) as FinalOrgName,RoleID,"+
		("Special".equals(sAType)?" ObjectNo,getCustomerName(ObjectNo) as CustomerName,":"ObjectNo,")+
		" UserID,AuthorizeOrgLevel,FlowNo,PhaseNo,NextPhaseNo,OperateCode1,Balance1, "+
		" OperateCode2,Balance2,OperateCode3,Balance3,OperateCode4,Balance4,InputOrgID, "+
		" InputUserID,InputDate,Remark,getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName "+
		" from AUTHORIZE_ORG "+
		" where OrgID = '"+sOrgID+"' "+
		" and RoleID = '"+sRoleID+"' "+
		" and ObjectNo = '"+sObjectNo+"' ";
				
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		
		doTemp.UpdateTable = "AUTHORIZE_ORG";
		doTemp.setKey("OrgID,RoleID,ObjectNo",true);
		doTemp.setUpdateable("InputOrgName,InputUserName,FinalOrgName",false);
		doTemp.setCheckFormat("Balance1,Balance2,Balance3,Balance4","2");
		doTemp.setCheckFormat("InputDate","3");
		doTemp.setType("Balance1,Balance2,Balance3,Balance4","Number");
		doTemp.setRequired("OrgID,RoleID,ObjectNo,OperateCode1,OperateCode2,Balance1,Balance2,FinalOrgName",true);
		doTemp.setReadOnly("InputOrgName,InputUserName,InputDate,FinalOrgName",true);
		doTemp.setVisible("AuthorizeOrgLevel,InputOrgID,InputUserID,UserID,FlowNo,PhaseNo,NextPhaseNo,OperateCode3,Balance3,OperateCode4,Balance4,OrgID",false);
		doTemp.setEditStyle("Remark","3");
		doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px} ");
		doTemp.setDDDWCode("OperateCode1,OperateCode2,OperateCode3,OperateCode4","MathMark");
		doTemp.setDDDWCode("AuthorizeOrgLevel","AuthorizeOrgLevel");
		//doTemp.setDDDWSql("OrgID","select OrgID,OrgName from org_info where OrgID in(select BelongOrgID from ORG_BELONG where OrgID = '"+CurOrg.OrgID+"') order by sortno");
		doTemp.setDDDWSql("RoleID","select RoleID,RoleName from ROLE_INFO where RoleStatus='1' order by RoleID");
		doTemp.setUnit("FinalOrgName"," <input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectFinalOrg()>");
		//added bllou 2011-09-08 ���ӶԿͻ����ر���Ȩ
		if("Special".equals(sAType)){
			doTemp.setRequired("OperateCode1,OperateCode2,Balance1,Balance2",false);
			doTemp.setUnit("CustomerName","<input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectCustomer()>");
			doTemp.setReadOnly("ObjectNo",true);
			doTemp.setUpdateable("CustomerName",false);
		}else{
			doTemp.setDDDWSql("ObjectNo","select SerialNo,AuthorizeName from AUTHORIZE_ROLE order by 2");
		}

		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="2";      //����ΪGrid���
		
		//����HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/
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
			{"true","","Button","����","������Ϣ","saveRecord()",sResourcesPath},
			{"true","","Button","����","����","goBack()",sResourcesPath}
			};
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/
%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		sOrgID = getItemValue(0,getRow(),"OrgID");
		sRoleID = getItemValue(0,getRow(),"RoleID");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		
		//�жϻ�������Ա��ɫ�����Ƿ�һ�� added by hysun 2006.10.26
		/*sAuthorizeOrgLevel = getItemValue(0,getRow(),"AuthorizeOrgLevel");
		sOrgIDLevel = RunMethod("��Ȩ����","�жϻ�������Ա��ɫ",sOrgID);//���ػ�������OrgLevel
		
		if(sAuthorizeOrgLevel.substring(0,2)=="00")//֧������Ȩ
		{
			if(sOrgIDLevel=="6")
			{
				if(sRoleID.substring(0,1)=="4")
				{	
				}else
				{alert("�����������ɫ�������Ƿ���ȷ��");return;}
			}else
			{alert("�����������ɫ�������Ƿ���ȷ��");return;}
		}else if(sAuthorizeOrgLevel.substring(0,2)=="01")//��������Ȩ
		{
			if(sOrgIDLevel=="3")
			{
				if(sRoleID.substring(0,1)=="2")
				{	
				}else
				{alert("�����������ɫ�������Ƿ���ȷ��");return;}
			}else
			{alert("�����������ɫ�������Ƿ���ȷ��");return;}
		}else if(sAuthorizeOrgLevel.substring(0,2)=="02")//��������Ȩ
		{
			if(sOrgIDLevel=="0")
			{
				if(sRoleID.substring(0,1)=="0")
				{	
				}else
				{alert("�����������ɫ�������Ƿ���ȷ��");return;}
			}else
			{alert("�����������ɫ�������Ƿ���ȷ��");return;}
		}
		*/
		//finished adding by hysun

		sReturnValue = RunMethod("��Ȩ����","�жϻ�����Ȩ�Ƿ����",sOrgID+","+sRoleID+","+sObjectNo);
		if(sReturnValue>0 && bIsInsert==true){
			alert("�û�����ɫ�Ѵ��ڴ���Ȩ������������ѡ�������ɫ����Ȩ������");
			return false;
		}
		as_save("myiframe0",sPostEvents);
	}
	

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		self.close();
	}
	
	/*~[Describe=ѡ��֧�л���;InputParam=��;OutPutParam=��;]~*/
	function selectFinalOrg()
	{
			
		//setObjectValue("SelectSubOrg",sParaString,"@FinalOrg@0@FinalOrgName@1",0,0,"");
		setObjectValue("SelectAllOrg","","@OrgID@0@FinalOrgName@1",0,0,"");
		
	}
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{			
		var sReturn=setObjectValue("SelectAllCustomer","","@ObjectNo@0@CustomerName@1",0,0,"");
		//var aReturn=sReturn.split("@");
		//setItemValue(0,getRow(),"ObjectNo","CID"+aReturn[0]);
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{	
		if (getRowCount(0) == 0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			
			bIsInsert = true;
		}
    }
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>
