<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cwliu 2004-11-29
		Tester:
		Describe:  ��Ŀ�ʽ���Դ
		Input Param:
			ProjectNo����ǰ��Ŀ���
		Output Param:
			ProjectNo����ǰ��Ŀ���
			

		HistoryLog: 
					2005.7.28   hxli �޸�Ͷ��ռ�ȳ�ʼ���������д
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ŀ�ʽ���Դ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	ASResultSet rs ;
	String sPlanTotalCast = "";
	String sProjectCapitalScale = "";
	//����������
	String sProjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProjectNo"));
	//���ҳ�����	
	String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sFundSource  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FundSource"));
	if(sFundSource == null ) sFundSource = "";
	if(sSerialNo == null ) sSerialNo = "";

	
	if(sFundSource.equals("01"))
	{
		sSql = "select PlanTotalCast,CapitalScale from PROJECT_INFO "+
			   " where ProjectNo= '"+sProjectNo+"'";
		rs = Sqlca.getResultSet(sSql);
		if(rs.next())
		{
			sPlanTotalCast = rs.getString("PlanTotalCast");
			sProjectCapitalScale = rs.getString("CapitalScale");
		}
		rs.getStatement().close();

	}
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ProjectFundsInfo";	
	String sTempletFilter = "  ColAttribute like '%"+sFundSource+"%' ";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	//����Ŀ���ʽ� �С����� Ҫ��Ӧ����Ϊ��Ͷ�ʽ����������Գ��ʽ��С���������Ϊ�����ʽ�
	System.out.println("sFundSource:"+sFundSource);
	if("02".equals(sFundSource))//��Ŀ���ʽ�
	{
		doTemp.setHeader("INVESTSUM","���ʽ��");
		doTemp.setHeader("INVESTRATIO","����ռ��");
		doTemp.setHeader("TOTALSUM","�ʱ����ܶ�");
		doTemp.setDDDWSql("ATTENDPROJECTWAY","select ItemNo,ItemName from code_Library where CodeNo ='ContributiveType' and ItemNo in ('010','020') ");
	}
	if("01".equals(sFundSource))//�����Գ��ʽ�
	{
		doTemp.setHeader("TOTALSUM","�����ܶ�");
		doTemp.setHeader("INVESTSUM","���ʽ��");
		doTemp.setDDDWSql("ATTENDPROJECTWAY","select ItemNo,ItemName from code_Library where CodeNo ='ContributiveType' and ItemNo in ('030','040') ");
	}
	if("03".equals(sFundSource))//��Ŀ���ʽ�
	{
		doTemp.setHeader("INVESTSUM","���ʽ��");
		doTemp.setHeader("INVESTRATIO","����ռ��");
		doTemp.setHeader("TOTALSUM","�����ܽ��");
		doTemp.setHeader("INVESTORNAME","���ڻ�������");
	}
	
	//����Ͷ��ռ��(%)��Χ
	//doTemp.appendHTMLStyle("INVESTRATIO"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"Ͷ��ռ��(%)�ķ�ΧΪ[0,100]\" ");
	//���õ�λ����(%)��Χ
	doTemp.appendHTMLStyle("ACTUALRADIO"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��λ����(%)�ķ�ΧΪ[0,100]\" ");
	//����Ͷ�ʽ��(Ԫ)��Χ
	doTemp.appendHTMLStyle("INVESTSUM"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʽ��(Ԫ)������ڵ���0��\" ");
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sProjectNo+","+sSerialNo);
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
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
		setObjectValue("SelectInvest","","@INVESTORCODE@0@INVESTORNAME@1",0,0,"");
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/EntManage/ProjectFundsList.jsp?","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/ProjectFundsInfo.jsp","_self","");
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();
		setItemValue(0,0,"PROJECTNO","<%=sProjectNo%>");
		setItemValue(0,0,"FUNDSOURCE","<%=sFundSource%>");
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{	
		var sFundSource = "<%=sFundSource%>";
		sInvestRatio = getItemValue(0,getRow(),"INVESTRATIO");
		if(sInvestRatio>100 || sInvestRatio<0){
			if(sFundSource=="01"){
				alert("����ռ��(%)�ķ�ΧΪ[0,100]");	
			}else if(sFundSource=="02"){
				alert("����ռ��(%)�ķ�ΧΪ[0,100]");
			}else if(sFundSource=="03"){
				alert("����ռ��(%)�ķ�ΧΪ[0,100]");
			}	
			return false;
		}
		return true;
	}

	//ѡ�����
	function getRegionCode()
	{
		sParaString = "CodeNo"+",AreaCode";			
		setObjectValue("SelectCode",sParaString,"@LOCATIONOFINVESTOR@0@LOCATIONOFINVESTORNAME@1",0,0,"");
	}	
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"FUNDSOURCE","<%=sFundSource%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			if("<%=sFundSource%>"=="010")
			{	//hxli Ͷ��ռ��Ϊ�գ��ÿհ�
				if("<%=sPlanTotalCast%>" != "null" )
				{
					setItemValue(0,0,"INVESTSUM","<%=sPlanTotalCast%>");
					//setItemValue(0,0,"INVESTRATIO","<%=sProjectCapitalScale%>");
				}
				
				if("<%=sProjectCapitalScale%>" != "null")
				{
					//setItemValue(0,0,"INVESTSUM","<%=sPlanTotalCast%>");
					setItemValue(0,0,"INVESTRATIO","<%=sProjectCapitalScale%>");
				}
			}
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "PROJECT_FUNDS";//����
		var sColumnName = "SERIALNO";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	function getInvestRatio(){
		var sInvestSum = getItemValue(0,getRow(),"INVESTSUM");
		var sTotalSum = getItemValue(0,getRow(),"TOTALSUM");
		sInvestRatio = parseFloat(sInvestSum/sTotalSum)*100
		sInvestRatio = Math.round(parseFloat(sInvestRatio)*100)/100
		setItemValue(0,getRow(),"INVESTRATIO" ,sInvestRatio);	
		
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
