<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: hysun 	2006.10.23
			Tester:
			Content:���ʹ���
			Input Param:
					Currency:����
					Type:״̬
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
		String PG_TITLE = "���ʹ���"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>

<html>
<head>
<title>���ʹ���</title>
<%
	String sAreaNo = DataConvert.toRealString(request.getParameter("AreaNo"));
	String sType = DataConvert.toRealString(request.getParameter("Type"));

	if(sAreaNo == null) sAreaNo = "";
	if(sType == null) sType ="";


  	String sHeaders[][] = { 
		                        {"Currency","����"},
			            {"EfficientDate","��Ч����"},  
			            {"RateName","��������"},
			            {"RateIDType","������������"},
			            {"RateType","��������"},
			            {"RangeFrom","��ʼ������(����)"},
			            {"RangeTo","��ֹ������(��)"},
			            {"Rate","����"}					        
				  };   		   		   		
	
	String sSql;
	
	sSql = " select AreaNo,Currency,RateName, "+
    	   " RateIDType,RateType,RangeFrom,RangeTo,Rate,EfficientDate" +
       	   " from RATE_INFO where AreaNo = '"+sAreaNo+"'";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	
	doTemp.UpdateTable="RATE_INFO";
	doTemp.setKey("AreaNo",true);

	doTemp.setRequired("Currency,EfficientDate,RateName,RateIDType,ratetype,,RangeFrom,RangeTo,Rate",true);
	doTemp.setRequired("Currency,EfficientDate,ExchangeValue",true);
	doTemp.setCheckFormat("ExchangeValue","16");
	doTemp.setCheckFormat("EfficientDate","3");
	doTemp.setVisible("AreaNo",false);
	//doTemp.setReadOnly("RateIDType",true);
	doTemp.setCheckFormat("Rate","16");
	doTemp.setHTMLStyle("RateName"," style={width:300px}");
	//���ݱ���ȷ����������
	doTemp.appendHTMLStyle("Currency", "onBlur = \"javascript:parent.getRatetype()\" ");
	//sFlagΪ1ʱ��ʾ����,Ϊ2��ʾ�޸�/����
	if( sType.equals("Read") )
	{	
		doTemp.setReadOnly("Currency,RateName,RateType,RangeFrom,RangeTo",true);
	}
	
	doTemp.setDDDWCode("Currency","Currency");
	doTemp.setDDDWCode("RateType","SystemRateType");
	doTemp.setDDDWCode("RateIDType","RateType");
	
	
	
	
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
    
    function getRatetype()
    {
   		var sCurrency = getItemValue(0,getRow(),"Currency");
   		if(sCurrency == "01")
   		{
   			setItemValue(0,getRow(),"ratetype","");
   		}else
   		{
   			setItemValue(0,getRow(),"ratetype","060");
   		}
   		
    }
	
	function beforeInsert()
	{
       initSerialNo();//��ʼ����ˮ���ֶ�
	}
	
	function pageReload()
	{
		sAreaNo = getItemValue(0,getRow(),"AreaNo");//--���»����ˮ��
		OpenPage("/SystemManage/SynthesisManage/RateChangeInfo.jsp?AreaNo="+sAreaNo+"", "_self","");
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
    	//���Ϊ��������,�����ҳ��ˢ��һ��,��ֹ�������޸�
   		as_save("myiframe0","pageReload()");
   	  	/*
   		sUpdateUserName = "<%=CurUser.UserName%>";
   		sAreaNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
   		sEfficientDate = getItemValue(0,getRow(),"EfficientDate");   		
   		sRateName = getItemValue(0,getRow(),"RateName");
   		sRateType = getItemValue(0,getRow(),"RateType");
   		sRateIDType = getItemValue(0,getRow(),"RateIDType");
   		sCurrency = getItemValue(0,getRow(),"Currency");
   		sRangeFrom = getItemValue(0,getRow(),"RangeFrom");
   		sRangeTo = getItemValue(0,getRow(),"RangeTo");
   		sNewRate = getItemValue(0,getRow(),"Rate");
   		if (typeof(sRate)=="undefined" || sRate.length==0)
   		{
   			sRate = sNewRate ;
   		}
   		RunMethod("BusinessManage","RateChangeRecord",sAreaNo+","+sEfficientDate+","+sRateName+","+sRateType+","+sRateIDType+","+sCurrency+","+sRangeFrom+","+sRangeTo+","+sRate+","+sUpdateUserName+","+sUpdateTime+","+sNewRate);
    	*/
    }
    
    function goBack()
    {
    	OpenPage("/SystemManage/SynthesisManage/RatechangeList.jsp", "_self","");
    }
    
    function getPrice()
    {
    	var sExchangeValue = parseFloat(getItemValue(0,getRow(),"ExchangeValue"));
    	var sPrice = sExchangeValue*100;
    	setItemValue(0,0,"Price",sPrice);
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