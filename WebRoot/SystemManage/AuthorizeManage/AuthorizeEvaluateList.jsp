<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: ylwang	2009-02-19
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
	String OrgCondition ="";
	String sSortNo = "";
	
	//���ҳ�������������ʽ��������Ϣ���
	
 	//����ֵת��Ϊ���ַ���
 	
 	//ȡ�ò�ѯ��ͳ��Ȩ��
	//Ĭ��Ϊ��ǰ���������ݵ�ǰ�����жϳ��û�����Ȩ��
	//ѡ������Ժ󣬸���ѡ��Ļ����жϳ�ѡ��Ĺ���Ȩ��
	if(sSortNo == null || sSortNo.equals(""))
	{
		String sSql1 = "select SortNo from ORG_INFO where OrgID = '"+CurOrg.OrgID+"' ";
		sSortNo = Sqlca.getString(sSql1);
	}
	String sSql2 = "select OrgLevel from ORG_INFO where SortNo = '"+sSortNo+"' ";
	String sOrgLevel = Sqlca.getString(sSql2);
	//out.println("sSortNo="+sSortNo);
	if(sOrgLevel == null) sOrgLevel = "";
	if (sOrgLevel.equals("6")) //֧��
	{		
		OrgCondition=" and AO.OrgID = '"+sSortNo+"' ";
	} 
	if (sOrgLevel.equals("3")) //����
	{
		sSortNo= sSortNo.substring(0,6);
		OrgCondition=" and AO.OrgID like '"+sSortNo+"%' ";
	}
	if (sOrgLevel.equals("0")) //����
	{
		sSortNo= sSortNo.substring(0,3);
		OrgCondition=" and AO.OrgID like '"+sSortNo+"%' ";
	}
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
	<%
		String sHeaders[][] = 	{ 
						{"SerialNo","��Ȩ���к�"},
						{"OrgID","��Ȩ����"},
						{"RoleID","��Ա��ɫ"},
						{"OrgName","��Ȩ����"},
						{"RoleName","��Ա��ɫ"},
						{"OperateCode1","�������������"},
						{"OperateCode1Name","�������������"},
						{"EvaluateLevel","���������ȼ�"},
						{"EvaluateLevelName","���������ȼ�"},
						{"IsJudgeCredit","�Ƿ��ж���;���Ŷ��"},
						{"OperateCode2","���Ŷ�������"},
						{"OperateCode2Name","���Ŷ�������"},
						{"CreditSum","���Ŷ��"},
						{"InputOrgName","¼�����"},
						{"InputUserName","¼����Ա"},
						{"InputDate","�Ǽ�����"},
						{"Remark","��ע"},
		   				};		   		
		
		sSql =  " select SerialNo,OrgID,getOrgName(OrgID) as OrgName, "+
		//" getOrgName(AO.OrgID) as OrgName, "+
		//" (select orgname from org_info where sortno = AO.OrgID) as OrgName, "+
		" RoleID,getRoleName(RoleID) as RoleName, "+
		" OperateCode1,getItemName('OperateCode',OperateCode1) as OperateCode1Name, "+
		" EvaluateLevel,getItemName('CreditLevel',EvaluateLevel) as EvaluateLevelName,"+
		" getItemName('YesNo',IsJudgeCredit) as IsJudgeCredit,"+
		" OperateCode2,getItemName('OperateCode',OperateCode2) as OperateCode2Name, "+
		" CreditSum,Remark, "+
		" InputOrgID,InputUserID,getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName,InputDate  "+
		" from EVALUATE_AUTHORIZE where 1=1"+
		//" and AO.OrgID in (select BelongOrgId from ORG_BELONG where OrgID='"+CurOrg.OrgID+"')"+
		//OrgCondition +
		//" order by OrgID,AuthorizeType,AuthorizeName,AuthorizeOrgLevel ";
		" order by OrgID,RoleID ";
				
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		doTemp.UpdateTable = "EVALUATE_AUTHORIZE";
		doTemp.setKey("OrgID,RoleID,SerialNo",true);
		doTemp.setUpdateable("OrgName,RoleName,OperateCode1Name,OperateCode2Name,EvaluateLevelName",false);
		doTemp.setUpdateable("EvaluateLevel,OperateCode1,CreditSum,OperateCode2",true);
		doTemp.setVisible("EvaluateLevelName,OrgID,RoleID,UserID,OperateCode1Name,OperateCode2Name,InputOrgID,InputUserID,Remark",false);
		doTemp.setReadOnly("",true);
		doTemp.setReadOnly("EvaluateLevel,OperateCode1,CreditSum,OperateCode2",false);
		doTemp.setHTMLStyle("RoleName"," style={width:200} ");
		doTemp.setDDDWSql("OperateCode1,OperateCode2","select ItemNo,ItemName from code_library where codeno='OperateCode' and ItemNo in ('01','02','03')");
		doTemp.setDDDWSql("EvaluateLevel","select ItemNo,ItemName from code_library where codeno='CreditLevel' and isinuse='1' order by 1");
		//���ӹ�����	
		doTemp.setDDDWSql("OrgID","select OrgID,OrgName from org_info where OrgID in(select BelongOrgID from ORG_BELONG where OrgID = '"+CurOrg.OrgID+"') order by sortno");
		doTemp.setDDDWSql("RoleID","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'AuthorizeEvaluateRoleID' and isinuse = '1' order by 1");
		//doTemp.setDDDWCode("AuthorizeOrgLevel","AuthorizeOrgLevel");
		//doTemp.setDDDWSql("ObjectNo","select Serialno,AuthorizeName from AUTHORIZE_ROLE order by 1");
		
		//doTemp.setColumnAttribute("OrgID,RoleID,AuthorizeOrgLevel,ObjectNo,AuthorizeName","IsFilter","1");
		doTemp.setColumnAttribute("OrgID,RoleID,SerialNo","IsFilter","1");
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

		if(!doTemp.haveReceivedFilterCriteria())
		 doTemp.WhereClause+=" and 1=2";
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="1";      //����ΪGrid���
		dwTemp.setPageSize(211);  //��������ҳ
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
			{"true","","Button","����������Ȩ","����������Ȩ","singletonRecord()",sResourcesPath},
			{"true","","Button","�޸�/�鿴������Ȩ","�޸�/�鿴������Ȩ","editRecord()",sResourcesPath},
			{"true","","Button","ɾ��������Ȩ","ɾ��������Ȩ","delRecord()",sResourcesPath},
			{"true","","Button","�����޸�","�����޸�","saveRecord()",sResourcesPath}
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
	/*~[Describe=����������Ȩ;InputParam=��;OutPutParam=��;]~*/
	function singletonRecord()
	{
		sCompID = "AuthorizeEvaluateInfo";
		sCompURL = "/SystemManage/AuthorizeManage/AuthorizeEvaluateInfo.jsp";
		sParamString = "";
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	
	/*~[Describe=�޸�/�鿴������Ȩ;InputParam=��;OutPutParam=��;]~*/
	function editRecord()
	{
		var sOrgID = getItemValue(0,getRow(),"OrgID");			//--������
		var sRoleID = getItemValue(0,getRow(),"RoleID");		//--��ɫ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	//--��Ȩ�������к�
		if(typeof(sOrgID)=="undefined" || sOrgID.length==0)
		{
			alert(getHtmlMessage('1'));
			return false;
		}
		sCompID = "AuthorizeEvaluateInfo";
		sCompURL = "/SystemManage/AuthorizeManage/AuthorizeEvaluateInfo.jsp";
		sParamString = "OrgID="+sOrgID+"&RoleID="+sRoleID+"&SerialNo="+sSerialNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	
	/*~[Describe=ɾ��������Ȩ;InputParam=��;OutPutParam=��;]~*/
	function delRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
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
	
	/*~[Describe=�����޸�;InputParam=��;OutPutParam=��;]~*/
	function saveRecord(){
		as_save("myiframe0");
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
