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
		String PG_TITLE = "��֤������ͬ���ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
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
					{"SerialNo","��ͬ��ˮ��"},
					{"BusinessTypeName","ҵ��Ʒ��"},
					{"CustomerID","����˿ͻ����"},
					{"CustomerName","���������"},
					{"GuarantorName1","�ṩ����������1"},
					{"GuarantorName2","�ṩ����������2"},
					{"GuarantorName3","�ṩ����������3"},
					{"GuarantorName4","�ṩ����������4"},
					{"GuarantorName5","�ṩ����������5"},
					{"GuarantorName6","�ṩ����������6"},
					{"VouchTypeName","������ʽ"},
					{"BusinessSum","��ͬ���"},	
					{"Balance","��ͬ���"},										
					{"PutOutDate","��ͬ��ʼ��"},
					{"Maturity","��ͬ������"},										
					{"ManageOrgName","�ܻ�����"},
					{"HeaderOrgName","ֱ����"},
					{"ManageUserName","�ܻ���"}
					}; 
	String sTab1 =  " (select BC.SerialNo,getBusinessName(BC.BusinessType) as BusinessTypeName,BC.Customerid,BC.CustomerName,BC.BusinessSum,BC.Balance, "+
	" BC.PutOutDate,BC.Maturity,getOrgName(BC.OperateOrgID) as ManageOrgName,getOrgName(getHeaderOrgID(BC.OperateOrgID)) as HeaderOrgName, "+
	" getUserName(BC.OperateUserID) as ManageUserName,BC.vouchtype from Business_Contract BC "+
	" ) as Tab1 ";
	
	String sTab2 = 	"  (select SerialNo as SerialNo, nvl(max(case when  tab1.Num = 1 THEN tab1.GuarantorName END),'') AS GuarantorName1,"+
        			" nvl(max(case when  tab1.Num = 2 THEN tab1.GuarantorName END),'') AS GuarantorName2, "+
			   " nvl(max(case when  tab1.Num = 3 THEN tab1.GuarantorName END),'') AS GuarantorName3, "+
			   " nvl(max(case when  tab1.Num = 4 THEN tab1.GuarantorName END),'') AS GuarantorName4, "+
			   " nvl(max(case when  tab1.Num = 5 THEN tab1.GuarantorName END),'') AS GuarantorName5, "+
			   " nvl(max(case when  tab1.Num = 6 THEN tab1.GuarantorName END),'') AS GuarantorName6 from "+
	 			" (SELECT bc.serialno,gc.GuarantorName as GuarantorName,row_number()over(partition by bc.serialno) as Num FROM "+
	 			" business_contract bc,contract_relative  cr,guaranty_contract gc "+
				" where gc.serialno=cr.objectno and cr.ObjectType='GuarantyContract' and cr.serialno=bc.serialno "+
				" and (gc.ContractStatus = '010' or gc.ContractStatus = '020') "+
				" and gc.guarantytype='010010' "+
				" and gc.CertType like 'Ent%' and gc.customerid in (select customerid from business_duebill) "+
				" and gc.GuarantorID in (select customerid from business_duebill) order by bc.GuarantyValue desc "+
				" ) tab1 group by serialno) as Tab2 ";
	
	sSql = " select Tab2.SerialNo,Tab1.BusinessTypeName,Tab1.Customerid,Tab1.CustomerName,Tab2.GuarantorName1,Tab2.GuarantorName2,Tab2.GuarantorName3, "+
	" Tab2.GuarantorName4,Tab2.GuarantorName5,Tab2.GuarantorName6,Tab1.BusinessSum,Tab1.Balance,Tab1.PutOutDate,Tab1.Maturity, "+
	" Tab1.ManageOrgName,Tab1.HeaderOrgName,Tab1.ManageUserName,getItemName('VouchType',Tab1.vouchtype) as VouchTypeName from "+sTab1+","+sTab2+
	" where Tab1.SerialNo=Tab2.SerialNo and Tab1.Customerid in (select customerid from ent_info) ";
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    //doTemp.setKeyFilter("BC.SerialNo");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);	
	//���ùؼ���
	//doTemp.setKey("CustomerID",true);	
	//������ʾ�ı���ĳ��ȼ��¼�����
	//doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	//doTemp.setHTMLStyle("BusinessRate","style={width:60px} "); 	
	doTemp.setHTMLStyle("CustomerName,GuarantorName1,GuarantorName2,GuarantorName3,GuarantorName4,GuarantorName5,GuarantorName6","style={width:350px} "); 
	//doTemp.setHTMLStyle("DirectionName","style={width:350px} "); 	
		
	//���ö��뷽ʽ
	//doTemp.setAlign("CK,BailRatio,BusinessSum,BusinessRate,Balance,OverdueBalance,InterestBalance1,InterestBalance2,TotalAssets,SellSum,EmployeeNumber,TermMonth,TermDay","3");	
	//С��Ϊ2������Ϊ5
	//doTemp.setCheckFormat("BailRatio,BusinessSum,CK","2");	
	doTemp.setCheckFormat("PutOutDate,Maturity","3");
	//doTemp.setType("BailRatio,BusinessSum,ActualBusinessRate,Balance,OverdueBalance,InterestBalance1,InterestBalance2,TotalAssets,SellSum,EmployeeNumber,RateFloat","Number");
	//doTemp.setCheckFormat("ActualBusinessRate","16");
	//doTemp.setCheckFormat("InputDate","3");
	//���������б�
	//doTemp.setDDDWCode("ClassifyResult","ClassifyResult");
	//doTemp.setDDDWCode("OrgNature","CustomerType");
	//���ÿɼ�
	doTemp.setVisible("VouchTypeName",false);
	

		doTemp.generateFilters(Sqlca);

		doTemp.setFilter(Sqlca,"1","SerialNo","");
		//doTemp.setFilter(Sqlca,"2","GuarantorName1","");
		doTemp.setFilter(Sqlca,"3","CustomerName","");
		doTemp.setFilter(Sqlca,"4","ManageOrgName","");
		doTemp.setFilter(Sqlca,"5","HeaderOrgName","");
		doTemp.setFilter(Sqlca,"6","ManageUserName","");
		doTemp.setFilter(Sqlca,"7","PutOutDate","");
		doTemp.setFilter(Sqlca,"8","Maturity","");
		doTemp.setFilter(Sqlca,"9","BusinessTypeName","");
		doTemp.parseFilterData(request,iPostChange);
		if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
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
	    sObjectType = "BusinessContract";
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
