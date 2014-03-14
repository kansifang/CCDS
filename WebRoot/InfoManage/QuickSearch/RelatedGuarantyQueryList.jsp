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
		String PG_TITLE = "����������ͬ���ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
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
					{"GuarantorName","�ṩ����������"},
					{"RelationShip","�����˹�����ϵ"},
					{"Pertain","�Ƿ�����ͬһ����"},
					{"VouchTypeName","������ʽ"},
					{"BusinessSum","��ͬ���"},	
					{"Balance","��ͬ���"},										
					{"PutOutDate","��ͬ��ʼ��"},
					{"Maturity","��ͬ������"},										
					{"ManageOrgName","�ܻ�����"},
					{"HeaderOrgName","ֱ����"},
					{"ManageUserName","�ܻ���"}
					}; 

	String sTab1 =  " (select BC.SerialNo,getBusinessName(BC.BusinessType) as BusinessTypeName,BC.CustomerID,BC.CustomerName, "+
	" BC.BusinessSum,BC.Balance,BC.PutOutDate,BC.Maturity,getOrgName(BC.OperateOrgID) as ManageOrgName, "+
	" getOrgName(getHeaderOrgID(BC.OperateOrgID)) as HeaderOrgName,getUserName(BC.OperateUserID) as ManageUserName "+
	" from Business_Contract BC where 1=1) Tab1 ";
	
	String sTab2 = " (select CR.SerialNo as CRSer,GC.CustomerID, "+
		 			" GC.GuarantorID,GC.GuarantorName,getItemName('GuarantyType',GC.GuarantyType) as VouchTypeName from GUARANTY_CONTRACT GC,CONTRACT_RELATIVE CR "+
		 			" where GC.serialno= CR.ObjectNo   and CR.ObjectType='GuarantyContract' "+
		    		" and CR.ObjectNo = GC.SerialNo	and GC.ContractType='010' "+
		 			" and (GC.ContractStatus = '010' or GC.ContractStatus = '020') and GC.ContractType='010' and GC.certtype like 'Ent%' "+
                    " and GC.GuarantorID in ( select customerid from business_duebill) "+
                    " and GC.Customerid in ( select customerid from business_duebill) order by GC.GuarantyValue desc) Tab2 ";
	
	String sTab3 = "(select Tab2.*,getItemName('RelationShip',CR.RelationShip) as RelationShip "+
			" from"+sTab2+" left outer join Customer_Relative CR on CR.Relativeid=Tab2.GuarantorID and CR.customerid=Tab2.CustomerID) Tab3 ";
	
	sSql = " select Tab1.SerialNo,Tab1.BusinessTypeName,Tab1.CustomerID,Tab1.CustomerName,Tab3.GuarantorName,Tab3.VouchTypeName, Tab3.RelationShip,Tab3.GuarantorID, "+
	" (case when Tab3.RelationShip is null or Tab3.RelationShip = '' then '��' else '��' end) as Pertain, "+
	" Tab1.BusinessSum,Tab1.Balance,Tab1.PutOutDate,Tab1.Maturity,Tab1.ManageOrgName,Tab1.HeaderOrgName,Tab1.ManageUserName from "+
	sTab1+','+sTab3+" where Tab1.SerialNo = Tab3.CRSer and Tab1.CustomerID <> Tab3.GuarantorID and Tab1.CustomerID in (select customerid from ent_info) order by Tab1.serialno ";
	
	
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
	doTemp.setHTMLStyle("CustomerName,GuarantorName","style={width:350px} "); 
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
	doTemp.setVisible("GuarantorID",false);
	
	//���ɲ�ѯ��
	//if(CurUser.hasRole("098")){
		//doTemp.setColumnAttribute("VouchTypeName","IsFilter","1");
	//}else{
	//	doTemp.setColumnAttribute("InputDate,Month,SerialNo,CustomerName,BusinessTypeName,ClassifyResult,BusinessSum,Balance, "+
	//	"OverdueBalance,ManageOrgName,PutOutDate,ActualMaturity,OverdueBalance,Flag3Name","IsFilter","1");
	//}
		doTemp.generateFilters(Sqlca);
		doTemp.setFilter(Sqlca,"1","SerialNo","");
		doTemp.setFilter(Sqlca,"2","CustomerID","");
		doTemp.setFilter(Sqlca,"3","CustomerName","");
		doTemp.setFilter(Sqlca,"4","BusinessTypeName","");
		doTemp.setFilter(Sqlca,"5","GuarantorName","");
		doTemp.setFilter(Sqlca,"6","RelationShip","");
		doTemp.setFilter(Sqlca,"7","PutOutDate","");
		doTemp.setFilter(Sqlca,"8","Maturity","");
		doTemp.setFilter(Sqlca,"9","ManageOrgName","");
		doTemp.setFilter(Sqlca,"10","HeaderOrgName","");
		doTemp.setFilter(Sqlca,"11","ManageUserName","");
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
