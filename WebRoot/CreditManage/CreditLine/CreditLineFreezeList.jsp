<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:zywei 2006/04/01
		Tester:
		Content: ���Ŷ�ȶ����ⶳ�б�ҳ��
		Input Param:
			FreezeFlag�������ⶳ��־��1����Ч�ģ�2���ѱ�����ģ�
		Output param:
		
		History Log: 

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
	//����������	
	String sFreezeFlag =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FreezeFlag"));
	if(sFreezeFlag == null) sFreezeFlag = "";
	//���ҳ�����	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%		
	//��ʾ����				
	String[][] sHeaders = {					
					{"BCSerialNo","��ͬ��ˮ��"},
					{"CLTypeName","�������"},
					{"CustomerID","�ͻ����"},
					{"CustomerName","�ͻ�����"},
					{"LineSum1","��Ƚ��"},
					{"Currency","����"},
					{"LineEffDate","��Ч��"},
					{"BeginDate","��ʼ��"},
					{"EndDate","������"}
					};
	String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
	if(sDBName.startsWith("INFORMIX"))
	{
		sSql =  " select LineID,CLTypeID,CLTypeName,BCSerialNo,CustomerID,CustomerName,"+
				" LineSum1,getItemName('Currency',Currency) as Currency,LineEffDate, "+
				" BeginDate,EndDate "+
				" from CL_INFO "+
				" where LineEffDate <= '"+StringFunction.getToday()+"' "+				
				" and BeginDate <= '"+StringFunction.getToday()+"' "+
				" and EndDate >= '"+StringFunction.getToday()+"' "+
				" and BCSerialNo is not null "+
				" and BCSerialNo <> '' "+
				" and (ParentLineID is null "+
				" or ParentLineID = '') ";
	}else if(sDBName.startsWith("ORACLE"))
	{
		sSql =  " select LineID,CLTypeID,CLTypeName,BCSerialNo,CustomerID,CustomerName,"+
				" LineSum1,getItemName('Currency',Currency) as Currency,LineEffDate, "+
				" BeginDate,EndDate "+
				" from CL_INFO "+
				" where LineEffDate <= '"+StringFunction.getToday()+"' "+				
				" and BeginDate <= '"+StringFunction.getToday()+"' "+
				" and EndDate >= '"+StringFunction.getToday()+"' "+
				" and BCSerialNo is not null "+
				" and BCSerialNo <> ' ' "+
				" and (ParentLineID is null "+
				" or ParentLineID = ' ') ";
	}else if(sDBName.startsWith("DB2"))
	{
		sSql =  " select LineID,CLTypeID,CLTypeName,BCSerialNo,CustomerID,CustomerName,"+
				" LineSum1,getItemName('Currency',Currency) as Currency,LineEffDate, "+
				" BeginDate,EndDate "+
				" from CL_INFO "+
				" where LineEffDate <= '"+StringFunction.getToday()+"' "+				
				" and BeginDate <= '"+StringFunction.getToday()+"' "+
				" and EndDate >= '"+StringFunction.getToday()+"' "+
				" and BCSerialNo is not null "+
				" and BCSerialNo <> '' "+
				" and (ParentLineID is null "+
				" or ParentLineID = '') ";
	}	
	//�����־FreezeFlag��1��������2�����᣻3���ⶳ��4����ֹ��
	if(sFreezeFlag.equals("1")) //��Ч��
		sSql +=	" and FreezeFlag in ('1','3') ";  
	else //�����
		sSql +=	" and FreezeFlag = '"+sFreezeFlag+"' ";  	
	//����Ȩ�޿���
	sSql +=" and InputOrg in(select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	//out.println(sSql);		
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="CL_INFO";
	doTemp.setKey("LineID",true);	
	doTemp.setHeader(sHeaders);
	doTemp.setVisible("LineID,CLTypeID,CustomerID,LineEffDate,BeginDate,EndDate",false);
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	//����Filter			
	doTemp.setColumnAttribute("CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	//����С����λ�� add by wangdw
	doTemp.setCheckFormat("LineSum1","2");	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause += " and 1=1 ";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
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
		{(sFreezeFlag.equals("1")?"true":"false"),"","Button","����","������ѡ�Ķ�ȼ�¼","freezeRecord()",sResourcesPath},
		{(sFreezeFlag.equals("2")?"true":"false"),"","Button","�ⶳ","�ⶳ��ѡ�Ķ�ȼ�¼","unfreezeRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","openWithObjectViewer()",sResourcesPath},
		{"true","","Button","���Ŷ������ҵ��","������Ŷ������ҵ��","lineSubList()",sResourcesPath}
		};
		
	%> 
	
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�������Ŷ��;InputParam=��;OutPutParam=��;]~*/
	function freezeRecord()
	{
		sLineID = getItemValue(0,getRow(),"LineID");
		sBCSerialNo = getItemValue(0,getRow(),"BCSerialNo");
		if (typeof(sLineID)=="undefined" || sLineID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getBusinessMessage('400')))//ȷʵҪ����ñ����Ŷ����
		{
			//�������
			sReturn=RunMethod("BusinessManage","FreezeCreditLine",sLineID+","+sBCSerialNo+","+"2");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {				
				alert(getBusinessMessage('401'));//�������Ŷ��ʧ�ܣ�
				return;			
			}else
			{
				reloadSelf();	
				alert(getBusinessMessage('402'));//�������Ŷ�ȳɹ���
			}	
		}	
	}
	
	/*~[Describe=�ⶳ���Ŷ��;InputParam=��;OutPutParam=��;]~*/
	function unfreezeRecord()
	{
		sLineID = getItemValue(0,getRow(),"LineID");
		sBCSerialNo = getItemValue(0,getRow(),"BCSerialNo");
		if (typeof(sLineID)=="undefined" || sLineID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getBusinessMessage('403')))//ȷʵҪ�ⶳ�ñ����Ŷ����
		{
			//�ⶳ����
			sReturn=RunMethod("BusinessManage","FreezeCreditLine",sLineID+","+sBCSerialNo+","+"3");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {				
				alert(getBusinessMessage('404'));//�ⶳ���Ŷ��ʧ�ܣ�
				return;			
			}else
			{
				reloadSelf();	
				alert(getBusinessMessage('405'));//�ⶳ���Ŷ�ȳɹ���
			}	
		}	
	}
	
	/*~[Describe=���Ŷ������ҵ��;InputParam=��;OutPutParam=��;]~*/
	function lineSubList()
	{		
		sBCSerialNo = getItemValue(0,getRow(),"BCSerialNo");
		if (typeof(sBCSerialNo)=="undefined" || sBCSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		popComp("lineSubList","/CreditManage/CreditLine/lineSubList.jsp","CreditAggreement="+sBCSerialNo,"","");
	}
			
	/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function openWithObjectViewer()
	{
		sLineID=getItemValue(0,getRow(),"LineID");
		if (typeof(sLineID)=="undefined" || sLineID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		openObject("CreditLine",sLineID,"002");
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
