<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: ymwu��20130505
			Tester:
			Content: ����Ӱ��Ȩ��
			Input Param:
			  RCSerialNo
			Output param:
			History Log:
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "INFOҳ������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/
%>
<%
	//����������
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	System.out.println(sObjectNo+"------------------------");
	if(sObjectType==null)  sObjectType="";
	if(sObjectNo==null)  sObjectNo="";
	String sSql = "";
	String sScanAuthority="0",sQueryAuthority="0",sDeleteAuthority="0",sAlterAuthority="0",sPrintAuthority="0",
	       sNoteAuthority="0",sAdminAuthority="0",sDownLoadAuthority="0";
	String sObjectTableName ="",sObjectCol="";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][] = {
					{"ScanAuthority","ɨ��Ȩ��"},
					{"QueryAuthority","�鿴Ȩ��"},
					{"DeleteAuthority","ɾ��Ȩ��"},
					{"AlterAuthority","�޸�Ȩ��"},
					{"PrintAuthority","��ӡȨ��"},
					{"NoteAuthority","��עȨ��"},
					{"AdminAuthority","����ԱȨ��"},
					{"DownLoadAuthority","����Ȩ��"},
					
	           };
	
    if("User".equals(sObjectType)){
    	sObjectTableName="User_Info";
    	sObjectCol ="UserID";
    }else{
    	sObjectTableName="Role_Info";
    	sObjectCol ="RoleID";
    }
    
	sSql = "Select ImageRight from "+sObjectTableName+" where "+sObjectCol+"='"+sObjectNo+"' ";
	String sImageRight = Sqlca.getString(sSql);
	if(sImageRight!= null &&sImageRight.length()>0){
		sScanAuthority     = sImageRight.substring(0,1);
		sQueryAuthority    = sImageRight.substring(1,2);
		sDeleteAuthority   = sImageRight.substring(2,3);
		sAlterAuthority    = sImageRight.substring(3,4);
		sPrintAuthority    = sImageRight.substring(4,5);
		sNoteAuthority     = sImageRight.substring(5,6);
		sAdminAuthority    = sImageRight.substring(6,7);
		sDownLoadAuthority = sImageRight.substring(7,8);
	} 
	
	sSql = " select "+
	" "+sScanAuthority+" as ScanAuthority,"+sQueryAuthority+" as QueryAuthority,"+sDeleteAuthority+" as DeleteAuthority,"+sAlterAuthority+" as AlterAuthority,"+
	       " "+sPrintAuthority+" as PrintAuthority,"+sNoteAuthority+" as NoteAuthority,"+sAdminAuthority+" as AdminAuthority, "+sDownLoadAuthority+" as DownLoadAuthority"+
	       " "+
		   " from sysibm.sysdummy1 ";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setRequired("ScanAuthority,QueryAuthority,DeleteAuthority,AlterAuthority,PrintAuthority,NoteAuthority,AdminAuthority,DownLoadAuthority",true);
	doTemp.setUpdateable("ScanAuthority,QueryAuthority,DeleteAuthority,AlterAuthority,PrintAuthority,NoteAuthority,AdminAuthority,DownLoadAuthority",false);
	doTemp.setHRadioCode("ScanAuthority,QueryAuthority,DeleteAuthority,AlterAuthority,PrintAuthority,NoteAuthority,AdminAuthority,DownLoadAuthority","TrueFalse");
	

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //����ΪGrid���
	dwTemp.ReadOnly = "0"; //����Ϊֻ��

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
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"User".equals(sObjectType)?"true":"false","","Button","���Ӱ��Ȩ��","���Ӱ��Ȩ��","clearRight()",sResourcesPath}
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
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		sScanAuthority = getItemValue(0,getRow(),"ScanAuthority");
		sQueryAuthority = getItemValue(0,getRow(),"QueryAuthority");
		sDeleteAuthority = getItemValue(0,getRow(),"DeleteAuthority");
		sAlterAuthority = getItemValue(0,getRow(),"AlterAuthority");
		sPrintAuthority = getItemValue(0,getRow(),"PrintAuthority");
		sNoteAuthority = getItemValue(0,getRow(),"NoteAuthority");
		sAdminAuthority = getItemValue(0,getRow(),"AdminAuthority");
		sDownLoadAuthority = getItemValue(0,getRow(),"DownLoadAuthority");
		sImageAuthority = sScanAuthority+sQueryAuthority+sDeleteAuthority+sAlterAuthority+sPrintAuthority+sNoteAuthority+sAdminAuthority+sDownLoadAuthority;
		var sNum = RunMethod("PublicMethod","UpdateColValue","String@ImageRight@"+sImageAuthority+",<%=sObjectTableName%>,String@<%=sObjectCol%>@"+"<%=sObjectNo%>");
		if(sNum){
			self.close();
			}
		
	}

	function clearRight(){
		var sNum = RunMethod("PublicMethod","ExecuteSql","Update User_Info set ImageRight='' where Userid='<%=sObjectNo%>'");
		if(sNum=="1"){
			self.close();
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
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
 
 

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{		 
		}
	}
 
 </SCRIPT>
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
	
</script>
<%
	/*~END~*/
%>


<%@ include file="/IncludeEnd.jsp"%>