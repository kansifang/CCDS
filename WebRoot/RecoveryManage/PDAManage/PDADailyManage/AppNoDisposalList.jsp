<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*   
		Author:   hxli 2005-8-3
		Tester:
		Content: �����õ��ʲ��б�
		Input Param:
				ObjectType	��������(AssetInfo)		          
		Output param:
				SerialNo   : ��ծ�ʲ����
				AssetType: ��ծ�ʲ����� 
		History Log: zywei 2005/09/07 �ؼ����		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����׼�������ʲ��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
	
	//����������	
	String sObjectType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
							{"SerialNo","�ʲ����"},							
							{"AssetName","�ʲ�����"},
							{"AssetType","�ʲ����"},	
							{"AssetTypeName","�ʲ����"},	
							{"PayType","��ծ��ʽ"},
							{"PayTypeName","��ծ��ʽ"},
							{"AssetSum","��ծ���"},
							{"Currency","��ծ����"},
							{"CurrencyName","��ծ����"},
							{"ManageUserID","������"},
							{"ManageOrgID","�������"}
						}; 
						
	//�ӵ�ծ�ʲ���Ϣ��ASSET_INFO��ѡ��δ������δ�鵵�ĵ�ծ�ʲ�
	sSql =  " select SerialNo,ObjectNo,"+
			" AssetName,"+
			" AssetType,getItemName('PDAType',AssetType) as AssetTypeName,"+
			" PayType, getItemName('PayType',PayType) as PayTypeName," +	
			" Currency, getItemName('Currency',Currency) as CurrencyName," +
			" AssetSum, " +	
			" getUserName(ManageUserID) as ManageUserID, " +	
			" getOrgName(ManageOrgID) as ManageOrgID"+			
			" from ASSET_INFO" +
			" where ManageUserID = '"+CurUser.UserID+
			"' and AssetStatus = '02'  "+
			" and AssetAttribute = '01' "+
			" and PigeonholeDate is null "+
			" and ObjectType = '"+sObjectType+"' "+
			" order by AssetName desc";
			//�ܻ���Ϊ��ǰ�û�
			//��ծ�ʲ�������״��02��������
			//�ʲ����01����ծ�ʲ���02������ʲ�
			//�鵵����Ϊ��
		
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSET_INFO";
	
	//���ùؼ���
	doTemp.setKey("SerialNo",true);	 

	//���ò��ɼ���
	doTemp.setVisible("AssetType,Currency,PayType,ObjectNo",false);

	doTemp.setHTMLStyle("AssetTypeName,CurrencyName,PayTypeName","style={width:60px} ");  
	doTemp.setHTMLStyle("AssetName,AssetSum,ManageOrgID"," style={width:100px} ");
	doTemp.setHTMLStyle("ManageUserID"," style={width:80px} ");
	doTemp.setUpdateable("AssetTypeName,CurrencyName,PayTypeName",false); 
	
	//���ö��뷽ʽ
	doTemp.setAlign("AssetSum,AssetBalance","3");
	doTemp.setType("AssetSum,AssetBalance","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("AssetSum","2");
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("AssetName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ
	
	//ɾ����ծ�ʲ���ɾ��������Ϣ
    dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(AssetInfo,#SerialNo,DeleteBusiness)");

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
			{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"true","","Button","����ת����","����ת����","my_Intable()",sResourcesPath},
			{"true","","Button","����ת����","����ת����","my_Outtable()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=SerialNo;]~*/
	function newRecord()
	{
		var sAssetInfo =PopPage("/RecoveryManage/PDAManage/PDADailyManage/PDATypeDialog.jsp","","resizable=yes;dialogWidth=21;dialogHeight=10;center:yes;status:no;statusbar:no");
		sAssetInfo = sAssetInfo.split("@");
		var sSerialNo=sAssetInfo[1];
		if(typeof(sSerialNo) != "undefined" && sSerialNo.length != 0)
		{			
			popComp("PDABasicView","/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp","ObjectNo="+sSerialNo,"");
			reloadSelf();
		} 		
	}
			
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
		{
			as_del("myiframe0");			
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��õ�ծ�ʲ���ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");					
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
	
	/*~[Describe=����ת������Ϣ;InputParam=��;OutPutParam=SerialNo;]~*/
	function my_Intable()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{			
			//������Ϣ����,��ʾ�û������µ����˼�ֵ��������ծ�ʲ���Ŀ���
			popComp("PDAInOutSwitchDialog","/RecoveryManage/PDAManage/PDADailyManage/PDAInOutSwitchDialog.jsp","SerialNo="+sSerialNo+"~InOut=In","dialogWidth:600px;dialogheight:440px","");
			reloadSelf();
		}
	}

	/*~[Describe=����ת������Ϣ;InputParam=��;OutPutParam=SerialNo;]~*/
	function my_Outtable()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{			
			//������Ϣ����,��ʾ�û������µĵ�ծʱ��������뵱ǰ�������
			popComp("PDAInOutSwitchDialog","/RecoveryManage/PDAManage/PDADailyManage/PDAInOutSwitchDialog.jsp","SerialNo="+sSerialNo+"~InOut=Out","dialogWidth:600px;dialogheight:440px","");
			reloadSelf();
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
