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
	String sSql="";
	//��Ȩ���
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	//����������ˮ��
	String sAuthorizeMethodSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AuthorizeMethodSerialNo"));
 	//����ֵת��Ϊ���ַ���
 	if(sObjectNo == null) sObjectNo = "";
 	if(sAuthorizeMethodSerialNo == null) sAuthorizeMethodSerialNo = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
	<%
		String sHeaders[][] = 	{ 
						{"Describe1","������������"},
						{"ItemName1","����ά��1"},
						{"ItemName2","����ά��2"},
						{"ItemName3","����ά��3"},
						{"ItemName4","����ά��4"},
						{"ItemName5","����ά��5"},
						{"ItemName6","����ά��6"},
						{"ItemName7","����ά��7"},
						{"ItemName8","����ά��8"},
						{"ItemName9","����ά��9"},
						{"ItemName10","����ά��10"},
						{"InputDate","���ƿ�ʼ����"},
						{"UpdateDate","���ƽ�ֹ����"},
						{"InputOrgName","¼�����"},
						{"InputUserName","¼����Ա"}
		   				};		   		
		
		sSql =  " select SerialNo,Describe1,"+
		" ItemName1,ItemName2, "+
		" ItemName3,ItemName4, "+
		" ItemName5,ItemName6,"+
		" ItemName7,ItemName8, "+
		" ItemName9,ItemName10, "+
		" IsInUse,InputOrgID,InputUserID,"+
		" getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName,InputDate"+
		" from Config_Info"+
		" where Attribute1='"+sAuthorizeMethodSerialNo+"'";
			
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		doTemp.UpdateTable = "Config_Info";
		doTemp.setKey("SerialNo",true);
		doTemp.setVisible("SerialNo,InputOrgID,InputUserID",false);
		doTemp.setReadOnly("",true);	
		//���ӹ�����	
		doTemp.setDDDWCode("IsInUse","YesNo");
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="1";      //����ΪGrid���
		dwTemp.setPageSize(211);  //��������ҳ
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
			//{"true","","Button","����������Ȩ(����)","��������������Ȩ","batchRecord()",sResourcesPath},
			{"true","","Button","�������ά��","�������ά��","newRecord()",sResourcesPath},
			{"true","","Button","�޸�/�鿴���ά��","�޸�/�鿴���ά��","editRecord()",sResourcesPath},
			{"true","","Button","ɾ�����ά��","ɾ�����ά��","delRecord()",sResourcesPath},
			//{"true","","Button","�������޸�","�������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","����","����","goBack()",sResourcesPath}
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
	function newRecord()
	{
		var sParamString = "Selects=ItemName,ItemNo@Code_Library@CodeNo='AuthorizeControlType' and IsInuse='1'~;";
		var sReturn = PopPage("/PublicInfo/MultiSelectDialogue.jsp?"+sParamString,"","dialogWidth=36;dialogHeight=22;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");
		if (typeof(sReturn)=="undefined" || sReturn.length==0||sReturn==="_none_"){
			return;
		}
		OpenPage("/PublicInfo/ConfigInfo.jsp?DispayContent="+sReturn+"&AuthorizeMethodSerialNo=<%=sAuthorizeMethodSerialNo%>&ObjectNo=<%=sObjectNo%>","DetailFrame",OpenStyle);
		//var sss=RunMethod("���÷���","DelTable","Config_Info,Describe1 is null or Describe1 =''");
		//reloadSelf();
	}
	
	/*~[Describe=�޸�/�鿴������Ȩ;InputParam=��;OutPutParam=��;]~*/
	function editRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	//--ά�����к�
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));
			return false;
		}
		OpenPage("/PublicInfo/ConfigInfo.jsp?SerialNo="+sSerialNo+"&AuthorizeMethodSerialNo=<%=sAuthorizeMethodSerialNo%>&ObjectNo=<%=sObjectNo%>","DetailFrame",OpenStyle);
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
	
	/*~[Describe=�������޸�;InputParam=��;OutPutParam=��;]~*/
	function saveRecord(){
		as_save("myiframe0");
	}
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/AuthorizeManage/AuthorizeControlList.jsp?SerialNo=<%=sObjectNo%>","_self","");
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
