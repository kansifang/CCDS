<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cwliu 2004-11-29
		Tester:
		Describe:  ��Ŀ�ʽ���Դ
		Input Param:
			ProjectNo����ǰ��Ŀ���
		Output Param:
			ProjectNo����ǰ��Ŀ���
			

		HistoryLog:
					2005.7.28	hxli   �����д
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ŀ�ʽ���Դ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	//���ҳ�����	 
	String sObjectNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	//����������	
	String sProjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProjectNo"));
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sHeaders[][] = { {"ProjectNo","��Ŀ���"},
							{"FundSourceName","�ʽ���Դ��ʽ"},
							{"INVESTORNAME","�ʽ���Դ��������"},
							{"Currency","����"},
							{"InvestSum","���"},
							//{"InvestRatio","Ͷ��ռ��(%)"},
							{"OrgName","�Ǽǻ���"},
						    {"UserName","�Ǽ���"}
						};   		   		
	
	String sSql =	"  select ProjectNo,SerialNo,FundSource,"+
					"  getItemName('CapitalsourceStyle',FundSource) as FundSourceName,INVESTORNAME,"+
					"  getItemName('Currency',Currency) as Currency,"+
					"  InvestSum,InvestRatio,"+
					"  InputOrgId,getOrgName(InputOrgId) as OrgName ,"+
					"  InputUserId,getUserName(InputUserId) as UserName" +
					"  from PROJECT_FUNDS "+
					"  where ProjectNo='"+sProjectNo+"'";
    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "PROJECT_FUNDS";
	doTemp.setKey("ProjectNo,SerialNo",true);	 //Ϊ�����ɾ��
	doTemp.setAlign("FundSourceName,Currency","2");
	//���ò��ɼ���
	doTemp.setVisible("ProjectNo,SerialNo,InputOrgId,InputUserId,FundSource,InvestRatio",false);	    
	//ͨ�������ⲿ�洢�����õ����ֶ�
	doTemp.setUpdateable("UserName,OrgName,FundSourceName",false);   
	doTemp.setHTMLStyle("UserName,OrgName"," style={width:80px} ");
	doTemp.setHTMLStyle("FundSourceName,InvestSum,InvestRatio"," style={width:80px} ");
	doTemp.setHTMLStyle("Currency"," style={width:60px} ");
	doTemp.setHTMLStyle("FundSourceName"," style={width:180px} ");
	doTemp.setHTMLStyle("OrgName","style={width=250px}");	
	//���Ҷ���
	doTemp.setAlign("InvestSum,InvestRatio","3");
	//����������֣�С������
	doTemp.setType("InvestSum,InvestRatio","Number");//���������ͣ���Ӧ����ģ�桰ֵ���͡�
	doTemp.setCheckFormat("InvestSum,InvestRatio","2");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String InvestSum = Sqlca.getString("select Sum(InvestSum) From PROJECT_FUNDS"+doTemp.WhereClause);
	if(InvestSum == null) InvestSum = "";
	String[][] sListSumHeaders = {	{"CurrencyName","����"},
									{"FundSourceName","�ʽ���Դ��ʽ"},
									{"InvestSum","���"},
									{"Currency","����"},
									{"InvestRatio","Ͷ��ռ��(%)"}
								 };
	String sListSumSql = "Select FundSource,getItemName('CapitalsourceStyle',FundSource) as FundSourceName,"
						+ " Currency,getItemName('Currency',Currency) as CurrencyName,Sum(InvestSum) as InvestSum, "
						+ "Sum(InvestSum)*100"+"/"+DataConvert.toMoney(InvestSum).replaceAll(",","") +" as InvestRatio"
						+ " From PROJECT_FUNDS "
						+ doTemp.WhereClause
						+ " Group By FundSource,Currency";
	CurComp.setAttribute("ListSumHeaders",sListSumHeaders);
	CurComp.setAttribute("ListSumSql",sListSumSql);	
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
		{"true","","Button","����","������Ŀ�ʽ���Դ��Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴��Ŀ�ʽ���Դ����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����Ŀ�ʽ���Դ��Ϣ","deleteRecord()",sResourcesPath},
		{"true","","Button","����","������","listSum()",sResourcesPath}		
		};
	if("".equals(InvestSum)){
		sButtons[3][0] = "false";
	}	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		//�ʽ���Դ��ʽ¼��ģ̬�����
		sReturnValue = PopPage("/CustomerManage/EntManage/AddFundSrcDialog.jsp?","","resizable=yes;dialogWidth=20;dialogHeight=8;center:yes;status:no;statusbar:no");

		//�ж��Ƿ񷵻���Ч��Ϣ
		if(typeof(sReturnValue)!="undefined" && sReturnValue.length!=0 && sReturnValue != '_none_')
			OpenPage("/CustomerManage/EntManage/ProjectFundsInfo.jsp?FundSource="+sReturnValue,"_self","");
	}
	

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sProjectNo = getItemValue(0,getRow(),"ProjectNo");		
		if (typeof(sProjectNo)=="undefined" || sProjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}		
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{

		sProjectNo = getItemValue(0,getRow(),"ProjectNo");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sFundSource = getItemValue(0,getRow(),"FundSource");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)		
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{       
			OpenPage("/CustomerManage/EntManage/ProjectFundsInfo.jsp?SerialNo="+sSerialNo+"&FundSource="+sFundSource, "_self","");
		}
	}
	/*~[Describe=������;InputParam=��;OutPutParam=��;]~*/
	function listSum()
	{
		popComp("ListSum","/Common/ToolsA/ListSum.jsp","Column1=222","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	
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
