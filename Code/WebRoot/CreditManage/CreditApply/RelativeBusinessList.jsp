<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: jytian 2004-12-11
		Tester:
		Describe: ���ҵ����Ϣ
		Input Param:
			ObjectType: �׶α��
			ObjectNo��ҵ����ˮ��
			CustomerID:�ͻ����
		Output Param:
			
		HistoryLog:
				����������ɾ�� lpzhang 2009-8-11 
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ҵ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sRTableName = "";
	String sSql = "";
	
	//���ҳ�����

	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sOccurType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OccurType"));
	System.out.println("sObjectType="+sObjectType+"         sObjectNo= "+sObjectNo+"        sCustomerID="+sCustomerID);
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	
	//����sObjectType�Ĳ�ͬ���õ���ͬ�Ĺ���������ģ����
	sSql = " select RelativeTable from OBJECTTYPE_CATALOG where ObjectType = '"+sObjectType+"' ";
	sRTableName = Sqlca.getString(sSql);
	
	//����ͬ
	/*
	String sHeaders[][] = 	{
								{"ObjectNo","��ͬ��ˮ��"},								
								{"CustomerName","�ͻ�����"},
								{"Currency","����"},
								{"BusinessSum","���"},
								{"OccurDate","��������"},
								{"OperateOrgName","�������"},
			      			};
	*/
	//�����
	String sHeaders[][] = 	{
								{"ObjectNo","�����ˮ��"},								
								{"CustomerName","�ͻ�����"},
								{"Currency","����"},
								{"BusinessSum","���"},
								{"OccurDate","��������"},
								{"OperateOrgName","�������"},
			      			};
	//����ͬ
	/*
	sSql =  " select R.SerialNo as SerialNo, "+
			" R.ObjectNo as ObjectNo, "+
			" R.ObjectType as ObjectType, "+
			" B.CustomerID,getCustomerName(B.CustomerID) as CustomerName, "+			
			" B.BusinessCurrency,getItemName('Currency',B.BusinessCurrency) as Currency, "+
			" B.BusinessSum,B.OccurDate, "+
			" B.OperateOrgID,getOrgName(B.OperateOrgID) as OperateOrgName "+
			" from  BUSINESS_CONTRACT B,"+sRTableName+" R "+
			" where B.SerialNo = R.ObjectNo "+
			" and R.SerialNo = '"+sObjectNo+"' "+
			" and R.ObjectType = 'BusinessContract' ";
	*/
	//�����
	sSql =  " select R.SerialNo as SerialNo, "+
			" R.ObjectNo as ObjectNo,RELATIVESERIALNO2, "+
			" R.ObjectType as ObjectType, "+
			" B.CustomerID,getCustomerName(B.CustomerID) as CustomerName, "+			
			" B.BusinessCurrency,getItemName('Currency',B.BusinessCurrency) as Currency, "+
			" B.BusinessSum,B.OccurDate, "+
			" B.OperateOrgID,getOrgName(B.OperateOrgID) as OperateOrgName "+
			" from  BUSINESS_DUEBILL B,"+sRTableName+" R "+
			" where B.SerialNo = R.ObjectNo "+
			" and R.SerialNo = '"+sObjectNo+"' "+
			" and R.ObjectType = 'BusinessDueBill' ";		

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("RELATIVESERIALNO2,CustomerID,BusinessCurrency,OperateOrgID,SerialNo,ObjectNo,ObjectType,OccurDate",false);
	//�������ݱ���������
   	doTemp.UpdateTable =sRTableName;                               
    doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);	
    	
	doTemp.setAlign("BusinessSum","3");
	doTemp.setCheckFormat("BusinessSum","2");

	//����datawindow
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
		{("BusinessContract".equals(sObjectType)||"015".equals(sOccurType))?"false":"true","","Button","���������ͬ","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","�������","�鿴�������","view()",sResourcesPath},
		{"true","","Button","��غ�ͬ����","�鿴��غ�ͬ����","viewTab()",sResourcesPath},
		//{"false","","Button","�������е�ҵ��","����һ�����е�ҵ��","newRecord()",sResourcesPath},
		{("BusinessContract".equals(sObjectType)||"015".equals(sOccurType))?"false":"true","","Button","ɾ��","ɾ������","deleteRecord()",sResourcesPath},
		{("BusinessContract".equals(sObjectType)||"015".equals(sOccurType))?"false":"true","","Button","������������","����һ����¼","newOtherRecord()",sResourcesPath}
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	function viewTab()
	{
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"RELATIVESERIALNO2");
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
	
	function newRecord()
	{		
		var sRelativeSerialNo = "";	
		//���պ�ͬ����	
		//sParaString = "CustomerID"+","+<%=sCustomerID%>+","+"ManageUserID"+","+"<%=CurUser.UserID%>";
		//var sContractInfo = setObjectValue("SelectExtendContract",sParaString,"",0,0,"");
		//if(typeof(sContractInfo) != "undefined" && sContractInfo != "") 
		//{
		//	sContractInfo = sContractInfo.split('@');
		//	sRelativeSerialNo = sContractInfo[0];
		//}
		//���ս�ݹ���	
		sOccurType = "<%=sOccurType%>";
		sParaString = "CustomerID"+","+<%=sCustomerID%>+","+"OperateOrgID"+","+"<%=CurUser.OrgID%>";
		var sDueBillInfo = "";
		if(sOccurType == "020"){//���»���
			sDueBillInfo = setObjectValue("SelectDueBill1",sParaString,"",0,0,"");	
		}else if(sOccurType == "060" || sOccurType == "065"){//���ɽ���||��������
			sDueBillInfo = setObjectValue("SelectDueBill2",sParaString,"",0,0,"");	
		}

		//var sDueBillInfo = setObjectValue("SelectExtendDueBill",sParaString,"",0,0,"");			
		if(typeof(sDueBillInfo) != "undefined" && sDueBillInfo != "") 
		{
			sDueBillInfo = sDueBillInfo.split('@');
			sRelativeSerialNo = sDueBillInfo[0];
		}
		//���ѡ���˺�ͬ/�����Ϣ�����жϸú�ͬ�Ƿ��Ѻ͵�ǰ��ҵ�����˹�����������������ϵ��
		if(typeof(sRelativeSerialNo) != "undefined" && sRelativeSerialNo != "") 
		{
			//���պ�ͬ����	
			//sReturn = RunMethod("PublicMethod","GetColValue","ObjectNo,"+<%=sRTableName%>+",String@SerialNo@"+"<%=sObjectNo%>"+"@String@ObjectType@BusinessContract@String@ObjectNo@"+sRelativeSerialNo);
			//���ս�ݹ���	
			sReturn = RunMethod("PublicMethod","GetColValue","ObjectNo,<%=sRTableName%>,String@SerialNo@"+"<%=sObjectNo%>"+"@String@ObjectType@BusinessDueBill@String@ObjectNo@"+sRelativeSerialNo);
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
						if(sReturnInfo[0] == "objectno")
						{
							if(typeof(sReturnInfo[1]) != "undefined" && sReturnInfo[1] != "" && sReturnInfo[1] == sRelativeSerialNo)
							{
								//alert("��ѡ��ͬ�ѱ���ҵ������,�����ٴ����룡");
								alert("��ѡ����ѱ���ҵ������,�����ٴ����룡");
								return;
							}
						}				
					}
				}			
			}
			//����ҵ������ѡ��ͬ�Ĺ�����ϵ
			//sReturn = RunMethod("BusinessManage","InsertRelative","<%=sObjectNo%>"+",BusinessContract,"+sRelativeSerialNo+","+<%=sRTableName%>);
			//����ҵ������ѡ��ݵĹ�����ϵ
			sReturn = RunMethod("BusinessManage","InsertRelative","<%=sObjectNo%>,BusinessDueBill,"+sRelativeSerialNo+",<%=sRTableName%>");
			if(typeof(sReturn) != "undefined" && sReturn != "")
			{
				//alert("���������ͬ�ɹ���");
				alert("���������ݳɹ���");
			}else
			{
				//alert("���������ͬʧ�ܣ������²�����");
				alert("����������ʧ�ܣ������²�����");
			}
			reloadSelf();
		}
	}

	function newOtherRecord()
	{		
		var sRelativeSerialNo = "";	
		//���ս�ݹ���	
		sRelativeSerialNo = PopPage("/CreditManage/CreditApply/AddOtherBusinessDuebill.jsp","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");

		dReturn = RunMethod("BusinessManage","QueryBusinessDuebill",sRelativeSerialNo);				
		if(dReturn < 1){
			alert("��ݺŲ���ȷ�����������룡");
			return;
		}
		//���ѡ���˺�ͬ/�����Ϣ�����жϸú�ͬ�Ƿ��Ѻ͵�ǰ��ҵ�����˹�����������������ϵ��
		if(typeof(sRelativeSerialNo) != "undefined" && sRelativeSerialNo != "") 
		{
			//���պ�ͬ����	
			//sReturn = RunMethod("PublicMethod","GetColValue","ObjectNo,"+<%=sRTableName%>+",String@SerialNo@"+"<%=sObjectNo%>"+"@String@ObjectType@BusinessContract@String@ObjectNo@"+sRelativeSerialNo);
			//���ս�ݹ���	
			sReturn = RunMethod("PublicMethod","GetColValue","ObjectNo,<%=sRTableName%>,String@SerialNo@"+"<%=sObjectNo%>"+"@String@ObjectType@BusinessDueBill@String@ObjectNo@"+sRelativeSerialNo);
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
						if(sReturnInfo[0] == "objectno")
						{
							if(typeof(sReturnInfo[1]) != "undefined" && sReturnInfo[1] != "" && sReturnInfo[1] == sRelativeSerialNo)
							{
								//alert("��ѡ��ͬ�ѱ���ҵ������,�����ٴ����룡");
								alert("��ѡ����ѱ���ҵ������,�����ٴ����룡");
								return;
							}
						}				
					}
				}			
			}
			//����ҵ������ѡ��ͬ�Ĺ�����ϵ
			//sReturn = RunMethod("BusinessManage","InsertRelative","<%=sObjectNo%>"+",BusinessContract,"+sRelativeSerialNo+","+<%=sRTableName%>);
			//����ҵ������ѡ��ݵĹ�����ϵ
			sReturn = RunMethod("BusinessManage","InsertRelative","<%=sObjectNo%>,BusinessDueBill,"+sRelativeSerialNo+",<%=sRTableName%>");
			if(typeof(sReturn) != "undefined" && sReturn != "")
			{
				//alert("���������ͬ�ɹ���");
				alert("���������ݳɹ���");
			}else
			{
				//alert("���������ͬʧ�ܣ������²�����");
				alert("����������ʧ�ܣ������²�����");
			}
			reloadSelf();
		}
	}
	
	function view()
	{
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}		
		else 
		{
			openObject("BusinessDueBill",sObjectNo,"002");
		}
	}
	
	function deleteRecord()
	{
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
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
