<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong 2010/10/14
		Tester:
		Describe: ���ǽ���б�
		Input Param:
			ObjectType: �׶α��
			ObjectNo��ҵ����ˮ��
		Output Param:
			
		HistoryLog:xlyu
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬ���½��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

    String ssSql = "";//Sql���
    ASResultSet rs = null;//�����
    String sBusinessType="" ;
   
	//���ҳ�����

	//����������
	//String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));//��ͬ��ˮ��
	//ȡ�ú�ͬ��Ϣ
	ssSql =  " select BusinessType from BUSINESS_CONTRACT  where SerialNo ='"+sObjectNo+"' ";
	rs = Sqlca.getASResultSet(ssSql);
	if(rs.next())
	{
		sBusinessType=rs.getString("BusinessType");
	}
	rs.getStatement().close();
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	

    String sHeaders[][] = 	{
								{"CustomerName","�ͻ�����"},
								{"SerialNo","�����ˮ��"},
								{"BillNo","Ʊ�ݺ�"},
								{"RelativeSerialNo1","��س�����ˮ��"},
								{"Currency","����"},
								{"BusinessSum","���"},
								{"OccurDate","��������"},
								{"FinishDate","�ս�����"},
								{"OperateOrgName","�������"},
			      			};


	String sSql =   " select Maturity,"+
					" CustomerID,CustomerName,"+
					" SerialNo,BillNo,"+
					" RelativeSerialNo1,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,OccurDate,FinishDate,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from  BUSINESS_DUEBILL "+
					" where RelativeSerialNo2='"+sObjectNo+"'  ";
					

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//�����޸ı���
	doTemp.UpdateTable = "BUSINESS_DUEBILL";
    //��������
	doTemp.setKey("SerialNo",true);
	//���ò��ɼ���
	doTemp.setVisible("CustomerID,BusinessCurrency,OperateOrgID,Maturity,Balance",false);
	if(sBusinessType.startsWith("2"))
	{
		doTemp.setVisible("RelativeSerialNo1,OccurDate",false);
		sHeaders[1][1]="ҵ����ˮ��";
		doTemp.setHeader(sHeaders);
	}
	if(sBusinessType.startsWith("1"))
	{
		doTemp.setVisible("BillNo,FinishDate",false);
	}
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum","3");
	doTemp.setCheckFormat("BusinessSum","2");
	
	//����html��ʽ
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("Currency,OccurDate"," style={width:80px} ");

	//����datawindow
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
			{"true","","Button","����","����","newAndEdit()",sResourcesPath},
			{"true","","Button","����","�鿴ҵ������","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
			{"false","","Button","�⸶","�⸶","removeRecord()",sResourcesPath},
			{"false","","Button","�����ݵĹ�����ͬ","�����ݵĹ�����ͬ","ChangeContract()",sResourcesPath}
		};
	if(sBusinessType.equals("2010"))//���гжһ�Ʊ
    { 
         sButtons[3][0]="true";  
    }
	if(sBusinessType.startsWith("2"))//���б��ⲹ��ҵ��Ҫɾ����ť
	{
		if(CurUser.hasRole("000"))//����ϵͳ����ά��Ա
		 sButtons[2][0]="true";
		else  sButtons[2][0]="false";
	}
	if(CurUser.hasRole("299"))
	{
		sButtons[0][0]="false";
		sButtons[3][0]="false";
	}
	%>

<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newAndEdit()
	{
		OpenPage("/CreditManage/CreditPutOut/MendDueBillInfo.jsp?","_self","");
	}
	
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
	    sSerialNo   = getItemValue(0,getRow(),"SerialNo");//--��ˮ��
	    sFinishDate = getItemValue(0,getRow(),"FinishDate");
	 	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			OpenPage("/CreditManage/CreditPutOut/MendDueBillInfo.jsp?SerialNo="+sSerialNo+"&FinishDate="+sFinishDate, "_self","");
		}
	}
	
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");//--��ˮ��
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
    		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
    		{
    			as_del('myiframe0');
    			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
    		}
		}
	}
	
	/*~[Describe=�⸶��¼;InputParam=��;OutPutParam=��;]~*/
	function removeRecord()
	{
	   	 sSerialNo   = getItemValue(0,getRow(),"SerialNo");//�����ˮ��
	   	 sMaturity   = getItemValue(0,getRow(),"Maturity"); //��Ʊ������
	   	 
	     if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		 {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		 }else if(confirm("��ȷ���⸶��?�⸶��ý����Ϣ���޷��޸�"))//�������⸶����Ϣ��
			{
			    sFinishDate=PopPage("/Common/ToolsA/SelectDate.jsp","","dialogWidth=20;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		        if(typeof(sFinishDate) != "undefined"  && sFinishDate != "_CANCEL_" && sFinishDate!= "_NONE_" )
		        {
		            if(sFinishDate < sMaturity)
		            {
		              alert("�⸶������ڻ���ڻ�Ʊ�����գ�");
		              return false;
		            }
	              sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@FinishDate@"+sFinishDate+"@Number@Balance@0,BUSINESS_DUEBILL,String@SerialNo@"+sSerialNo);
	              reloadSelf(); 
	          }
			}
		}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	/*~[Describe=�����ݵĹ�����ͬ;InputParam=��;OutPutParam=��;]~*/
	function ChangeContract()
	{
		//�����ˮ�š�ԭ��ͬ��š��ͻ����
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sOldContractNo   = "<%=sObjectNo%>";
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else 
		{
			sParaString = "SerialNo"+","+sOldContractNo+",CustomerID"+","+sCustomerID;	
			sContractNo = setObjectValue("SelectChangeContract",sParaString,"",0,0,"");
			if (!(sContractNo=='_CANCEL_' || typeof(sContractNo)=="undefined" || sContractNo.length==0 || sContractNo=='_CLEAR_' || sContractNo=='_NONE_'))
			{
				if(confirm(getBusinessMessage('487'))) //ȷʵҪ�����ݵĹ�����ͬ��
				{
					sContractNo = sContractNo.split('@');
					sContractSerialNo = sContractNo[0];					
					var sReturn = PopPage("/InfoManage/DataInput/ChangeContractAction.jsp?ContractNo="+sContractSerialNo+"&DueBillNo="+sSerialNo+"&OldContractNo="+sOldContractNo,"","");
					if(sReturn == "true")
					{
						alert("��ͬ��"+sOldContractNo+"���µĽ�ݡ�"+sSerialNo+"���Ѿ��ɹ��������ͬ��"+sContractNo+"����!");
						reloadSelf();
					}
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

<%@	include file="/IncludeEnd.jsp"%>
