<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:jjwang  2008.10.07
		Tester:
		Content: ���ݲɼ�  ���Ŵ�����ά����ʾ����
		Input Param:
		Output param:
		History Log:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ŵ�����ά����ʾ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������

	//����������

	//���ҳ�����
	String sAccountMonth =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	if(sAccountMonth==null) sAccountMonth="";
	String sAssetNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AssetNo"));
	if(sAssetNo==null) sAssetNo="";
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ReserveNullDataInfo";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.UpdateTable = "ReserveNull_Total";
	
	//doTemp.setUnit("AccountMonth","<input type=\"button\" class=\"inputDate\" value=\"...\" onclick=\"parent.selectAccountMonth()\">");
	doTemp.setUnit("CountryCodeName","<input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectCountryCode()>");
	doTemp.setUnit("RegionName","<input class=\"inputdate\" value=\"...\" type=button onClick=parent.getRegionCode(\"ent\")>(��ѡ�����Ϊ�й�ʱ��ѡ�����ʡ��)");
	doTemp.setVisible("DuebillNo,CustomerID",false);
    doTemp.setAlign("Interest,RetSum,OmitSum","3");
    doTemp.appendHTMLStyle("Balance"," onBlur=\"javascript:parent.setRMBBalance()\" ");
	doTemp.appendHTMLStyle("ExchangeRate"," onBlur=\"javascript:parent.setRMBBalance()\" ");
    doTemp.setUnit("VouchTypeName", "<input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectVouchType()>");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sAccountMonth+","+sAssetNo);
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
	function getIndustryType()
	{
   		 //������ҵ��������м������������ʾ��ҵ����
    	sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?rand=" + randomNumber(), "", "dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");

    	if (sIndustryTypeInfo == "NO")
    	{
       	 	setItemValue(0, getRow(), "Direction", "");
        	setItemValue(0, getRow(), "DirectionName", "");
    	}
    	else if (typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
    	{
        	sIndustryTypeInfo = sIndustryTypeInfo.split('@');
        	sIndustryTypeValue = sIndustryTypeInfo[0];
        	sIndustryTypeName = sIndustryTypeInfo[1];

        	sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?IndustryTypeValue=" + sIndustryTypeValue, "", "dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
        	if (sIndustryTypeInfo == "NO")
        	{
            	setItemValue(0, getRow(), "Direction", "");
            	setItemValue(0, getRow(), "DirectionName", "");
        	} else if (typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
        	{
            	sIndustryTypeInfo = sIndustryTypeInfo.split('@');
            	sIndustryTypeValue = sIndustryTypeInfo[0];
            	sIndustryTypeName = sIndustryTypeInfo[1];
            	setItemValue(0, getRow(), "Direction", sIndustryTypeValue);
            	setItemValue(0, getRow(), "DirectionName", sIndustryTypeName);
        	}
    	}
	}
	function selectVouchType() 
	{
    	sParaString = "CodeNo" + "," + "VouchType";
    	setObjectValue("SelectCode", sParaString, "@VouchType@0@VouchTypeName@1", 0, 0, "");
	}
	
	function setRMBBalance()
	{
		if(getActureVale()==false)
		{
			return;
		}
		else
		{
			var dBalance=getItemValue(0,getRow(),"Balance");
			var dExchangeRate=getItemValue(0,getRow(),"ExchangeRate");
			setItemValue(0,0,"RMBBalance",dBalance*dExchangeRate);
		}
	}
	function getActureVale()
	{
		var sBalance=getItemValue(0,getRow(),"Balance");
		if(typeof(sBalance)=="undefined" || sBalance.length==0)
		{
			return false;
		}
		var sExchangeRate=getItemValue(0,getRow(),"ExchangeRate");
		if(typeof(sExchangeRate)=="undefined" || sExchangeRate.length==0)
		{
			return false;
		}
		return true;
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
			setItemValue(0,0,"LoanAccount","<%=sAssetNo%>");
			setItemValue(0,0,"AccountMonth","<%=sAccountMonth%>");
			setItemValue(0,0,"BusinessFlag","3");
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
