<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  hxli 2005.8.11
		Tester:
		Content: ���鷽��������ͬ�б�
		Input Param:
				SerialNo:������				  
		Output param:
				
		History Log: zywei 2005/09/03 �ؼ����
		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������غ�ͬ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
	String sCustomerID = "";
	ASResultSet rs1=null;
	//������������������ˮ��		
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//����ֵת���ɿ��ַ���	
	if(sSerialNo == null) sSerialNo = "";
	//���ҳ�����
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	sSql = "select CustomerID from BUSINESS_APPLY "+
	" where SerialNo in(select SerialNo from APPLY_RELATIVE "+
			" where ObjectType='CapitalReform' and ObjectNo='"+sSerialNo+"')";
	rs1 = Sqlca.getResultSet(sSql);
	if(rs1.next()) 
	{
		sCustomerID = rs1.getString("CustomerID");
	}
	rs1.getStatement().close();
	//�����ͷ�ļ�
	String sHeaders[][] = { 		
    					{"SerialNo","��ͬ��ˮ��"},  
    					{"CustomerName","�ͻ�����"},
						{"BusinessTypeName","ҵ��Ʒ��"},
						{"BusinessCurrencyName","����"},
						{"BusinessSum","���"},
						{"Balance","���"},
						{"RecoveryUserName","�����ʲ�������"},
						{"RecoveryOrgName","�����ʲ��������"}
						}; 
	
	//�����������LAWCASE_RELATIVE�л�ö�Ӧ��ͬ�ŵ������Ϣ
	sSql = 	" select BC.SerialNo,BC.CustomerName,getBusinessName(BC.BusinessType) as BusinessTypeName, "+
			" getItemName('Currency',BC.BusinessCurrency) as BusinessCurrencyName,BC.BusinessSum,BC.Balance, "+
			" AR.ObjectNo,AR.ObjectType as ObjectType,getUserName(BC.RecoveryUserID) as RecoveryUserName, "+
			" GetOrgName(BC.RecoveryOrgID) as RecoveryOrgName,BC.BusinessType "+
			" from BUSINESS_CONTRACT BC,REFORM_RELATIVE AR "+
			" where BC.SerialNo = AR.ObjectNo "+		
			" and AR.SerialNo = '"+sSerialNo+"' "+		
			" and AR.ObjectType= 'BusinessContract' "+
			" order by SerialNo desc ";	
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	
	//���ù��ø�ʽ
	doTemp.setVisible("ObjectType,ObjectNo,BusinessType",false);	

	//���ý��Ϊ������ʽ
	doTemp.setType("BusinessSum","Number");
	doTemp.setCheckFormat("BusinessSum","2");
	
	doTemp.setType("Balance","Number");
	doTemp.setCheckFormat("Balance","2");
	
	//���ý����뷽ʽ
	doTemp.setAlign("BusinessSum,Balance","3");
	doTemp.setAlign("BusinessTypeName,BusinessCurrencyName","2");
	
	//�����п�	
	doTemp.setHTMLStyle("CustomerName,BusinessTypeName,RecoveryOrgName"," style={width:150px} ");		
	doTemp.setHTMLStyle("BusinessCurrencyName,BusinessSum,Balance,RecoveryUserName"," style={width:100px} ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);  //��������ҳ
	
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
				{"true","","Button","���������ͬ","�������鷽���Ĺ�����ͬ��Ϣ","my_relativecontract()",sResourcesPath},
				{"true","","Button","��ͬ����","�鿴��ͬ����","viewAndEdit()",sResourcesPath},
				{"true","","Button","ɾ��","������鷽�����ͬ�Ĺ�����ϵ","deleteRecord()",sResourcesPath},
				{"true","","Button","������������","�����ǽ���������","other_relativecontract()",sResourcesPath}
			};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=ContractInfo;Describe=�鿴��ͬ����;]~*/%>
	<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�������鷽���ĺ�ͬ��Ϣ;InputParam=��;OutPutParam=��;]~*/
	function my_relativecontract()
	{ 				
		var sRelativeContractNo = "";	
		/*//��ȡ���鷽�������ĺ�ͬ��ˮ��	
		var sContractInfo = setObjectValue("SelectRelativeContract","","@RelativeContract@0",0,0,"");
		if(typeof(sContractInfo) != "undefined" && sContractInfo != "" && sContractInfo != "_NONE_" 
		&& sContractInfo != "_CLEAR_" && sContractInfo != "_CANCEL_") 
		{
			sContractInfo = sContractInfo.split('@');
			sRelativeContractNo = sContractInfo[0];
		}
		*/
		var sContractInfo = PopComp("SelectRelativeContract","/RecoveryManage/Public/SelectRelativeContract.jsp","CustomerID=<%=sCustomerID%>","dialogWidth=55;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sContractInfo != "" && sContractInfo != "_CANCEL_" &&  sContractInfo != "_NONE_" && sContractInfo != "_CLEAR_" &&  typeof(sContractInfo) != "undefined")
		{
			sContractInfo = sContractInfo.split("@");
			sRelativeContractNo = sContractInfo[0];
		}
		//���ѡ���˺�ͬ��Ϣ�����жϸú�ͬ�Ƿ��Ѻ͵�ǰ�����鷽�������˹�����������������ϵ��
		if(typeof(sRelativeContractNo) != "undefined" && sRelativeContractNo != "") 
		{
			sReturn = RunMethod("PublicMethod","GetColValue","ObjectNo,REFORM_RELATIVE,String@SerialNo@"+"<%=sSerialNo%>"+"@String@ObjectType@BusinessContract@String@ObjectNo@"+sContractInfo);
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
							if(typeof(sReturnInfo[1]) != "undefined" && sReturnInfo[1] != "" && sReturnInfo[1] == sRelativeContractNo)
							{
								alert(getBusinessMessage("756"));//��ѡ��ͬ�ѱ������鷽������,�����ٴ����룡
								return;
							}
						}				
					}
				}			
			}
			//�������鷽������ѡ��ͬ�Ĺ�����ϵ
			sReturn = RunMethod("BusinessManage","InsertRelative","<%=sSerialNo%>"+",BusinessContract,"+sRelativeContractNo+",REFORM_RELATIVE");
			if(typeof(sReturn) != "undefined" && sReturn != "")
			{
				alert(getBusinessMessage("754"));//���������ͬ�ɹ���
				OpenPage("/RecoveryManage/Public/NPAContractList.jsp","right","");	
			}else
			{
				alert(getBusinessMessage("755"));//���������ͬʧ�ܣ������²�����
				return;
			}
		}	
	}
		
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{		
		//��ȡ��ͬ��ˮ��
		sContractNo = getItemValue(0,getRow(),"SerialNo");  
		if (typeof(sContractNo) == "undefined" || sContractNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
		{
			sReturn = RunMethod("PublicMethod","GetColValue","ObjectNo,APPLY_RELATIVE,String@ObjectType@NPARefromApply@String@ObjectNo@"+"<%=sSerialNo%>");
			if (typeof(sReturn) != "undefined" && sReturn.length != 0)
			{
				alert(getBusinessMessage("757"));  //���ڸ����鷽���Ѿ�������ҵ�����˹�����ϵ�������Ĺ�����ͬ��Ϣ����ɾ����
				return;
			}else
			{
				//ɾ�����鷽������ѡ��ͬ�Ĺ�����ϵ
				sReturn = RunMethod("BusinessManage","DeleteRelative","<%=sSerialNo%>"+",BusinessContract,"+sContractNo+",REFORM_RELATIVE");
				if(typeof(sReturn) != "undefined" && sReturn != "")
				{
					alert(getBusinessMessage("758"));//�����鷽���Ĺ�����ͬɾ���ɹ���
					OpenPage("/RecoveryManage/Public/NPAContractList.jsp","right","");	
				}else
				{
					alert(getBusinessMessage("759"));//�����鷽���Ĺ�����ͬɾ��ʧ�ܣ������²�����
					return;
				}
			}
		}
	}
	
	/*~[Describe=������������;InputParam=��;OutPutParam=��;]~*/
	function other_relativecontract()
	{		
		var sRelativeSerialNo = "";	
		//���պ�ͬ����	
		sRelativeContractNo = PopPage("/RecoveryManage/Public/AddOtherContract.jsp","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");

		dReturn = RunMethod("BusinessManage","QueryBusinessContract",sRelativeContractNo);				
		if(dReturn < 1){
			alert("��ͬ�Ų���ȷ����������룡");
			return;
		}
			//���ѡ���˺�ͬ��Ϣ�����жϸú�ͬ�Ƿ��Ѻ͵�ǰ�����鷽�������˹�����������������ϵ��
		if(typeof(sRelativeContractNo) != "undefined" && sRelativeContractNo != "") 
		{
			sReturn = RunMethod("PublicMethod","GetColValue","ObjectNo,REFORM_RELATIVE,String@SerialNo@"+"<%=sSerialNo%>"+"@String@ObjectType@BusinessContract@String@ObjectNo@"+sRelativeContractNo);
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
							if(typeof(sReturnInfo[1]) != "undefined" && sReturnInfo[1] != "" && sReturnInfo[1] == sRelativeContractNo)
							{
								alert(getBusinessMessage("756"));//��ѡ��ͬ�ѱ������鷽������,�����ٴ����룡
								return;
							}
						}				
					}
				}			
			}
			//�������鷽������ѡ��ͬ�Ĺ�����ϵ
			sReturn = RunMethod("BusinessManage","InsertRelative","<%=sSerialNo%>"+",BusinessContract,"+sRelativeContractNo+",REFORM_RELATIVE");
			if(typeof(sReturn) != "undefined" && sReturn != "")
			{
				alert(getBusinessMessage("754"));//���������ͬ�ɹ���
				OpenPage("/RecoveryManage/Public/NPAContractList.jsp","right","");	
			}else
			{
				alert(getBusinessMessage("755"));//���������ͬʧ�ܣ������²�����
				return;
			}
			reloadSelf();
		}
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
