<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: ����¼�б�
		
		Input Param:
		SerialNo:��ˮ��
		ObjectType:��������
		ObjectNo��������
		
		Output Param:
		SerialNo:��ˮ��
		ObjectType:��������
		ObjectNo��������	
		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����¼�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//����������
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	//out.println("tteee"+sSerialNo);
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sHeaders[][] = { {"AccountNo","�����˺�"},
							{"CustomerName","���˿ͻ�����"},
							{"CurrencyName","����"}, 
							{"ItemDate","��������"},
							{"ItemSum","���׽��"},
							{"Balance","�ʻ����"}
						  };
	String sSql = " select SerialNo,ItemNo,ObjectType,objectno,AccountNo,CustomerName,"+
				  " getItemName('Currency',Currency) as CurrencyName,"+
	              " ItemDate,ItemSum,Balance from INSPECT_DETAIL "+
	              " where ItemType='01' and SerialNo='"+sSerialNo+"' and ObjectNo='"+sObjectNo+"' "+
	              " and  ObjectType='"+sObjectType+"'";
    //sql����doTemp����
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ÿɸ��µı�
	doTemp.UpdateTable = "INSPECT_DETAIL";
	//���ùؼ���
	doTemp.setKey("SerialNo,ItemNo,ObjectType,objectno",true);
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,ItemNo,ObjectType,objectno",false);
	
	doTemp.setCheckFormat("ItemSum,Balance","2");//���������ʽ�������ŵ�Ǯ��
	doTemp.setAlign("ItemSum,Balance","3");
	doTemp.setVisible("Balance",false);
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
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
		{"true","","Button","����","��������¼","newRecord()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ������¼","deleteRecord()",sResourcesPath},
		};
	//���ñ����Ƿ������	
	sSql = " select Finishdate from INSPECT_INFO where SerialNo='"+sSerialNo+"' and ObjectNo='"+sObjectNo+"'"+
		   " and  ObjectType='"+sObjectType+"'";
	ASResultSet rs = Sqlca.getResultSet(sSql);

	if(rs.next())
	{
		String s =(String)rs.getString("Finishdate");
		if(s != null)
		{
			sButtons[0][0] = "false";
			sButtons[1][0] = "false";
		}
	}
	rs.getStatement().close();
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
		OpenPage("/CreditManage/CreditCheck/PutoutRecordInfo.jsp?SerialNo=<%=sSerialNo%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&rand="+randomNumber(),"_self","");
	}

	function deleteRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
		
			alert("��ѡ��һ����¼��");
			
		}
		else
		{		
			if (confirm("��ȷ��Ҫɾ���ü�¼��"))
			{
				as_del('myiframe0');
				as_save('myiframe0');
			}			
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>

