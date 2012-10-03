<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zywei  2006.03.14
		Tester:
		Content: ��ʾ��������ҵ��_List
		Input Param:			
			Days��������7�죻15�죻30�죩			   
		Output param:
		                
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������ҵ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	int iDays = 0;
	String sBeginDate = "",sEndDate="";
	String sSql = "";
		
	//����������		
	String sDays = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Days"));	
	//����ֵת��Ϊ���ַ���	
	if(sDays == null) sDays = "";	
	//���ҳ�����	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
 	//���ַ���������ת��Ϊ����
 	if(!sDays.equals("")) iDays = Integer.parseInt(sDays);
	sBeginDate=StringFunction.getToday();
	sEndDate = StringFunction.getRelativeDate(StringFunction.getToday(),iDays);
	
	//�б��ͷ
	String sHeaders[][] = {
							{"RelativeSerialNo2","��ͬ��ˮ��"},
							{"SerialNo","�����ˮ��"},
							{"CustomerName","�ͻ�����"},													
							{"BusinessType","ҵ��Ʒ��"},
							{"BusinessSum","���Ž��"},
							{"Balance","���"},
							{"Maturity","������"},
							{"InterestBalance1","����ǷϢ���"},
							{"InterestBalance2","����ǷϢ���"},
							{"FineBalance1","����Ϣ"},
							{"FineBalance2","��Ϣ��Ϣ"},												
							{"PutoutDate","������"}
							
						};
			              
	
	sSql = 	" select RelativeSerialNo2,SerialNo,CustomerName, "+
			" getBusinessName(BusinessType) as BusinessType, "+
			" BusinessSum,nvl(Balance,0) as Balance, Maturity,"+
			" InterestBalance1,InterestBalance2,FineBalance1, "+
			" FineBalance2,PutoutDate "+
			" from BUSINESS_DUEBILL BD " + 
			" where Maturity >= '"+sBeginDate+"' and Maturity<='"+sEndDate+"' "+			
			//" and OperateOrgID = '"+CurOrg.OrgID+"' "+
			//" and OperateUserID = '"+CurUser.UserID+"' "+
			" and exists(select 1 from Business_contract "+
			" where serialno=BD.RelativeSerialNo2  "+
			" and ManageOrgID='"+CurOrg.OrgID+"' and ManageUserID='"+CurUser.UserID+"') "+
			" and (FinishDate is null or FinishDate = '' or FinishDate=' ') ";
        				
	//ͨ��SQL��������ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "BUSINESS_DUEBILL";
	doTemp.setKey("SerialNo",true);
	//�����б��ͷ
	doTemp.setHeader(sHeaders);
	
	//���ø�ʽ
	doTemp.setHTMLStyle("CustomerName","style={width:200px}");
	doTemp.setCheckFormat("BusinessSum,Balance,InterestBalance","2");
	doTemp.setAlign("BusinessType","2");
	//���ù�����
	doTemp.setColumnAttribute("RelativeSerialNo2,Customername","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
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
			{"true","","Button","�������","�鿴�������","viewDueBill()",sResourcesPath}
		};
		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------	
	/*~[Describe=�������;InputParam=��;OutPutParam=��;]~*/
	function viewDueBill()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		sObjectType = "BusinessDueBill";
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}	
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');

</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
