<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   wwhe 2010-01-18
			Tester:
			Content: ���˿ͻ������Ϣ���ٲ�ѯ
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
		String PG_TITLE = "���˿ͻ������Ϣ���ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
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
					{"PayType","֧����ʽ"},
					{"BusinessTypeName","ҵ��Ʒ��"},										
					{"VouchType","��Ҫ������ʽ"},										
					{"BusinessSum","���"},
					{"Balance","���"},										
					{"Currency","����"},
					{"ActualBusinessRate","ִ������(%)"},
					{"PutOutDate","�����ʼ��"},
					{"Maturity","��ݵ�����"},
					{"MFOrgName","���˻���"},
					{"Direction","��ҵͶ��"},
					{"DirectionName1","��ҵͶ��(����)"},
					{"DirectionName","��ҵͶ��(����)"},
					{"RateFloatType","���ʸ�����ʽ"},
					{"RateFloat","���ʸ���ֵ"},
					{"ICType","���ʽ"},
					{"ICTypeName","���ʽ"},
					{"OverdueDays","��������"},
					{"TermMonth","��������"},
					{"Purpose","������;"},
					{"PurposeName","������;"},
					{"Flag2","�Ƿ��д���"},
					{"Flag2Name","�Ƿ��д���"},
					{"FixCYC","��Ϣ��"}, 
					{"CMIntSum","������Ϣ����"},
					{"AMIntSum","����Ϣ����"},
					{"Sex","�Ա�"},
					{"WorkBeginDate","����λ������ʼ��"},
					{"WorkCorp","��λ����"},
					{"WorkAdd","��λ��ַ"},
					{"FamilyStatus","����˾�ס״��"},
					{"Marriage","����״��"},
					{"NativePlace","������ַ"},
					{"CreditFarmer","�ͻ�������1"},
					{"CreditFarmerName","�ͻ�������1"},
					{"FarmerSort","�ͻ�������2"},
					{"FarmerSortName","�ͻ�������2"},
					{"ManageOrgName","�ܻ�����"},
					{"ManageUserName","�ܻ���"},
					{"ClassifyResult","�弶����"},
					{"ClassifyResultName","�弶����"},
					{"OverdueBalance","�������"},
					{"InterestBalance1","����ǷϢ���(Ԫ)"},
					{"InterestBalance2","����ǷϢ���(Ԫ)"}
					}; 
	
	sSql =	" select BD.SerialNo,BD.CustomerID,BD.CustomerName,getItemName('pay_type',BC.paytype) as PayType,"+
	" getBusinessName(BD.BusinessType) as BusinessTypeName,getItemName('VouchType',getVouchTypeByDueBillNo(BD.SerialNo)) as VouchType,"+
	" BD.ClassifyResult,getItemName('ClassifyResult',BD.ClassifyResult) as ClassifyResultName,"+
	" BP.ICType,getItemName('BackLoanType',BP.ICType) as ICTypeName,BD.LCATimes as OverdueDays,BC.TermMonth,BP.Purpose,getItemName('LoanPurpose',BP.Purpose) as PurposeName ,BC.Flag2,getItemName('YesNo',BC.Flag2) as Flag2Name,BP.FixCYC,"+
	" II.CreditFarmer,getItemName('CustomerType',II.CreditFarmer) as CreditFarmerName,II.FarmerSort,getItemName('CustomerType3',II.FarmerSort) as FarmerSortName,"+
	" BC.Direction,getItemName('IndustryType',substr(BC.Direction,1,1)) as DirectionName1,getItemName('IndustryType',BC.Direction) as DirectionName,getItemName('RateFloatType',BC.RateFloatType) as RateFloatType,BC.RateFloat,"+
	" getItemName('Currency',BD.BusinessCurrency) as Currency,BD.BusinessSum,BD.Balance,BD.OverdueBalance,BD.InterestBalance1,"+
	" BD.InterestBalance2,BD.ActualBusinessRate,BD.PutOutDate,BD.Maturity,"+
	" t.CMIntSum,t.AMIntSum,"+//added by bllou ���㵱����Ϣ������ۼ���Ϣ���� 20120327		
	" getItemName('Sex',II.Sex) as Sex,II.WorkBeginDate,II.WorkCorp,II.WorkAdd,getItemName('FamilyStatus',II.FamilyStatus) as FamilyStatus,getItemName('Marriage',II.Marriage) as Marriage,II.NativePlace,"+
	" getOrgName(getHeaderOrgID(GetOrgIDByCoreOrgID(nvl(BD.MFOrgID,''))))||'-'||getOrgName(GetOrgIDByCoreOrgID(nvl(BD.MFOrgID,''))) as MFOrgName,"+
	" getOrgName(BD.OperateOrgID) as ManageOrgName,getUserName(BD.OperateUserID) as ManageUserName " +
	       	" from Business_Duebill BD"+
	       	" left join Business_PutOut BP on BD.RelativeSerialNo1 = BP.SerialNo"+
	       	" inner join Business_Contract BC on BD.RelativeSerialNo2 = BC.SerialNo"+
	       	" inner join Ind_Info II on BD.CustomerID = II.CustomerID "+
	       	" left join"+
	       		" (select RelativeSerialNo,"+
	       			"nvl(sum(ActualDebitSum),0) as AMIntSum,"+//����Ϣ����
	       			"nvl(sum(case when OccurDate like '"+StringFunction.getToday().substring(0,7)+"%' then ActualDebitSum end),0) as CMIntSum"+//������Ϣ����
	       		" from Business_WasteBook"+
	       		" where OccurSubject='2' group by RelativeSerialNo)t"+
	       	" on BD.SerialNo = t.RelativeSerialNo"+
	" where BD.OperateOrgID in (select BelongOrgID from ORG_BELONG where OrgID='"+CurOrg.OrgID+"') ";
	
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
	//���ö��뷽ʽ
	doTemp.setAlign("BusinessSum,BusinessRate,Balance,OverdueBalance,InterestBalance1,InterestBalance2","3");	
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("BusinessSum","2");	
	doTemp.setCheckFormat("PutOutDate,Maturity","3");
	doTemp.setType("BusinessSum,ActualBusinessRate,Balance,OverdueBalance,InterestBalance1,InterestBalance2,TermMonth","Number");
	doTemp.setCheckFormat("ActualBusinessRate","16");
	//���������б�
	doTemp.setDDDWCode("ClassifyResult","ClassifyResult");
	doTemp.setDDDWCode("ICType","BackLoanType");
	doTemp.setDDDWCode("Direction","IndustryType");
	doTemp.setDDDWCode("Flag2","YesNo"); 
	doTemp.setDDDWCode("Purpose","LoanPurpose"); 
	doTemp.setDDDWSql("CreditFarmer","Select ItemNo,ItemName from code_library where codeno='CustomerType' and itemno like '030%' and itemno<>'0301' order by itemno");
	doTemp.setDDDWCode("FarmerSort","CustomerType3");
	//���ÿɼ�
	doTemp.setVisible("ClassifyResult,Direction,ICType,Purpose,Flag2,CreditFarmer,FarmerSort",false);
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("SerialNo,CustomerName,BusinessTypeName,Direction,ClassifyResult,BusinessSum,Balance,Flag2,OverdueBalance,ManageOrgName,PutOutDate,Maturity,OverdueBalance,ICType,Purpose,CreditFarmer,FarmerSort","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) 
		doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ
	//dwTemp.DataObject.SelectClause=StringFunction.replace(dwTemp.DataObject.SelectClause,"#CMIntSum","(select nvl(sum(BW.ActualDebitSum),0) from Business_WasteBook BW where BW.RelativeSerialNo=BD.SerialNo and BW.OccurSubject='2' and BW.OccurDate like '"+StringFunction.getToday().substring(0,7)+"%')");//added by bllou 20120316 ��ȡ������Ϣ����
	//dwTemp.DataObject.SelectClause=StringFunction.replace(dwTemp.DataObject.SelectClause,"#AMIntSum","(select nvl(sum(BW.ActualDebitSum),0) from Business_WasteBook BW where BW.RelativeSerialNo=BD.SerialNo and BW.OccurSubject='2')");//added by bllou 20120316 ��ȡ����Ϣ����
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
			{"true","","Button","�弶�����϶�","�弶�����϶�","ClassifyEdit()",sResourcesPath}
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
