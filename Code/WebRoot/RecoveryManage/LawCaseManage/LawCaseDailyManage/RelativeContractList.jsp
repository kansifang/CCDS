<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   slliu 2004.11.22
		Tester:
		Content: ������غ�ͬ�б�
		Input Param:
				SerialNo:�������				  
		Output param:
				
		History Log: zywei 2005/09/06 �ؼ����
		                  
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
	
	//������������������ˮ�ţ�		
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 		
	    					{"SerialNo1","�������"}, 
	    					{"SerialNo","��ͬ��ˮ��"},  	    					
	    					{"CustomerName","�ͻ�����"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"BusinessCurrencyName","����"},
							{"BusinessSum","���"},
							{"BlanceSum","���"},
							{"RecoveryUserName","�����ʲ�������"},
							{"RecoveryOrgName","�����ʲ��������"}
						}; 
	
	//�Ӱ���������LAWCASE_RELATIVE�л�ö�Ӧ��ͬ�ŵ������Ϣ
	sSql = " select LR.SerialNo as SerialNo1,BC.SerialNo as SerialNo,BC.CustomerName as CustomerName, "+
		   " BC.BusinessType as BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName, "+
           " BC.BusinessCurrency,getItemName('Currency',BC.BusinessCurrency) as BusinessCurrencyName, "+
		   " BC.BusinessSum as BusinessSum,BC.Balance as BlanceSum, "+
		   " LR.ObjectNo,LR.ObjectType as ObjectType,BC.RecoveryOrgID, "+
		   " getUserName(BC.RecoveryUserID) as RecoveryUserName, "+
		   " GetOrgName(BC.RecoveryOrgID) as RecoveryOrgName ,BC.RecoveryUserID "+
		   " from BUSINESS_CONTRACT BC,LAWCASE_RELATIVE LR "+
		   " where BC.SerialNo = LR.ObjectNo "+		
		   " and LR.SerialNo = '"+sSerialNo+"' "+
		   " and LR.ObjectType= 'BusinessContract' "+
		   " order by LR.SerialNo desc ";	//��������
	
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);	
	//���ù��ø�ʽ
	doTemp.setVisible("ObjectType,ObjectNo,BusinessType,SerialNo1,SerialNo,BusinessType,BusinessCurrency,RecoveryOrgID,RecoveryUserID",false);	

	//���ý��Ϊ������ʽ
	doTemp.setType("BusinessSum","Number");
	doTemp.setCheckFormat("BusinessSum","2");	
	doTemp.setType("BlanceSum","Number");
	doTemp.setCheckFormat("BlanceSum","2");	
	//���ý����뷽ʽ
	doTemp.setAlign("BusinessSum,BlanceSum","3");
	doTemp.setAlign("BusinessTypeName,BusinessCurrencyName","2");
	
	//����html��ʽ
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName,RecoveryUserName"," style={width:80px} ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);  //��������ҳ

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
			{"true","","Button","���������ͬ","���������ͬ��Ϣ","my_relativecontract()",sResourcesPath},
			{"true","","Button","��ͬ����","�鿴��ͬ����","viewAndEdit()",sResourcesPath},
			{"true","","Button","ȡ��������ͬ","����������ͬ�Ĺ�����ϵ","deleteRecord()",sResourcesPath}
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
		
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sContractNo = getItemValue(0,getRow(),"SerialNo");  //��ͬ��ˮ�Ż������
		if (typeof(sContractNo) == "undefined" || sContractNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
		{
			//ɾ����������ѡ��ͬ�Ĺ�����ϵ
			sReturn = RunMethod("BusinessManage","DeleteRelative","<%=sSerialNo%>"+",BusinessContract,"+sContractNo+",LAWCASE_RELATIVE");
			if(typeof(sReturn) != "undefined" && sReturn != "")
			{
				alert(getBusinessMessage("751"));//�ð����Ĺ�����ͬɾ���ɹ���
				OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/RelativeContractList.jsp","right","");	
			}else
			{
				alert(getBusinessMessage("752"));//�ð����Ĺ�����ͬɾ��ʧ�ܣ������²�����
				return;
			}			
		}
	}	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	function my_relativecontract()
	{ 
		var sRelativeContractNo = "";	
		//��ȡ���������ĺ�ͬ��ˮ��	
		var sContractInfo = setObjectValue("SelectRelativeContract","","@RelativeContract@0",0,0,"");
		if(typeof(sContractInfo) != "undefined" && sContractInfo != "" && sContractInfo != "_NONE_" 
		&& sContractInfo != "_CLEAR_" && sContractInfo != "_CANCEL_") 
		{
			sContractInfo = sContractInfo.split('@');
			sRelativeContractNo = sContractInfo[0];
		}
		//���ѡ���˺�ͬ��Ϣ�����жϸú�ͬ�Ƿ��Ѻ͵�ǰ�İ��������˹�����������������ϵ��
		if(typeof(sRelativeContractNo) != "undefined" && sRelativeContractNo != "") 
		{
			sReturn = RunMethod("PublicMethod","GetColValue","ObjectNo,LAWCASE_RELATIVE,String@SerialNo@"+"<%=sSerialNo%>"+"@String@ObjectType@BusinessContract@String@ObjectNo@"+sContractInfo);
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
								alert(getBusinessMessage("753"));//��ѡ��ͬ�ѱ��ð�������,�����ٴ����룡
								return;
							}
						}				
					}
				}			
			}
			//������������ѡ��ͬ�Ĺ�����ϵ
			sReturn = RunMethod("BusinessManage","InsertRelative","<%=sSerialNo%>"+",BusinessContract,"+sRelativeContractNo+",LAWCASE_RELATIVE");
			if(typeof(sReturn) != "undefined" && sReturn != "")
			{
				alert(getBusinessMessage("754"));//���������ͬ�ɹ���
				OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/RelativeContractList.jsp","right","");	
			}else
			{
				alert(getBusinessMessage("755"));//���������ͬʧ�ܣ������²�����
				return;
			}
		}	
	}
		
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
