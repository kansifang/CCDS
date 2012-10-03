<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   	FSGong  2004.12.05
		Tester:
		Content:  	�����ʲ��б�(Listҳ��)
		Input Param:
				���в�����Ϊ�����������
				ComponentName	������ƣ������ʲ��б�
				PropertyType	�ʲ����ͣ������ʲ�/�����ʲ�								
				ObjectType	�������ͣ�BUSINESS_CONTRACT
						��������������Ŀ���Ǳ�����չ��,�������ܲ������û������ʲ��Ĵ��պ�����.
			        
		Output param:
		                ContractID	�ʲ����
		History Log: 		               
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʲ��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","125");
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sSql ="";
	
	String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
	if(sDBName.startsWith("INFORMIX"))
	{
			sSql =	" select bc.SerialNo as SerialNo,"+					
					" bc.PutOutDate as PutOutDate,"+
					" bc.Maturity as Maturity,"+
					" bc.CustomerName as CustomerName,"+
					" getBusinessName(bc.BusinessType) as BusinessType, " +
					" getItemName('Currency',bc.BusinessCurrency) as BusinessCurrency, " +
					" bc.BusinessSum as BusinessSum," +
					" bc.Balance as Balance, "+
					" Count(di.ObjectNo) as Counter,"+
					" Max(di.DunDate) as DunDate "+			
					" from  BUSINESS_CONTRACT bc,outer Dun_Info di" +
					" where bc.RecoveryUserID='"+CurUser.UserID+
					"' and bc.Balance >0 "+
					" AND(( bc.FinishDate is  NULL)or(bc.FinishDate ='') or (bc.FinishType='060'))  and bc.ShiftType='02' "+
					"  and (bc.SerialNo=di.ObjectNo) "+
					" Group by bc.SerialNo, bc.ArtificialNo, bc.OccurDate, "+
					" bc.Maturity,bc.CustomerName,bc.BusinessType,"+
					" bc.BusinessCurrency,bc.BusinessSum,bc.Balance,PutOutDate"+
					" order by bc.SerialNo desc";//���Ǻ������ʲ���
	}else if(sDBName.startsWith("ORACLE")) 
	{
			sSql =	" select bc.SerialNo as SerialNo,"+					
					" bc.PutOutDate as PutOutDate,"+
					" bc.Maturity as Maturity,"+
					" bc.CustomerName as CustomerName,"+
					" getBusinessName(bc.BusinessType) as BusinessType, " +
					" getItemName('Currency',bc.BusinessCurrency) as BusinessCurrency, " +
					" bc.BusinessSum as BusinessSum," +
					" bc.Balance as Balance, "+
					" Count(di.ObjectNo) as Counter,"+
					" Max(di.DunDate) as DunDate "+			
					" from  BUSINESS_CONTRACT bc,Dun_Info di" +
					" where bc.RecoveryUserID='"+CurUser.UserID+
					"' and bc.Balance >0 "+
					" AND(( bc.FinishDate is  NULL)or(bc.FinishDate ='') or (bc.FinishType='060'))  and bc.ShiftType='02' "+
					"  and bc.SerialNo=di.ObjectNo(+) "+
					" Group by bc.SerialNo, bc.ArtificialNo, bc.OccurDate, "+
					" bc.Maturity,bc.CustomerName,bc.BusinessType,"+
					" bc.BusinessCurrency,bc.BusinessSum,bc.Balance,PutOutDate"+
					" order by bc.SerialNo desc";//���Ǻ������ʲ���
	}else if(sDBName.startsWith("DB2")) 
	{
			sSql =	" select bc.SerialNo as SerialNo,"+					
					" bc.PutOutDate as PutOutDate,"+
					" bc.Maturity as Maturity,"+
					" bc.CustomerName as CustomerName,"+
					" getBusinessName(bc.BusinessType) as BusinessType, " +
					" getItemName('Currency',bc.BusinessCurrency) as BusinessCurrency, " +
					" bc.BusinessSum as BusinessSum," +
					" bc.Balance as Balance, "+
					" Count(di.ObjectNo) as Counter,"+
					" Max(di.DunDate) as DunDate "+			
					" from  BUSINESS_CONTRACT bc left outer join  Dun_Info di on(bc.SerialNo=di.ObjectNo) " +
					" where bc.RecoveryUserID='"+CurUser.UserID+
					"' and bc.Balance >0 "+
					" AND(( bc.FinishDate is  NULL)or(bc.FinishDate ='') or (bc.FinishType='060'))  and bc.ShiftType='02' "+
					" Group by bc.SerialNo, bc.ArtificialNo, bc.OccurDate, "+
					" bc.Maturity,bc.CustomerName,bc.BusinessType,"+
					" bc.BusinessCurrency,bc.BusinessSum,bc.Balance,PutOutDate"+
					" order by bc.SerialNo desc";//���Ǻ������ʲ���
	}
    //out.println(sSql);  			
   	String sHeaders[][] = {
										{"SerialNo","��ͬ��ˮ��"},										
										{"PutOutDate","��ͬ��ʼ��"},
										{"Maturity","��ͬ������"},
										{"CustomerName","�ͻ�����"},
										{"BusinessType","ҵ��Ʒ��"},
										{"BusinessCurrency","����"},
										{"BusinessSum","��ͬ���"},
										{"Balance","��ͬ���"},	
										{"Counter","���մ���"},				
										{"DunDate","�����������"}				
									};  
    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "BUSINESS_CONTRACT";
	doTemp.setKey("SerialNo",true);	 	   
	//������ʾ�ı���ĳ���
	doTemp.setHTMLStyle("SerialNo,DunLetterNo"," style={width:90px} ");
	doTemp.setHTMLStyle("PutOutDate,DunDate,Maturity"," style={width:70px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BusinessType"," style={width:100px} ");
	doTemp.setHTMLStyle("DunDate"," style={width:80px} ");
	doTemp.setHTMLStyle("BusinessCurrency,Counter"," style={width:60px} ");
	doTemp.setHTMLStyle("BusinessSum,Balance,BusinessRate"," style={width:80px} ");
	//���ö��뷽ʽ
	doTemp.setAlign("BusinessSum,Balance,BusinessRate,counter","3");
	doTemp.setAlign("BusinessCurrency","2");
	//����С����ʾ״̬,
	doTemp.setType("BusinessSum,BusinessRate,Balance","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("counter","5");
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	doTemp.setCheckFormat("BusinessRate","16");
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("SerialNo,CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(16);  //��������ҳ
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
		{"true","","Button","��ͬ����","��ͬ����","viewTab()",sResourcesPath},
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
		/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
		function viewTab()
		{
			sObjectType = "AfterLoan";
			sObjectNo = getItemValue(0,getRow(),"SerialNo");
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
			{
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
				return;
			}
			sApproveType = getItemValue(0,getRow(),"ApproveType");
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ApproveType="+sApproveType;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
		
		/*~[Describe=ѡ��ĳ�ʺ�ͬ,�Զ���ʾ��صĴ����б�;InputParam=��;OutPutParam=��;]~*/
		function mySelectRow()
		{
			sSerialNo = getItemValue(0,getRow(),"SerialNo");//��ͬ���
			if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
			{
				//alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			}else 
			{
				OpenComp("DunList","/RecoveryManage/DunManage/DunList.jsp","ObjectType=BusinessContract&ObjectNo="+sSerialNo,"DetailFrame");
			}
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
	OpenPage("/Blank.jsp?TextToShow=����ѡ����Ӧ�ĺ�ͬ��Ϣ!","DetailFrame","");
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
