<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   hxli 2005-8-3
		Tester:
		Content: �ѵ���/�����е��ʲ��б�AppDisposingList.jsp
		Input Param:
				ObjectType���������ͣ�AssetInfo��	
				InOut���������־	          
		Output param:
				SerialNo����ծ�ʲ����
		History Log: zywei 2005/09/07 �ؼ����	                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����е��ʲ��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
	
	//����������	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sInOut = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InOut"));
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	if(sInOut == null) sInOut = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
							{"SerialNo","�ʲ����"},							
							{"AssetName","�ʲ�����"},
							{"Flag","����/��"},
							{"FlagName","����/��"},
							{"AssetType","�ʲ����"},	
							{"AssetTypeName","�ʲ����"},	
							{"PayType","��ծ��ʽ"},
							{"PayTypeName","��ծ��ʽ"},
							{"Currency","��ծ����"},
							{"CurrencyName","��ծ����"},
							{"AssetSum","��ծ���"},
							{"InAccontDate","��������"},
							{"EnterValue","���˼�ֵ(Ԫ)"},
							{"AssetBalance","��Ŀ���(Ԫ)"},
							{"OutInitBalance","��ծʱ�������(Ԫ)"},
							{"OutNowBalance","��ǰ�������(Ԫ)"},
							{"ManageUserID","������"},
							{"ManageOrgID","�������"}
						}; 
						
	//�ӵ�ծ�ʲ���Ϣ��ASSET_INFO��ѡ���ѵ���/�����е��ʲ�
	sSql =  " select SerialNo,ObjectNo,"+
			" AssetName,"+
			" AssetType,getItemName('PDAType',AssetType) as AssetTypeName,"+
			" PayType, getItemName('PayType',PayType) as PayTypeName," +	
			" Flag ,"+
			" getItemName('Flag',Flag) as FlagName,"+
			" Currency, getItemName('Currency',Currency) as CurrencyName," +	
			" AssetSum, " +	
			" InAccontDate, "+
			" EnterValue, " +	
			" AssetBalance, " +	
			" OutInitBalance, " +	
			" OutNowBalance, " +	
			" getUserName(ManageUserID) as ManageUserID, " +	
			" getOrgName(ManageOrgID) as ManageOrgID"+			
			" from ASSET_INFO" +
			" where ManageUserID = '"+CurUser.UserID+"' "+
			" and AssetStatus = '03' "+
			" and AssetAttribute = '01' "+
			" and PigeonholeDate is null "+
			" and ObjectType = '"+sObjectType+"' ";
			//�ܻ���Ϊ��ǰ�û�
			//��ծ�ʲ�������״��03���ѵ���
			//AssetAttribute��01����ծ�ʲ���02������ʲ�
			//�鵵����Ϊ��

	if (sInOut.equals("In"))   //��ȡ�����ʲ�
		sSql = sSql + " and Flag='010'  order by AssetName desc ";
	else					   //��ȡ�����ʲ�
		sSql = sSql + " and Flag='020'  order by AssetName desc ";
	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSET_INFO";	
	//���ùؼ���
	doTemp.setKey("SerialNo",true);	 
	//���ò��ɼ���
	doTemp.setVisible("AssetType,Flag,FlagName,PayType,PayTypeName,Currency,ObjectNo",false);
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("FlagName","style={width:50px} ");  
	doTemp.setHTMLStyle("AssetTypeName","style={width:80px} ");  
	doTemp.setHTMLStyle("CurrencyName,InAccontDate","style={width:70px} ");  
	doTemp.setHTMLStyle("AssetName,ManageUserID,ManageOrgID"," style={width:80px} ");
	doTemp.setHTMLStyle("AssetSum,EnterValue,AssetBalance,OutInitBalance,OutNowBalance"," style={width:80px} ");
	doTemp.setHTMLStyle("OutInitBalance,OutNowBalance"," style={width:110px} ");
	doTemp.setUpdateable("AssetTypeName,PayTypeName,CurrencyName",false); 
	//���ö��뷽ʽ
	doTemp.setAlign("AssetSum,EnterValue,AssetBalance,OutInitBalance,OutNowBalance","3");
	doTemp.setType("AssetSum,EnterValue,AssetBalance,OutInitBalance,OutNowBalance","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("AssetSum,EnterValue,AssetBalance,OutInitBalance,OutNowBalance","2");
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("AssetName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style = "1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);  //��������ҳ

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
			{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
			{"true","","Button","�����ս�","�����ս�","PDADisposed()",sResourcesPath},	
			{"true","","Button","ת����","ת����","my_Intable()",sResourcesPath},
			{"true","","Button","ת����","ת����","my_Outtable()",sResourcesPath},
		};

	if (sInOut.equals("In"))  //�����ʲ�ֻ��ת����
		sButtons[2][0]="false";
	else							  //�����ʲ�ֻ��ת����
		sButtons[3][0]="false";
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=ת������Ϣ;InputParam=��;OutPutParam=SerialNo;]~*/
	function my_Intable()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{			
			myFlag = getItemValue(0,getRow(),"Flag");
			if (myFlag == "020")
			{
				//������Ϣ����,��ʾ�û������µ����˼�ֵ��������ծ�ʲ���Ŀ���
				var myReturn=popComp("PDAInOutSwitchDialog","/RecoveryManage/PDAManage/PDADailyManage/PDAInOutSwitchDialog.jsp","SerialNo="+sSerialNo+"&InOut=In","dialogWidth:600px;dialogheight:440px","");
				if (myReturn == "true") reloadSelf();
			}else
			{
				alert("���ʲ��Ѿ�ת�����!");
			}
			reloadSelf();
		}
	}
	
	/*~[Describe=ת������Ϣ;InputParam=��;OutPutParam=SerialNo;]~*/
	function my_Outtable()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			myFlag = getItemValue(0,getRow(),"Flag");
			if (myFlag == "010")
			{
				//������Ϣ����,��ʾ�û������µĵ�ծʱ��������뵱ǰ�������
				var myReturn=popComp("PDAInOutSwitchDialog","/RecoveryManage/PDAManage/PDADailyManage/PDAInOutSwitchDialog.jsp","SerialNo="+sSerialNo+"~InOut=Out","dialogWidth:600px;dialogheight:440px","");
				if (myReturn == "true")	 reloadSelf();
			}else
			{
				alert("���ʲ��Ѿ�ת�����!");
			}
			reloadSelf();
		}
	}
	
	
	//�����ս᣺�Զ�����AssetStatus״̬���ս����ڡ�
	function PDADisposed()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		//type=1 ��ζ�Ŵ�AppDisposingList��ִ�д����սᲢ�һ��ܡ�
		//type=2 ��ζ�Ŵ�PDADisposalEndList�в쿴���ܡ�
		//type=3 ��ζ�Ŵ�PDADisposalBookList�в쿴���ܡ�
        sReturn = popComp("PDADisposalEndInfo","/RecoveryManage/PDAManage/PDADailyManage/PDADisposalEndInfo.jsp","SerialNo="+sSerialNo+"~Type=1","dialogWidth:720px;dialogheight:580px","");
		reloadSelf();
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��õ�ծ�ʲ���ˮ�š���ծ�ʲ�����
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");			
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		popComp("PDABasicView","/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp","ObjectNo="+sSerialNo,"");
		reloadSelf();
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