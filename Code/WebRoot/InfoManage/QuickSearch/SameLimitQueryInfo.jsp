<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zwhu 2009-08-30
		Tester:
		Describe: ��ˮ̨���б�;
		Input Param:

		Output Param:
			
		HistoryLog:

	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ˮ̨���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";

	//���ҳ�����
	
	//����������
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sLineID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("LineID"));
	
	if(sObjectNo == null) sObjectNo = "";
	if(sLineID == null) sLineID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//�����ͷ�ļ�
	String sHeaders[][] = { 
							{"LineID","��ȱ��"},
							{"ClTypeName","�����������"},		
							{"ApplySerialNo","����������ˮ��"},					
							{"ApproveSerialNo","���������"},
							{"BCSerialNo","���ź�ͬ��"},
							{"CustomerName","�ͻ�����"},
							{"BusinessType","ҵ��Ʒ��"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"CurrencyName","����"},
							{"LineSum1","���"},
							{"FreezeFlag","״̬"},										
							{"FreezeFlagName","״̬"},										
							{"LineEffDate","ʹ������"},
							{"PutOutDeadLine","��ֹ����"},										
							{"InputUser","������"},
							{"InputOrg","�������"}
							}; 
	sSql =	" select LineID,ClTypeName,ApplySerialNo,ApproveSerialNo,BusinessType,getBusinessName(BusinessType) as BusinessTypeName , "+ 
			" BCSerialNo,CustomerName,getItemName('Currency',Currency) as CurrencyName,LineSum1,"+
			" FreezeFlag,getItemName('FreezeFlag',FreezeFlag) as FreezeFlagName, LineEffDate,PutOutDeadLine, "+
			" getUserName(InputUser) as InputUser ,getOrgName(InputOrg) as InputOrg "+
			" from CL_INFO where LineID = '"+sLineID+"'";
	//out.println(sSql);

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.UpdateTable = "CL_INFO";
	doTemp.setKey("LineID",true);
	doTemp.setVisible("BusinessType,FreezeFlag",false);

    //���ý��Ϊ������ʽ
    doTemp.setType("LineSum1","Number");
    doTemp.setCheckFormat("LineSum1","2");
	doTemp.setAlign("LineSum1","3");


	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����ΪGrid���
	dwTemp.Height=100;
	dwTemp.Width=100;
	dwTemp.ReadOnly = "1"; //����Ϊֻ��


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
//		{"true","","Button","�鿴����","�鿴����","viewAndEdit()",sResourcesPath},
		};

	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>


	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	bFreeFormMultiCol=true;
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
