<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   bma 2008-09-19
		Tester:
		Content: ����ҵ�񲹵�����ҳ��
		Input Param:
			SerialNo����ݺ�
			ReinforceFlag����־λ
				020010δ������
			   	020020�ѽ�����
			   	030010�ѽ������ҵ��
			   	030020�ѽ������ҵ��
		Output param:
		History Log: 	
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ҵ�񲹵�����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//����������	���������͡��������͡��׶����͡����̱�š��׶α��
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReinforceFlag"));
	String sMFOrgID = "";
	
	//����ֵת���ɿ��ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sReinforceFlag == null) sReinforceFlag = "";
		
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "NewNationalInfo";
	String sSql = " select MainFrameExgID from ORG_INFO where OrgID ='"+CurOrg.OrgID+"'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sMFOrgID = rs.getString("MainFrameExgID");
		if(sMFOrgID==null) sMFOrgID = "";
	}
	rs.getStatement().close();
	//����ģ�����������ݶ���	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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
			  {"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath},
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
		sBusinessStatus = getItemValue(0,getRow(),"BusinessStatus");
		sFinishDate = getItemValue(0,getRow(),"FinishDate");
		sReturnType = getItemValue(0,getRow(),"ReturnType");
		sActualMaturity = getItemValue(0,getRow(),"Maturity");//ʵ�ʵ�����
		if(sBusinessStatus == "20" && (sReturnType == null || sReturnType == "" ))
		{
			alert("ҵ��״̬Ϊע��ʱ�����ʽ����Ϊ��");
			return;
		}else if(sBusinessStatus == "20" && (sFinishDate == null || sFinishDate == "" ))
		{
			alert("ҵ��״̬Ϊע��ʱ��ע�����ڲ���Ϊ��");
			return;
		}
		judgeBalance();
		setItemValue(0,getRow(),"ActualMaturity",sActualMaturity);
		as_save("myiframe0",sPostEvents);
	}
	
	/*~[Describe=�ж����;InputParam=��;OutPutParam=ȡ����־;]~*/
	function judgeBalance()
	{		
		sBalance = getItemValue(0,getRow(),"Balance");	//���
		sNormalBalance = getItemValue(0,getRow(),"NormalBalance"); //�������
		sOverdueBalance = getItemValue(0,getRow(),"OverdueBalance");//�������
		sDullBalance = getItemValue(0,getRow(),"DullBalance");	//�������
		sBadBalance = getItemValue(0,getRow(),"BadBalance");	//�������
		if(sBalance == null ||sBalance == "" || sBalance == " ") sBalance = 0.0;
		if(sNormalBalance == null || sNormalBalance == "" || sNormalBalance == " ") sNormalBalance = 0.0;
		if(sOverdueBalance == null || sOverdueBalance == "" || sOverdueBalance == " ") sOverdueBalance = 0.0;
		if(sDullBalance == null || sDullBalance == " ") sDullBalance = 0.0;
		if(sBadBalance == null || sBadBalance == "" || sBadBalance == " ") sBadBalance = 0.0;
		sSum = sNormalBalance+sOverdueBalance+sDullBalance+sBadBalance;
		if(sBalance != sSum)
		{
			alert("�϶����֮�Ͳ�����Ԥ�����");
			return;
		}	
	}
	
	/*~[Describe=��ʼ���϶����;InputParam=��;OutPutParam=ȡ����־;]~*/
	function getBalance()
	{		
		sBalance = getItemValue(0,getRow(),"Balance");	//���
		if(sBalance == null ||sBalance == "" || sBalance == " ") sBalance = 0.0;
		sNormalBalance = sBalance; //�������
		sOverdueBalance = 0.0;//�������
		sDullBalance = 0.0;	//�������
		sBadBalance = 0.0;	//�������
		setItemValue(0,getRow(),"NormalBalance",sNormalBalance);
		setItemValue(0,getRow(),"OverdueBalance",sOverdueBalance);
		setItemValue(0,getRow(),"DullBalance",sDullBalance);
		setItemValue(0,getRow(),"BadBalance",sBadBalance);
	}
		   
    /*~[Describe=ȡ���������ŷ���;InputParam=��;OutPutParam=ȡ����־;]~*/
	function goBack()
	{		
		self.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	
	function selectDueBill()
	{  
		setObjectValue("SelectDueBill","","@RelativeSerialNo1@0",0,0,"");
	}
	
							
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		var sInputOrgID = getItemValue(0,getRow(),"InputOrgID");
		if( sInputOrgID == "" || sInputOrgID == " " || sInputOrgID == null)
		{
			setItemValue(0,getRow(),"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,getRow(),"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,getRow(),"MFOrgID","<%=sMFOrgID%>");
		}
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