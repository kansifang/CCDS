<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: slliu  2005-02-23 
		Tester:
		Content: �������У��
		Input Param:                                                           
    			   
		Output param:                                                          
			        
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%!
	//�жϿͻ���Ϣ�Ƿ�����������ʾ��Ϣ
	String getCustomerMesssage(String sMainTable,String sObjectNo,Transaction Sqlca) throws Exception {
	String sMesssage = "";
	String sSql = "select CustomerID from "+sMainTable+" where SerialNo='"+sObjectNo+"'";
	String sCustomerID=Sqlca.getString(sSql);
	ASResultSet rs = null;
	if (sCustomerID==null) sCustomerID="";

	if(sCustomerID.equals("")){
		sMesssage="\\n\\����ָ����ͬ��Ӧ�Ŀͻ��������ָ���ͻ���";
		return sMesssage;
	}else{
		sSql = "select CustomerType from CUSTOMER_INFO where CustomerID='"+sCustomerID+"'";
		rs=Sqlca.getASResultSet(sSql);
		if(rs.next()){
			String sCustomerType=rs.getString(1);
			if(sCustomerType==null) sCustomerType="  ";
			if(sCustomerType.substring(0,2).equals("03")){
				sSql = "select TempSaveFlag from IND_INFO where CustomerID='"+sCustomerID+"'";
				String sTempSaveFlag=Sqlca.getString(sSql);
				if (sTempSaveFlag==null) sTempSaveFlag="";
				/*if (!sTempSaveFlag.equals("2"))
					sMesssage += "\\n\\�ͻ���ϢΪ��ʱ����״̬��������д�ͻ���Ϣ��������水ť�����ߴ˽�ݶ�Ӧ�ͻ������ڣ�";*/	
				return sMesssage;		
			}
		}else{
			sMesssage += "\\n\\�˽�ݶ�Ӧ�ͻ������ڣ�����[ָ���ͻ�]��[�������]��";	
			return sMesssage;		
		}
		rs.close();
	}

	/*
	sSql = "select TempSaveFlag from ENT_INFO where CustomerID='"+sCustomerID+"'";
	String sTempSaveFlag=Sqlca.getString(sSql);
	if (sTempSaveFlag==null) sTempSaveFlag="";
	if (!sTempSaveFlag.equals("2"))
		sMesssage += "\\n\\�ͻ���ϢΪ��ʱ����״̬��������д�ͻ���Ϣ��������水ť�����ߴ˽�ݶ�Ӧ�ͻ������ڣ�";
	*/
	
	//�ͻ�������ҵ���� IndustryType
	sSql = "select IndustryType from ENT_INFO where CustomerID='"+sCustomerID+"'";
	String sIndustryType = Sqlca.getString(sSql);
	if (sIndustryType==null) sIndustryType="";
	if (sIndustryType.equals(""))
		sMesssage += "\\n\\r�ͻ���Ϣ�Ĺ�����ҵ���಻��Ϊ�գ������ڿͻ���Ϣ��ѡ����ҵ���ಢ���棡";

	//�ͻ����õȼ�����ģ������ CreditBelong
	sSql = "select CreditBelong from ENT_INFO where CustomerID='"+sCustomerID+"'";
	String sCreditBelong = Sqlca.getString(sSql);
	if (sCreditBelong==null) sCreditBelong="";
	if (sCreditBelong.equals(""))
		sMesssage += "\\n\\r�ͻ���Ϣ�Ŀͻ����õȼ�����ģ�岻��Ϊ�գ������ڿͻ���Ϣ��ѡ�����õȼ�����ģ�岢���棡";
	//���񱨱�����FinanceBelong
	sSql = "select FinanceBelong from ENT_INFO where CustomerID='"+sCustomerID+"'";
	String sFinanceBelong = Sqlca.getString(sSql);
	if (sFinanceBelong==null) sFinanceBelong="";
	if (sFinanceBelong.equals(""))
		sMesssage += "\\n\\r�ͻ���Ϣ�Ĳ��񱨱����Ͳ���Ϊ�գ������ڿͻ���Ϣ��ѡ����񱨱����Ͳ����棡";
	return sMesssage;
	}

	//�ж���ʱ��־����ʾ��Ϣ
	String getTempSaveMesssage(String sMainTable,String sObjectNo,Transaction Sqlca) throws Exception {
	String sMesssage = "";
	String sSql = "select TempSaveFlag from "+sMainTable+" where SerialNo='"+sObjectNo+"'";
	String sTempSaveFlag=Sqlca.getString(sSql);
	if (sTempSaveFlag==null) sTempSaveFlag="";
	if (!sTempSaveFlag.equals("2"))
		sMesssage += "\\n\\r����ҵ����Ϣδ¼����ȫ״̬��������д����ҵ����Ϣ��������水ť��";
	return sMesssage;
	}
	//�ж��Ƿ�¥��Ҷ������ҵ��
	String getBuildingMesssage(String sMainTable,String sObjectNo,Transaction Sqlca) throws Exception {
	String sMesssage = "";
	String sSql = "SELECT count(*)  FROM BUSINESS_CREDITAGGREEMENT  Where ObjectNo='"+sObjectNo+"' ";
	int iCount=Integer.parseInt(Sqlca.getString(sSql));
	if (iCount<1)
		sMesssage += "\\n\\r¥��Ҷ������ҵ�����ڡ����¥���ȡ���������Ӧ�����Ϣ��";
	return sMesssage;
	}
%>

<html>
<head>
<title>�������У�� </title>
</head>


<%
	//�������
	ASResultSet rs = null;
	String sPutOutOrgID="";
	String sVouchType="";
	String sVouchType1="";
	String sBusinessType="";
	String sFinishType ="";
	String sOccurType ="";
	
	int iCount1=0;
	int iCount6=0;
	int iCount7=0;
	int iCount8=0;
	int iCount9=1;
	
	String sSql="";
	String sExistFlag="";
	String sFlag2="",sOldBusinessType="";
	
	
	//��ͬ��ˮ�š��ͻ���š�ҵ��Ʒ��
	String sContractNo =    DataConvert.toRealString(iPostChange,(String)request.getParameter("ContractNo"));
	String sCustomerID =    DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
   
	//------------------------У���ͬҵ�������Ϣ�Ƿ���������-----------------------------------------
	//�õ�ҵ�������Ϣ
        
	sSql = " select PutOutOrgID,VouchType,BusinessType,OccurType,Flag2 "+
               " from BUSINESS_CONTRACT where SerialNo='"+sContractNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sPutOutOrgID =  DataConvert.toString(rs.getString("PutOutOrgID"));
        sVouchType = DataConvert.toString(rs.getString("VouchType"));
        sBusinessType = DataConvert.toString(rs.getString("BusinessType"));
        sOccurType = DataConvert.toString(rs.getString("OccurType"));
        sFlag2 = DataConvert.toString(rs.getString("Flag2"));
        if(sFlag2 == null) sFlag2="";
	}
	rs.getStatement().close();
	sOldBusinessType=sBusinessType;
	sBusinessType = sBusinessType.substring(0,1);
			       
			       
	if(sBusinessType.equals("3"))	//���Ϊ���Ŷ�ȣ�����У�鵣����ʽ
	{
		sVouchType = "";
	}else if(sBusinessType.equals("1"))	//���Ϊ����ҵ��У�鵣����ʽ
	{
		sVouchType1 = sVouchType;
		if(sVouchType !=null && !sVouchType.equals(""))
	    {
			sVouchType = sVouchType.substring(0,3);
		}else
		{
			sVouchType = "";
		}
	}else if(sBusinessType.equals("2"))	//���Ϊ����ҵ��У�鵣����ʽ
	{    	
       if(sVouchType !=null && !sVouchType.equals(""))
       	{
       		if(!sVouchType.equals("04005"))  //��Ϊ��Ѻ����֤��
       		{
       			sVouchType = sVouchType.substring(0,3);
       		}else
       		{
       			sVouchType = "";
       		}
       	}
	}else
	{
		sVouchType = "";
	}
	       
	   
	//----------------------------�����ͬ�ĵ�����ʽΪ����Ѻ��У���Ƿ��е���Ѻ��ͬ----------------------------------------
	if(sVouchType1.equals("04005"))  //���Ϊ��Ѻ����֤��Ҫ�����������Ѻ��֤���ͬ
    {
      	sSql = 	" select Count(*) from CONTRACT_RELATIVE CR,GUARANTY_CONTRACT GC "+
          		" where CR.SerialNo= '"+sContractNo+"' "+
               	" and CR.ObjectType = 'GuarantyContract' "+
               	" and CR.ObjectNo = GC.SerialNo "+
               	" and GC.GuarantyType='010040' ";
	                   	
        rs = Sqlca.getASResultSet(sSql);
    	if(rs.next())
    	{
        	iCount6=rs.getInt(1);
    	}
    	rs.getStatement().close();
	} else
	{
		 iCount6=1;	       
	}
		
		
   	if(sVouchType !=null && !sVouchType.equals("") && (sVouchType.equals("020") || sVouchType.equals("040")))
   	{	             
       	sSql = 	" select Count(*) from CONTRACT_RELATIVE where SerialNo= '"+sContractNo+"' "+
           		" and ObjectType = 'GuarantyContract' ";
     	rs = Sqlca.getASResultSet(sSql);
    	if(rs.next())
    	{
        	iCount7=rs.getInt(1);	
    	}
    	rs.getStatement().close();	               
 	}else
 	{
 		iCount7=1;
 	}
	
	//---------------------------�����ͬ�ĵ�����ʽΪ����Ѻ��У���Ƿ��е���Ѻ����Ϣ-----------------------------------------
   	if(sVouchType !=null && !sVouchType.equals("") && (sVouchType.equals("020") || sVouchType.equals("040")))
   	{	                
        	sSql = 	" select Count(*) from GUARANTY_INFO "+
               		" where GuarantyID in (select GuarantyID from GUARANTY_RELATIVE where ObjectNo='"+sContractNo+"') ";	
        	rs = Sqlca.getASResultSet(sSql);
        	if(rs.next())
        	{
            	iCount8 = rs.getInt(1);	
        	}
        	rs.getStatement().close();	              
 	}else
 	{
 		iCount8=1;
 	}
	
	//---------------------------�����ͬ�ķ�����ʽΪծ�����飬У���Ƿ���������鷽��-----------------------------------------
   	//   zwhu20100607 ע��
   	/*if(sOccurType == null)sOccurType="";
   	if(sOccurType.equals("030"))
   	{	                
        	sSql = 	" select Count(*) from CONTRACT_RELATIVE "+
               		" where SerialNo ='"+sContractNo+"' and ObjectType='NPARefromApply'";
        	rs = Sqlca.getASResultSet(sSql);
        	if(rs.next())
        	{
            	iCount9 = rs.getInt(1);	
        	}
        	rs.getStatement().close();	              
 	}else
 	{
 		iCount9=1;
 	}*/

  	//---------------------------�ж��Ƿ����ҵ��-----------------------------------------
 	sSql="select FinishType from BUSINESS_CONTRACT where SerialNo='"+sContractNo+"'";
	sFinishType=Sqlca.getString(sSql);
	if(sFinishType==null)sFinishType="000";
	if(sFinishType.equals(""))sFinishType="000";
	sFinishType=sFinishType.substring(0,3);
	
 	//---------------------------�ж������Ϣ�Ƿ���ڸ�����Ӧ����Ϣ��ʾ-----------------------------------------
	 
	//�жϿͻ���Ϣ�Ƿ�����������ʾ��Ϣ
	String sCustomerFlag = getCustomerMesssage("BUSINESS_CONTRACT",sContractNo,Sqlca);
	//�ж���ʱ��־����ʾ��Ϣ
	String sTempSaveMesssage = getTempSaveMesssage("BUSINESS_CONTRACT",sContractNo,Sqlca);
    //String sBuildingMessage = getBuildingMesssage("BUSINESS_CONTRACT",sContractNo,Sqlca);	
    	
	if(!sCustomerFlag.equals("") && !sFinishType.equals("060"))
	{
    	sExistFlag = sCustomerFlag;
	}else if(!sTempSaveMesssage.equals(""))
    {
        sExistFlag = sTempSaveMesssage;
    }else if(sPutOutOrgID == null || sPutOutOrgID.equals(""))
    {
        sExistFlag = "ҵ�������Ϣ��д��������";
    }else if(iCount6 == 0)
    {
       	sExistFlag = "������ʽΪ��Ѻ-��֤�������뱣֤�𵣱���ͬ��Ϣ��"; 
    }else if(iCount7 == 0)
    {
   		sExistFlag = "������ʽΪ����Ѻ����û�ж�Ӧ�ĵ�����Ϣ��"; 
    }else if(iCount8 == 0)
    {
        sExistFlag = "������ʽΪ����Ѻ����û�ж�Ӧ�ĵ���Ѻ��Ϣ��";  
    }else if(iCount9 == 0)
    {
        sExistFlag = "������ʽΪծ�����飬��û�ж�Ӧ�����鷽����Ϣ��";  
    }else
    {
       	sExistFlag = "true";   
    }   	
%>

</html>

<script language=javascript>
	self.returnValue="<%=sExistFlag%>";
    self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>