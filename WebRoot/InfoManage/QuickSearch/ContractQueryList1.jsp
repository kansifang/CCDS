<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   CYHui 2005-1-25
			Tester:
			Content: ��ͬ��Ϣ���ٲ�ѯ
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
		String PG_TITLE = "���˺�ͬ��Ϣ���ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
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
					{"CustomerID","�ͻ����"},
					{"CustomerName","�ͻ�����"},										
					{"CustomerType2","���ڿͻ�����"},										
					{"BusinessTypeName","ҵ��Ʒ��"},
					{"PayType","֧����ʽ"},	
					{"BusinessSum","���"},
					{"Balance","���"},										
					{"Currency","����"},
					{"RateFloat","���ʸ���ֵ"},
					{"BusinessRate","ִ������(%)"},
					{"PutOutDate","��ͬ��ʼ��"},
					{"Maturity","��ͬ������"},
					{"VouchTypeName","��Ҫ������ʽ"},
					{"ManageOrgName","�ܻ�����"},
					{"HeaderOrgName","ֱ����"},
					{"ManageUserName","�ܻ���"},
					{"BailRatio","��֤�����(%)"},
					}; 
	
	sSql =	" select BC.SerialNo,BC.CustomerID,BC.CustomerName,getItemName('CustomerType2',II.Flag1) as CustomerType2,getBusinessName(BusinessType) as BusinessTypeName,getItemName('pay_type',paytype) as PayType, "+
	" getItemName('Currency',BusinessCurrency) as Currency,BusinessSum,Balance,RateFloat,BusinessRate,BailRatio, "+
	" PutOutDate,Maturity,getItemName('VouchType',VouchType) as VouchTypeName, "+
	" getOrgName(BC.OperateOrgID) as ManageOrgName,getOrgName(getHeaderOrgID(OperateOrgID)) as HeaderOrgName,getUserName(BC.OperateUserID) as ManageUserName " +
	       	" from BUSINESS_CONTRACT BC,IND_INFO II "+
	" where BC.OperateOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') "+
	" and BC.CustomerID = II.CustomerID";
	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("SerialNo");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);	
	//���ùؼ���
	doTemp.setKey("CustomerID",true);	
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("CustomerName","style={width:100px} ");  
	doTemp.setHTMLStyle("BusinessRate","style={width:60px} "); 		
	//���ö��뷽ʽ
	doTemp.setAlign("BusinessSum,BusinessRate,Balance","3");	
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("BusinessSum,BailRatio","2");	
	doTemp.setCheckFormat("PutOutDate,Maturity","3");
	doTemp.setType("BusinessSum,RateFloat,BusinessRate,Balance,TermMonth,BailRatio","Number");
	doTemp.setCheckFormat("BusinessRate","16");
	
	//���ɲ�ѯ��
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");	
	doTemp.setFilter(Sqlca,"3","BusinessTypeName","");
	doTemp.setFilter(Sqlca,"4","BusinessSum","");
	doTemp.setFilter(Sqlca,"5","Balance","");
	doTemp.setFilter(Sqlca,"6","ManageOrgName","");
	doTemp.setFilter(Sqlca,"7","PutOutDate","");
	doTemp.setFilter(Sqlca,"8","Maturity","");	
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
