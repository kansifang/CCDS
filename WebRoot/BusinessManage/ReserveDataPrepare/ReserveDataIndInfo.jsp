<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:jjwang  2008.10.07
		Tester:
		Content: ���ݲɼ�  �Ը�����ά��
		Input Param:
		Output param:
		History Log:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�Ը�����ά��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������

	//����������

	//���ҳ�����
	String sAccountMonth =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	if(sAccountMonth==null) sAccountMonth="";
	String sLoanAccount =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanAccount"));
	if(sLoanAccount==null) sLoanAccount="";
	String sIsManageUser = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("IsManageUser"));
	if(sIsManageUser == null) sIsManageUser = "";
	String sMFiveClassify = "" ,sAFiveClassify = "",sManageStatFlag="";
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ReserveDataIndInfo";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.UpdateTable = "Reserve_Total";
	doTemp.setVisible("SubjectNo,DuebillNo,CustomerOrgCode,OverDueDays",false);
	//doTemp.setUnit("AccountMonth","<input type=\"button\" class=\"inputDate\" value=\"...\" onclick=\"parent.selectAccountMonth()\">");
    //doTemp.setUnit("CountryCodeName","<input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectCountryCode()>");
	//doTemp.setUnit("RegionName","<input class=\"inputdate\" value=\"...\" type=button onClick=parent.getRegionCode(\"ent\")>(��ѡ�����Ϊ�й�ʱ��ѡ�����ʡ��)");
	doTemp.setHTMLStyle("AccountMonth","style={width:80}");
	doTemp.setHTMLStyle("VouchTypeName","style={width:360}");
	doTemp.setUnit("VouchTypeName", "<input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectVouchType()>");
	doTemp.appendHTMLStyle("ManageStatFlag"," onchange=\"javascript:parent.selAuditStatFlag()\" ");
	if(!CurUser.hasRole("608"))
	{
		doTemp.setVisible("MFiveClassify,AFiveClassify,AuditStatFlag,ManageStatFlag",false);
	}
 	if("true".equals(sIsManageUser))
    {
    	doTemp.setReadOnly("BusinessSum,MFiveClassify,AuditStatFlag",false);
    }
	/*
	String sSql = "select MFiveClassify,AFiveClassify from reserve_total where LoanAccount = '"+sLoanAccount+"'";
    ASResultSet rs = null;
    rs = Sqlca.getASResultSet(sSql);
    if(rs.next()){
			sMFiveClassify = rs.getString("MFiveClassify");
			sAFiveClassify = rs.getString("AFiveClassify");
		}
	rs.getStatement().close();
	if(sMFiveClassify.equals("01") || sMFiveClassify.equals("02"))
	{
		doTemp.setHeader("MBadLastPrdDiscount","�����������������Ԥ���ֽ�����������ֵ");
		doTemp.setHeader("MBadPrdDiscount","�����ھ����������Ԥ���ֽ�������ֵ");
		doTemp.setHeader("MBadReserveSum","�����ھ���������ڼ����ֵ׼��");
		doTemp.setHeader("MBadMinusSum","�����ھ����������ת�ؼ�ֵ׼��");
		doTemp.setHeader("MBadRetSum","�����ھ�������������ֻز���ֵ׼��");
		doTemp.setHeader("MBadReserveBalance","�����ھ���������ڼ�ֵ׼�����");
	}
	if(sAFiveClassify.equals("01") || sAFiveClassify.equals("02"))
	{
		doTemp.setHeader("ABadLastprdDiscount","��ƿھ�������������Ԥ���ֽ�����������ֵ");
		doTemp.setHeader("ABadPrdDiscount","��ƿھ����������Ԥ���ֽ�������ֵ");
		doTemp.setHeader("ABadReserveSum","��ƿھ���������ڼ����ֵ׼��");
		doTemp.setHeader("ABadMinusSum","��ƿھ����������ת�ؼ�ֵ׼��");
		doTemp.setHeader("ABadRetSum","��ƿھ�������������ֻز���ֵ׼��");
		doTemp.setHeader("ABadReserveBalance","��ƿھ���������ڼ�ֵ׼�����");
	}
	*/
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sAccountMonth+","+sLoanAccount);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//session.setAttribute(dwTemp.Name,dwTemp);
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
		{"true","","Button","����","����","goBack()",sResourcesPath}
		};
	if("true".equals(sIsManageUser))
    {
    	sButtons[0][0] = "true";
    }		
	%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	function selectCountryCode()
	{		
		sParaString = "CodeNo"+","+"CountryCode";			
		sCountryCodeInfo = setObjectValue("SelectCode",sParaString,"@CountryCode@0@CountryCodeName@1",0,0,"");
		if (typeof(sCountryCodeInfo) != "undefined" && sCountryCodeInfo != "" )
		{
			sCountryCodeInfo = sCountryCodeInfo.split('@');
			CountryCode = sCountryCodeInfo[0];//-- ���ڹ���(����)����
			setItemValue(0,getRow(),"CountryCode",CountryCode);			
		}
	}
	
	function getRegionCode(flag)
	{
		//�жϹ�����û��ѡ�й�
		var sCustomerType="01";
		var sCountryTypeValue = getItemValue(0,getRow(),"CountryCode");
		var sRegionInfo;
		if (flag == "ent")
		{
			if(sCustomerType.substring(0,2) == "01")//��˾�ͻ�Ҫ����ѡ���ڹ��һ��������ѡ�����ʡ��
			{
				//�жϹ����Ƿ��Ѿ�ѡ��
				if (typeof(sCountryTypeValue) != "undefined" && sCountryTypeValue != "" )
				{
					if(sCountryTypeValue == "142")
					{
						sParaString = "CodeNo"+",AreaCode";			
						setObjectValue("SelectCode",sParaString,"@Region@0@RegionName@1",0,0,"");
					}else
					{
						alert(getBusinessMessage('122'));//��ѡ���Ҳ����й�������ѡ�����
						return;
					}
				}else
				{
					alert(getBusinessMessage('123'));//��δѡ����ң��޷�ѡ�����
					return;
				}
			}else
			{
				sParaString = "CodeNo"+",AreaCode";			
				setObjectValue("SelectCode",sParaString,"@Region@0@RegionName@1",0,0,"");
			}
		}else 	//������ҵ�ͻ�����������͸��˵ļ���
		{
			sParaString = "CodeNo"+",AreaCode";			
			setObjectValue("SelectCode",sParaString,"@Region@0@RegionName@1",0,0,"");
		}
	}	
	
	function selectAccountMonth()
	{
		var sAccountMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=21;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sAccountMonth)!="undefined" && sAccountMonth!="")
		{	
			setItemValue(0,0,"AccountMonth",sAccountMonth);
		}
		else
			setItemValue(0,0,"AccountMonth","");
	}
	
	function selectVouchType() 
	{
    	sParaString = "CodeNo" + "," + "VouchType";
    	setObjectValue("SelectCode", sParaString, "@VouchType@0@VouchTypeName@1", 0, 0, "");
	}
	
	//������ģʽ�Ƿ���Ը���
	function selAuditStatFlag()
	{
		sMFiveClassify = getItemValue(0,getRow(),"MFiveClassify");
		sAFiveClassify = getItemValue(0,getRow(),"AFiveClassify");
		if(sMFiveClassify > 02 || sAFiveClassify > 02)
		{
			alert("�弶����Ϊ����,�����Խ�����ģʽ��Ϊ��ϼ���");
			setItemValue(0,0,"ManageStatFlag","2");
			return;
		}
	}
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
		}
		else{
			beforeUpdate();
		}
		sMFiveClassify = getItemValue(0,getRow(),"MFiveClassify");
		sAFiveClassify = getItemValue(0,getRow(),"AFiveClassify");
		sManageStatFlag = getItemValue(0,getRow(),"ManageStatFlag");
		if(sMFiveClassify =="03" || sMFiveClassify =="04" || sMFiveClassify =="05" || sAFiveClassify == "03" || sAFiveClassify == "04" || sAFiveClassify == "05")
		{
			if(sManageStatFlag == "1")
			{
				alert("�弶����Ϊ����,�����Խ�����ģʽ��Ϊ��ϼ���");
				setItemValue(0,0,"ManageStatFlag","2");
				return;
			}
		}
		as_save("myiframe0",sPostEvents);
	}

	function goBack()
	{
		self.close();
	}
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		
	}
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
		}
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
