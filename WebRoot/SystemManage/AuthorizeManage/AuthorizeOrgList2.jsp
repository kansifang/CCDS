<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: wwhe	2006-09-04
			Tester:
			Describe: 	������Ȩά��
			Input Param:
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
		String PG_TITLE = "������Ȩά��"; // ��������ڱ��� <title> PG_TITLE </title>
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
	
	//���ҳ�������������ʽ��������Ϣ���
	
 	//����ֵת��Ϊ���ַ���
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
	<%
		String sHeaders[][] = 	{ 
						{"OrgName","��Ȩ����"},
						{"RoleName","��Ա��ɫ"},
						{"ObjectNo","��Ȩ���к�"},
						{"AuthorizeName","��Ȩ����"},
						{"AuthorizeOrgLevel","��Ȩ����"},
						{"AuthorizeOrgLevelName","��Ȩ����"},
						{"UserID","��Ա��"},
						{"FlowNo","��������"},
						{"PhaseNo","���̽׶�"},
						{"NextPhaseNo","�����½׶α��"},
						{"OperateCode1","��Ȩ������������"},
						{"OperateCode1Name","��Ȩ������������"},
						{"Balance1","��Ȩ�������"},
						{"OperateCode2","ȫ��ʽ�������"},
						{"OperateCode2Name","ȫ��ʽ�������"},
						{"Balance2","���ʽ��"},
						{"OperateCode3Name","���ڵ�����������"},
						{"Balance3","���ڵ������"},
						{"OperateCode4Name","���ڵ��ʽ�������"},
						{"Balance4","���ڵ��ʽ��"},
						{"InputOrgName","¼�����"},
						{"InputUserName","¼����Ա"},
						{"InputDate","�Ǽ�����"},
						{"Remark","��ע"},
						{"OrgID","��Ȩ����"},
						{"RoleID","��Ȩ��ɫ"},
						{"AuthorizeTypeName","��Ȩ����"}
		   				};		   		
		
		sSql =  " select AO.OrgID,getOrgName(AO.OrgID) as OrgName,AO.RoleID,getRoleName(AO.RoleID) as RoleName, "+
		" AO.ObjectNo,AR.AuthorizeName,AO.OperateCode1,getItemName('OperateCode',AO.OperateCode1) as OperateCode1Name, "+
		" AO.Balance1,getItemName('OperateCode',AO.OperateCode2) as OperateCode2Name,AO.OperateCode2,AO.Balance2, "+
		" AR.AuthorizeType,getItemName('AuthorizeType',AuthorizeType) as AuthorizeTypeName, "+
		" AO.AuthorizeOrgLevel,getItemName('AuthorizeOrgLevel',AO.AuthorizeOrgLevel) as AuthorizeOrgLevelName, "+
		" AO.UserID,AO.FlowNo,AO.PhaseNo,AO.NextPhaseNo, "+
		" getItemName('OperateCode',AO.OperateCode3) as OperateCode3Name,AO.OperateCode3,AO.Balance3, "+
		" getItemName('OperateCode',AO.OperateCode4) as OperateCode4Name,AO.OperateCode4,AO.Balance4, "+
		" AO.InputOrgID,AO.InputUserID,getOrgName(AO.InputOrgID) as InputOrgName,getUserName(AO.InputUserID) as InputUserName,AO.InputDate,AO.Remark  "+
		" from AUTHORIZE_ORG AO,AUTHORIZE_ROLE AR "+
		" where AO.ObjectNo = AR.SerialNo "+
		" and AO.OrgID in (select BelongOrgId from ORG_BELONG where OrgID='"+CurOrg.OrgID+"')"+
		" order by OrgID,AuthorizeType,AuthorizeName,AuthorizeOrgLevel ";
				
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		doTemp.UpdateTable = "AUTHORIZE_ORG";
		doTemp.setKey("OrgID,RoleID,ObjectNo",true);
		doTemp.setUpdateable("AuthorizeOrgLevelName,OrgName,RoleName,OperateCode1Name,OperateCode2Name,OperateCode3Name,OperateCode4Name,AuthorizeTypeName",false);
		doTemp.setVisible("OrgID,RoleID,UserID,AuthorizeOrgLevel,FlowNo,PhaseNo,NextPhaseNo,OperateCode3,OperateCode4,Balance3,Balance4,OperateCode3Name,OperateCode4Name,InputOrgID,InputUserID,Remark,AuthorizeType,OperateCode1,OperateCode2",false);
		doTemp.setReadOnly("",true);
		doTemp.setReadOnly("Balance3,Balance4,OperateCode1,OperateCode2",false);
		doTemp.setType("Balance1,Balance2,Balance3,Balance4","Number");
		doTemp.setHTMLStyle("AuthorizeName"," style={width:250px} ");
		doTemp.setHTMLStyle("RoleName"," style={width:200} ");
		//doTemp.setDDDWSql("OperateCode1,OperateCode2","select ItemNo,ItemName from code_library where codeno='OperateCode' and ItemNo in ('01','02','03')");
		
		//���ӹ�����	
		doTemp.setDDDWSql("OrgID","select OrgID,OrgName from ORG_INFO where OrgID in (select BelongOrgId from ORG_BELONG where OrgID='"+CurOrg.OrgID+"') and (OrgName like '%��������%' or OrgName like '%Ӫҵ%' or OrgName like '%�г�%' or OrgName like '%��%' or OrgName like '%С��ҵ%' or OrgName like '%֧��%') order by SortNo");
		doTemp.setDDDWSql("RoleID","select RoleID,RoleName from ROLE_INFO where (RoleName like '%���쵼%' or RoleName like '%��������%' or RoleName like '%����%' or RoleName like '%С��ҵ������Ա%') and RoleID not in ('260','282','236','235','035','036') order by 1");
		doTemp.setDDDWCode("AuthorizeOrgLevel","AuthorizeOrgLevel");
		//doTemp.setDDDWSql("ObjectNo","select Serialno,AuthorizeName from AUTHORIZE_ROLE order by 1");
		
		doTemp.setColumnAttribute("OrgID,RoleID,AuthorizeOrgLevel,ObjectNo,AuthorizeName","IsFilter","1");
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

		if(!doTemp.haveReceivedFilterCriteria())
		 doTemp.WhereClause+=" and 1=2";
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="1";      //����ΪGrid���
		dwTemp.setPageSize(207);  //��������ҳ
		//dwTemp.ReadOnly = "1"; //����Ϊֻ��
		
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
			{"false","","Button","����������Ȩ(����)","��������������Ȩ","batchRecord()",sResourcesPath},
			{"false","","Button","����������Ȩ(����)","��������������Ȩ","singletonRecord()",sResourcesPath},
			{"false","","Button","�޸�/�鿴������Ȩ","�޸�/�鿴������Ȩ","editRecord()",sResourcesPath},
			{"false","","Button","ɾ��������Ȩ","ɾ��������Ȩ","delRecord()",sResourcesPath},
			{"false","","Button","�������޸�","�������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","����ΪExcel","����ΪExcel","exportAll()",sResourcesPath}
			};
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/
%>
	<script language=javascript>
	/*~[Describe=��������������Ȩ;InputParam=��;OutPutParam=��;]~*/
	function batchRecord()
	{
		var sInputOrgID = "<%=CurOrg.OrgID%>";
		var sInputUserID = "<%=CurUser.UserID%>";
		var sReturnValue = PopPage("/SystemManage/AuthorizeManage/AddAuthorizeOrgDialog.jsp","","resizable=yes;dialogWidth=30;dialogHeight=13;center:yes;status:no;statusbar:no");
		
		sReturnValue = sReturnValue.split('@');
		//var sAuthorizeNo = sReturnValue[0];
		var sAuthorizeType = sReturnValue[0];
		var sAuthorizeOrgLevel = sReturnValue[1];
		var sOrgID = sReturnValue[2];
		var sRoleID = sReturnValue[3];
		//sAuthorizeOrgLevel��Ȩ����ǰ��λ��00 ֧������Ȩ��01 ��������Ȩ��02 ��������Ȩ
		//sRoleID��ɫ��һλ:0 ���н�ɫ,2 ���н�ɫ,4 ֧�н�ɫ
		//sOrgID��������0,3,6
		var sOrgIDLevel = RunMethod("��������","ȡ�����������",sOrgID);
		//�ж�����������Ȩ���𡢽�ɫ�������Ƿ���ȷ
		
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
		
		//sAuthorizeOrgLevel = sAuthorizeOrgLevel.substr(1,1);

		if(typeof(sOrgID)!="undefined" && sOrgID.length!=0 && sOrgID != "_CANCEL_")
		{
			//sReturnValue = RunMethod("��Ȩ����","��������������Ȩ",sAuthorizeNo+","+sOrgID+","+sAuthorizeOrgLevel+","+sRoleID+","+sInputOrgID+","+sInputUserID);
			sReturnValue = RunMethod("��Ȩ����","��������������Ȩ",sAuthorizeType+","+sOrgID+","+sAuthorizeOrgLevel+","+sRoleID+","+sInputOrgID+","+sInputUserID);
			//if(sReturnValue == "true")
			//{	
				alert("����������Ȩ�ɹ���");	
				reloadSelf();
			//}
		}
		else
			alert("����������Ȩû�гɹ���");	
	}
	
	/*~[Describe=��������������Ȩ;InputParam=��;OutPutParam=��;]~*/
	function singletonRecord()
	{
		sCompID = "AuthorizeOrgInfo";
		sCompURL = "/SystemManage/AuthorizeManage/AuthorizeOrgInfo.jsp";
		sParamString = "";
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
		//OpenPage("/SystemManage/AuthorizeManage/AuthorizeOrgInfo.jsp","right");
	}
	
	/*~[Describe=�޸�/�鿴������Ȩ;InputParam=��;OutPutParam=��;]~*/
	function editRecord()
	{
		var sOrgID = getItemValue(0,getRow(),"OrgID");			//--������
		var sRoleID = getItemValue(0,getRow(),"RoleID");		//--��ɫ��
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");	//--��Ȩ�������к�
		if(typeof(sOrgID)=="undefined" || sOrgID.length==0)
		{
			alert(getHtmlMessage('1'));
			return false;
		}
		sCompID = "AuthorizeOrgInfo";
		sCompURL = "/SystemManage/AuthorizeManage/AuthorizeOrgInfo.jsp";
		sParamString = "OrgID="+sOrgID+"&RoleID="+sRoleID+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
		//OpenComp("/SystemManage/AuthorizeManage/AuthorizeOrgInfo.jsp?OrgID="+sOrgID+"&RoleID="+sRoleID+"&ObjectNo="+sObjectNo,"right");
	}
	
	/*~[Describe=ɾ��������Ȩ;InputParam=��;OutPutParam=��;]~*/
	function delRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));
			return false;
		}
		if(confirm("�������ɾ������Ϣ��")) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	/*~[Describe=�������޸�;InputParam=��;OutPutParam=��;]~*/
	function saveRecord(){
		as_save("myiframe0");
	}
	
	function exportAll(){
		amarExport("myiframe0");
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
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
	hideFilterArea();
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>
