<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: wwhe 2008-11-28
			Tester:
			Describe: ���ʹ���
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
		String PG_TITLE = "���ʹ�����Ϣ��ϸ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������

	//����������

	//���ҳ�����
	String sCurrency = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Currency"));
	String sEfficientDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EfficientDate"));
	String sEfficientTime = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EfficientTime"));
	
	if(sCurrency == null) sCurrency = "";
	if(sEfficientDate == null || "".equals(sEfficientDate)) sEfficientDate = "XX";
	if(sEfficientTime == null || "".equals(sEfficientTime)) sEfficientTime = "XX";
%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][] = { 
		                        {"Currency","����"},
			            {"EfficientDate","��Ч����"},  
			            {"Price","�м��"},
			            {"Unit","��λ"},					        
			            {"Remark","��ע"}					        
				  };   		   		
	
	String sSql =  " select ExchangeValue,Currency,"+
		           " Unit,Price,EfficientDate,EfficientTime,Remark"+
		           " from ERATE_INFO "+
		           " where Currency = '"+sCurrency+"' "+
		           " and nvl(EfficientDate,'XX') = '"+sEfficientDate+"'"+
		           " and nvl(EfficientTime,'XX') = '"+sEfficientTime+"'";
             
  	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ÿɸ���Ŀ���
	doTemp.UpdateTable = "ERATE_INFO";
	doTemp.setKey("Currency",true);		
	//���ñ�������������
	doTemp.setDDDWCode("Currency","Currency");
	doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px} ");
	//�����ֶθ�ʽ
	//doTemp.setCheckFormat("EfficientDate","3");
	doTemp.setAlign("ExchangeValue,Price,Unit","3");
	doTemp.setType("ExchangeValue,Price,Unit","Number");
	doTemp.setVisible("ExchangeValue,EfficientTime",false);
	doTemp.setReadOnly("ExchangeValue,EfficientTime", true);
	doTemp.setHTMLStyle("Currency,Price,Unit,EfficientDate","onBlur=parent.getExchangeValue()");
	doTemp.setRequired("Currency,Price,Unit,EfficientDate",true);	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //freeform��ʽ
	dwTemp.ReadOnly = "0"; //����Ϊֻ��
	
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

<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/
%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			//��������,���Ϊ��������,�����ҳ��ˢ��һ��,��ֹ�������޸�
			as_save("myiframe0");
			return;
		}
		as_save("myiframe0",sPostEvents);
	}

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/SynthesisManage/ExchangeList.jsp","_self","");
	}
	
	//�����Զ�����ExchangeValue�ֶε�ֵ  added by ylwang 2009-12-03
	function getExchangeValue(){
		dPrice = getItemValue(0,getRow(),"Price");
		dUnit = getItemValue(0,getRow(),"Unit");
		dExchangeValue = dPrice/dUnit;
		if(isNaN(dExchangeValue))
			dExchangeValue = 0.0;
		setItemValue(0,0,"ExchangeValue",dExchangeValue);
	}
	</script>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"EfficientTime","<%=StringFunction.getNow()%>");
			bIsInsert = true;
		}
	}
	</script>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>
<%
	/*~END~*/
%>

<%@	include file="/IncludeEnd.jsp"%>