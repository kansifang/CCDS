<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: wangdw 2012-3-21
		Tester:
		Describe: ��ʾ���ԭ������Ϣ;
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
	String PG_TITLE = "ԭ������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sRTableName = "";
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
	//����sObjectType�Ĳ�ͬ���õ���ͬ�Ĺ���������ģ����
	sSql = " select RelativeTable from OBJECTTYPE_CATALOG where ObjectType = '"+sObjectType+"' ";
	sRTableName = Sqlca.getString(sSql);
	
	String sHeaders[][] = {
							{"SerialNo","������"},
							{"CustomerID","�ͻ����"},							
							{"CustomerName","�ͻ�����"},
							{"OccurTypeName","��������"},	
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"BusinessSum","���"},
							{"OPERATEUSERNAME","������"},
							{"OPERATEORGNAME","�������"},
						  };

	sSql =  " select B.SerialNo,B.CustomerID,B.CustomerName,  "+
			" getItemName('OccurType',B.OccurType) as OccurTypeName, "+
			" getBusinessName(B.BusinessType) as BusinessTypeName,B.BusinessType,"+
			" B.BusinessSum,getUserName(B.OPERATEUSERID) as OPERATEUSERNAME,getOrgName(B.OPERATEORGID) as OPERATEORGNAME "+
			" from BUSINESS_APPLY as B ,"+sRTableName+" R "+
			" where "+
			" R.ObjectType='ApplyChange'"+
			" and R.objectno=b.serialno  "+
			" and R.serialno='"+sObjectNo+"'";
	System.out.println("sql======<><><><>"+sSql);
	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ,���±���,��ֵ,�ɼ����ɼ�,�Ƿ���Ը���
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GUARANTY_CONTRACT";
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("ObjectNo,ObjectType,RELATIVESERIALNO,BusinessType",false);
	doTemp.setUpdateable("GuarantyTypeName,GuarantyCurrency,InputUserName,InputOrgName",false);
	//���ø�ʽ
	doTemp.setAlign("GuarantyValue","3");
	doTemp.setCheckFormat("GuarantyValue","2");
	doTemp.setHTMLStyle("GuarantyTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("GuarantorName"," style={width:180px} ");
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);
	//��֯���кϼ��ò��� add by lpzhang 2010-1-21 
	String[][] sListSumHeaders = {{"GuarantyValue","�������"},
								  {"GuarantyCurrency","����"}
								 };
	String sListSumSql = "Select getItemName('Currency',GC.GuarantyCurrency) as GuarantyCurrency,Sum(GC.GuarantyValue) as GuarantyValue from GUARANTY_CONTRACT GC "+doTemp.WhereClause +" group by  GuarantyCurrency";
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
			{"true","","Button","��������","��������","viewTab()",sResourcesPath},
			{"true","","Button","�鿴���鱨��","�鿴���鱨��","viewReport()",sResourcesPath},
			{"true","","Button","�鿴��鱨��","�鿴��鱨��","viewCreateApproveReport()",sResourcesPath},
			{"true","","Button","�鿴��������","�鿴��������","viewApproveApproval()",sResourcesPath},
			
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>


	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			sReturn=RunMethod("BusinessManage","DeleteGuarantyContract","<%=sObjectType%>,<%=sObjectNo%>,"+sSerialNo);
			if(typeof(sReturn)!="undefined"&&sReturn=="SUCCEEDED") 
			{
				alert(getHtmlMessage('7'));//��Ϣɾ���ɹ���
				reloadSelf();
			}else
			{
				alert(getHtmlMessage('8'));//�Բ���ɾ����Ϣʧ�ܣ�
				return;
			}
		}
	}


	/*~[Describe=�鿴�����ͻ���������;InputParam=��;OutPutParam=��;]~*/
	function viewCustomerInfo()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			sCustomerID = getItemValue(0,getRow(),"GuarantorID");
			if (typeof(sCustomerID)=="undefined" || sCustomerID.length == 0)
				alert(getBusinessMessage('413'));//ϵͳ�в����ڵ����˵Ŀͻ�������Ϣ�����ܲ鿴��
			else
				openObject("Customer",sCustomerID,"002");
		}
	}


	/*~[Describe=������;InputParam=��;OutPutParam=��;]~*/
	function listSum()
	{
		popComp("ListSum","/Common/ToolsA/ListSum.jsp","Column1=222","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

	}
	/*~[Describe=�鿴��������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sObjectType="CreditApply";
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
	/*~[Describe=�鿴���鱨��;InputParam=��;OutPutParam=��;]~*/
	function viewReport()
	{
		//����������͡�������ˮ��
		sObjectType = "CreditApply";
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sObjectNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm("�Ƿ�鿴ϵͳ���ɵĵ��鱨�棬�����ȷ�����鿴�������ȡ�����鿴�ϴ��ĵ��鱨�棡")){
			var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if (typeof(sDocID)=="undefined" || sDocID.length==0)
			{
				alert(getBusinessMessage('505'));//���鱨�滹δ��д��������д���鱨���ٲ鿴��
				return;
			}
			sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&DocID="+sDocID,"","");
			if (sReturn == "false")
			{
				createReport();
				return;  
			}else
			{
				 if((sPhaseNo=="0010"||sPhaseNo=="3000")&&confirm(getBusinessMessage('503')))//���鱨���п��ܸ��ģ��Ƿ����ɵ��鱨����ٲ鿴��
				{
					createReport();
					return; 
				}else
				{				
					var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
					OpenPage("/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
				}
			}
		}
		else{
			PopComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo);
		}	
	}	
	/*~[Describe=�鿴����ҵ����������;InputParam=��;OutPutParam=��;]~*/
	function viewApproveApproval()
	{	
	    //����������͡�������ˮ��
		var sObjectType = "ApproveApproval";
		var sObjectNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
	    
	    var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+","+sObjectType);
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0 || sSerialNo == "Null")
		{
			alert("��ҵ����������Ϣ��");
			return;
		}else{
		    //�ж��Ƿ��ύ
			var sColName = "FinishApproveUserID";
			var sTableName = "BUSINESS_APPLY";
			var sWhereClause = "String@SerialNo@"+sObjectNo;
		    sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{			
				sReturn = sReturn.split('@');
				if(sReturn[1]=="null")
				{
					alert("����δͨ����");
					return;
				}
			}
			var sCompID = "PurposeInspectTab";
			var sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			var sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&viewOnly=true&viewPrint=true";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
		return true;
	}
	
	/*~[Describe=�����ίԱ�鿴��鱨��;InputParam=��;OutPutParam=��;]~*/
	function viewCreateApproveReport()
	{
		sObjectType = "";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sObjectType = "CreditApply";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
			PopComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo);
	}	
		/*~[Describe=���ɷ��շ����϶�����;InputParam=��;OutPutParam=��;]~*/
	function createReport()
	{
		//����������͡�������ˮ�š��ͻ����
		sObjectType = "CreditApply";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sCustomerID = getItemValue(0,getRow(),"CustomerID");

		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}	
		
		var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (typeof(sDocID)=="undefined" || sDocID.length==0)
		{
			alert(getBusinessMessage('505'));//���鱨�滹δ��д��������д���鱨���ٲ鿴��
			return;
		}	
		var sAttribute = PopPage("/FormatDoc/DefaultPrint/GetAttributeAction.jsp?DocID="+sDocID,"","");
		
		if (confirm(getBusinessMessage('504'))) //�Ƿ�Ҫ���Ӵ�ӡ����,���������ȷ����ť��
		{
			var sAttribute1 = PopPage("/Common/WorkFlow/DefaultPrintSelect.jsp?DocID="+sDocID+"&rand="+randomNumber(),"","dialogWidth=36;dialogHeight=22;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");
			if (typeof(sAttribute1)=="undefined" || sAttribute1.length==0)
				return;
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
			OpenPage("/FormatDoc/ProduceFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&CustomerID="+sCustomerID+"&Attribute="+sAttribute1,"_blank02",CurOpenStyle); 
		}
		else
		{
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
			OpenPage("/FormatDoc/ProduceFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&CustomerID="+sCustomerID+"&Attribute="+sAttribute,"_blank02",CurOpenStyle); 
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