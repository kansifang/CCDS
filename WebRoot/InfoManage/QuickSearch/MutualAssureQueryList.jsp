<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   CYHui 2005-1-26
			Tester:
			Content: ��������Ϣ���ٲ�ѯ
			Input Param:
				���в�����Ϊ�����������
				ComponentName	������ƣ���������Ϣ���ٲ�ѯ
		          
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
		String PG_TITLE = "������Ϣ���ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
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
	String sComponentName = "";//--����������
	String PG_CONTENT_TITLE = "";
	String sTab1 = "";
	String sTab2 = "";
	String sTab3 = "";
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
	String sHeaders[][] =	{ 			
						{"SerialNo","��ͬ���"},
						{"CustomerID","����˱��"},
						{"CustomerName","���������"},
						{"BusinessType","ҵ��Ʒ��"},
						{"BusinessSum","��ͬ���"},
						{"Balance","��ͬ���"},
						{"GuarantorName","�ṩ�����ͻ�����"},
						//{"GuarantorName","�ṩ�����ͻ��������������"},
						{"PutOutDate","��ͬ��ʼ��"},
						{"Maturity","��ͬ������"},
						{"ManageOrgID","�ܻ�����"},
						{"OrgName","ֱ����"},
						{"InputUserName","�ͻ�����"}
					}; 
	
	sTab1 =	"(select BC.SerialNo,BC.customerid,BC.customername,getBusinessName(BusinessType) as BusinessType,BC.BusinessSum,BC.Balance,GC.guarantorid,GC.guarantorname, "+
	" BC.PutOutDate,BC.Maturity,getOrgName(BC.ManageOrgID) as ManageOrgID,getOrgName(getHeaderOrgID(BC.InputOrgID)) as OrgName,getUserName(BC.InputUserID) as InputUserName "+
	" from guaranty_contract GC,contract_relative CR,business_contract BC "+
	" where GC.serialno=CR.objectno and CR.serialno=BC.serialno and BC.customerid<>GC.guarantorid ) as Tab1";
	
	sTab2 = " (select BC.serialno,BC.customerid,BC.customername,GC.guarantorid,GC.guarantorname "+
	" from guaranty_contract GC,contract_relative CR,business_contract BC "+
	" where GC.serialno=CR.objectno and CR.serialno=BC.serialno and BC.customerid<>GC.guarantorid ) as Tab2";
	
	sTab3 = "(select distinct Tab1.SerialNo,Tab1.customerid as CustomerID,Tab1.customername as CustomerName,Tab1.BusinessType as BusinessType,Tab1.BusinessSum as BusinessSum, "+
	" Tab1.Balance as Balance,Tab1.guarantorname as GuarantorName,Tab1.PutOutDate as PutOutDate,Tab1.Maturity as Maturity,Tab1.ManageOrgID as ManageOrgID,Tab1.OrgName as OrgName,Tab1.InputUserName as InputUserName from"+
	sTab1+","+sTab2+" where Tab1.customerid=Tab2.guarantorid and Tab1.guarantorid = Tab2.customerid ) as Tab3 ";
	
	sSql = " select Tab3.SerialNo,Tab3.CustomerID,Tab3.CustomerName,Tab3.BusinessType,Tab3.BusinessSum,Tab3.Balance,Tab3.GuarantorName, "+
	" Tab3.PutOutDate,Tab3.Maturity,Tab3.ManageOrgID,Tab3.OrgName,Tab3.InputUserName from "+sTab3 +"where 1=1 ";

	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    //doTemp.setKeyFilter("CustomerID");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ùؼ���
	//doTemp.setKey("GuarantyID",true);
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("CustomerName,GuarantorName","style={width:250px} ");  
	//���ò��ɼ���
	//doTemp.setVisible("GuarantyType,InputOrgID",false);		
	//���ö��뷽ʽ
	//doTemp.setAlign("EvalNetValue,ConfirmValue","3");
	//doTemp.setType("EvalNetValue,ConfirmValue","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("PutOutDate,Maturity","3");	
	//����������
	//doTemp.setDDDWSql("BusinessType","select SortNo,TypeName from Business_Type where length(SortNo) > 4");

	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerID","");
	doTemp.setFilter(Sqlca,"3","CustomerName","");
	doTemp.setFilter(Sqlca,"4","BusinessType","");
	doTemp.setFilter(Sqlca,"5","CustomerName","");
	doTemp.setFilter(Sqlca,"6","GuarantorName","");
	doTemp.setFilter(Sqlca,"7","PutOutDate","");
	doTemp.setFilter(Sqlca,"8","Maturity","");
	doTemp.setFilter(Sqlca,"9","ManageOrgID","");
	doTemp.setFilter(Sqlca,"10","OrgName","");
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
			{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath}
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
		
	    sObjectType = "AfterLoan";
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
