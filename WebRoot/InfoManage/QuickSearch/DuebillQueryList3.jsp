<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   wwhe 2009-10-13
			Tester:
			Content: �����Ϣ���ٲ�ѯ
			Input Param:
				���в�����Ϊ�����������
				ComponentName	������ƣ���ͬ��Ϣ���ٲ�ѯ
		          
			Output param:
			History Log: 
		 */
	%>
<%
	/*~END~*/
%>

            
<%
            	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
            %>
	<%
		String PG_TITLE = "�����Ϣ���ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql = "";//--���sql���
	String sComponentName = "";//--�������
	String PG_CONTENT_TITLE = "";
	//����������	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//���ҳ�����	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
					{"SerialNo","�����ˮ��"},
					{"CustomerID","�ͻ����"},
					{"CustomerName","�ͻ�����"},	
					{"CorpID","֤������"},	
					{"RegionCode","���ҵ���"},	
					{"PayType","֧����ʽ"},
					{"isJGT","�Ƿ����ͨҵ��"},	
					{"BusinessTypeName","ҵ��Ʒ��"},										
					{"BusinessSum","���(Ԫ)"},
					{"Balance","���(Ԫ)"},										
					{"Currency","����"},
					{"ActualBusinessRate","ִ��������(%)"},
					{"TermMonth","������"},
					{"TermDay","������"},
					{"PutOutDate","�����ʼ��"},
					{"ActualMaturity","��ݵ�����"},
					{"MFOrgName","���˻���"},
					{"ManageOrgName","�ܻ�����"},
					{"ManageUserName","�ܻ���"},
					{"ClassifyResult","�弶����"},
					{"ClassifyResultName","�弶����"},
					{"OverdueBalance","�������(Ԫ)"},
					{"IndustryTypeBigName","������ҵ�������"},
					{"IndustryTypeName","������ҵ����"},
					{"OldScopeName","��ҵ��ģ(�ϱ�׼)"},
					{"ScopeName","��ҵ��ģ"},
					{"InterestBalance1","����ǷϢ���(Ԫ)"},
					{"InterestBalance2","����ǷϢ���(Ԫ)"},
					{"VouchTypeName","��Ҫ������ʽ"},
					{"OrgTypeName","��ҵ����"},
					{"LoanCardNo","�����"},
					{"TotalAssets","�ʲ��ܶ�(Ԫ)"},
					{"SellSum","�����۶�(Ԫ)"},
					{"EmployeeNumber","ְ������"},
					{"OrgNatureName","�ͻ�����"},
					{"OrgNature","�ͻ�����"},
					{"Month","��������"},
					{"Man","����������"},
					{"StockHolder","�ɶ�����"},
					{"Voucher","����������"},
					{"StockHolder2","�����˹ɶ�����"},
					{"Man2","�����˷���������"},
					{"Flag3Name","���ڿͻ�����"},
					{"InputDate","��ѯ����"},
					{"BailRatio","��֤�����(%)"},
					{"OrgName","ֱ��������"},
					{"OldDirectionName","��ҵͶ��(�Ϲ���)"},
					{"DirectionName","��ҵͶ��"},
					{"RateFloatTypeName","���ʸ�����ʽ"},
					{"RateFloat","���ʸ���ֵ"},
					{"CK","���ճ���"},
					{"RealtyFlag","�ص�ͻ���������"},
					{"IndustryType1","����ͻ�����"},
					{"EconomyTypeName","��Ӫ����"}
					}; 
	if(CurUser.hasRole("098")){
		sSql =	" select BD.SerialNo,BD.RelativeSerialNo1,BD.RelativeSerialNo2,getOrgName(getHeaderOrgID(BD.OperateOrgID)) as OrgName, "+
	" getOrgName(BD.OperateOrgID) as ManageOrgName,getItemName('CustomerType2',EI.Flag3) as Flag3Name, "+
	" getItemName('RealtyFlag',RealtyFlag) as RealtyFlag,getItemName('IndustryType1',IndustryType1) as IndustryType1, "+
	" getItemName('EconomyType',EconomyType) as EconomyTypeName, "+
	" BC.CustomerID,BD.CustomerName,EI.CorpID,getItemName('AreaCode',EI.RegionCode) as RegionCode,getItemName('pay_type',BC.paytype) as PayType, getItemName('YesNo',isJGTByContractNo(BC.Serialno)) as isJGT,"+
	
	" getItemName('OldIndustryType',substr(AU.OldBIndustryType,1,1))||'--'||"+
	" getItemName('OldIndustryType',substr(AU.OldBIndustryType,1,3))||'--'||"+
	" getItemName('OldIndustryType',substr(AU.OldBIndustryType,1,4))||'--'||"+
	" getItemName('OldIndustryType',substr(AU.OldBIndustryType,1,5)) as OldDirectionName, "+
	//" getItemName('IndustryType',BC.Direction) as DirectionName, "+
	" getItemName('IndustryType',substr(BC.Direction,1,1))||'--'||"+
	" getItemName('IndustryType',substr(BC.Direction,1,3))||'--'||"+
	" getItemName('IndustryType',substr(BC.Direction,1,4))||'--'||"+
	" getItemName('IndustryType',substr(BC.Direction,1,5)) as DirectionName, "+
	
	" getItemName('Currency',BD.BusinessCurrency) as Currency, "+
	" BD.BusinessSum,BD.Balance,BD.OverdueBalance,BD.InterestBalance1,BD.InterestBalance2, "+
	" getItemName('RateFloatType',BC.RateFloatType) as RateFloatTypeName,BC.RateFloat,BD.ActualBusinessRate, "+
	" BD.BailRatio,(BD.BusinessSum-(BD.BusinessSum*nvl(BD.BailRatio,0))/100) as CK, "+
	" BC.TermMonth,BC.TermDay,"+
	/*
	" case when BD.BusinessType = '2010' "+
	" then BD.BusinessSum-(BD.BusinessSum*nvl(BD.BailRatio,0)/100) "+
	" else 0.00 end as CK2, "+
	*/
	" case when days(date(replace(BD.ActualMaturity,'/','-')))-days(date(replace(BD.PutOutDate,'/','-')))>367 "+
	" then '�г���' "+
	" else '����' end as Month, "+
	//" days(date(replace(BD.ActualMaturity,'/','-')))-days(date(replace(BD.PutOutDate,'/','-'))) as Month, "+
	" BD.PutOutDate,BD.ActualMaturity,"+
	" getOrgName(getHeaderOrgID(GetOrgIDByCoreOrgID(BD.MFOrgID)))||'-'||getOrgName(GetOrgIDByCoreOrgID(BD.MFOrgID)) as MFOrgName,"+
	" getBusinessName(BD.BusinessType) as BusinessTypeName,"+
	" BD.ClassifyResult,getItemName('ClassifyResult',BD.ClassifyResult) as ClassifyResultName, "+
	" getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
	//--����������
	" getVoucher(BD.RelativeSerialNo2) as Voucher, "+
	//--�����˷�������������
	" 	case when getFictitiousPerson(getVoucherID(BD.RelativeSerialNo2)) is not null and getFictitiousPerson(getVoucherID(BD.RelativeSerialNo2)) <> '' "+
	"	then "+
	"	substr(getFictitiousPerson(getVoucherID(BD.RelativeSerialNo2)),1,Locate('@',getFictitiousPerson(getVoucherID(BD.RelativeSerialNo2)))-1) "+
	"	else ''  "+
	"	end as Man2, "+
	//--���������Ĺɶ�����
	" getStockHolder(getVoucherID(BD.RelativeSerialNo2)) as StockHolder2, "+
	
	" EI.OrgNature,getItemName('CustomerType',EI.OrgNature) as OrgNatureName, "+
	//--��ȡ��������������
	" 	case when getFictitiousPerson(EI.CustomerID) is not null and getFictitiousPerson(EI.CustomerID) <> '' "+
	"	then "+
	"	substr(getFictitiousPerson(EI.CustomerID),1,Locate('@',getFictitiousPerson(EI.CustomerID))-1) "+
	"	else ''  "+
	"	end as Man, "+
	//--�������Ĺɶ�����
	" getStockHolder(EI.CustomerID) as StockHolder, "+
	
	
	" EI.LoanCardNo,getItemName('IndustryType',substr(EI.IndustryType,1,1)) as IndustryTypeBigName, "+
	" getItemName('IndustryType',EI.IndustryType) as IndustryTypeName,getItemName('OrgType',EI.OrgType) as OrgTypeName, "+
	" getItemName('Scope',AUS.OldEntScope) as OldScopeName,"+
	" getItemName('Scope',EI.Scope) as ScopeName,"+
	" EI.TotalAssets,EI.SellSum,EI.EmployeeNumber, "+
	" getUserName(BD.OperateUserID) as ManageUserName " +
	       	" from BUSINESS_DUEBILL BD,ENT_INFO EI,Als_UpdateEntScope AUS,BUSINESS_CONTRACT BC left join ALS_UPDATEBUSIINDUSTRY AU on BC.SerialNo=AU.ApplyNo "+
	" where BC.BusinessType not like '1%' "+
	" and BC.CustomerID = EI.CustomerID "+
	" and EI.CustomerID = AUS.CustomerID "+
	" and BD.RelativeSerialNo2 = BC.SerialNo "+
	//" and BD.SerialNo = BH.SerialNo "+
	" and BD.OperateOrgID in (select BelongOrgID from ORG_BELONG where OrgID='"+CurOrg.OrgID+"') ";
	}else{
		sSql =	" select BD.RelativeSerialNo1,BD.RelativeSerialNo2,getOrgName(substr(BD.OperateOrgID,1,2)) as OrgName, "+
	" getOrgName(BD.OperateOrgID) as ManageOrgName,getItemName('CustomerType2',EI.Flag3) as Flag3Name, "+
	//" getItemName('IndustryType1',IndustryType1) as IndustryType1Name, "+
	" BD.SerialNo,BC.CustomerID,BD.CustomerName,EI.CorpID,getItemName('AreaCode',EI.RegionCode) as RegionCode, "+
	
	" getItemName('OldIndustryType',substr(AU.OldBIndustryType,1,1))||'--'||"+
	" getItemName('OldIndustryType',substr(AU.OldBIndustryType,1,3))||'--'||"+
	" getItemName('OldIndustryType',substr(AU.OldBIndustryType,1,4))||'--'||"+
	" getItemName('OldIndustryType',substr(AU.OldBIndustryType,1,5)) as OldDirectionName, "+
	//" getItemName('IndustryType',BC.Direction) as DirectionName, "+
	" getItemName('IndustryType',substr(BC.Direction,1,1))||'--'||"+
	" getItemName('IndustryType',substr(BC.Direction,1,3))||'--'||"+
	" getItemName('IndustryType',substr(BC.Direction,1,4))||'--'||"+
	" getItemName('IndustryType',substr(BC.Direction,1,5)) as DirectionName, "+
	
	" getItemName('Currency',BD.BusinessCurrency) as Currency, "+
	" BD.BusinessSum,BD.Balance,BD.OverdueBalance,BD.InterestBalance1,BD.InterestBalance2, "+
	" getItemName('RateFloatType',BC.RateFloatType) as RateFloatTypeName,BC.RateFloat,BD.ActualBusinessRate, "+
	" BD.BailRatio,(BD.BusinessSum-(BD.BusinessSum*nvl(BD.BailRatio,0))/100) as CK, "+
	" BC.TermMonth,BC.TermDay,"+
	/*
	" case when BD.BusinessType = '2010' "+
	" then BD.BusinessSum-(BD.BusinessSum*nvl(BD.BailRatio,0)/100) "+
	" else 0.00 end as CK2, "+
	*/
	" case when days(date(replace(BD.ActualMaturity,'/','-')))-days(date(replace(BD.PutOutDate,'/','-')))>367 "+
	" then '�г���' "+
	" else '����' end as Month, "+
	//" days(date(replace(BD.ActualMaturity,'/','-')))-days(date(replace(BD.PutOutDate,'/','-'))) as Month, "+
	" BD.PutOutDate,BD.ActualMaturity, "+
	" getOrgName(getHeaderOrgID(GetOrgIDByCoreOrgID(BD.MFOrgID)))||'-'||getOrgName(GetOrgIDByCoreOrgID(BD.MFOrgID)) as MFOrgName,"+
	" getBusinessName(BD.BusinessType) as BusinessTypeName,"+
	" BD.ClassifyResult,getItemName('ClassifyResult',BD.ClassifyResult) as ClassifyResultName, "+
	" getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
	//--����������
	" getVoucher(BD.RelativeSerialNo2) as Voucher, "+
	//--�����˷�������������
	" 	case when getFictitiousPerson(getVoucherID(BD.RelativeSerialNo2)) is not null and getFictitiousPerson(getVoucherID(BD.RelativeSerialNo2)) <> '' "+
	"	then "+
	"	substr(getFictitiousPerson(getVoucherID(BD.RelativeSerialNo2)),1,Locate('@',getFictitiousPerson(getVoucherID(BD.RelativeSerialNo2)))-1) "+
	"	else ''  "+
	"	end as Man2, "+
	//--���������Ĺɶ�����
	" getStockHolder(getVoucherID(BD.RelativeSerialNo2)) as StockHolder2, "+
	
	" EI.OrgNature,getItemName('CustomerType',EI.OrgNature) as OrgNatureName, "+
	//--��ȡ��������������
	" 	case when getFictitiousPerson(EI.CustomerID) is not null and getFictitiousPerson(EI.CustomerID) <> '' "+
	"	then "+
	"	substr(getFictitiousPerson(EI.CustomerID),1,Locate('@',getFictitiousPerson(EI.CustomerID))-1) "+
	"	else ''  "+
	"	end as Man, "+
	//--�������Ĺɶ�����
	" getStockHolder(EI.CustomerID) as StockHolder, "+
	
	
	" EI.LoanCardNo,getItemName('IndustryType',substr(EI.IndustryType,1,1)) as IndustryTypeBigName, "+
	" getItemName('IndustryType',EI.IndustryType) as IndustryTypeName,getItemName('OrgType',EI.OrgType) as OrgTypeName, "+
	" getItemName('Scope',AUS.OldEntScope) as OldScopeName,"+
	" getItemName('Scope',EI.Scope) as ScopeName,"+
	" EI.TotalAssets,EI.SellSum,EI.EmployeeNumber, "+
	" getUserName(BD.OperateUserID) as ManageUserName " +
	       	" from BUSINESS_DUEBILL BD,ENT_INFO EI,Als_UpdateEntScope AUS,BUSINESS_CONTRACT BC left join ALS_UPDATEBUSIINDUSTRY AU on BC.SerialNo=AU.ApplyNo "+
	" where BC.BusinessType not like '1%' "+
	" and BC.CustomerID = EI.CustomerID "+
	" and EI.CustomerID = AUS.CustomerID "+
	" and BD.RelativeSerialNo2 = BC.SerialNo "+
	//" and BD.SerialNo = BH.SerialNo "+
	" and BD.OperateOrgID in (select BelongOrgID from ORG_BELONG where OrgID='"+CurOrg.OrgID+"') ";
	}

	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("BD.SerialNo");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);	
	//���ùؼ���
	doTemp.setKey("CustomerID",true);	
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setHTMLStyle("BusinessRate","style={width:60px} "); 		
	doTemp.setHTMLStyle("DirectionName","style={width:350px} "); 	
		
	//���ö��뷽ʽ
	doTemp.setAlign("CK,BailRatio,BusinessSum,BusinessRate,Balance,OverdueBalance,InterestBalance1,InterestBalance2,TotalAssets,SellSum,EmployeeNumber,TermMonth,TermDay","3");	
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("BailRatio,BusinessSum,CK","2");	
	doTemp.setCheckFormat("PutOutDate,ActualMaturity","3");
	doTemp.setType("BailRatio,BusinessSum,ActualBusinessRate,Balance,OverdueBalance,InterestBalance1,InterestBalance2,TotalAssets,SellSum,EmployeeNumber,RateFloat","Number");
	doTemp.setCheckFormat("ActualBusinessRate","16");
	doTemp.setCheckFormat("InputDate","3");
	//���������б�
	doTemp.setDDDWCode("ClassifyResult","ClassifyResult");
	//doTemp.setDDDWCode("OrgNature","CustomerType");
	//���ÿɼ�
	doTemp.setVisible("RelativeSerialNo1,RelativeSerialNo2,ClassifyResult,OrgNature",false);
	
	//���ɲ�ѯ��
	if(CurUser.hasRole("098")){
		doTemp.setColumnAttribute("InputDate,Month,SerialNo,CustomerName,BusinessTypeName,ClassifyResult,BusinessSum,Balance, "+
		"OverdueBalance,ManageOrgName,PutOutDate,ActualMaturity,OverdueBalance,Flag3Name,RealtyFlag,EconomyTypeName","IsFilter","1");
	}else{
		doTemp.setColumnAttribute("InputDate,Month,SerialNo,CustomerName,BusinessTypeName,ClassifyResult,BusinessSum,Balance, "+
		"OverdueBalance,ManageOrgName,PutOutDate,ActualMaturity,OverdueBalance,Flag3Name","IsFilter","1");
	}
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	
	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/
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
			{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
			{"true","","Button","�弶�����϶�","�弶�����϶�","ClassifyEdit()",sResourcesPath},
			{CurUser.hasRole("000")?"true":"false","","Button","�����ͬ����","�����ͬ����","TransferToContract()",sResourcesPath}
		};
	%> 
<%
 	/*~END~*/
 %>


<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		//BusinessDueBill
	    sObjectType = "BusinessDueBill";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			sCompID = "CreditTab";
    		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
    		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
    		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}

	}	
	
	function ClassifyEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sParaString = "CodeNo"+","+"ClassifyResult2";
		sReturnValue = setObjectValue("SelectCode",sParaString,"",0,0,"");
		if (typeof(sReturnValue)!="undefined" && sReturnValue.length!=0){
			sReturnValue = sReturnValue.split("@");
			sClassifyResult = sReturnValue[0];
			
			RunMethod("BusinessManage","UpdateClassifyResult",sSerialNo+","+sClassifyResult);
			alert("���ǳɹ���");
			reloadSelf();
		}
	}
	//added by bllou �ѵ�ǰ��ݹ�������һ����ͬ�� 2012-07-19
	function TransferToContract()
	{
		var sDuebillSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sPutOutSerialNo = getItemValue(0,getRow(),"RelativeSerialNo1");
		var sContractSerialNo = getItemValue(0,getRow(),"RelativeSerialNo2");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sDuebillSerialNo)=="undefined" || sDuebillSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sParaString = "SerialNo,"+sContractSerialNo+",CustomerID,"+sCustomerID;
		var sReturnValue = setObjectValue("SelectChangeContract",sParaString,"",0,0,"");
		if (typeof(sReturnValue)!="undefined" && sReturnValue.length!=0){
			sReturnValue = sReturnValue.split("@");
			var sToContractSerialNo = sReturnValue[0];
			sReturnValue = RunMethod("PublicMethod","UpdateColValue","String@RelativeSerialNo2@"+sToContractSerialNo+",Business_Duebill,String@SerialNo@"+sDuebillSerialNo);
			sReturnValue = RunMethod("PublicMethod","UpdateColValue","String@ContractSerialNo@"+sToContractSerialNo+",Business_PutOut,String@SerialNo@"+sPutOutSerialNo);
			if(sReturnValue!=='TRUE'){
				alert("���½�ݺͳ��˵ĺ�ͬ����"+sContractSerialNo+"Ϊ"+sToContractSerialNo+"ʧ�ܣ�");
				return false;
			}
			alert("�����ͬ�����ɹ���");
			reloadSelf();
		}
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>
