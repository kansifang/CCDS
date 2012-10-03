<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   hxli 2005-8-2
		Tester:   
		Content: �����ʲ����ʽ�����б�
		Input Param:
			 ItemMenuNo���˵���ţ�00510�����ǡ�00520�������	�� 
			 SerialNo����ͬ��ˮ��     
		Output param:
				 
		History Log: zywei 2005/09/03 �ؼ����
		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʲ����ʽ�����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sWhereClause = ""; //Where����
	
	//���ҳ�����

	//����������
	String sItemMenuNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemMenuNo")); 
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo")); 
	if(sItemMenuNo == null) sItemMenuNo = "";
	if(sSerialNo == null) sSerialNo = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//�����ͷ
	String sHeaders[][] = {
				{"SerialNo","��ͬ��ˮ��"},
				{"RelativeSerialNo","�����ˮ��"},
                {"BackType","���շ�ʽ"},
				{"ActualCreditSum","���ս��(Ԫ)"},
				{"OccurDate","��������"},
				{"CustomerName","ծ��������"}
			}; 
	if(sItemMenuNo.equals("00510"))
	{
		sWhereClause = " and (BW.BackType is null or BW.BackType='') order by SerialNo desc,ArtificialNo ";
	}
	
	if(sItemMenuNo.equals("00520"))
	{
		String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
		if(sDBName.startsWith("INFORMIX"))
			sWhereClause = " and (BW.BackType is not null and BW.Backtype <> '') order by SerialNo desc ";
		else if(sDBName.startsWith("ORACLE"))
			sWhereClause = " and (BW.BackType is not null and BW.Backtype <> ' ') order by SerialNo desc ";		
		if(sDBName.startsWith("DB2"))
			sWhereClause = " and (BW.BackType is not null and BW.Backtype <> '') order by SerialNo desc ";
		
	}

 	//�Ӻ�ͬ����ѡ�������ʲ��ܻ�����Ϊ��¼�û��ܻ��Ĳ����ʲ�
 	String sSql = 	" select BW.RelativeContractNo as SerialNo,BC.BusinessType, "+
					" getItemName('ReclaimType',BW.BackType) as BackType,BW.ActualCreditSum, "+
					" BW.SerialNo as BWSerialNo,BW.OccurDate,BC.CustomerName "+
					" from BUSINESS_CONTRACT BC,BUSINESS_WASTEBOOK BW" +
					" Where BW.RelativeContractNo = BC.SerialNo  "+
					" and BW.OccurDirection = '1' "+
					" and BC.SerialNo = '"+sSerialNo+"' "+sWhereClause ;	

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.UpdateTable = "BUSINESS_WASTEBOOK";
	doTemp.setKey("BWSerialNo",true);
	doTemp.setVisible("BusinessType,BWSerialNo",false);

    //���ý��Ϊ������ʽ
    doTemp.setType("ActualCreditSum","Number");
   	doTemp.setCheckFormat("ActualCreditSum","2");
	doTemp.setAlign("ActualCreditSum","3");
	
	//����ѡ���п�
	doTemp.setHTMLStyle("BackType"," style={width:80px} ");
		
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("SerialNo,CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20);  //��������ҳ


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
		{"true","","Button","��ͬ����","�鿴�����ʲ�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","�鿴����","�鿴������ˮ����","my_Detail()",sResourcesPath},
		{"true","","Button","���ǻ��ʽ","���ǻ��ʽ","my_register()",sResourcesPath},
		{"true","","Button","�޸Ļ��ʽ","�޸Ļ��ʽ","my_register()",sResourcesPath}
		
		};
	if(sItemMenuNo.equals("00510"))
	{
		sButtons[3][0] = "false";
	}	
	if(sItemMenuNo.equals("00520"))
	{
		sButtons[2][0] = "false";
	}

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
	/*~[Describe=�鿴������ˮ����;InputParam=��;OutPutParam=��;]~*/
	function my_Detail()
	{ 
		//������ˮ��
		sSerialNo = getItemValue(0,getRow(),"BWSerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)	
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{			
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/NPABadDebtWasteBookInfo.jsp?SerialNo="+sSerialNo+"&Flag=Y", "_self","");
		}
	}	

	/*~[Describe=���ǻ��ʽ;InputParam=��;OutPutParam=��;]~*/
	function my_register()
	{ 
		//��¼��ˮ��
		sSerialNo = getItemValue(0,getRow(),"BWSerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)	
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{       			
			sParaString = "CodeNo"+",ReclaimType";
			sReturn = selectObjectValue("SelectCode",sParaString,"@BackType@0",0,0,"");
			if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn != "_NONE_" && sReturn != "_CLEAR_" && sReturn != "_CANCEL_") 
			{
				sReturn = sReturn.split('@');
				sBackType = sReturn[0];
				sReturnValue = RunMethod("PublicMethod","UpdateColValue","String@BackType@"+sBackType+",BUSINESS_WASTEBOOK,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{
					alert(getBusinessMessage('676')); //���ʽ���ǳɹ���
					reloadSelf();
				}else
				{
					alert(getBusinessMessage('677')); //���ʽ����ʧ�ܣ�
					return;
				}
			}
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

<%@include file="/IncludeEnd.jsp"%>
