<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: lkzou 2010-10-28
			Tester:
			Describe: �������������ѯҳ��;
			Input Param:

			Output Param:
		
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "�������������ѯҳ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	//�����б����
	String sHeaders[][] = {
					{"CustomerName","�ͻ�����"},
					{"SerialNo","��ݺ�"},
					{"ArtificialNo","��ͬ���"},
					{"AcceptTime","����ʱ��"},
					{"DistributeTime","����ʱ��"},
					{"InvestigateTime","����ʱ��"},
					{"CheckTime","���ʱ��"},
					{"ApproveTime","����ʱ��"},
					{"PutOutDate","�ſ�����"},
					{"Days","��������"}
				  };

	String sSql =   " select CA.SerialNo as AcceptSerialNo,BD.CustomerName,BD.SerialNo,BC.ArtificialNo,"+
			" #AcceptTime as AcceptTime,"+//����ʱ��
			" #DistributeTime as DistributeTime,"+//����ʱ��
			" #InvestigateTime as InvestigateTime,"+//����ʱ��
			" #CheckTime as CheckTime,"+//���ʱ��
			" #ApproveTime as ApproveTime,"+//����ʱ��
			" BD.PutOutDate,"+//�ſ�����
			" (days(date(replace(BD.PutOutDate,#A,#B)))-days(date(replace(#AcceptTime,#A,#B)))) as Days"+//��������
			" from Business_Duebill BD,Business_Contract BC,Business_Approve BAP,Approve_Relative AR,Credit_Accept CA"+
			" where BD.RelativeSerialNo2=BC.SerialNo"+
			" and BC.RelativeSerialNo=BAP.SerialNo"+
			" and BAP.SerialNo=AR.SerialNo"+
			" and AR.ObjectType='AcceptSource'"+
			" and AR.ObjectNo=CA.SerialNo"+
			" order by BD.SerialNo desc ";
	
	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("AcceptSerialNo,SerialNo,CustomerType,Status,Representative,InputUserID,InputOrgID,InputOrgName,InputDate",false);
	doTemp.setCheckFormat("PutOutDate","3");

    //���ò�ѯ��
    
	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","PutOutDate","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	//����DW
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20); 	//��������ҳ
	//����ʱ��
	String sTempS=" (select substr(CAT1.BeginTime,1,10) from Credit_Accept_Track CAT1 "+
			" where CAT1.AcceptSerialNo=CA.SerialNo and CAT1.SerialNo=(select Max(SerialNo) from Credit_Accept_Track CAT2 "+
			"  where CAT2.AcceptSerialNo=CAT1.AcceptSerialNo and CAT2.Status ='1'))";
	dwTemp.DataObject.SelectClause=StringFunction.replace(dwTemp.DataObject.SelectClause,"#AcceptTime",sTempS);
	//����ʱ��
	sTempS=" (select substr(CAT1.BeginTime,1,10) from Credit_Accept_Track CAT1 "+
	" 		where CAT1.AcceptSerialNo=CA.SerialNo and CAT1.SerialNo=(select Max(SerialNo) from Credit_Accept_Track CAT2 "+
	" where CAT2.AcceptSerialNo=CAT1.AcceptSerialNo and CAT2.Status ='2'))";

	dwTemp.DataObject.SelectClause=StringFunction.replace(dwTemp.DataObject.SelectClause,"#DistributeTime",sTempS);
	//����ʱ��
	sTempS=" (select substr(BeginTime,1,10) from Credit_Accept_Track where AcceptSerialNo=CA.SerialNo and Status ='6')";
	dwTemp.DataObject.SelectClause=StringFunction.replace(dwTemp.DataObject.SelectClause,"#InvestigateTime",sTempS);
	//���ʱ��
	sTempS=" (select substr(FT1.EndTime,1,10) from Flow_Task FT1 "+
	" where SerialNo=(select Max(SerialNo) from Flow_Task FT2 "+
	"  where FT2.ObjectType=FT1.ObjectType and FT2.ObjectNo=FT1.ObjectNo"+
	" 	and FT2.ObjectType='CreditApply' and FT2.ObjectNo=BAP.RelativeSerialNo and FT2.PhaseNo in('0010','3000')))";
	dwTemp.DataObject.SelectClause=StringFunction.replace(dwTemp.DataObject.SelectClause,"#CheckTime",sTempS);
	//����ʱ��
	sTempS=" (select substr(FT1.BeginTime,1,10) from Flow_Task FT1,Flow_Task FT2 "+
	" where FT1.ObjectType=FT2.ObjectType and FT1.ObjectNo=FT2.ObjectNo and FT1.SerialNo=FT2.RelativeSerialNo"+
	" and FT2.ObjectType='CreditApply' and FT2.ObjectNo=BAP.RelativeSerialNo and FT2.PhaseNo='1000')";
	dwTemp.DataObject.SelectClause=StringFunction.replace(dwTemp.DataObject.SelectClause,"#ApproveTime",sTempS);
	dwTemp.DataObject.SelectClause=StringFunction.replace(dwTemp.DataObject.SelectClause,"#A","'/'");
	dwTemp.DataObject.SelectClause=StringFunction.replace(dwTemp.DataObject.SelectClause,"#B","'-'");
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/
%>
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
			{"true","","Button","��������","�鿴/�޸���������","viewAndEdit()",sResourcesPath},
			{"false","","Button","�鿴���������","�鿴���������","viewApplyTable()",sResourcesPath},
			{"false","","Button","ʱЧ����","ʱЧ����","followTime()",sResourcesPath},
			{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath},
			};
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
    /*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteApply()
	{			
		var sSerialNo = getItemValue(0,getRow(),"AcceptSerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sSerialNo= getItemValue(0,getRow(),"AcceptSerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		else
		{
			var sStatus = "6";
	    	OpenComp("AcceptView","/BusinessManage/AcceptManage/AcceptView.jsp","SerialNo="+sSerialNo+"&Status="+sStatus,"_blank",OpenStyle);
		reloadSelf();		
		}
	}
	
	/*~[Describe=�鿴/��ӡ����������;InputParam=��;OutPutParam=��;]~*/
	function viewApplyTable(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sCustomerType = getItemValue(0,getRow(),"CustomerType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}	
		sDocID = "L003";
		if(sCustomerType=="01"){
		sDocID = "L001";
		}
		PopPage("/BusinessManage/AcceptManage/"+sDocID+".jsp?DocID="+sDocID+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=1&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		//��ü��ܺ��ҵ��������ˮ��
		sEncryptSerialNo = PopPage("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sSerialNo+"&rand="+randomNumber(),"myprint10","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		//�򿪴�������֪ͨ��
		window.open("<%=sWebRootPath%>/FormatDoc/WorkDoc/"+sEncryptSerialNo+".html","_blank",OpenStyle,true);
	}	
	
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}
	
	/*~[Describe=ʱЧ����;InputParam=��;OutPutParam=��;]~*/
	function followTime(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sCustomerType = getItemValue(0,getRow(),"CustomerType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}

		PopPage("/BusinessManage/AcceptManage/FT001.jsp?DocID=FT001&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=1&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		//��ü��ܺ��ҵ��������ˮ��
		sEncryptSerialNo = PopPage("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sSerialNo+"&rand="+randomNumber(),"myprint10","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		//��ʱЧ���ٱ�
		window.open("<%=sWebRootPath%>/FormatDoc/WorkDoc/"+sEncryptSerialNo+".html","_blank",OpenStyle,true);
	}	
	</script>
<%
	/*~END~*/
%>



<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%
	/*~END~*/
%>

<%@	include file="/IncludeEnd.jsp"%>
