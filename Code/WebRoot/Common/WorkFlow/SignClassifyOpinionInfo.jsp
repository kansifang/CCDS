<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
	Author:  xhyong 2009/08/19 
	Tester:
	Content: ���շ����϶�ǩ�����
	Input Param:
		SerialNo ������ˮ��
		ObjectNo ������ˮ��
		ObjectType ��������
		CSerialNo ��ͬ��ˮ��
		CustomerID �ͻ�ID
	Output param:
	History Log: 
	
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���շ����϶�ǩ�����";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%	
	//�������:��ʾģ���š��״η����ա��ͻ����͡�ģ�ͷ�������Sql��䡢��ѯ�����
	String sTempletNo = "";
	String sOriginalPutOutDate = "",sCustomerType = "",sResult1 = "";
	String sClassifyLevel1 = "",sClassifyLevel2 = "",sphasechoice = "", sphasechoice2 = "";
	String sCustomerName = "";
	String sSql = "";
	ASResultSet rs = null;
	//��ȡ���������������ˮ��
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sCSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CSerialNo"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	String sClassifyLevel = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ClassifyLevel"));
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sCSerialNo == null) sCSerialNo = "";
	if(sCustomerID == null) sCustomerID = "";
	if(sPhaseNo == null) sPhaseNo = "";
	
	sSql = " select PhaseOpinion1,PhaseOpinion5 from Flow_opinion where serialNo in(select serialno from flow_task "+
	" where objectno = '"+sObjectNo+"' and objecttype = 'ClassifyApply' and Phaseno = '0020')";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sphasechoice = DataConvert.toString(rs.getString("PhaseOpinion1"));
		sphasechoice2 = DataConvert.toString(rs.getString("PhaseOpinion5"));
				
		//����ֵת���ɿ��ַ���
		if(sphasechoice == null) sphasechoice = "";	
		if(sphasechoice2 == null) sphasechoice2 = "";	
	}
	rs.getStatement().close(); 
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
	<%
	
	sTempletNo = "SignClassifyOpinionInfo";
		
	//����ͬ���з��շ��࣬����״η�����
	sSql = " select min(PUTOUTDATE) from BUSINESS_DUEBILL where RelativeSerialNo2 = '"+sCSerialNo+"' ";
	sOriginalPutOutDate = Sqlca.getString(sSql);
	if(sOriginalPutOutDate == null) sOriginalPutOutDate = "";
	
	//��ÿͻ�����
	sSql = " select CustomerType,CustomerName from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sCustomerType = DataConvert.toString(rs.getString("CustomerType"));
		sCustomerName = DataConvert.toString(rs.getString("CustomerName"));
				
		//����ֵת���ɿ��ַ���
		if(sCustomerType == null) sCustomerType = "";
		if(sCustomerName == null) sCustomerName = "";
	}
	rs.getStatement().close(); 
	
	sCustomerType = Sqlca.getString(sSql);
	if(sCustomerType == null) sCustomerType = "";
	
	//������������Ϣ:���ֽ��
	sSql = 	" select Result1,ClassifyLevel,ClassifyLevel2 "+
			" from CLASSIFY_RECORD "+
			" where SerialNo = '"+sObjectNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sResult1 = rs.getString("Result1");
		sClassifyLevel1 = rs.getString("ClassifyLevel");
		sClassifyLevel2 = rs.getString("ClassifyLevel2");
		//����ֵת��Ϊ���ַ���
		if(sResult1 == null) sResult1 = "";
		if(sClassifyLevel1 == null) sClassifyLevel1 = "";
		if(sClassifyLevel2 == null) sClassifyLevel2 = "";
	}
	rs.getStatement().close();
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//����������
	if(sCustomerType.substring(0,2).equals("01"))//��˾�ͻ�ʹ��10������
	{
		doTemp.setDDDWSql("PhaseOpinion1,PhaseOpinion5","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'ClassifyResult' and length(ItemNo)=4 order by SortNo ");
	}else{
		doTemp.setDDDWSql("PhaseOpinion1,PhaseOpinion5","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'ClassifyResult' and length(ItemNo)=2 order by SortNo ");
	}
	
	if("0010".equals(sPhaseNo) || "0020".equals(sPhaseNo)){
		doTemp.setVisible("phasechoice,phasechoice2",false);
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//��������¼�

	//����HTMLDataWindow
	//classify_record�������ΪSerialNo��ObjectType��ObjectNo������������Ϊȷ���߼�׼ȷ�����Ӵ��������ͬʱ�޸Ķ�Ӧ��ʾģ��
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo+","+sObjectNo+","+sObjectType);
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
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ�����","deleteRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language="javascript">

	/*~[Describe=����ǩ������;InputParam=��;OutPutParam=��;]~*/
	function saveRecord()
	{
		sObjectNo = "<%=sObjectNo%>";
		sObjectType = "<%=sObjectType%>";
		sOpinionNo = getItemValue(0,getRow(),"OpinionNo");	
		if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
		{
			var sTaskNo = "<%=sSerialNo%>";
			var sReturn = RunMethod("WorkFlowEngine","CheckOpinionInfo",sTaskNo);
			if(!(typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn == "Null" || sReturn == "null" || sReturn == "NULL")){
				alert("�˱�ҵ����ǩ���������ˢ��ҳ����ǩ�������");
				return;
			}
			initOpinionNo();
		}
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
        sPhaseOpinion1 = getItemValue(0,getRow(),"PhaseOpinion1");
        if("<%=sPhaseNo%>"=="0010")
        {
        	sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@Result2@"+sPhaseOpinion1+",CLASSIFY_RECORD,String@SerialNo@<%=sObjectNo%>");
        }
        if("<%=sPhaseNo%>"=="0020"){
        	if(sPhaseOpinion1 < "<%=sClassifyLevel1%>"){
        		if(!confirm("��ѡ��ķ����϶���������棩���ڿͻ�������շ�����(����)���Ƿ����?")){
        			setItemValue(0,0,"PhaseOpinion1","");
        			return;
        		}
        	}
        }
        if("<%=sPhaseNo%>"=="0050"){
        	if(sPhaseOpinion1 < "<%=sphasechoice%>"){
        		if(!confirm("��ѡ��ķ����϶���������棩���ڸ���Ա���շ�����(����)���Ƿ����?")){
        			setItemValue(0,0,"PhaseOpinion1","");
        			return ;
        		}
        	}
        }
        
		as_save("myiframe0");
	}
	
	/*~[Describe=ɾ�����;InputParam=��;OutPutParam=��;]~*/
    function deleteRecord()
    {
	    sSerialNo=getItemValue(0,getRow(),"SerialNo");
	    sOpinionNo = getItemValue(0,getRow(),"OpinionNo");
	    
	    if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
	 	{
	   		alert("����û��ǩ�������������ɾ�����������");
	 	}
	 	else if(confirm("��ȷʵҪɾ�������"))
	 	{
	   		sReturn= RunMethod("BusinessManage","DeleteSignOpinion",sSerialNo+","+sOpinionNo);
	   		if (sReturn==1)
	   		{
	    		alert("���ɾ���ɹ�!");
	  		}
	   		else
	   		{
	    		alert("���ɾ��ʧ�ܣ�");
	   		}
		}
		reloadSelf();
	} 
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initOpinionNo() 
	{
		var sTableName = "FLOW_OPINION";//����
		var sColumnName = "OpinionNo";//�ֶ���
		var sPrefix = "";//��ǰ׺
								
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sOpinionNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sOpinionNo);
	}
	
	/*~[Describe=����һ���¼�¼;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		//���û���ҵ���Ӧ��¼��������һ���������������ֶ�Ĭ��ֵ
		if (getRowCount(0)==0) 
		{
			as_add("myiframe0");//������¼
			setItemValue(0,getRow(),"SerialNo","<%=sSerialNo%>");
			setItemValue(0,getRow(),"ObjectType","<%=sObjectType%>");
			setItemValue(0,getRow(),"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"OriginalPutOutDate","<%=sOriginalPutOutDate%>");
			setItemValue(0,getRow(),"InputOrg","<%=CurOrg.OrgID%>");
			setItemValue(0,getRow(),"PhaseOpinion2","<%=sResult1%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,getRow(),"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,getRow(),"CustomerID","<%=sCustomerID%>");
			setItemValue(0,getRow(),"CustomerName","<%=sCustomerName%>");
		}
		setItemValue(0,0,"OriginalPutOutDate","<%=sOriginalPutOutDate%>");      
		setItemValue(0,getRow(),"phasechoice","<%=sphasechoice%>");
		setItemValue(0,getRow(),"phasechoice2","<%=sphasechoice2%>");
		setItemValue(0,getRow(),"PhaseOpinion3","<%=sClassifyLevel1%>");
		setItemValue(0,getRow(),"PhaseOpinion4","<%=sClassifyLevel2%>");
	}

	</script>
<%/*~END~*/%>


<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%@ include file="/IncludeEnd.jsp"%>