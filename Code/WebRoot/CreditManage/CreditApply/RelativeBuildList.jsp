<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 2009-8-10 lpzhang
		Tester:
		Describe: ����/���뷿�ز�����Э��
		Input Param:
				ObjectType���������ͣ�CreditApply��
				ObjectNo: �����ţ�������ˮ�ţ�
		Output Param:
				
		HistoryLog:				
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����/���뷿�ز�����Э��"; // ��������ڱ��� 
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
	//�������������������͡�������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//��ʾ����				
	String[][] sHeaders = {		
							{"SerialNo","Э����ˮ��"},              	
							{"CustomerName","����������"},              
							{"ProjectName","������Ŀ����"},            
							{"Currency","����"},                    
							{"LoanSum","�����ܶ�Ƚ��"},           	
							{"PutOutDate","Э��ǩ������"},            	
							{"Maturity","Э�鵽������"},           	
							{"InputUserName","�Ǽ���"},                  
							{"InputOrgName","�Ǽǻ���"},                
							{"InputDate","�Ǽ�����"},                
							{"UpdateDate","��������"},    
						 };

	sSql =  " select SerialNo,CustomerName,ProjectName,LoanSum,"+
		    " getItemName('Currency',Currency) as Currency,PutOutDate,Maturity, "+
			" getUserName(InputUserID) as InputUserName,UpdateDate "+
			" from Ent_Agreement EA where EA.AgreementType = 'BuildAgreement'"+
		    " and EXISTS (select 1 from Apply_Relative AR where AR.ObjectType='BuildAgreement'"+
		    "            and  AR.SerialNo= '"+sObjectNo+"' and AR.ObjectNo =EA.SerialNo )";
    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="Ent_Agreement";
	doTemp.setKey("SerialNo",true);	
	doTemp.setHeader(sHeaders);
	doTemp.setAlign("Currency","2");
	
	doTemp.setType("LoanSum","Number");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("Currency"," style={width:80px} ");
	
	//����Filter			
	doTemp.setColumnAttribute("CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","���뵣����ͬ��Ϣ","importRecord()",sResourcesPath},
		{"true","","Button","����","�鿴������ͬ��Ϣ����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��������ͬ��Ϣ","deleteRecord()",sResourcesPath},
		};

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
		sObjectNo = "<%=sObjectNo%>";
		OpenComp("BuildAgreementInfo","/CreditManage/CreditLine/BuildAgreementInfo.jsp","ObjectNo="+sObjectNo,"_blank",OpenStyle)
		reloadSelf();
	}

	/*~[Describe=�����¼;InputParam=��;OutPutParam=��;]~*/
	function importRecord()
	{
	    //���뵱ǰ����������
	    sParaString = "ObjectType"+",BuildAgreement"+","+"CurDate"+",<%=StringFunction.getToday()%>";		
		sReturn = selectObjectValue("SelectEntAgreement",sParaString,"",0,0,"");
		if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_NONE_" || sReturn=="_CLEAR_" || typeof(sReturn)=="undefined") return;
		sReturn= sReturn.split('@');
		sSerialNo = sReturn[0];
		//�Ƿ��Ѿ�����
		iCount = RunMethod("BusinessManage","CheckRelative","BuildAgreement,"+sSerialNo+",<%=sObjectNo%>");
		if(iCount>0)
		{
			alert("��Э���Ѿ����룬�����ٴ�����!");
			return;
		}
		sReturn=RunMethod("BusinessManage","InsertApplyRelative","BuildAgreement,"+sSerialNo+",<%=sObjectNo%>");
		alert("����¥���Э��ɹ���");
		reloadSelf();
		
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			sReturn=RunMethod("BusinessManage","DeleteApplyRelative","BuildAgreement,"+sSerialNo);
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
			reloadSelf();
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			OpenComp("BuildAgreementInfo","/CreditManage/CreditLine/BuildAgreementInfo.jsp","ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo,"_blank",OpenStyle)
			//OpenPage("/CreditManage/CreditLine/BuildAgreementInfo.jsp?ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo,"right");
		}
	}

    
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>


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