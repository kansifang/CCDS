<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   bma 2008-09-19
		Tester:
		Content: ��������
		Input Param:		
		Output param:
		History Log: 	
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//����������	���������͡��������͡��׶����͡����̱�š��׶α��
	
	//����ֵת���ɿ��ַ���
		
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = { 
			{"PutoutDate","��������"},
			{"SerialNo","��ݺ�"},
			{"CustomerID","�ͻ����"},
			{"RelativeSerialNo1","ԭҵ����"},
			{"BusinessType","�������"}
          }; 
	String sSql = "	select PutoutDate,CustomerID,SerialNo,RelativeSerialNo1,BusinessType from BUSINESS_DUEBILL where 1=2 ";
	
	//sql����datawindows
	ASDataObject doTemp = new ASDataObject(sSql);
	//ͷ����
	doTemp.setHeader(sHeaders);
	//�޸ı�
	doTemp.UpdateTable = "BUSINESS_DUEBILL";
    //��������
	doTemp.setKey("SerialNo",true);
	//���ò����޸ĵ���
	//doTemp.setUpdateable("UserName,OrgName,Resouce",false);
    //���ò��ɼ���
	doTemp.setVisible("CustomerID",false);
	//���ñ�����
	doTemp.setRequired("PutoutDate,BusinessType",true);
	//����ֻ����
	doTemp.setReadOnly("SerialNo,RelativeSerialNo1",true); 
	//�������ڵĸ�ʽ
	doTemp.setCheckFormat("PutoutDate","3");
	
	//��������
    doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where TypeNo like '1130%' and TypeNo <> '1130'");
    
    //ȱʡֵΪ��Ч��־
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	doTemp.setUnit("RelativeSerialNo1"," <input type=button value=.. onclick=parent.selectDueBill()>");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			{"true","","Button","ȷ��","ȷ����������","doCreation()",sResourcesPath},
			{"true","","Button","ȡ��","ȡ������","doCancel()",sResourcesPath}	
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
		
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{		
		as_save("myiframe0",sPostEvents);
	}
	
	/*~[Describe=ȷ��;InputParam=�����¼�;OutPutParam=��;]~*/
	function doCreation()
	{
		saveRecord("doReturn()");
	}
	
	function doReturn()
	{
		sSerialNo = getItemValue(0,0,"SerialNo");		
		top.returnValue = sSerialNo;
		insertBalance();
		top.close();
	}
	
	function insertBalance()//��ԭҵ������Ϊ��ˮ�Ŵ�BUSINESS_DUEBILL����ȡ���Balance,NormalBalance,OverdueBalance,DullBalance,BadBalance
	{
		sSerialNo = getItemValue(0,0,"SerialNo");
		sRelativeSerialNo1 = getItemValue(0,0,"RelativeSerialNo1");
		RunMethod("WorkFlowEngine","insertBalance",sRelativeSerialNo1+","+sSerialNo);
	}
		   
    /*~[Describe=ȡ������;InputParam=��;OutPutParam=ȡ����־;]~*/
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	
	function selectDueBill()
	{  
		sParaString = "OrgID"+","+"<%=CurOrg.OrgID%>";
		setObjectValue("SelectDueBill",sParaString,"@RelativeSerialNo1@0@CustomerID@1",0,0,"");
	}
							
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//����һ���ռ�¼			
			initSerialNo() 		//��ʼ����ˮ��
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_DUEBILL";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "BD";//ǰ׺
								
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
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