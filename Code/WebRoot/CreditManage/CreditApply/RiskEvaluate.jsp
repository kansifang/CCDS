<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:lpzhang 2009-8-12 
		Tester:
		Content:���նȲ���
		Input Param:
			ObjectNo�� ������
			ObjectType:��������
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���նȲ���"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";//sql���
	ASResultSet rs = null;
	//�ͻ���ţ�������ʽ
	String sCustomerID = "",sVouchResult = "",sEvaluateResult = "",sVouchResultName="",sTableName="",sVouchModulus ="";
	String sCustomerType = "";
	//����ϵ����
	double  dTermModulus = 0.0 ,dEvaluateModulus = 0.0,dTermMonth=0.0;
	String[] VouchModulus = new String[2];
	
	//����������
	//���ҳ�����	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectNo == null) sObjectNo = "";
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	if(sObjectType==null) sObjectType="";
%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%

	
	//ȡ���������ֵ
	sSql = " select BA.CustomerID,BA.VouchType,getItemName('VouchType',VouchType) as VouchResultName,"+
		   " TermMonth,getTermModulus(TermMonth) as TermModulus, CL.Attribute3 "+
		   " from Business_Apply BA ,Code_library CL where BA.VouchType =CL.ItemNo and CL.CodeNo='VouchType' and BA.SerialNo = '"+sObjectNo+"'" ;
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sCustomerID = rs.getString("CustomerID"); //�ͻ����
		sVouchResult = rs.getString("VouchType");//������ʽ
		sVouchResultName = rs.getString("VouchResultName");//������ʽ
		dTermMonth = rs.getDouble("TermMonth");//��������
		sVouchModulus = rs.getString("Attribute3");//����ϵ��
		dTermModulus = rs.getDouble("TermModulus");//����ϵ��
		if(sCustomerID == null) sCustomerID = "";
		if(sVouchResult == null) sVouchResult = ""; 
		if(sVouchResultName == null) sVouchResultName = ""; 
		if(sVouchModulus == null) sVouchModulus = ""; 
	}else
	{
		out.println("<font color=red>������д������������Ϣ��</font>");
		return;
	}
	rs.getStatement().close();
	//ȡ�ͻ���Ϣ
	sSql = "select CustomerType from Customer_Info where CustomerID = '"+sCustomerID+"'"; 
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sCustomerType = rs.getString("CustomerType");
		if(sCustomerType == null) sCustomerType = "";
	}
	rs.getStatement().close();	
	
	//ȡ�ÿͻ����õȼ�ֵ,����ͻ�����03��ͷ��Ϊ���˿ͻ�
	sTableName = Sqlca.getString("select (case when locate('03',CustomerType) = 1 then 'IND_INFO' else 'ENT_INFO' end) as TableName from Customer_Info where CustomerID ='"+sCustomerID+"'");
	if(sTableName==null) sTableName="";
	//���м������� 
	sSql = "select CreditLevel,getEvaluateModulus(CreditLevel) as EvaluateModulus from "+sTableName+" where CustomerID ='"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sEvaluateResult = rs.getString("CreditLevel"); //�������
		dEvaluateModulus = rs.getDouble("EvaluateModulus");//����ϵ��
		if(sEvaluateResult == null) sEvaluateResult = ""; 	
	}
	rs.getStatement().close();
	
	//�����������Ϊ��ȡ��ǰϵͳ���һ��ĩ(�Թ�)�������һ��(����)���������
	if("".equals(sEvaluateResult))
	{
		if(sCustomerType.startsWith("03"))//����
		{
			sSql = "select EvaluateResult,getEvaluateModulus(EvaluateResult) as EvaluateModulus "+
				" from EVALUATE_RECORD R "+
				" where ObjectType = 'Customer' "+
				" and ObjectNo = '"+sCustomerID+"'  order by AccountMonth desc fetch first 1 rows only";
		}else//�Թ�
		{
			sSql = "select EvaluateResult,getEvaluateModulus(EvaluateResult) as EvaluateModulus "+
				" from EVALUATE_RECORD R "+
				" where ObjectType = 'Customer' "+
				" and AccountMonth like '%/12' "+
				" and ObjectNo = '"+sCustomerID+"'  order by AccountMonth desc fetch first 1 rows only";
			
		}
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sEvaluateResult = rs.getString("EvaluateResult"); //�������
			dEvaluateModulus = rs.getDouble("EvaluateModulus");//����ϵ��
			if(sEvaluateResult == null) sEvaluateResult = ""; 	
		}
		rs.getStatement().close();
	}
	
	String sBizHouseFlag = "";
	sSql = "select CustomerType,GETBIZHOUSEFLAG(CustomerID) as BizHouseFlag from Customer_Info where CustomerID = '"+sCustomerID+"'"; 
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sCustomerType = rs.getString("CustomerType");
		sBizHouseFlag = rs.getString("BizHouseFlag");//�Ƿ��̻�
		if(sCustomerType == null) sCustomerType = "";
		if(sBizHouseFlag == null) sBizHouseFlag = "";
		if((!sCustomerType.startsWith("03") && sBizHouseFlag.equals("1")) && sVouchResult.equals("005")){
			dEvaluateModulus = 1.00;
			sEvaluateResult = "";
			dTermModulus = 1.00;
		}
	}
	rs.getStatement().close();
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "RiskEvaluate";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//�������ϵ�������䣬��VouchModulus����Ϊֻ��
	if(sVouchModulus.length()<1){
		out.println("<font color=red>�޵�����ʽ["+sVouchResultName+"]��Ӧϵ��������ϵϵͳ����Ա����ά����</font>");
		return;
	}else{
		if(sVouchModulus.indexOf(",")>-1)
		{
			VouchModulus = sVouchModulus.split(",");
			doTemp.setReadOnly("VouchModulus",false);
			doTemp.setRequired("VouchModulus",true);
			doTemp.setUnit("VouchModulus","<font color=red>������¼������ֵ�ڣ�"+VouchModulus[0]+"~"+VouchModulus[1]+"��֮��</font>");
		}
	}
	if((!sCustomerType.startsWith("03") && sBizHouseFlag.equals("1")) && sVouchResult.equals("005")){
		doTemp.setUnit("EvaluateResult","<font color=red>���˿ͻ����̻�����Ҫ������ʽΪ����ʱ�����ô�������õȼ�Ϊ�գ�</font>");
	}
	else if("".equals(sEvaluateResult)){
		doTemp.setUnit("EvaluateResult","<font color=red>�ÿͻ���û�п��õ�����������</font>");
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����һ��HTMLģ��
	String sHTMLTemplate = "<table align='center' width='100%' border='0' Backgroundcolor='#red' cellpadding='1' cellspacing='2' bodercolor='#red' bordercolorlight='#FFFFFF'   bordercolordark='#FFFFFF'>";
	sHTMLTemplate += "<tr><td><fieldset><legend><font color='blue'>����Ҫ��</font></legend>${DOCK:PART1}</fieldset></td></tr>";			   
	sHTMLTemplate += "<tr><td><fieldset><legend><font color='blue'>������</font></legend>${DOCK:PART2}</fieldset></td></tr>";
	sHTMLTemplate += "<tr><td><fieldset><legend><font color='blue'>�Ǽ���Ϣ</font></legend>${DOCK:PART3}</fieldset></td></tr>";			   
	sHTMLTemplate += "</table>";
	//��ģ��Ӧ����Datawindow
	dwTemp.setHarborTemplate(sHTMLTemplate);
	//����setEvent	
	dwTemp.setEvent("AfterInsert","!BusinessManage.UpdateLowRisk("+sObjectNo+",#RiskEvaluate)");
	dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateLowRisk("+sObjectNo+",#RiskEvaluate)");
	
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+sObjectType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//System.out.println("doTemp.SourceSql:"+doTemp.SourceSql);
	
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
							{"true","","Button","���㲢����","���㲢����","saveRecord()",sResourcesPath}
						  };
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if (!ValidityCheck()) return;
		if(vI_all("myiframe0"))
		{
			if(bIsInsert){		
				beforeInsert();
			}
			dVouchModulus = getItemValue(0,getRow(),"VouchModulus");
			if("<%=sCustomerType%>" == "03")
			{
				dRiskEvaluate =  parseFloat("<%=dEvaluateModulus%>")*parseFloat(dVouchModulus); //���ŷ��ն�=���õȼ�����ϵ��x������ʽ����ϵ��
			}else{
				dRiskEvaluate =  parseFloat("<%=dEvaluateModulus%>")*parseFloat(dVouchModulus)*parseFloat("<%=dTermModulus%>");//���ŷ��ն�=���õȼ�����ϵ��x������ʽ����ϵ��x�������޵���ϵ��
			}
			setItemValue(0,0,"RiskEvaluate",dRiskEvaluate);
			
			as_save("myiframe0",sPostEvents);
		}
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{
		sVouchResult = getItemValue(0,getRow(),"VouchResult");
		dTermNum = getItemValue(0,getRow(),"TermNum");
		dVouchModulus = getItemValue(0,getRow(),"VouchModulus");
		if(typeof(sVouchResult) == "undefined" || sVouchResult == "" || typeof(<%=dTermMonth%>) == "undefined" || "<%=dTermMonth%>" == "")
		{	
			alert("���ȱ����������������Ϣ�");
			return false;
		}
		if("<%=sVouchModulus%>".indexOf(",")>-1)//����ϵ�������䣬����Ҫ�ж�����������Ƿ���������
		{
			if(parseFloat(dVouchModulus) < parseFloat("<%=VouchModulus[0]%>") || parseFloat(dVouchModulus) > parseFloat("<%=VouchModulus[1]%>"))
			{
				alert("������ʽ����ϵ��¼��������������֮�ڣ�");
				return false;
			}
		}
		
		return true;
	}
	
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		}
		setItemValue(0,0,"EvaluateResult","<%=sEvaluateResult%>");
		setItemValue(0,0,"VouchResult","<%=sVouchResult%>");
		setItemValue(0,0,"VouchResultName","<%=sVouchResultName%>");
		if("<%=sCustomerType%>" == "03")
		{
			setItemValue(0,0,"TermNum","");
			setItemValue(0,0,"TermModulus","");
			 
		}else
		{
			setItemValue(0,0,"TermNum","<%=dTermMonth%>");
			setItemValue(0,0,"TermModulus","<%=dTermModulus%>");
		}
		if("<%=sVouchModulus%>".indexOf(",")<0)
		{
			setItemValue(0,0,"VouchModulus","<%=sVouchModulus%>");
		}
		
		setItemValue(0,0,"EvaluateModulus","<%=dEvaluateModulus%>");
	}
	
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�
		bIsInsert = false;
	}
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "RISK_EVALUATE";//���� 
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

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
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
