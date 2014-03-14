<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: lzhang 	2011.04.25
			Tester:
			Content:LIBOR���ʹ���
			Input Param:
					Currency:����
					InputDate:����
					RateType:��������
			Output param:
			History Log: 
				update by yfliu 2007.9.3

		 */
	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "LIBOR���ʹ���"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>

<html>
<head>
<title>���ʹ���</title>
<%
	String sCurrency = DataConvert.toRealString(request.getParameter("Currency"));
	String sInputDate = DataConvert.toRealString(request.getParameter("InputDate"));
	String sRateType = DataConvert.toRealString(request.getParameter("RateType"));

	if(sCurrency 	== null) 	sCurrency = "";
	if(sInputDate 	== null) 	sInputDate ="";
	if(sRateType 	== null) 	sRateType ="";


  	String sHeaders[][] = { 
		                        {"CurrencyName","����"},
		                        {"Currency","����"},
			            {"InputDate","��Ч����"},  
			            {"RateType","��������"},
			            {"RateTypeName","��������"},
			            {"Rate","��׼����"}					        
				  };   		   		   		
	
	String sSql;
	
	sSql = " select InputDate,Currency,RateType,getItemName('GJRateType',RateType) as RateTypeName,getItemName('Currency',Currency) as CurrencyName,Rate "+
       	   " from LIBOR_INFO where InputDate = '"+sInputDate+"' and RateType = '"+sRateType+"' and Currency = '"+sCurrency+"' ";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	
	doTemp.UpdateTable="LIBOR_INFO";
	doTemp.setKey("InputDate,Currency,RateType",true);

	doTemp.setRequired("Currency,InputDate,RateType,Rate",true);
	doTemp.setVisible("RateTypeName,CurrencyName",false);
	doTemp.setCheckFormat("Rate","16");
	doTemp.setCheckFormat("InputDate","3");
	doTemp.setDDDWCode("RateType","GJRateType");
	doTemp.setDDDWSql("RateType","select ItemNo,ItemName from code_library where CodeNo = 'GJRateType' and left(ItemNo,1) in ('Y','Z')");
	doTemp.setDDDWCode("Currency","Currency");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
		String sButtons[][] = 	{
						{"true","","Button","����","������Ϣ","finish()",sResourcesPath},
						{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
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

<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	var sRate = "" , sUpdateUserName ="" ,sUpdateTime ="";
	var sName ="";

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		sRate = getItemValue(0,getRow(),"Rate");
    	sUpdateUserName = "<%=CurUser.UserName%>";
    	sUpdateTime = "<%=StringFunction.getToday()%>";
    	
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"RateIDType","02");
			bIsInsert = true;
		}
    }
	
	function beforeInsert()
	{
       initSerialNo();//��ʼ����ˮ���ֶ�
	}
	
	function pageReload()
	{
		sAreaNo = getItemValue(0,getRow(),"AreaNo");//--���»����ˮ��
		OpenPage("/SystemManage/SynthesisManage/LiborRateChangeInfo.jsp?AreaNo="+sAreaNo+"", "_self","");
	}
	
    //�����ͬʱ���޸���,�޸�ʱ��,�����ʱ��浽rate_info_log����
    function finish()
    {
    	var sTableName = "RATE_INFO_LOG";//����
		var sColumnName = "AreaNo";//�ֶ���
		var sPrefix = "";//ǰ׺
		
    	if(bIsInsert)
    	{
    		beforeInsert();
    	}
   		as_save("myiframe0","");
    }
    
    function goBack()
    {
    	OpenPage("/SystemManage/SynthesisManage/LiborRatechangeList.jsp", "_self","");
    }
    
    /*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "RATE_INFO";//����
		var sColumnName = "AreaNo";//�ֶ���
		var sPrefix = "";//ǰ׺
       
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
</script>

<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>

<%@ include file="/IncludeEnd.jsp"%>