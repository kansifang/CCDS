<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Describe: ����ͻ���Ϣ
			Input Param:
			Output Param:
			HistoryLog: fbkang on 2005/08/14 
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "����ͻ���Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//��ñ������ͻ����
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sCustomerID == null) sCustomerID = "";
	if(sSerialNo == null) sSerialNo = "";
	
	//���������sql���
	String sSql = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	//���ݿͻ���Ż�ȡ�ͻ�����
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sHeaders[][] = {	
					{"SerialNo","��ˮ��"},	
					{"Year","���"},
					{"OrgID","�������"},								
					{"OrgName","��������"},
					{"TaskIndex","����ָ��"},
					{"Remark","��ע"},
					{"InputUserName","�Ǽ���"},
					{"InputorgName","�Ǽǻ���"}	,	
					{"InputDate","�Ǽ�����"},
					{"UpdateDate","��������"}
		          };
   
   sSql = " select SerialNo,Year,OrgID,OrgName,"+
   		  " TaskIndex,Remark,"+
   		  " InputOrgID,getOrgName(InputOrgID) as InputOrgName,"+
   		  " InputUserID,getUserName(InputUserID) as InputUserName,"+
   		  " InputDate,UpdateDate,TempSaveFlag"+
   		  " from Org_Task_Info "+
          " where SerialNo='"+sSerialNo+"'";
    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ÿɸ���Ŀ���
	doTemp.UpdateTable = "Org_Task_Info";
	doTemp.setKey("SerialNo",true);
	//�����ֶ��Ƿ�ɼ�
	doTemp.setVisible("SerialNo,InputOrgID,InputUserID,TempSaveFlag",false);
	doTemp.setUpdateable("InputOrgName,InputUserName",false);
	doTemp.setCheckFormat("TaskIndex","5");
	doTemp.setEditStyle("Remark","3");
	doTemp.setLimit("Remark",250);
	doTemp.setLimit("Year",4);
	//���ñ༭����
	doTemp.setReadOnly("OrgID,OrgName,InputOrgName,InputUserName,InputDate,UpdateDate",true);
	doTemp.setUnit("OrgName"," <input type=button value=.. onclick=parent.selectOrgID()>");
	doTemp.setRequired("OrgName,TaskIndex",true);
	//doTemp.appendHTMLStyle("Year","myvalid=\"parseFloat(myobj.value,10)<0\" mymsg=\"���������ֻ������ֵ��\" ");
	//���ñ�����Ϳɼ���	
	//����datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����ΪGrid���
		
	Vector vTemp = dwTemp.genHTMLDataWindow(""+sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>

<%
	/*~END~*/
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
			   {"true","","Button","����","�������ͻ���Ϣ","saveRecord()",sResourcesPath}
			   
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
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------	
	//*~[Describe=������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function saveRecord()
	{
		var sYear =getItemValue("0","0","Year");
		if(isNaN(sYear)==true){
			alert("���������ֵ��");
			return;
		}
        as_save("myiframe0","newRecord");        
	}
   
	
	
	//*~[Describe=��ȡ��������;InputParam=��;OutPutParam=��;]~*/
	function selectOrgID()
	{
		//���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤�����롢������			
			setObjectValue("selectOrgID","","@OrgID@0@OrgName@1",0,0,"");		
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
	/*~[Describe=��ʼ����ҵ����ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "ORG_TASK_INFO";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,getRow(),"InputOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			initSerialNo();
		    bIsInsert = true;
		   
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
	initRow();
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>
