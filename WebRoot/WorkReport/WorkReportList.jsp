<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: �������б�
		Input Param:
			InspectType��  �������� 
				010     ������;��鱨��
	            010010  δ���
	            010020  �����
	            020     �����鱨��
	            020010  δ���
	            020020  �����
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
	String PG_TITLE = "�������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
		//����˼�壬���ǻ�ȡ���˵��е�ItemNo��Ψһһ����¼�����˴˱����������� 
		//�䱾����Ϊ��ǰ��λ��ʾ01ͨ�á�02С��ҵ��03���廧�ȣ�������λ��ʾ010��;��鱨�桢020�ͻ���鱨�棬�����λ��ʾ����010δ��ɡ�020�����
		 String sCurItemID =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CurItemID"))); 
	    String sObjectType =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CurItemDescribe3"))); 
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
		ASDataObject doTemp = null;
		String sHeaders1[][] = {
										{"ReportDate","��������"},
										{"IsFinished","�Ƿ����"},
										{"BusinessTypeName","ҵ��Ʒ��"},
										{"SerialNo","��ˮ��"},
										{"Currency","����"},
										{"BusinessSum","��ͬ���"},
										{"PutOutDate","��ͬ��Ч����"},
										{"InputUser","�����"},
										{"InputOrg","��������"}
									};
		String sSql1 =  " select "+
							" case when II.InspectType like '%010' then '2' else '1' end as IsFinished,"+
							" II.SerialNo,II.ObjectType,II.InspectType,"+
							" ReportDate,'A003' as EDocNo,"+
							" getUserName(II.InputUserID) as InputUser,"+
							" getOrgName(II.InputOrgId) as InputOrg"+
							" from Work_Report II "+
							" where II.ObjectType='"+sObjectType+"' "+
			                " order by II.ReportDate desc";
		//��SQL������ɴ������
		doTemp = new ASDataObject(sSql1);
		doTemp.setHeader(sHeaders1);
		//���ÿɸ��µı�
		doTemp.UpdateTable = "Work_Report";
		//���ùؼ���
		doTemp.setKey("SerialNo",true);
		
		//���ò��ɼ���
		doTemp.setVisible("BusinessType,ObjectType,CustomerID,InspectType,InputUserID,InputOrgID,IsFinished",false);
		if("91".equals(sObjectType) || "92".equals(sObjectType)){
			doTemp.setVisible("IsFinished",true);
			doTemp.setColumnAttribute("IsFinished","IsFilter","1");
			doTemp.setDDDWCode("IsFinished","YesNo");
		}
		//���ò��ɸ�����
		doTemp.setUpdateable("BusinessTypeName,BusinessType,BusinessSum,CustomerName",false);
		doTemp.setUpdateable("CustomerName,InputUserName,InputOrgName",false);
		doTemp.setAlign("BusinessSum,Balance","3");
		doTemp.setType("BusinessSum,Balance","Number");
		doTemp.setCheckFormat("BusinessSum,Balance","2");
		//����html��ʽ
	  	doTemp.setHTMLStyle("InspectType"," style={width:100px} ");
	  	doTemp.setHTMLStyle("ObjectNo,CustomerName,BusinessTypeName"," style={width:120px} ");
		doTemp.setHTMLStyle("UpdateDate,InputUserName"," style={width:80px} ");
		doTemp.setHTMLStyle("ObjectNo,CustomerName"," style={width:250px} ");
		doTemp.setCheckFormat("ReportDate","3");
		//���ò�ѯ��
		doTemp.setColumnAttribute("BCSerialNo,CustomerName,BusinessSum","IsFilter","1");
		doTemp.setColumnAttribute("ObjectNo,CustomerName,ReportDate","IsFilter","1");
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));//��֪���ã���ʱ�������Ժ���̽��
	
	  	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	  	dwTemp.Style="1";      //����ΪGrid���
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
			{"true","","Button","����","��������","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴��������","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ���ñ���","deleteRecord()",sResourcesPath},
			{"true","","Button","�ͻ�������Ϣ","�鿴�ͻ�������Ϣ","viewCustomer()",sResourcesPath},
			{"true","","Button","ҵ���嵥","�鿴ҵ���嵥","viewBusiness()",sResourcesPath},
			{"false","","Button","���","��ɱ���","finished()",sResourcesPath},
			{"true","","Button","���ɱ���","���ɱ���","printContract()",sResourcesPath}
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
	function newRecord(){
		var sObjectType="<%=sObjectType%>";
		var sAccountMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?","","dialogWidth:350px;dialogHeight:350px;resizable:yes;scrollbars:no");
		if(typeof sAccountMonth=='undefined'){
			return;
		}
		//������в��¼
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName=Work_Report&ColumnName=SerialNo&Prefix=","","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		var sCol="String@SerialNo@"+sSerialNo+"@String@ObjectType@"+sObjectType;
		sCol=sCol+"@String@InputOrgID@"+"<%=CurOrg.OrgID%>"+"@String@InputUserID@"+"<%=CurUser.UserID%>"+"@String@InputDate@"+"<%=StringFunction.getToday()%>"+"@String@ReportDate@"+sAccountMonth;
		sCol=sCol+",Work_Report";
		var sRV=RunMethod("PublicMethod","InsertColValue",sCol);
		if(sRV==="TRUE"){
			sCompID = "AfterLoanInspectTab";
			sCompURL = "/BusinessManage/WorkReport/AfterLoanInspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectType="+sObjectType+"&CurrentItemNo=<%=sCurItemID%>&ReportDate="+sAccountMonth;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			reloadSelf();
		}else{
			alert("����ʧ�ܣ�");
		}
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType=getItemValue(0,getRow(),"ObjectType");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			var sCol="Inspect_Detail";
			sCol=sCol+",String@SerialNo@"+sSerialNo+"@String@ObjectNo@"+sObjectNo+"@String@ObjectType@"+sObjectType;
			var sRV=RunMethod("PublicMethod","DeleteColValue",sCol);
			if(sRV==="TRUE"){
				as_del('myiframe0');
				as_save('myiframe0');  //�������ɾ������Ҫ���ô����
			}else{
				alert("ɾ��ʧ�ܣ�");
			}
		}	
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectType=getItemValue(0,getRow(),"ObjectType");
		var sReportDate=getItemValue(0,getRow(),"ReportDate");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			sCompID = "AfterLoanInspectTab";
			sCompURL = "/BusinessManage/WorkReport/AfterLoanInspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectType="+sObjectType+"&CurrentItemNo=<%=sCurItemID%>&ReportDate="+sReportDate;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}

  /*~[Describe=���;InputParam=��;OutPutParam=��;]~*/
	function finished()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType=getItemValue(0,getRow(),"ObjectType");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getBusinessMessage('650')))//���������ɸñ�����
		{
			sReturn=PopPage("/CreditManage/CreditCheck/AfterLoanInspectAction.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			
			if(sReturn=="Inspectunfinish")
			{
				alert(getBusinessMessage('651'));//�ô���ͻ���鱨���޷���ɣ�������ɷ��շ��࣡
				return;
			}
			if(sReturn=="Purposeunfinish")
			{
				alert("�ô�����;�����޷���ɣ�����������ά���ļ���");//�ô�����;�����޷���ɣ�����������ά���ļ���
				return;
			}
			if(sReturn=="finished")
			{
				alert(getBusinessMessage('653'));//�ñ�������ɣ�
				reloadSelf();
			}
		}
	}
	 
	function generateReport(){
	    var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType=getItemValue(0,getRow(),"ObjectType");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm(getBusinessMessage('654'))){//��ȷ��Ҫ���ظñ�����
			sReturn=PopPage("/CreditManage/CreditCheck/ReEditInspectAction.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			var sCol="[Number@InspectType@substr(InspectType,1,5)||'010'@String@FinishDate@None@String@UpdateDate@<%=StringFunction.getToday()%>]";
			sCol=sCol+",Work_Report";
			sCol=sCol+",String@SerialNo@"+sSerialNo+"@String@ObjectNo@"+sObjectNo+"@String@ObjectType@"+sObjectType;
			var sRV=RunMethod("PublicMethod","UpdateColValue",sCol);
			if(sRV==="TRUE"){
				alert("���سɹ���");
				reloadSelf();
			}else{
				alert("���ز��ɹ���");
			}
		}
	}
	/*~[Describe=��ӡ���Ӻ�ͬ;InputParam=��;OutPutParam=��;]~*/
	function printContract(){
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sEDocNo = getItemValue(0,getRow(),"EDocNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sReturn = PopPage("/Common/EDOC/EDocCreateCheckAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","");
		if (typeof(sReturn)=="undefined") {
	        alert("��ӡ���Ӻ�ͬʧ�ܣ���");
		    return;
		}
		else if (sReturn=="nodef") {
			alert("��Ӧ�Ĳ�Ʒδ������Ӻ�ͬģ��,�������ɵ��Ӻ�ͬ��");
			return;
		}
		else if (sReturn=="nodoc") {
			if(confirm("���Ӻ�ͬδ���ɣ�ȷ��Ҫ���ɵ��Ӵ�ӡ��ͬ��"))
			{
				sReturn = PopPage("/Common/EDOC/EDocCreateActionAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","");
			    if (typeof(sReturn)=="undefined") {
			        alert("���ɵ��Ӻ�ͬʧ�ܣ�");
				    return;
				}
			}
			else
			    return;
		}
		popComp("EDocView","/Common/EDOC/EDocView.jsp","SerialNo="+sReturn);
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