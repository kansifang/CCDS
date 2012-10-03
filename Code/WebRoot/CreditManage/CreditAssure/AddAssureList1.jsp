<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005-11-27
		Tester:
		Describe: ҵ���ͬ����Ӧ�������ĵ�����ͬ�б�һ����֤��ͬ��Ӧһ����֤�ˣ�;
		Input Param:
				ObjectType���������ͣ�BusinessContract��
				ObjectNo: �����ţ���ͬ��ˮ�ţ�
		Output Param:
				
		HistoryLog:
							
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������ͬ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","125");
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%!
	int getBtnIdxByName(String[][] sArray, String sButtonName){
		for (int i=0;i<sArray.length;i++) {
			if (sButtonName.equals(sArray[i][3]))
				return i;
		}
		return -1;
	}
%>
<%
	//�������
	String sSql = "";
	//�������������������͡�������
	String sObjectType = "BusinessContract";
	
	//����ֵת��Ϊ���ַ���
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","������ͬ���"},
							{"GuarantyTypeName","������ʽ"},
							{"ContractTypeName","������ͬ����"},
							{"GuarantorName","����������"},
							{"GuarantyValue","�������"},				            
							{"GuarantyCurrency","����"},
							{"InputUserName","�Ǽ���"},
							{"InputOrgName","�Ǽǻ���"}
						  };

	sSql =  " select GC.SerialNo,GC.CustomerID,GC.ContractType,GC.GuarantyType, "+
			" getItemName('GuarantyType',GC.GuarantyType) as GuarantyTypeName, "+
			" getItemName('ContractType',GC.ContractType) as ContractTypeName,"+
			" GC.GuarantorID,GC.GuarantorName,GC.GuarantyValue, "+
			" getItemName('Currency',GC.GuarantyCurrency) as GuarantyCurrency, "+
			" GC.InputUserID,getUserName(GC.InputUserID) as InputUserName, "+
			" GC.InputOrgID,getOrgName(GC.InputOrgID) as InputOrgName "+
			" from GUARANTY_CONTRACT GC "+
			" where GC.SerialNo like 'ZJGC%' "+
			" and ContractStatus = '020' "+
			" and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	//�ͻ�����ֻ�ܲ鿴�Լ���ҵ��
	if(CurUser.hasRole("2D3")||CurUser.hasRole("480")||CurUser.hasRole("0E8")||CurUser.hasRole("080")||CurUser.hasRole("2A5")||CurUser.hasRole("280")||CurUser.hasRole("2J4"))
	{
		sSql += " and InputUserID='"+CurUser.UserID+"'";
	}
	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ,���±���,��ֵ,�ɼ����ɼ�,�Ƿ���Ը���
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GUARANTY_CONTRACT";
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("CustomerID,GuarantorID,GuarantyType,ContractType,InputUserID,InputOrgID,Channel",false);
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
		{"false","","Button","����","����������Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴������Ϣ����","viewAndEdit()",sResourcesPath},
		{"false","","Button","ɾ��","ɾ��������Ϣ","deleteRecord()",sResourcesPath},
		{"true","","Button","�����ͻ�����","�鿴������صĵ����ͻ�����","viewCustomerInfo()",sResourcesPath},
		{"true","","Button","���ҵ������","�鿴���ҵ���ͬ��Ϣ","viewBusinessInfo()",sResourcesPath},
		{"false","","Button","����ҵ���ͬ","����ҵ���ͬ��Ϣ","my_relativecontract()",sResourcesPath},
		{"false","","Button","������Ч","��������ͬ��ʧЧ��Ϊ��Ч","statusChange()",sResourcesPath},
		};
	//�ͻ��������׷��
	if(CurUser.hasRole("2D3")||CurUser.hasRole("480")||CurUser.hasRole("0E8")||CurUser.hasRole("080")||CurUser.hasRole("2A5")||CurUser.hasRole("280")||CurUser.hasRole("2J4"))
	{
		sButtons[getBtnIdxByName(sButtons,"����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"ɾ��")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"����ҵ���ͬ")][0]="true";
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		//ѡ������ĺ�ͬ��Ϣ
		sParaString = "ManageUserID"+","+"<%=CurUser.UserID%>";
		sReturn = setObjectValue("SelectContractOfGuaranty",sParaString,"",0,0,"");
		if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || sReturn == "_CANCEL_") return;
		//��ͬ��ˮ��
		var sReturn = sReturn.split("@");
		sObjectNo = sReturn[0];
		
		sGuarantyType=PopPage("/CreditManage/CreditAssure/AddAssureDialog1.jsp","","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
		if(typeof(sGuarantyType) != "undefined" && sGuarantyType.length != 0 && sGuarantyType != '_none_')
		{
			OpenPage("/CreditManage/CreditAssure/AddAssureInfo1.jsp?GuarantyType="+sGuarantyType+"&ObjectNo="+sObjectNo,"right");
		}
	}


	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--������Ϣ���
		sContractType = getItemValue(0,getRow(),"ContractType");//--������ͬ����
		var sReturnValue = "";
		var sObjectNo = "";
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			if(sContractType=="010")//һ�㵣����ͬ
			{
				sReturn=RunMethod("PublicMethod","GetColValue","SerialNo,Contract_relative,String@ObjectNo@"+sSerialNo+"@String@ObjectType@GuarantyContract");
				sReturnValue=sReturn.split("@")
				if(sReturnValue[1] != ""  || sReturnValue[1] != "null" || sReturnValue[1] != 0) 
				{
					sObjectNo=sReturnValue[1];
				} 
			}else{//��߶����ͬ
				sParaString="UserID,<%=CurUser.UserID%>"+",ObjectNo,"+sSerialNo;
				sReturn = setObjectValue("SelectGuarantyBContract",sParaString,"",0,0,"");
				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn != "_NONE_" && sReturn != "_CLEAR_" && sReturn != "_CANCEL_")
				{
					//��ͬ��ˮ��
					sReturnValue = sReturn.split("@");
					sObjectNo = sReturnValue[0];
				}
				
			}
			if(typeof(sObjectNo)!="undefined" && sObjectNo.length!=0&&confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��)
			{
				sReturn=RunMethod("BusinessManage","DeleteAddGuarantyContract","BusinessContract,"+sObjectNo+","+sSerialNo);
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
	}


	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--������Ϣ���
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			sGuarantyType = getItemValue(0,getRow(),"GuarantyType");//--������ʽ
			OpenPage("/CreditManage/CreditAssure/AddAssureInfo1.jsp?SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType,"right");
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


	/*~[Describe=ѡ��ĳ�ʵ�����ͬ,������ʾ�������µĵ���Ѻ��;InputParam=��;OutPutParam=��;]~*/
	function mySelectRow()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		var sObjectNo="";
		sReturn=RunMethod("PublicMethod","GetColValue","SerialNo,Contract_relative,String@ObjectNo@"+sSerialNo+"@String@ObjectType@GuarantyContract");
		sReturnValue=sReturn.split("@");
		if(sReturnValue[1] != ""  || sReturnValue[1] != "null" || sReturnValue[1] != 0) 
		{
			sObjectNo=sReturnValue[1];
		} 
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
		}else
		{
			sGuarantyType = getItemValue(0,getRow(),"GuarantyType");			
			if (sGuarantyType.substring(0,3) == "010") {
				OpenPage("/Blank.jsp?TextToShow=��֤����������ϸ��Ϣ!","DetailFrame","");
			}else 
			{
				if (sGuarantyType.substring(0,3) == "050") //��Ѻ
					OpenPage("/CreditManage/GuarantyManage/AddAssurePawnList1.jsp?ObjectType=<%=sObjectType%>&ObjectNo="+sObjectNo+"&ContractNo="+sSerialNo,"DetailFrame","");
				else //��Ѻ
					OpenPage("/CreditManage/GuarantyManage/AddAssureImpawnList1.jsp?ObjectType=<%=sObjectType%>&ObjectNo="+sObjectNo+"&ContractNo="+sSerialNo,"DetailFrame","");
			}
		}
	}
	

	/*~[Describe=�鿴������ͬ����ҵ������;InputParam=��;OutPutParam=��;]~*/
	function viewBusinessInfo()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--������ͬ��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenComp("AssureBusinessList","/CreditManage/CreditAssure/AssureBusinessList.jsp","SerialNo="+sSerialNo,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=������߶����ͬ����ҵ��;InputParam=��;OutPutParam=��;]~*/
	function my_relativecontract()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--������ͬ��ˮ����
		sContractType = getItemValue(0,getRow(),"ContractType");//--������ͬ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(sContractType=='010')//���Ϊһ�㵣����ͬ
		{
			alert("��Ϊһ�㵣����ͬ�����ܽ��й���ҵ�����");
			return ;
		}
		//ѡ������ĺ�ͬ��Ϣ
		sParaString = "ManageUserID"+","+"<%=CurUser.UserID%>";
		sReturn = setObjectValue("SelectContractOfGuaranty",sParaString,"",0,0,"");
		if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || sReturn == "_CANCEL_") return;
		//��ͬ��ˮ��
		var sReturn = sReturn.split("@");
		sObjectNo = sReturn[0];
		//alert(sObjectNo);
		sReturn = RunMethod("PublicMethod","GetColValue","SerialNo,CONTRACT_RELATIVE,String@ObjectNo@"+sSerialNo+"@String@ObjectType@GuarantyContract@String@SerialNo@"+sObjectNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{			
			sReturn = sReturn.split('~');
			var my_array = new Array();
			for(i = 0;i < sReturn.length;i++)
			{
				my_array[i] = sReturn[i];
			}
				
			for(j = 0;j < my_array.length;j++)
			{
				sReturnInfo = my_array[j].split('@');				
				if(typeof(sReturnInfo) != "undefined" && sReturnInfo != "")
				{		
					if(sReturnInfo[0] == "serialno")
					{ 
						if(typeof(sReturnInfo[1]) != "undefined" && sReturnInfo[1] != "" )
						{
							alert("��ѡ��ͬ�ѱ��õ�����ͬ����,�����ٴ����룡");//��ѡ��ͬ�ѱ��õ�����ͬ����,�����ٴ����룡
					        return;
					    }
					}				
				}
			}			
		}
		//�����õ�����ͬ����ѡ��ͬ�Ĺ�����ϵ
		sReturn=RunMethod("BusinessManage","ImportGauarantyContract","BusinessContract,"+sObjectNo+","+sSerialNo);
		if(sReturn == "EXIST") alert(getBusinessMessage('415'));//��ҵ���ͬ�Ѿ������ϣ�
		if(sReturn == "SUCCEEDED")
		{
			alert(getBusinessMessage('416'));//����ҵ���ͬ�ɹ���
			reloadSelf();
		}
		
	}
	
	
	/*~[Describe=׷�ӵ�����ͬ;InputParam=��;OutPutParam=��;]~*/
	function statusChange()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getBusinessMessage('418'))) //������뽫������ͬ��ʧЧ��Ϊ��Ч��
		{
			RunMethod("BusinessManage","UpdateGuarantyContractStatus",sSerialNo+",020");
			alert("�ѳɹ����õ�����Ч");
			reloadSelf();
			OpenPage("/Blank.jsp?TextToShow=����ѡ����Ӧ�ĵ�����Ϣ!","DetailFrame","");
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
	OpenPage("/Blank.jsp?TextToShow=����ѡ����Ӧ�ĵ�����Ϣ!","DetailFrame","");
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>