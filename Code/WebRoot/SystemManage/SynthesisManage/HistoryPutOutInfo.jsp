<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> 

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hlzhang 2012.08.09
		Tester:
		Content: �����޸�����
		Input Param:
		Output param:
		History Log:  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����޸�����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	
	//�������������������ͺͶ�����
	String sBPBSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BPBSerialNo"));
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//���������SQL��䡢����ҵ��Ʒ�֡�������ʾģ�桢���������ݴ��־
	String sSql = "",sBusinessType = "",sDisplayTemplet = "",sMainTable = "";
	//�����������������
	String sBCOccurType = "";
	//�����������ѯ�����
	ASResultSet rs = null;
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%
	//���ݶ������ʹӶ������Ͷ�����в�ѯ����Ӧ�����������
	sSql = 	" select ObjectTable from OBJECTTYPE_CATALOG "+
			" where ObjectType = '"+sObjectType+"' ";
	sMainTable = Sqlca.getString(sSql);	
	
	//��ȡ����ҵ��Ʒ��
	sSql = 	" select BusinessType from "+sMainTable+" "+
			" where SerialNo ='"+sObjectNo+"' ";
	sBusinessType = Sqlca.getString(sSql);	
	//���ҵ��Ʒ��Ϊ��,����ʾ���������ʽ����
	if (sBusinessType.equals(""	)) sBusinessType = "1010010";
	
	//��ȡ�ó�����Ϣ�ķ�������
	sSql = 	" select BC.OccurType,BC.PutOutDate,BC.Maturity,BC.BusinessType,BC.BusinessSum,BC.AdjustRateType "+
			" from BUSINESS_CONTRACT BC "+
			" where exists (select BP.ContractSerialNo from BUSINESS_PUTOUT BP "+
			" where BP.SerialNo = '"+sObjectNo+"' "+
			" and BP.ContractSerialNo = BC.SerialNo) ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sBCOccurType = rs.getString("OccurType");
		//����ֵת��Ϊ���ַ���
		if(sBCOccurType == null) sBCOccurType = "";
	}
	rs.getStatement().close();
	
	if(sBCOccurType.equals("015")) //չ��
		sDisplayTemplet = "PutOutInfo0";
	else
	{
		//���ݲ�Ʒ���ʹӲ�Ʒ��Ϣ��BUSINESS_TYPE�л����ʾģ������
		sSql = " select DisplayTemplet from BUSINESS_TYPE where TypeNo = '"+sBusinessType+"' ";
		sDisplayTemplet = Sqlca.getString(sSql);
		if(sDisplayTemplet==null)sDisplayTemplet="";
	}
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sDisplayTemplet,Sqlca);
	
	//���ø��±���������
	doTemp.UpdateTable = "BUSINESS_PUTOUT_BAK";
	doTemp.setKey("BPBSerialNo",true);
	doTemp.FromClause = " from BUSINESS_PUTOUT_BAK BUSINESS_PUTOUT";
	doTemp.WhereClause = " where BPBSerialNo = '"+sBPBSerialNo+"' ";
		
	//��ҵ��Ʒ��Ϊ����ҵ��ʱ������ʾ֧����ʽ add by bqliu 2011-05-19
	if(sBusinessType.startsWith("2"))
	{
		doTemp.setRequired("SelfPayMethod",false);
		doTemp.setVisible("SelfPayMethod",false);
	}
	
	//���ø�ʽ,����С����4λ
	doTemp.setCheckFormat("RateFloat,BackRate,RiskRate","14");
	//�������ʸ�ʽ,����С����6λ
	doTemp.setCheckFormat("BaseRate,BusinessRate,OverdueRate,TARate","16");
	
	//���ù̶��������뷶Χ
	if(sDisplayTemplet.equals("PutOutInfo1") || sDisplayTemplet.equals("PutOutInfo2") || sDisplayTemplet.equals("PutOutInfo3") || sDisplayTemplet.equals("PutOutInfo8")){
		doTemp.appendHTMLStyle("FixCyc"," myvalid=\"parseFloat(myobj.value,10)>=2 && parseFloat(myobj.value,10)<=12 \" mymsg=\"�̶��������뷶ΧΪ[2,12]\" ");
	}
	if(sDisplayTemplet.equals("PutOutInfo9")){
		doTemp.appendHTMLStyle("CDate"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=31 \" mymsg=\"�ۿ������뷶ΧΪ[0,31]\" ");
	}
	if(sDisplayTemplet.equals("PutOutInfo11")||sDisplayTemplet.equals("PutOutInfo12"))
	{
		doTemp.appendHTMLStyle("FZANBalance"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"�������ʱ�����ڵ���0,С�ڵ���1000��\" ");
	}
	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����������ڵ���0,С�ڵ���100��\" ");
	
	if("2050010".equals(sBusinessType) || "2050020".equals(sBusinessType) || "2050030".equals(sBusinessType) || "2050040".equals(sBusinessType)){
		doTemp.setRequired("BusinessRate,ICCyc,CorpusPayMethod",false);
		doTemp.setVisible("BusinessRate,ICCyc,CorpusPayMethod",false);
	}
	
	doTemp.setReadOnly("",false);
	doTemp.setReadOnly("SerialNo,CustomerID,CustomerName,BusinessTypeName,OccurDate,CertID,CertType,ContractSerialNo",true);
	doTemp.setRequired("",false);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);

	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
 
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
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
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------

	//---------------------���尴ť�¼�------------------------------------	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/SynthesisManage/HistoryPutOutList.jsp","_self","");
	}
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~[Describe=��ȡ��֤��;InputParam=��;OutPutParam=��;]~*/
	function getBailSum(){
		//�ֹ�¼��
	}
	
	/*~[Describe=�����������ʻ���ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getPutOutOrg()
	{		
		sParaString = "OrgID"+","+"<%=CurOrg.OrgID%>";
		setObjectValue("SelectBelongOrg",sParaString,"@AboutBankID3@0@AboutBankID3Name@1",0,0,"");		
	}
	
	/*~[Describe=�������˻���ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectPutOutOrg()
	{		
		sParaString = "SortNo"+","+"<%=CurOrg.SortNo%>";
		setObjectValue("SelectBelongOrgCode",sParaString,"@PutOutOrgID@0@PutOutOrgIDName@1",0,0,"");		
	}
	/*~[Describe=���ݻ�׼���ʡ����ʸ�����ʽ�����ʸ���ֵ����ִ����(��)����;InputParam=��;OutPutParam=��;]~*/
	function getBusinessRate(sFlag)
	{
		//�ֹ�¼��
	}
	
	//ȡ�û�׼������
	function selectBaseRateType(){
		sCurDate = "<%=StringFunction.getToday()%>"
		sParaString = "CurDate"+","+sCurDate;
	    sReturn = setObjectValue("selectBaseRateType",sParaString,"@BaseRateType@0@BaseRate@1",0,0,"");
		getBusinessRate("M");
	}
	//�Զ���ȡ�������� 2009-12-24 
	function getBaseRateType(){
		 //�ֹ�¼��
	}
	
	/*~[Describe=��ռ/Ų������InputParam=��;OutPutParam=��;]~*/
	function getTARate()
	{
		//�ֹ�¼��
	}
	/*~[Describe=������������;InputParam=��;OutPutParam=��;]~*/
	function getOverdueRate()
	{
		//�ֹ�¼��
	}
	
	//���˽׶Σ����»�ȡ��׼���� 
	function getNewBaseRate(){
		//�ֹ�¼��
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_PUTOUT_BAK";//����
		var sColumnName = "BPBSerialNo";//�ֶ���
		var sPrefix = "BPB";//ǰ׺
       
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sBPBSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		
		//����ˮ�ŷ���
		return sBPBSerialNo;
	}
	</SCRIPT>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>