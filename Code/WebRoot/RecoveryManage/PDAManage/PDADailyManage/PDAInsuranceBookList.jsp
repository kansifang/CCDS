<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   FSGong 2004.12.12
		Tester:
		Content: ��ծ�ʲ�����̨��AppDisposingList.jsp
		Input Param:
				���в�����Ϊ�����������				
				ObjectType			�������ͣ�ASSET_INFO
				ObjectNo			    �����ţ��ʲ���ˮ��	
		Output param:

		History Log: 	zywei 2005/09/07 �ؼ����	                  
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ�����̨���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
	
	//����������	
	String sObjectType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";

	//��ȡҳ�����	

%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
							{"ObjectType","��������"},
							{"ObjectNo","������"},
							{"SerialNo","���ռ�¼��ˮ��"},							
							{"AssetName","�ʲ�����"},
							{"InsuranceNo","���յ���"},
							{"Insurer","����������"},
							{"InsuranceName","Ͷ��������"},
							{"beneficiary","����������"},
							{"InsuranceSum","���ս��"},
							{"InsuranceCost","Ͷ������"},
							{"UptoDate","���յ�����"}
						}; 
	
	//�ӵ�ծ�ʲ�������Ϣ��ASSET_DISPOSITON��ѡ��������Ϣ��¼
	sSql = 	" select INSURANCE_INFO.ObjectType as ObjectType ,"+
			" INSURANCE_INFO.ObjectNo as ObjectNo,"+
			" INSURANCE_INFO.SerialNo as SerialNo,"+			
			" ASSET_INFO.AssetName as AssetName,"+
			" INSURANCE_INFO.InsuranceNo as InsuranceNo,"+
			" INSURANCE_INFO.Insurer as Insurer,"+
			" INSURANCE_INFO.InsuranceName as InsuranceName,"+
			" INSURANCE_INFO.beneficiary as beneficiary,"+
			" INSURANCE_INFO.InsuranceSum  as InsuranceSum,"+
			" INSURANCE_INFO.InsuranceCost  as InsuranceCost,"+
			" INSURANCE_INFO.UptoDate as UptoDate"+
			" from INSURANCE_INFO,ASSET_INFO" +
			" where INSURANCE_INFO.ObjectType = '"+sObjectType+"' "+
			" and INSURANCE_INFO.ObjectNo = '"+sObjectNo+"' "+
			" and ASSET_INFO.SerialNo = INSURANCE_INFO.ObjectNo"+
			" order by INSURANCE_INFO.InsuranceNo desc";
	
	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "INSURANCE_INFO";
	
	//���ùؼ���
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);	 

	//���ò��ɼ���
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo",false);

	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("ObjectNo,UptoDate","style={width:80px} ");  
	doTemp.setHTMLStyle("InsuranceSum,InsuranceCost,AssetNo","style={width:80px} ");  
	doTemp.setHTMLStyle("Insurer,InsuranceName,beneficiary,AssetName"," style={width:100px} ");
	
	//���ö��뷽ʽ
	doTemp.setAlign("InsuranceSum,InsuranceCost","3");
	doTemp.setType("InsuranceSum,InsuranceCost","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("InsuranceSum,InsuranceCost","2");
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ

	//��������¼�
	
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
				{"true","","Button","����","����","newRecord()",sResourcesPath},
				{"true","","Button","����","����","viewAndEdit()",sResourcesPath},
				{"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath}
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
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAInsuranceBookInfo.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","right");				
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
		//����ʲ�������ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAInsuranceBookInfo.jsp?SerialNo="+sSerialNo+"&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","right");
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
