<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: wwhe	2008-04-19
			Tester:
			Describe: 	��Ȩ��������
			Input Param:
					sSerialNo	��Ȩ�������
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
		String PG_TITLE = "��Ȩ��������"; // ��������ڱ��� <title> PG_TITLE </title>
		//CurPage.setAttribute("ShowDetailArea","true");
		//CurPage.setAttribute("DetailAreaHeight","60");
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
	
	//������������������
	
	//���ҳ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	
 	//����ֵת��Ϊ���ַ���
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
						{"ObjectNo","��Ȩ�������"},
						{"MethodTypeName","������������"},
						{"MethodDescribe","��������˵��"},
						{"MethodName","�����෽��������"},
						{"MethodStatusName","��Ч��־"},
						{"InputOrgName","¼�����"},
						{"InputUserName","¼����Ա"}
		   				};		   		
		
		sSql =  " select SerialNo,ObjectNo,MethodType,getItemName('AuthorizeMethodType',MethodType) as MethodTypeName,MethodDescribe,MethodName,MethodStatus,getItemName('IsInUse',MethodStatus) as MethodStatusName, "+
		" InputOrgID,InputUserID,getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName"+
		" from AUTHORIZE_METHOD "+
		" where ObjectNo = '"+sSerialNo+"' ";
				
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		doTemp.UpdateTable = "AUTHORIZE_METHOD";
		doTemp.setKey("SerialNo",true);
		
		doTemp.setVisible("SerialNo,InputOrgID,InputUserID,MethodType,MethodDescribe,MethodStatus,MethodTypeName",false);
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="1";      //����ΪGrid���
		dwTemp.ReadOnly = "1"; //����Ϊֻ��
		
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
		{"true","","Button","������������","������������","newRecord()",sResourcesPath},
		{"true","","Button","�޸�/�鿴��������","�޸�/�鿴��������","editRecord()",sResourcesPath},
		{"true","","Button","ɾ����������","ɾ����������","delRecord()",sResourcesPath},
		{"true","","Button","�����Ȩ����","�����Ȩ����","setComposeAu()",sResourcesPath}
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
	/*~[Describe=������Ȩ����;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/SystemManage/AuthorizeManage/AuthorizeControlInfo.jsp?ObjectNo=<%=sSerialNo%>","DetailFrame","right");
	}
	
	/*~[Describe=�޸���Ȩ����;InputParam=��;OutPutParam=��;]~*/
	function editRecord()
	{
		var sMethodType = getItemValue(0,getRow(),"MethodType");
		var sMethodName = getItemValue(0,getRow(),"MethodName");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));
			return false;
		}
		OpenPage("/SystemManage/AuthorizeManage/AuthorizeControlInfo.jsp?MethodName="+sMethodName+"&ObjectNo="+sObjectNo,"DetailFrame","right");
	}
	
	/*~[Describe=ɾ��ҵ��Ʒ��;InputParam=��;OutPutParam=��;]~*/
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
			var sReturn=RunMethod("PublicMethod","DeleteColValue","Config_Info,String@Attribute1@"+sSerialNo);
			if(sReturn=="TRUE"){
				as_del("myiframe0");
				as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			}
		}
	}
	function setComposeAu()
	{
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");//--��Ȩ��ˮ����
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��Ȩ������ˮ����
		var sMethodName = getItemValue(0,getRow(),"MethodName");//--��Ȩ������ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
		}else if(sMethodName==="�����Ȩ")
		{
			OpenPage("/PublicInfo/ConfigList.jsp?ObjectNo="+sObjectNo+"&AuthorizeMethodSerialNo="+sSerialNo,"DetailFrame",OpenStyle);	
		}
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
	//OpenPage("/Blank.jsp?TextToShow=����ѡ����Ӧ����Ȩ��������!","DetailFrame","");
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>
