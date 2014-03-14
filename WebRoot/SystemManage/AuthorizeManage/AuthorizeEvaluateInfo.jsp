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
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	
	//����ֵת��Ϊ���ַ���
	if(sOrgID == null) sOrgID = "";
	if(sRoleID == null) sRoleID = "";
	if(sSerialNo == null) sSerialNo = "";
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
						{"EvaluateLevel","���������ȼ�"},
						{"IsJudgeCredit","�Ƿ��ж���;���Ŷ��"},
						{"OperateCode2","���Ŷ�������"},
						{"CreditSum","���Ŷ��"},
						{"InputOrgName","¼�����"},
						{"InputUserName","¼����Ա"},
						{"InputDate","�Ǽ�����"},
						{"Remark","��ע"},
		   				};		   		
		
		sSql =  " select SerialNo,OrgID,RoleID,OperateCode1,EvaluateLevel, "+
		" IsJudgeCredit,OperateCode2,CreditSum,Remark, "+
		" InputUserID,getUserName(InputUserID) as InputUserName,InputOrgID,getOrgName(InputOrgID) as InputOrgName,InputDate "+
		" from EVALUATE_AUTHORIZE "+
		" where OrgID = '"+sOrgID+"' "+
		" and RoleID = '"+sRoleID+"' "+
		" and SerialNo = '"+sSerialNo+"' ";
				
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		
		doTemp.UpdateTable = "EVALUATE_AUTHORIZE";
		doTemp.setKey("OrgID,RoleID,SerialNo",true);
		doTemp.setUpdateable("InputOrgName,InputUserName",false);
		doTemp.setCheckFormat("CreditSum","2");
		doTemp.setCheckFormat("InputDate","3");
		doTemp.setType("CreditSum","Number");
		doTemp.setRequired("OrgID,RoleID,IsJudgeCredit",true);
		doTemp.setReadOnly("SerialNo,InputOrgName,InputUserName,InputDate",true);
		doTemp.setVisible("InputOrgID,InputUserID,UserID",false);
		doTemp.setEditStyle("Remark","3");
		doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px} ");
		doTemp.setDDDWCode("OperateCode1,OperateCode2","OperateCode");
		doTemp.setDDDWSql("IsJudgeCredit","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'YesNo' and isinuse = '1' order by 1 desc");
		doTemp.setDDDWSql("OrgID","select OrgID,OrgName from org_info where OrgID in(select BelongOrgID from ORG_BELONG where OrgID = '"+CurOrg.OrgID+"') order by sortno");
		doTemp.setDDDWSql("RoleID","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'AuthorizeEvaluateRoleID' and isinuse = '1' order by 1 desc");
		doTemp.setDDDWSql("EvaluateLevel","select ItemNo,ItemName from code_library where codeno='CreditLevel' and isinuse='1' order by 1");
		
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
	function saveRecord()
	{
		sOrgID = getItemValue(0,getRow(),"OrgID");
		sRoleID = getItemValue(0,getRow(),"RoleID");
		
		sReturnValue = RunMethod("��Ȩ����","�ж�������Ȩ�Ƿ����",sOrgID+","+sRoleID);
		if(sReturnValue>0 && bIsInsert==true){
			alert("�û�����ɫ�Ѵ��ڴ���Ȩ������������ѡ�������ɫ����Ȩ������");
			return false;
		}
		
		if(bIsInsert){
			beforeInsert();
		}
		as_save("myiframe0");
	}

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		self.close();
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>	
	
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�
		setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
		setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
		setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{	
		if (getRowCount(0) == 0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
		}
    }
    
    function initSerialNo() 
	{
		var sTableName = "EVALUATE_AUTHORIZE";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "EA";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		if(typeof(sSerialNo)!="undefined"||sSerialNo.length!=0)
			setItemValue(0,getRow(),sColumnName,sSerialNo);
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
