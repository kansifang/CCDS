<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> 

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: jytian 2004/12/7
		Tester:
		Content: ��������
		Input Param:
		Output param:
		History Log:  fXie 2005-03-13   ����У���ϵ���˺Ų�ѯ
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	
	//�������������������ͺͶ�����
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//���������SQL��䡢����ҵ��Ʒ�֡�������ʾģ�桢���������ݴ��־
	String sSql = "",sBusinessType = "",sDisplayTemplet = "",sMainTable = "",sTempSaveFlag="";
	//����������������͡���ͬ��ʼ�ա���ͬ�����ա���ͬҵ��Ʒ�֡���ͬ���ʵ�����ʽ
	String sBCOccurType = "",sBCPutOutDate = "",sBCMaturity = "",sBCBusinessType = "",sBCAdjustRateType = "";
	//�����������ͬ���
	double dBCBusinessSum = 0.0;	
	//�����������ѯ�����
	ASResultSet rs = null;
	

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%
	//���ݶ������ʹӶ������Ͷ�����в�ѯ����Ӧ�����������
	sSql = 	" select ObjectTable from OBJECTTYPE_CATALOG "+
			" where ObjectType = '"+sObjectType+"' ";
	sMainTable = Sqlca.getString(sSql);	
	
	//��ȡ����ҵ��Ʒ��
	sSql = 	" select BusinessType from "+sMainTable+" "+
			" where SerialNo ='"+sObjectNo+"' ";
	sBusinessType = Sqlca.getString(sSql);	
	//���ҵ��Ʒ��Ϊ��,����ʾ���������ʽ����
	if (sBusinessType.equals(""	)) sBusinessType = "1010010";
	
	//��ȡ�ó�����Ϣ�ķ�������
	sSql = 	" select BC.OccurType,BC.PutOutDate,BC.Maturity,BC.BusinessType,BC.BusinessSum,BC.AdjustRateType "+
			" from BUSINESS_CONTRACT BC "+
			" where exists (select BP.ContractSerialNo from BUSINESS_PUTOUT BP "+
			" where BP.SerialNo = '"+sObjectNo+"' "+
			" and BP.ContractSerialNo = BC.SerialNo) ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sBCOccurType = rs.getString("OccurType");
		sBCPutOutDate = rs.getString("PutOutDate");
		sBCMaturity = rs.getString("Maturity");
		sBCBusinessType = rs.getString("BusinessType");
		dBCBusinessSum = rs.getDouble("BusinessSum");
		sBCAdjustRateType = rs.getString("AdjustRateType");
		//����ֵת��Ϊ���ַ���
		if(sBCOccurType == null) sBCOccurType = "";
		if(sBCPutOutDate == null) sBCPutOutDate = "";
		if(sBCMaturity == null) sBCMaturity = "";
		if(sBCBusinessType == null) sBCBusinessType = "";
		if(sBCAdjustRateType == null) sBCAdjustRateType = "";
	}
	rs.getStatement().close();
	
	if(sBCOccurType.equals("015")) //չ��
		sDisplayTemplet = "PutOutInfo0";
	else
	{
		//���ݲ�Ʒ���ʹӲ�Ʒ��Ϣ��BUSINESS_TYPE�л����ʾģ������
		sSql = " select DisplayTemplet from BUSINESS_TYPE where TypeNo = '"+sBusinessType+"' ";
		sDisplayTemplet = Sqlca.getString(sSql);
		if(sDisplayTemplet==null)sDisplayTemplet="";
	}
	
	//�ӳ��˱����ݴ��־
	sSql = "select TempSaveFlag from " + sMainTable + " where SerialNo='" + sObjectNo + "'";
	sTempSaveFlag = Sqlca.getString(sSql);
	if(sTempSaveFlag == null) sTempSaveFlag = "";
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sDisplayTemplet,Sqlca);
	//���ø��±���������
	doTemp.UpdateTable = sMainTable;
	doTemp.setKey("SerialNo",true);
	
	//��ҵ��Ʒ��Ϊ���гжһ�Ʊ���֡���ҵ�жһ�Ʊ���֡�Э�鸶ϢƱ�����֣������޸�Ʊ����
	if(sBusinessType.equals("1020010") || sBusinessType.equals("1020020") || sBusinessType.equals("1020030"))
	{
		doTemp.setReadOnly("BusinessSum",true);
	}
	
	//��ҵ��Ʒ��Ϊ����ҵ��ʱ������ʾ֧����ʽ add by bqliu 2011-05-19
	if(sBusinessType.startsWith("2"))
	{
		doTemp.setRequired("SelfPayMethod",false);
		doTemp.setVisible("SelfPayMethod",false);
	}
	
	//���ø�ʽ,����С����4λ
	doTemp.setCheckFormat("RateFloat,BackRate,RiskRate","14");
	//�������ʸ�ʽ,����С����6λ
	doTemp.setCheckFormat("BaseRate,BusinessRate,OverdueRate,TARate","16");
	
	//���ù̶��������뷶Χ
	if(sDisplayTemplet.equals("PutOutInfo1") || sDisplayTemplet.equals("PutOutInfo2") || sDisplayTemplet.equals("PutOutInfo3") || sDisplayTemplet.equals("PutOutInfo8")){
		doTemp.appendHTMLStyle("FixCyc"," myvalid=\"parseFloat(myobj.value,10)>=2 && parseFloat(myobj.value,10)<=12 \" mymsg=\"�̶��������뷶ΧΪ[2,12]\" ");
	}
	if(sDisplayTemplet.equals("PutOutInfo9")){
		doTemp.appendHTMLStyle("CDate"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=31 \" mymsg=\"�ۿ������뷶ΧΪ[0,31]\" ");
	}
	if(sDisplayTemplet.equals("PutOutInfo11")||sDisplayTemplet.equals("PutOutInfo12"))
	{
		doTemp.appendHTMLStyle("FZANBalance"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"�������ʱ�����ڵ���0,С�ڵ���1000��\" ");
	}
	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����������ڵ���0,С�ڵ���100��\" ");
	
	if("2050010".equals(sBusinessType) || "2050020".equals(sBusinessType) || "2050030".equals(sBusinessType) || "2050040".equals(sBusinessType)){
		doTemp.setRequired("BusinessRate,ICCyc,CorpusPayMethod",false);
		doTemp.setVisible("BusinessRate,ICCyc,CorpusPayMethod",false);
	}
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);

	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},		
			{"true","","Button","�ݴ�","��ʱ���������޸�����","saveRecordTemp()",sResourcesPath}
		};
	//���ݴ��־Ϊ�񣬼��ѱ��棬�ݴ水ťӦ����
	if(sTempSaveFlag.equals("2"))
		sButtons[1][0] = "false";
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		if(vI_all("myiframe0")){
			if("2110020" != "<%=sBusinessType%>" )
			{
			//¼��������Ч�Լ��
			if (!ValidityCheck()) return;
			}
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			sOccurType = "<%=sBCOccurType%>";
			sBCAdjustRateType = "<%=sBCAdjustRateType%>";//���ʵ�����ʽ
			if(sOccurType != "015" && sBCAdjustRateType != "1")
			{
				getNewBaseRate();
			}
			if("PutOutInfo5" == "<%=sDisplayTemplet%>" || "PutOutInfo14" == "<%=sDisplayTemplet%>" || "PutOutInfo15" == "<%=sDisplayTemplet%>" )
			{
			    setBailRatio();//���ݳ���ģ��ʹ�� ���㱣֤�����
			}
			setItemValue(0,getRow(),"TempSaveFlag","2"); //�ݴ��־��1���ǣ�2����			
			as_save("myiframe0");
		}
	}
	
	/*~[Describe=�ݴ�;InputParam=��;OutPutParam=��;]~*/
	function saveRecordTemp()
	{
		//0����ʾ��һ��dw
		setNoCheckRequired(0);  //���������б���������
		setItemValue(0,getRow(),'TempSaveFlag',"1");//�ݴ��־��1���ǣ�2����
		as_save("myiframe0");   //���ݴ�
		setNeedCheckRequired(0);//����ٽ����������û���		
	}		
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{
		//��������
		sOccurType = "<%=sBCOccurType%>";
		//������ʼ��
		sPutOutDate = getItemValue(0,getRow(),"PutOutDate");
		//���ʵ�����
		sMaturity = getItemValue(0,getRow(),"Maturity");	
		//ҵ��Ʒ��
		sBusinessType = getItemValue(0,getRow(),"BusinessType");	
		//��Ϣ��ʽ
		sICCyc = getItemValue(0,getRow(),"ICCyc");	
		//�ͻ����
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sSmallEntFlag = RunMethod("BusinessManage","GetSmallEntFlag","CustomerID,"+sCustomerID);
		if(typeof(sSmallEntFlag) != "undefined" && sSmallEntFlag != "" && sSmallEntFlag != null && "NULL" != sSmallEntFlag){
			if(sSmallEntFlag == "1" &&(sICCyc !="102" || sICCyc !="103")){
				alert("΢С��ҵ�����Ϣ���ڱ���Ϊ���½�Ϣ�򰴼���Ϣ��");
				return;
			}
		}

		if(typeof(sPutOutDate) != "undefined" && sPutOutDate != ""
		&& typeof(sMaturity) != "undefined" && sMaturity != "")
		{
			
			if(sMaturity < sPutOutDate)
			{
				if(sOccurType == "015") //չ��ҵ��
				{
					alert(getBusinessMessage('578'));//չ�ڵ����ձ�������չ����ʼ�գ�
					return false;
				}else
				{
					if(sBusinessType == '2030010' || sBusinessType == '2030020'
					|| sBusinessType == '2030030' || sBusinessType == '2030040'
					|| sBusinessType == '2030050' || sBusinessType == '2030060'
					|| sBusinessType == '2030070' || sBusinessType == '2040010'
					|| sBusinessType == '2040020' || sBusinessType == '2040030'
					|| sBusinessType == '2040040' || sBusinessType == '2040050'
					|| sBusinessType == '2040060' || sBusinessType == '2040070'
					|| sBusinessType == '2040080' || sBusinessType == '2040090'
					|| sBusinessType == '2040100' || sBusinessType == '2040110'				
					|| sBusinessType == '1110140' || sBusinessType == '1110170'
					|| sBusinessType == '3030020' || sBusinessType == '1110160'
					|| sBusinessType == '1110150' || sBusinessType == '1110130'
					|| sBusinessType == '1110027' || sBusinessType == '1110120'
					|| sBusinessType == '2100' || sBusinessType == '2090020'
					|| sBusinessType == '1110110' || sBusinessType == '2090010'
					|| sBusinessType == '1110100' || sBusinessType == '1110090'
					|| sBusinessType == '2080010' || sBusinessType == '1110080'
					|| sBusinessType == '2110050' || sBusinessType == '2060040'				
					|| sBusinessType == '2110040' || sBusinessType == '1110050'
					|| sBusinessType == '2060010' || sBusinessType == '1110040'
					|| sBusinessType == '2050040' || sBusinessType == '2050030'
					|| sBusinessType == '1110030' || sBusinessType == '2050020'
					|| sBusinessType == '2050010' || sBusinessType == '1110020'
					|| sBusinessType == '1110010' || sBusinessType == '2060020'
					|| sBusinessType == '2060030' || sBusinessType == '1100010'
					|| sBusinessType == '2060050' || sBusinessType == '2060060'
					|| sBusinessType == '1110070' || sBusinessType == '1090030'				
					|| sBusinessType == '2080020' || sBusinessType == '2080030'
					|| sBusinessType == '1090020' || sBusinessType == '1090010') 
					//������������𳥻�������͸֧�黹��������˰��������������ó�ױ�����
					//����������������Ա�����Ͷ�걣������Լ������Ԥ��������а����̱���
					//����ά�ޱ��������±���������ó�ױ��������ϱ��������ý𱣺���
					//�ӹ�װ��ҵ����ڱ����������������Ա�������ҵ��ѧ������˾�Ӫ���
					//����ס��װ�޴��������ѧ����������������������ס����������
					//����Ӫ������������뷵��ҵ���м�֤ȯ���е��������˵�Ѻ����������
					//���˱�֤���������Ѻ��������ŵ�������˾�Ӫѭ����� ���˸������
					//ת�����Ŵ�������С�����ô������ί�д������������Ѻ���
					//ת�����������������ٽ�����ҵ�÷�������Ᵽ������������֤��
					//������ҵ�÷��������������֤�����������ת�����ʽ�����֯���
					//������㴢��ת��������ٽ���ס���������ծȯת�������ת���
					//���˵�Ѻѭ���������ס������ƽ�����ҵ�񡢴��������顢�����Ŵ�֤����
					//���ڱ������ڱ������ڱ���
					{
						alert(getBusinessMessage('584'));//ʧЧ���ڱ���������Ч���ڣ�
						return false;
					}else if(sBusinessType == '1020010' || sBusinessType == '1020020'
					|| sBusinessType == '1020030' || sBusinessType == '1020040')
					//���гжһ�Ʊ���֡���ҵ�жһ�Ʊ���֡�Э�鸶ϢƱ�����֡���ҵ�жһ�Ʊ����
					{
						alert(getBusinessMessage('589'));//�����ձ���������Ϣ�գ�
						return false;
					}else if(sBusinessType == '2020')//��������֤
					{
						alert(getBusinessMessage('590'));//����֤��Ч�ڱ�������ҵ�����ڣ�
						return false;
					}else if(sBusinessType == '2010')//���гжһ�Ʊ
					{
						alert(getBusinessMessage('582'));//���ڸ����ձ�������ǩ���գ�
						return false;
					}else
					{
						alert(getBusinessMessage('588'));//�����ձ�����������գ�
						return false;
					}
					
				}
			}
			
			//��ͬҵ��Ʒ��
			sBCBusinessType = "<%=sBCBusinessType%>";
			//��ͬ��ʼ��
			sBCPutOutDate = "<%=sBCPutOutDate%>";
			//��ͬ������
			sBCMaturity = "<%=sBCMaturity%>";	
			//У�������ʼ���Ƿ����ں�ͬ��ʼ��			
			if(typeof(sPutOutDate) != "undefined" && sPutOutDate != ""
			&& typeof(sBCPutOutDate) != "undefined" && sBCPutOutDate != "")
			{
				if(sPutOutDate < sBCPutOutDate)
				{
					if(sOccurType == "015") //չ��ҵ��
					{
						alert(getBusinessMessage('592'));//���ʵ�չ����ʼ�ձ������ڻ���ں�ͬ��չ����ʼ�գ�
						return false;
					}else
					{
						if(sBusinessType == '2030010' || sBusinessType == '2030020'
						|| sBusinessType == '2030030' || sBusinessType == '2030040'
						|| sBusinessType == '2030050' || sBusinessType == '2030060'
						|| sBusinessType == '2030070' || sBusinessType == '2040010'
						|| sBusinessType == '2040020' || sBusinessType == '2040030'
						|| sBusinessType == '2040040' || sBusinessType == '2040050'
						|| sBusinessType == '2040060' || sBusinessType == '2040070'
						|| sBusinessType == '2040080' || sBusinessType == '2040090'
						|| sBusinessType == '2040100' || sBusinessType == '2040110'				
						|| sBusinessType == '1110140' || sBusinessType == '1110170'
						|| sBusinessType == '3030020' || sBusinessType == '1110160'
						|| sBusinessType == '1110150' || sBusinessType == '1110130'
						|| sBusinessType == '1110027' || sBusinessType == '1110120'
						|| sBusinessType == '2100' || sBusinessType == '2090020'
						|| sBusinessType == '1110110' || sBusinessType == '2090010'
						|| sBusinessType == '1110100' || sBusinessType == '1110090'
						|| sBusinessType == '2080010' || sBusinessType == '1110080'
						|| sBusinessType == '2110050' || sBusinessType == '2060040'				
						|| sBusinessType == '2110040' || sBusinessType == '1110050'
						|| sBusinessType == '2060010' || sBusinessType == '1110040'
						|| sBusinessType == '2050040' || sBusinessType == '2050030'
						|| sBusinessType == '1110030' || sBusinessType == '2050020'
						|| sBusinessType == '2050010' || sBusinessType == '1110020'
						|| sBusinessType == '1110010' || sBusinessType == '2060020'
						|| sBusinessType == '2060030' || sBusinessType == '1100010'
						|| sBusinessType == '2060050' || sBusinessType == '2060060'
						|| sBusinessType == '1110070' || sBusinessType == '1090030'				
						|| sBusinessType == '2080020' || sBusinessType == '2080030'
						|| sBusinessType == '1090020' || sBusinessType == '1090010') 
						//������������𳥻�������͸֧�黹��������˰��������������ó�ױ�����
						//����������������Ա�����Ͷ�걣������Լ������Ԥ��������а����̱���
						//����ά�ޱ��������±���������ó�ױ��������ϱ��������ý𱣺���
						//�ӹ�װ��ҵ����ڱ����������������Ա�������ҵ��ѧ������˾�Ӫ���
						//����ס��װ�޴��������ѧ����������������������ס����������
						//����Ӫ������������뷵��ҵ���м�֤ȯ���е��������˵�Ѻ����������
						//���˱�֤���������Ѻ��������ŵ�������˾�Ӫѭ����� ���˸������
						//ת�����Ŵ�������С�����ô������ί�д������������Ѻ���
						//ת�����������������ٽ�����ҵ�÷�������Ᵽ������������֤��
						//������ҵ�÷��������������֤�����������ת�����ʽ�����֯���
						//������㴢��ת��������ٽ���ס���������ծȯת�������ת���
						//���˵�Ѻѭ���������ס������ƽ�����ҵ�񡢴��������顢�����Ŵ�֤����
						//���ڱ������ڱ������ڱ���
						{
							if(sBCBusinessType == '2050030') //��������֤
							{
								alert(getBusinessMessage('594'));//���ʵ���Ч���ڱ������ڻ���ں�ͬ�Ŀ�֤�գ�
								return false;
							}else if(sBCBusinessType == '2050010' || sBCBusinessType == '2050020' 
							|| sBCBusinessType == '2090010' || sBCBusinessType == '2080030'
							|| sBCBusinessType == '2080020') 
							//�����������������֤��������������Ŵ�֤��������������
							{
								alert(getBusinessMessage('595'));//���ʵ���Ч���ڱ������ڻ���ں�ͬ�ķ����գ�
								return false;
							}else if(sBCBusinessType == '2050040') //���Ᵽ��
							{
								alert(getBusinessMessage('596'));//���ʵ���Ч���ڱ������ڻ���ں�ͬ��ǩ���գ�
								return false;
							}else if(sBCBusinessType == '2030010' || sBCBusinessType == '2030020'
							|| sBCBusinessType == '2030030' || sBCBusinessType == '2030040'
							|| sBCBusinessType == '2030050' || sBCBusinessType == '2030060'
							|| sBCBusinessType == '2030070' || sBCBusinessType == '2040010'
							|| sBCBusinessType == '2040020' || sBCBusinessType == '2040030'
							|| sBCBusinessType == '2040040' || sBCBusinessType == '2040050'
							|| sBCBusinessType == '2040060' || sBCBusinessType == '2040070'
							|| sBCBusinessType == '2040080' || sBCBusinessType == '2040090'
							|| sBCBusinessType == '2040100' || sBCBusinessType == '2040110') 
							//������������𳥻�������͸֧�黹��������˰��������������ó�ױ�����
							//����������������Ա�����Ͷ�걣������Լ������Ԥ��������а����̱���
							//����ά�ޱ��������±���������ó�ױ��������ϱ��������ý𱣺���
							//�ӹ�װ��ҵ����ڱ����������������Ա���
							{
								alert(getBusinessMessage('597'));//���ʵ���Ч���ڱ������ڻ���ں�ͬ����Ч���ڣ�
								return false;
							}else
							{
								alert(getBusinessMessage('598'));//���ʵ���Ч���ڱ������ڻ���ں�ͬ����ʼ�գ�
								return false;
							}
						}else if(sBusinessType == '1020010' || sBusinessType == '1020020'
						|| sBusinessType == '1020030' || sBusinessType == '1020040')
						//���гжһ�Ʊ���֡���ҵ�жһ�Ʊ���֡�Э�鸶ϢƱ�����֡���ҵ�жһ�Ʊ����
						{
							alert(getBusinessMessage('599'));//���ʵ���Ϣ�ձ������ڻ���ں�ͬ����ʼ�գ�
							return false;
						}else if(sBusinessType == '2020')//��������֤
						{
							alert(getBusinessMessage('600'));//���ʵ�ҵ�����ڱ������ڻ���ں�ͬ�Ŀ�֤�գ�
							return false;
						}else if(sBusinessType == '2010')//���гжһ�Ʊ
						{
							alert(getBusinessMessage('601'));//���ʵ�ǩ���ձ������ڻ���ں�ͬ�ĳ�Ʊ�գ�
							return false;
						}else
						{
							alert(getBusinessMessage('593'));//���ʵ�����ձ������ڻ���ں�ͬ����ʼ�գ�
							return false;	
						}
					}
				}
			}
			
			//У����ʵ������Ƿ����ں�ͬ������
			if(typeof(sMaturity) != "undefined" && sMaturity != ""
			&& typeof(sBCMaturity) != "undefined" && sBCMaturity != "")
			{
				if(sMaturity > sBCMaturity && sBusinessType!="1110027" && sBusinessType!="2110020")
				{
					if(sOccurType == "015") //չ��ҵ��
					{
						alert(getBusinessMessage('602'));//���ʵ�չ�ڵ����ձ������ڻ���ں�ͬ��չ�ڵ����գ�
						return false;
					}else
					{
						if(sBusinessType == '2030010' || sBusinessType == '2030020'
						|| sBusinessType == '2030030' || sBusinessType == '2030040'
						|| sBusinessType == '2030050' || sBusinessType == '2030060'
						|| sBusinessType == '2030070' || sBusinessType == '2040010'
						|| sBusinessType == '2040020' || sBusinessType == '2040030'
						|| sBusinessType == '2040040' || sBusinessType == '2040050'
						|| sBusinessType == '2040060' || sBusinessType == '2040070'
						|| sBusinessType == '2040080' || sBusinessType == '2040090'
						|| sBusinessType == '2040100' || sBusinessType == '2040110'				
						|| sBusinessType == '1110140' || sBusinessType == '1110170'
						|| sBusinessType == '3030020' || sBusinessType == '1110160'
						|| sBusinessType == '1110150' || sBusinessType == '1110130'
						|| sBusinessType == '1110027' || sBusinessType == '1110120'
						|| sBusinessType == '2100' || sBusinessType == '2090020'
						|| sBusinessType == '1110110' || sBusinessType == '2090010'
						|| sBusinessType == '1110100' || sBusinessType == '1110090'
						|| sBusinessType == '2080010' || sBusinessType == '1110080'
						|| sBusinessType == '2110050' || sBusinessType == '2060040'				
						|| sBusinessType == '2110040' || sBusinessType == '1110050'
						|| sBusinessType == '2060010' || sBusinessType == '1110040'
						|| sBusinessType == '2050040' || sBusinessType == '2050030'
						|| sBusinessType == '1110030' || sBusinessType == '2050020'
						|| sBusinessType == '2050010' || sBusinessType == '1110020'
						|| sBusinessType == '1110010' || sBusinessType == '2060020'
						|| sBusinessType == '2060030' || sBusinessType == '1100010'
						|| sBusinessType == '2060050' || sBusinessType == '2060060'
						|| sBusinessType == '1110070' || sBusinessType == '1090030'				
						|| sBusinessType == '2080020' || sBusinessType == '2080030'
						|| sBusinessType == '1090020' || sBusinessType == '1090010') 
						//������������𳥻�������͸֧�黹��������˰��������������ó�ױ�����
						//����������������Ա�����Ͷ�걣������Լ������Ԥ��������а����̱���
						//����ά�ޱ��������±���������ó�ױ��������ϱ��������ý𱣺���
						//�ӹ�װ��ҵ����ڱ����������������Ա�������ҵ��ѧ������˾�Ӫ���
						//����ס��װ�޴��������ѧ����������������������ס����������
						//����Ӫ������������뷵��ҵ���м�֤ȯ���е��������˵�Ѻ����������
						//���˱�֤���������Ѻ��������ŵ�������˾�Ӫѭ����� ���˸������
						//ת�����Ŵ�������С�����ô������ί�д������������Ѻ���
						//ת�����������������ٽ�����ҵ�÷�������Ᵽ������������֤��
						//������ҵ�÷��������������֤�����������ת�����ʽ�����֯���
						//������㴢��ת��������ٽ���ס���������ծȯת�������ת���
						//���˵�Ѻѭ���������ס������ƽ�����ҵ�񡢴��������顢�����Ŵ�֤����
						//���ڱ������ڱ������ڱ���
						{
							if(sBCBusinessType == '2050010' || sBCBusinessType == '2050020' 
							|| sBCBusinessType == '2090010' || sBCBusinessType == '2080030'
							|| sBCBusinessType == '2080020' || sBCBusinessType == '2050030') 
							//�����������������֤��������������Ŵ�֤�������������顢��������֤
							{
								alert(getBusinessMessage('604'));//���ʵ�ʧЧ���ڱ������ڻ���ں�ͬ�ĵ����գ�
								return false;
							}else if(sBCBusinessType == '2050040') //���Ᵽ��
							{
								alert(getBusinessMessage('605'));//���ʵ�ʧЧ���ڱ������ڻ���ں�ͬ�ĵ��ڸ����գ�
								return false;
							}else if(sBCBusinessType == '2030010' || sBCBusinessType == '2030020'
							|| sBCBusinessType == '2030030' || sBCBusinessType == '2030040'
							|| sBCBusinessType == '2030050' || sBCBusinessType == '2030060'
							|| sBCBusinessType == '2030070' || sBCBusinessType == '2040010'
							|| sBCBusinessType == '2040020' || sBCBusinessType == '2040030'
							|| sBCBusinessType == '2040040' || sBCBusinessType == '2040050'
							|| sBCBusinessType == '2040060' || sBCBusinessType == '2040070'
							|| sBCBusinessType == '2040080' || sBCBusinessType == '2040090'
							|| sBCBusinessType == '2040100' || sBCBusinessType == '2040110') 
							//������������𳥻�������͸֧�黹��������˰��������������ó�ױ�����
							//����������������Ա�����Ͷ�걣������Լ������Ԥ��������а����̱���
							//����ά�ޱ��������±���������ó�ױ��������ϱ��������ý𱣺���
							//�ӹ�װ��ҵ����ڱ����������������Ա���
							{
								alert(getBusinessMessage('606'));//���ʵ�ʧЧ���ڱ������ڻ���ں�ͬ��ʧЧ���ڣ�
								return false;
							}else
							{
								alert(getBusinessMessage('604'));//���ʵ�ʧЧ���ڱ������ڻ���ں�ͬ�ĵ����գ�
								return false;
							}
						}else if(sBusinessType == '1020010' || sBusinessType == '1020020'
						|| sBusinessType == '1020030' || sBusinessType == '1020040')
						//���гжһ�Ʊ���֡���ҵ�жһ�Ʊ���֡�Э�鸶ϢƱ�����֡���ҵ�жһ�Ʊ����
						{
							alert(getBusinessMessage('603'));//���ʵĵ����ձ������ڻ���ں�ͬ�ĵ����գ�
							return false;
						}else if(sBusinessType == '2020')//��������֤
						{
							alert(getBusinessMessage('607'));//���ʵ�����֤��Ч�ڱ������ڻ���ں�ͬ������֤��Ч�ڣ�
							return false;
						}else if(sBusinessType == '2010')//���гжһ�Ʊ
						{
							alert(getBusinessMessage('608'));//���ʵĵ��ڸ����ձ������ڻ���ں�ͬ�ĵ����գ�
							return false;
						}else
						{
							alert(getBusinessMessage('603'));//���ʵĵ����ձ������ڻ���ں�ͬ�ĵ����գ�
							return false;	
						}
						
					}
				}
			}							
		}
		
		//���ʽ��
		dBusinessSum = getItemValue(0,getRow(),"BusinessSum");	
		//��ͬ���
		dBCBusinessSum = "<%=dBCBusinessSum%>";
		//�ж��ۼƳ��ʽ���Ƿ��ѳ����˺�ͬ���
		if(parseFloat(dBusinessSum) >= 0 && parseFloat(dBCBusinessSum) >= 0)
		{
			//��ȡ��ͬ���¿ɳ��ʵĽ��
			//������ˮ��
			sSerialNo = getItemValue(0,getRow(),"SerialNo");
			//��ͬ��ˮ��
			sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");	
			sSurplusPutOutSum = RunMethod("BusinessManage","GetPutOutSum",sContractSerialNo+","+sSerialNo);
			if(parseFloat(sSurplusPutOutSum) > 0)
			{
				if(parseFloat(dBusinessSum) > parseFloat(sSurplusPutOutSum))
				{
					alert(getBusinessMessage('572'));//������¼��Ľ�����С�ڻ���ں�ͬ�Ŀ��ý�
					return false;
				}
			}else
			{
				alert(getBusinessMessage('573'));//��ҵ���ͬ��û�п��ý����ܽ��зŴ����룡
				return false;
			}			
		}
		
		if(sBusinessType == '1040010' || sBusinessType == '1040020' 
		|| sBusinessType == '1040030' || sBusinessType == '1040040') 
		//���˹�������������˰��ҡ��豸���˰��ҡ��������˰���
		{
			//���ۿ�����ѡ�񰴹̶�������Ϣʱ,�����������,���뷶ΧΪ2-12.
			//�ۿ�����
			sICCyc = getItemValue(0,getRow(),"ICCyc");
			//�̶�����
			sFixCyc = getItemValue(0,getRow(),"FixCyc");
			if(typeof(sICCyc) != "undefined" && sICCyc != "")
			{
				if(sICCyc == '1')
				{
					if(typeof(sFixCyc) == "undefined" || sFixCyc.length==0 
					|| parseInt(sFixCyc) < 2 || parseInt(sFixCyc) > 12)
					{
						alert(getBusinessMessage('611'));//���ۿ�����ѡ�񰴹̶�������Ϣʱ,�̶�������������,���뷶ΧΪ2-12��
						return false;
					}
				}
			}
		}else
		{
			//����Ϣ����ѡ�񰴹̶�������Ϣʱ,�����������,���뷶ΧΪ2-12.
			//��Ϣ����
			sICCyc = getItemValue(0,getRow(),"ICCyc");
			//�̶�����
			sFixCyc = getItemValue(0,getRow(),"FixCyc");
			if(typeof(sICCyc) != "undefined" && sICCyc != "")
			{
				if(sICCyc == '5')
				{
					if(typeof(sFixCyc) == "undefined" || sFixCyc.length==0 
					|| parseInt(sFixCyc) < 2 || parseInt(sFixCyc) > 12)
					{
						alert(getBusinessMessage('609'));//����Ϣ����ѡ�񰴹̶�������Ϣʱ,�̶����ڱ�������,���뷶ΧΪ2-12��
						return false;
					}
				}
			}
		}
		
		//�����ָ�Ϣ��ʽѡ��Э�鸶Ϣʱ�����򷽸�Ϣ����
		//���ָ�Ϣ��ʽ
		sAcceptIntType = getItemValue(0,getRow(),"AcceptIntType");
		//�򷽸�Ϣ����(%)
		sBillRisk = getItemValue(0,getRow(),"BillRisk");
		if(typeof(sAcceptIntType) != "undefined" && sAcceptIntType != "")
		{
			if(sAcceptIntType == '2')
			{
				if(typeof(sBillRisk) == "undefined" || sBillRisk.length==0 
				|| parseInt(parseFloat) <= 0)
				{
					alert(getBusinessMessage('610'));//�����ָ�Ϣ��ʽѡ��Э�鸶Ϣʱ�����򷽸�Ϣ������
					return false;
				}
			}
		}
		
		return true;
	}
	
	/*~[Describe=��ȡ��֤��;InputParam=��;OutPutParam=��;]~*/
	function getBailSum(){
		sObjectType = "<%=sObjectType%>";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sBailAccount = getItemValue(0,getRow(),"BailAccount");
		//Ϊ�˽���֤���˺���Ϊ������������ҳ��
		sObjectType = sObjectType+"@"+sBailAccount;
		//���б�֤����Ϣ���� add by xlyu 
		sTradeType = "798015";
		sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000"){
			alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
		    return;
		}else
		{
		    alert("���ͺ��ĳɹ���"+sReturn[1]);
		    reloadSelf();
		    
		}
		
	}
	
	/*~[Describe=�����������ʻ���ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getPutOutOrg()
	{		
		sParaString = "OrgID"+","+"<%=CurOrg.OrgID%>";
		setObjectValue("SelectBelongOrg",sParaString,"@AboutBankID3@0@AboutBankID3Name@1",0,0,"");		
	}
	
	/*~[Describe=�������˻���ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectPutOutOrg()
	{		
		sParaString = "SortNo"+","+"<%=CurOrg.SortNo%>";
		setObjectValue("SelectBelongOrgCode",sParaString,"@PutOutOrgID@0@PutOutOrgIDName@1",0,0,"");		
	}
	/*~[Describe=���ݻ�׼���ʡ����ʸ�����ʽ�����ʸ���ֵ����ִ����(��)����;InputParam=��;OutPutParam=��;]~*/
	function getBusinessRate(sFlag)
	{
		if("<%=sObjectType%>" == "ReinforceContract")
		{
			return;
		}
	
		//ҵ������
		sBusinessType = "<%=sBusinessType%>";
		//��׼����
		dBaseRate = getItemValue(0,getRow(),"BaseRate");
		//���ʸ�����ʽ
		sRateFloatType = getItemValue(0,getRow(),"RateFloatType");
		//���ʸ���ֵ
		dRateFloat = getItemValue(0,getRow(),"RateFloat");
		if(typeof(sRateFloatType) != "undefined" && sRateFloatType != "" 
		&& parseFloat(dBaseRate) >= 0 )
		{			
			if(sRateFloatType=="0")	//�����ٷֱ�
			{
				if(sFlag == 'Y') //ִ��������
					dBusinessRate = parseFloat(dBaseRate) * (1 + parseFloat(dRateFloat)/100 );
				if(sFlag == 'M') //ִ��������
					dBusinessRate = parseFloat(dBaseRate) * (1 + parseFloat(dRateFloat)/100 ) / 1.2;
			}else	//1:��������
			{
				if(sFlag == 'Y') //ִ��������
					dBusinessRate = parseFloat(dBaseRate) + parseFloat(dRateFloat);
				if(sFlag == 'M') //ִ��������
					dBusinessRate = (parseFloat(dBaseRate) + parseFloat(dRateFloat)) / 1.2;
			}
			dBusinessRate = roundOff(dBusinessRate,6);
			setItemValue(0,getRow(),"BusinessRate",dBusinessRate);
		}else
		{
			setItemValue(0,getRow(),"BusinessRate","");
		}
		if(sBusinessType == "1020010" || sBusinessType == "1020020")
		{
			dBusinessRate = parseFloat(dBaseRate)/1.2;
			dBusinessRate = roundOff(dBusinessRate,6);
			setItemValue(0,getRow(),"BusinessRate",dBusinessRate);
		}
	}
	
	//ȡ�û�׼������
	function selectBaseRateType(){
		sCurDate = "<%=StringFunction.getToday()%>"
		sParaString = "CurDate"+","+sCurDate;
	    sReturn = setObjectValue("selectBaseRateType",sParaString,"@BaseRateType@0@BaseRate@1",0,0,"");
		getBusinessRate("M");
	}
	//�Զ���ȡ�������� 2009-12-24 
	function getBaseRateType(){
		 var sOccurType = "<%=sBCOccurType%>";
		 var sBusinessType = <%=sBusinessType%>
		 dTermDay = getItemValue(0,getRow(),"TermDay");
		 dTermMonth = getItemValue(0,getRow(),"TermMonth");
		 sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
		 sBaseRateID = "";
	 
		  if(sBusinessCurrency=="01")//�����
		 {
			  if(typeof(dTermDay) != "undefined" && dTermDay != "" && dTermDay>0)
			 {
			 	dTermMonth = dTermMonth+1; 
			 }
			 if(dTermMonth <= 6){
			 	sBaseRateID = "10010";
			 }else if(dTermMonth > 6 && dTermMonth <= 12){
			 	sBaseRateID = "10020";
			 }else if(dTermMonth > 12 && dTermMonth <= 36){
			 	sBaseRateID = "10040";
			 }else if(dTermMonth > 36 && dTermMonth <= 60){
			 	sBaseRateID = "10050";
			 }else{
			 	sBaseRateID = "10030";
			 }
		}else{//���
			 if(dTermDay < 7 && dTermMonth==0){
			 	sBaseRateID = "20010";//��ҹ
			 }else if(dTermDay < 14 && dTermMonth==0){
			 	sBaseRateID = "20020";//һ��
			 }else if(dTermMonth==0 ){
			 	sBaseRateID = "20030";//����
			 }else if(dTermMonth <3){
			 	sBaseRateID = "20040";//һ����
			 }else if(dTermMonth <6){
			 	sBaseRateID = "20050";//������
			 }else if(dTermMonth <12){
			 	sBaseRateID = "20060";//������
			 }else{
			 	sBaseRateID = "20070";//ʮ������
			 }
		}
		 setItemValue(0,0,"BaseRateType",sBaseRateID);
		 
		 //sReturn = RunMethod("BusinessManage","getBaseRate",sBaseRateID);
		 sReturn = RunMethod("BusinessManage","getCurrencyBaseRate",sBaseRateID+","+sBusinessCurrency);
		    if(typeof(sReturn) != "undefined" && sReturn != ""){
		    	setItemValue(0,0,"BaseRate",sReturn);
		    }  
		getBusinessRate("M");
	}
	
	/*~[Describe=��ռ/Ų������InputParam=��;OutPutParam=��;]~*/
	function getTARate()
	{
		//��ռ/Ų�ø�������
		dTARateFloat = getItemValue(0,getRow(),"TARateFloat");
		//ִ��������
		dBusinessRate = getItemValue(0,getRow(),"BusinessRate");
		//��ռ/Ų�����ʣ�ִ������*��1+��ռ/Ų�ø���������
		dTARate = parseFloat(dBusinessRate)*(1+parseFloat(dTARateFloat)/100.00);
		setItemValue(0,getRow(),"TARate",roundOff(dTARate,6));
	}
	/*~[Describe=������������;InputParam=��;OutPutParam=��;]~*/
	function getOverdueRate()
	{
		//���ڸ�������
		dOverdueRateFloat = getItemValue(0,getRow(),"OverdueRateFloat");
		//ִ��������
		dBusinessRate = getItemValue(0,getRow(),"BusinessRate");
		//�������ʣ�ִ������*��1+���ڸ���������
		dOverdueRate = parseFloat(dBusinessRate)*(1+parseFloat(dOverdueRateFloat)/100.00);
		setItemValue(0,getRow(),"OverdueRate",roundOff(dOverdueRate,6));
	}
	
	//���˽׶Σ����»�ȡ��׼���� 
	function getNewBaseRate(){
		sBaseRateID = getItemValue(0,getRow(),"BaseRateType");
		sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//����
		if("2110020" == "<%=sBusinessType%>"){//����Ǵ����������
			sReturn = RunMethod("BusinessManage","getAFBaseRate",sBaseRateID);
		    if(typeof(sReturn) != "undefined" && sReturn != ""){
		    	setItemValue(0,0,"BaseRate",sReturn);
		    }
		}else{
			//sReturn = RunMethod("BusinessManage","getBaseRate",sBaseRateID);
			sReturn = RunMethod("BusinessManage","getCurrencyBaseRate",sBaseRateID+","+sBusinessCurrency);
			if(typeof(sReturn) != "undefined" && sReturn != "")
			{
				setItemValue(0,0,"BaseRate",sReturn);
			} 	
		}    
		getBusinessRate("M");
		getTARate();
		getOverdueRate();
	}
	
	/*~[Describe=���㱣֤�����;InputParam=��;OutPutParam=��;]~*/
	function setBailRatio()
	{
			sERateDate = getItemValue(0,getRow(),"ERateDate");//��������
	    	sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//ҵ�����
			sBailCurrency = getItemValue(0,getRow(),"BailCurrency");//��֤�����
			dBailSum = getItemValue(0,getRow(),"BailSum");//��֤����
			sBailDate = getItemValue(0,getRow(),"BailDate");//��֤�𿪻�����
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");//���˽��
			var dBailRatio=0.0;
			if(sBusinessCurrency == sBailCurrency)
			{
		    	dBailRatio = parseFloat(dBailSum)*100/parseFloat(dBusinessSum);     
			}else
			{    
	    		dBailRateRatio = RunMethod("BusinessManage","getErateRatio1",sBailCurrency+",01,"+sBailDate);
	    		dERateRatio = RunMethod("BusinessManage","getErateRatio1",sBusinessCurrency+",01,"+sERateDate);
	        	dBailRatio = parseFloat(dBailSum*dBailRateRatio*100)/parseFloat(dBusinessSum*dERateRatio);
	        	
	    	}
	    	setItemValue(0,getRow(),"BPBailRatio",dBailRatio);
	}
	</SCRIPT>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>