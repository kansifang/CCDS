<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   	FSGong  2004.12.05
		Tester:
		Content:  	���պ����ٲ�ѯ
		Input Param:
				���в�����Ϊ�����������
				ComponentName	������ƣ����պ����ٲ�ѯ
				ComponentType		������ͣ�ListWindow												
			        
		Output param:
		                	
		History Log: 
		               
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���պ����ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";		
	String sObjectType = "BusinessContract"; //��������
	String sComponentName = "";
	
	//����������	
	sComponentName	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sHeaders[][] = {
							{"SerialNo","���պ���ˮ��"},
							{"ObjectNo","������"},
							{"BCSerialNo","��ͬ��ˮ��"},
							{"Maturity","��ͬ������"},
							{"CustomerName","�ͻ�����"},
							{"DunLetterNo","���պ����"},
							{"DunDate","��������"},
							{"ServiceMode","�ʹ﷽ʽ"},
							{"ServiceModeName","�ʹ﷽ʽ"},
							{"DunObjectName","���ն�������"},
							{"OperateUserName","������"},
							{"OperateOrgName","���ջ���"},
							{"DunCurrency","���ձ���"},
							{"DunSum","���ս��"},	
							{"Corpus","����"},	
							{"InterestInSheet","����Ϣ"},	
							{"InterestOutSheet","����Ϣ"},
							{"ElseFee","����"}	
					   };  
			       			
	sSql = 	" select di.ObjectNo,di.SerialNo as SerialNo,"+
			" bc.SerialNo as BCSerialNo,"+
			" bc.Maturity as Maturity,"+
			" bc.CustomerName as CustomerName,"+
			" di.DunLetterNo,"+
			" di.DunDate,"+
			" di.ServiceMode as ServiceMode, "+
			" getItemName('DunMode',di.ServiceMode) as ServiceModeName, "+	
			" di.DunObjectName,"+
			" getUserName(di.OperateUserID) as OperateUserName, " +	
			" getOrgName(di.OperateOrgID) as OperateOrgName,"+			
			" getItemName('Currency',di.DunCurrency) as DunCurrency, "+	
			" di.DunSum,"+			
			" di.Corpus,"+			
			" di.InterestInSheet,"+			
			" di.InterestOutSheet,"+
			" di.ElseFee "+			
			" from BUSINESS_CONTRACT bc, DUN_INFO di" +
			" where di.ObjectType='"+sObjectType+"' "+
			" and di.ObjectNo = bc.SerialNo "+
			" order by DunDate desc ";
	       			
   	
    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKeyFilter("di.SerialNo");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "DUN_INFO";
	doTemp.setKey("SerialNo",true);	 
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,ServiceMode,ObjectNo",false);	    
	//������ʾ�ı���ĳ���
	doTemp.setHTMLStyle("DunLetterNo"," style={width:70px} ");
	doTemp.setHTMLStyle("DunObjectName"," style={width:100px} ");
	doTemp.setHTMLStyle("DunDate,ServiceModeName,DunDate,Maturity"," style={width:70px} ");
	doTemp.setHTMLStyle("DunCurrency"," style={width:60px} ");
	doTemp.setHTMLStyle("DunSum,Corpus,InterestInSheet,InterestOutSheet,BCSerialNo,OperateUserName,ElseFee"," style={width:80px} ");
	//����С����ʾ״̬,
	doTemp.setAlign("DunSum,Corpus,InterestInSheet,InterestOutSheet,ElseFee","3");
	doTemp.setType("DunSum,Corpus,InterestInSheet,InterestOutSheet,ElseFee","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("DunSum,Corpus,InterestInSheet,InterestOutSheet,ElseFee","2");
	
	
	//���ɲ�ѯ��
	doTemp.setDDDWCode("ServiceMode","DunMode");


	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","DunObjectName","");
	doTemp.setFilter(Sqlca,"2","DunDate","");
	doTemp.setFilter(Sqlca,"3","OperateOrgName","");
	doTemp.setFilter(Sqlca,"4","OperateUserName","");
	doTemp.setFilter(Sqlca,"5","ServiceMode","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"6","BCSerialNo","");
	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
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
		{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
		{"true","","Button","ҵ���ͬ����","ҵ���ͬ����","viewTab()",sResourcesPath},
		{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath},
		};	 	
	%>	
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			popComp("RMDunQueryInfo","/InfoManage/QuickSearch/RMDunQueryInfo.jsp","SerialNo="+sSerialNo,"","");
		}
	}
   	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
    	
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
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
	//showFilterArea();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
