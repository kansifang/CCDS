<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: jytian 2004-12-21
		Tester:
		Describe:�����ص���Ϣ����
		Input Param:
      		ObjectType:                �������
           		Customer:          �ͻ�
           		BusinessContract:  ��ͬ
		Output Param:

		HistoryLog:slliua 2005-01-15
						FSGong 2005-02-02 Changed something  about PDAAsset.
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ĵ���Ϣ�б�@WindowTitle"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������                     
    	String sSql="";   	
	String sObjectNo="";
	//���ҳ�����
	
	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));

	

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][]= { 
	                         {"ObjectType","��������"},
	                         {"CustomerID","�ͻ����"},	           
							 {"CustomerName","�ͻ�����"},
							 {"CertType","֤������"},
	                         {"CertID","֤������"},
							 {"ArtificialNo","��ͬ���"},
							 {"BusinessTypeName","ҵ��Ʒ��"},
							 {"BusinessCCYName","����"},
							 {"Balance","��ͬ���"},
							 {"ClassifyResult","���շ���"}
						     };  
	
	//�ص㰸��
	String sHeaders1[][] = { 							
				{"ObjectType","��������"},
				{"SerialNo","�ڲ�����"},
				{"LawCaseName","��������"},
				{"LawCaseTypeName","��������"},				
				{"LawsuitStatusName","���е����ϵ�λ"},
				{"CaseBriefName","����"},				
				{"CaseStatusName","��ǰ���Ͻ���"},
				{"CognizanceResultName","������"},
				{"CurrencyName","���ϱ���"},
				{"AimSum","�����ܱ��(Ԫ)"},				
				{"ManageUserName","����������"},
				{"ManageOrgName","�����������"},
				{"InputDate","�Ǽ�����"}				
			}; 
	
	//�ص��ծ�ʲ�		
	String sHeaders2[][] = { 							
				{"SerialNo","�ʲ����"},
				{"AssetNo","�ʲ����"},
				{"AssetName","�ʲ�����"},
				{"Flag","�������/����"},
				{"FlagName","�������/����"},
				{"AssetType","�ʲ����"},	
				{"AssetTypeName","�ʲ����"},	
				{"AssetSum","��ծ���(Ԫ)"},
				{"AssetBalance","�ʲ����(Ԫ)"},
				{"ManageUserID","������"},
				{"ManageOrgID","�������"}
			}; 
			
					              				   		
	if(sObjectType.equals("Customer"))
	{
		sSql = 	" select UD.ObjectType,UD.UserID,UD.ObjectNo,UD.ObjectNo as CustomerID,CI.CustomerName,getItemName('CertType',CI.CertType) as CertType,CI.CertID "+
	       		" from USER_DEFINEINFO UD,CUSTOMER_INFO CI"+
	       		" where UD.UserID ='"+CurUser.UserID+"' and UD.ObjectType='Customer' and CI.CustomerID=UD.ObjectNo";
	}
	else if(sObjectType.equals("BusinessContract"))
	{
		sSql = 	" select UD.ObjectType,UD.UserID,UD.ObjectNo,BC.CustomerID,getCustomerName(BC.CustomerID) as CustomerName, "+
	       		" BC.ArtificialNo,BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName,BC.BusinessCurrency,getItemName('Currency',BC.BusinessCurrency) as BusinessCCYName,"+
	       		" BC.Balance,BC.ClassifyResult"+
	       		" from USER_DEFINEINFO UD,BUSINESS_CONTRACT BC"+
	       		" where UD.UserID ='"+CurUser.UserID+"' and UD.ObjectType='BusinessContract' and BC.SerialNo=UD.ObjectNo"; 
  	}
  	else if(sObjectType.equals("LawCase"))
	{
		sSql = 	"  select  UD.ObjectType,UD.UserID,UD.ObjectNo,LI.SerialNo,LI.LawCaseName,"+
			"  LI.LawCaseType,getItemName('LawCaseType',LI.LawCaseType) as LawCaseTypeName, "+		  
			"  LI.LawsuitStatus,getItemName('LawsuitStatus',LI.LawsuitStatus) as LawsuitStatusName, "+
			"  LI.CaseBrief,getItemName('CaseBrief',LI.CaseBrief) as CaseBriefName," +
			"  LI.CaseStatus,getItemName('CaseStatus',LI.CaseStatus) as CaseStatusName," +
			"  LI.CognizanceResult,getItemName('CognizanceResult',LI.CognizanceResult) as CognizanceResultName," +
			"  LI.Currency,getItemName('Currency',LI.Currency) as CurrencyName," +
			"  LI.AimSum,"+
			"  LI.ManageUserID,getUserName(LI.ManageUserID) as ManageUserName, " +
			"  LI.ManageOrgID,getOrgName(LI.ManageOrgID) as ManageOrgName," +
			"  LI.InputDate"+
			"  from USER_DEFINEINFO UD,LAWCASE_INFO LI " +
			"  where UD.UserID ='"+CurUser.UserID+"' "+
			" and UD.ObjectType='LawCase' "+
			" and LI.SerialNo=UD.ObjectNo order by  LI.InputDate desc,LI.LawCaseName ";	//��ǰ�û�
	}
	else if(sObjectType.equals("PDAAsset"))
	{
		sSql = "  select UD.ObjectType,UD.UserID,UD.ObjectNo,AI.SerialNo,AI.AssetNo,"+
				" AI.AssetName,AI.AssetType,"+
				" getItemName('PDAType',rtrim(ltrim(AI.AssetType))) as AssetTypeName,"+
				" AI.AssetSum, " +	
				" AI.AssetBalance, " +	
				" getUserName(AI.ManageUserID) as ManageUserID, " +	
				" getOrgName(AI.ManageOrgID) as ManageOrgID"+			
	       		" from USER_DEFINEINFO UD,ASSET_INFO AI " +
	       		"  where UD.UserID ='"+CurUser.UserID+"' "+
				" and UD.ObjectType='PDAAsset' "+
				" and AI.SerialNo=UD.ObjectNo order by  AI.InputDate desc,AssetTypeName ";	//��ǰ�û�
	}
    
    	ASDataObject doTemp = new ASDataObject(sSql);
    	
    	if(sObjectType.equals("Customer"))	//�ص�ͻ�
    	 {
		doTemp.setHeader(sHeaders);
	 }
	 else if(sObjectType.equals("BusinessContract"))	//�ص��ͬ
	 {
	 	doTemp.setHeader(sHeaders);
	 }
	 else if(sObjectType.equals("LawCase")) 	//�ص㰸��
    	 {
    	 	doTemp.setHeader(sHeaders1);
    	 }
    	 else if(sObjectType.equals("PDAAsset")) 	//�ص㰸��
    	 {
    	 	doTemp.setHeader(sHeaders2);
    	 }
    	 
    	 //���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("AssetSum,AimSum,AssetBalance,Balance","2");
	
	//���ý��Ϊ��λһ������
	doTemp.setType("AssetSum,AimSum,AssetBalance,Balance","Number");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("AssetSum,AimSum,AssetBalance,Balance","3");
	
	doTemp.UpdateTable = "USER_DEFINEINFO";
	doTemp.setKey("ObjectType,UserID,ObjectNo",true);
	
	doTemp.setVisible("UserID,ObjectType,ObjectNo,BusinessType,BusinessCurrency,ClassifyResult",false);
	doTemp.setVisible("SerialNo,LawCaseType,LawsuitStatus,CaseBrief,CaseStatus,CognizanceResult,Currency",false);
	doTemp.setVisible("ManageUserID,ManageOrgID,AssetType",false);
	
	doTemp.setHTMLStyle("ArtificialNo,","style={width:150px} ");
	doTemp.setHTMLStyle("CustomerID,","style={width:100px} ");
	doTemp.setHTMLStyle("CustomerName,","style={width:120px} ");
	doTemp.setHTMLStyle("CertType,","style={width:90px} ");
    	doTemp.setUpdateable("BusinessCCYName,BusinessTypeName",false);
	doTemp.setHTMLStyle("BusinessCCYName,BusinessTypeName,ClassifyResult","style={width:80px} ");
	
	//���ð����п�
	doTemp.setHTMLStyle("LawCaseName"," style={width:120px} ");
	doTemp.setHTMLStyle("LawCaseTypeName"," style={width:100px} ");
	
	doTemp.setHTMLStyle("LawsuitStatusName"," style={width:100px} ");
	doTemp.setHTMLStyle("CaseBriefName"," style={width:80px} ");
	doTemp.setHTMLStyle("CaseStatusName"," style={width:80px} ");
	doTemp.setHTMLStyle("CognizanceResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("CurrencyName"," style={width:80px} ");
	doTemp.setHTMLStyle("AimSum"," style={width:100px} ");
	doTemp.setHTMLStyle("ManageUserName"," style={width:80px} ");
	doTemp.setHTMLStyle("ManageOrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("InputDate"," style={width:80px} ");
	
	//���õ�ծ�ʲ��п�
	doTemp.setHTMLStyle("SerialNo","style={width:100px} ");  
	doTemp.setHTMLStyle("AssetTypeName,FlagName","style={width:85px} ");  
	doTemp.setHTMLStyle("AssetName,ManageUserID,ManageOrgID,AssetSum,AssetBalance,AssetNo"," style={width:100px} ");
	doTemp.setUpdateable("AssetTypeName",false); 
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��


	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
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
		{"true","","Button","����","�鿴��ϸ��Ϣ","view()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��һ���û��Զ�������","deleteRecord()",sResourcesPath}
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		
		if(confirm(getHtmlMessage('2'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴����;InputParam=��;OutPutParam=��;]~*/
	function view()
	{
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
		    	alert(getHtmlMessage('1'));
			return;
		}
		else
		{
		    	sObjectType=getItemValue(0,getRow(),"ObjectType");
		    	
		    	//�ص�ͻ�
		    	if(sObjectType=="Customer")
		    	{
		       		openObject("Customer",sObjectNo,"001");
            		}                   
            		
            		//�ص��ͬ
            		if(sObjectType=="BusinessContract")
            		{
               			
		               	//���ҵ��Ʒ��
				var sBusinessType=getItemValue(0,getRow(),"BusinessType"); 
					
				if(sBusinessType=="8010" || sBusinessType=="8020" || sBusinessType=="8030")
				{
					OpenComp("DataInputDetailInfo","/InfoManage/DataInput/DataInputDetailInfo.jsp","ComponentName=�б�&ComponentType=MainWindow&SerialNo="+sObjectNo+"&Flag=Y&CurItemDescribe3="+sBusinessType+"","_blank",OpenStyle);
				}
				else
				{
				  	openObject("BusinessContract",sObjectNo,"002");
				}
				
            		} 
            		
            		//�ص㰸��
            		if(sObjectType=="LawCase")
		    	{
	       			//��ð�����ˮ�š���������
				var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
				var sLawCaseType=getItemValue(0,getRow(),"LawCaseType");
				
				if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
				{
					alert(getHtmlMessage(1));  //��ѡ��һ����¼��
					return;
				}
				openObject("LawCase",sSerialNo,"002");
				
            		}  
            		
			//�ص��ծ�ʲ�
			if(sObjectType=="PDAAsset")
		    	{
		       		//��õ�ծ�ʲ���ˮ�š���ծ�ʲ�����
				sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		
				if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
				{
					alert(getHtmlMessage(1));  //��ѡ��һ����¼��
					return;
				}
				OpenComp("PDABasicView",
								"/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp","ObjectNo="+sSerialNo,"_blank",OpenStyle);
				reloadSelf();
		     		
            		}  
            		                    
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
