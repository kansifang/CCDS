<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*	Author: hxli 2005-8-4
*	Tester:
*	Describe: �����ʲ������˱����¼����;
*	Input Param:
*		ObjectNo����ͬ��ˮ���
*	Output Param:     
*		SerialNo	:��ˮ��       
*		OldOrgName	:���ǰ���� 
*		OldUserName	:���ǰ��Ա
*	HistoryLog:
*/
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʲ������˱����¼����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";

	//����������
	//���ҳ�����
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType")); //��������
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo")); //ȡ��ˮ��
	if(sObjectType == null) sObjectType = "BusinessContract";  
	
	//Flag=ShiftType��ʾ�鿴�ƽ����ͱ����ʷ������鿴�ܻ��˱����ʷ
	String sFlag =  DataConvert.toRealString(iPostChange,(String)request.getParameter("Flag")); 
	if(sFlag==null)	sFlag="";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//�ܻ������α���б��ͷ
	String sHeaders[][] = {	
							{"SerialNo","��ˮ��"},
							{"OldUserName","ԭ������"},
							{"OldOrgName","ԭ�������"},
							{"NewUserName","�ֹ�����"},
							{"NewOrgName","�ֹ������"},
							{"ChangeUserName","���������"},
							{"ChangeOrgName","�����������"},
							{"ChangeTime","�������"}
						};
			
	//�ƽ��������α���б��ͷ
	String sHeaders1[][] = {	
							{"SerialNo","��ˮ��"},
							{"OldShiftName","ԭ�ƽ�����"},
							{"NewShiftName","�ƽ�����"},
							{"InputUserName","���������"},
							{"InputOrgName","�����������"},
							{"InputDate","�������"}
					      };
	
	
	if(!sFlag.equals("ShiftType"))
	{
		//�ܻ������α���б�
		sSql = " Select SerialNo, " +
				" getUserName(OldUserID) as OldUserName, " +
				" getOrgName(OldOrgID) as OldOrgName, " +
				" getUserName(NewUserID) as NewUserName, " +
				" getOrgName(NewOrgID) as NewOrgName, " +
				" getUserName(ChangeUserID) as ChangeUserName, " +
				" getOrgName(ChangeOrgID) as ChangeOrgName, " +
				" ChangeTime " +
				" From MANAGE_CHANGE " +
				" Where ObjectNo = '"+sObjectNo+"' "+
				" and ObjectType = '"+sObjectType+"' order by ChangeTime desc";	  
	}else
	{
		//�ƽ��������α���б�
		sSql = " Select SerialNo, " +
				" OldShift,getItemName('ShiftType',OldShift) as OldShiftName, " +
				" NewShift,getItemName('ShiftType',NewShift) as NewShiftName," +
				" getUserName(InputUserID) as InputUserName, " +
				" getOrgName(InputOrgID) as InputOrgName, " +
				" InputDate " +
				" From SHIFTCHANGE_INFO " +
				" Where ContractNo = '"+sObjectNo+"' "+
				" order by InputDate desc,SerialNo desc";		
	}
	
	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	
	if(sFlag.equals("ShiftType"))
		doTemp.setHeader(sHeaders1);
	else
		doTemp.setHeader(sHeaders);

	doTemp.setKey("SerialNo",true);
	if(sFlag.equals("ShiftType"))
		doTemp.UpdateTable = "SHIFTCHANGE_INFO";
	else
		doTemp.UpdateTable = "MANAGE_CHANGE";
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,OldShift,NewShift",false);
	//����ѡ���п�
	doTemp.setHTMLStyle("OldUserName,NewUserName,ChangeDate,ChangeUserName,ChangeTime"," style={width:80px} ");
	doTemp.setHTMLStyle("OldShiftName,NewShiftName,InputUserName,InputDate"," style={width:80px} ");

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
			{"true","","Button","����","�鿴��¼��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
			{"true","","Button","����","����","goBack()",sResourcesPath},
  		  };
	
	if(sFlag.equals("ShiftType"))
	{
		sButtons[0][0] = "false";
	}
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			sOldOrgName = getItemValue(0,getRow(),"OldOrgName");
			sOldUserName = getItemValue(0,getRow(),"OldUserName");
			OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/NPAChangeUserInfo.jsp?OldOrgName="+sOldOrgName+"&OldUserName="+sOldUserName+"&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo+"","right",OpenStyle);
		}
	}
	
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{	if("<%=sObjectType%>" == "BadBizAsset")
		{
			OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/NPAPDAssetList.jsp","_self","");
		}else
		{
			OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/NPADispenseList.jsp","_self","");
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

<%@include file="/IncludeEnd.jsp"%>
