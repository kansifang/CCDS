<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:byhu 20050727
		Tester:
		Content: ���Ŷ�ȼ���б�ҳ��
		Input Param:
			
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
	
	//���ҳ�����	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%		
	//��ʾ����				
	String[][] sHeaders = {						
						{"BCSerialNo","��ͬ��ˮ��"},
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
				" and FreezeFlag = '1' ";  		
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
				" and FreezeFlag = '1' ";  		
	}if(sDBName.startsWith("DB2"))
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
				" and FreezeFlag = '1' ";  		
	}
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="CL_INFO";
	doTemp.setKey("LineID",true);	
	doTemp.setHeader(sHeaders);
	doTemp.setVisible("LineID,CLTypeID,CLTypeName,CustomerID",false);
	
	//����Filter			
	doTemp.setColumnAttribute("CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause += " and 1=1 ";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	dwTemp.setEvent("AfterDelete","!CreditLine.DeleteLineRelative(#LineID)");
	
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
		{"true","","Button","����","�鿴/�޸�����","openWithObjectViewer()",sResourcesPath},
		{"true","","Button","���","�����ѡ�еĶ������ҵ��ĺϷ���","checkCreditLine()",sResourcesPath},
		};
		
	%> 
	
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	
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
	
	/*~[Describe=�����ѡ�еĶ������ҵ��ĺϷ���;InputParam=��;OutPutParam=��;]~*/
	function checkCreditLine()
	{
		sLineID=getItemValue(0,getRow(),"LineID");
		if (typeof(sLineID)=="undefined" || sLineID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sReturn = PopPage("/CreditManage/CreditLine/CreditLineCheckAction.jsp?LineID="+sLineID,"_blank","");
		alert("����ֵ��"+sReturn+" \n˵���� Refuse ��ʾ����У�鲻ͨ��  Pass ��ʾ����У��ͨ��!");
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
