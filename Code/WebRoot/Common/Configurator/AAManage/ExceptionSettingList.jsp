
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:zywei 2005/08/28
		Tester:
		Content: ��Ȩ���б�ҳ��
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ȩ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
	//����������	
	
	//���ҳ�����	
	String sAuthID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AuthID"));
	if(sAuthID == null) sAuthID = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders = {
							{"SortNo","˳���"},
							{"ExceptionID","�����ID"},
							{"AuthID","��Ȩ��ID"},														
							{"TypeID","��������ID"},
							{"TypeName","��������"},
							{"VariableA","����A"},
							{"BizBalanceCeiling","�������ʽ�����ޣ�Ԫ��"},
							{"BizExposureCeiling","�������ʳ�����Ȩ���ޣ�Ԫ��"},
							{"CustBalanceCeiling","�������������Ȩ���ޣ�Ԫ��"},
							{"CustExposureCeilin","��������������Ȩ���ޣ�Ԫ��"},
							{"InterestRateFloor","��Ȩ�������ޣ�%��"},
							{"VariableB","����B"},
							{"IsInUse","�Ƿ����"}
						  };
	sSql =  " select AE.SortNo,AE.ExceptionID,AE.AuthID,AE.TypeID,AET.TypeName, "+
			" AE.VariableA,AE.VariableB,AE.BizBalanceCeiling,AE.BizExposureCeiling, "+
			" AE.CustBalanceCeiling,AE.CustExposureCeilin,AE.InterestRateFloor, "+
			" getItemName('YesNo',AE.IsInUse) as IsInUse "+
			" from AA_EXCEPTION AE,AA_EXCEPTIONTYPE AET "+
			" Where AE.TypeID=AET.TypeID "+
			" and AE.AuthID = '"+sAuthID+"' "+
			" order by SortNo";	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "AA_EXCEPTION";
	doTemp.setKey("ExceptionID",true);
	doTemp.setHeader(sHeaders);
	doTemp.setVisible("ExceptionID,AuthID,TypeID",false);
	doTemp.setHTMLStyle("TypeName"," style={width:250px} ");
	doTemp.setType("BizBalanceCeiling","Number");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style = "1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);

	//out.println(doTemp.SourceSql); //������仰����datawindow
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{		
		sAuthID = "<%=sAuthID%>";
		if(typeof(sAuthID) == "undefined" || sAuthID.length == 0)
		{
			alert("������Ȩ���趨�б�����ѡ��һ����Ϣ������������������");
			return;
		}else
			OpenPage("/Common/Configurator/AAManage/ExceptionSettingInfo.jsp?AuthID=<%=sAuthID%>","_self","");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		//��������ID   
	    sExceptionID = getItemValue(0,getRow(),"ExceptionID");			
		if (typeof(sExceptionID) == "undefined" || sExceptionID.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('2'))) //�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		//��������ID  
		sExceptionID = getItemValue(0,getRow(),"ExceptionID");
		if (typeof(sExceptionID) == "undefined" || sExceptionID.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		OpenPage("/Common/Configurator/AAManage/ExceptionSettingInfo.jsp?AuthID=<%=sAuthID%>&ExceptionID="+sExceptionID,"_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
