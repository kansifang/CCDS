package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;

public class UpdateCustomerRelaInfo extends Bizlet{
	
	public Object run(Transaction Sqlca) throws Exception
	 {		
        //�Զ���ô���Ĳ���ֵ		
		String sCustomerID   = (String)this.getAttribute("CustomerID");
		String sFromUserID   = (String)this.getAttribute("FromUserID");
		String sToUserID   = (String)this.getAttribute("ToUserID");
		
        //����ֵת���ɿ��ַ���		
		if(sCustomerID == null) sCustomerID = "";
		if(sFromUserID == null) sFromUserID = "";
		if(sToUserID == null) sToUserID = "";
		
		
		//�������	
        ASUser CurUser = null;
        String sCustomerType = "";
        String sFromOrgID = "";
        String sToUserName = "",sToOrgID = "",sToOrgName = "";
        String sUpdateDate = "",sUpdateTime = "";
        
        //��ȡת��ǰ�Ļ�������ͻ�������
        CurUser = new ASUser(sFromUserID,Sqlca);
        sFromOrgID = CurUser.OrgID;
        
        //��ȡת��ǰ�Ļ�������ͻ�������
        CurUser = new ASUser(sToUserID,Sqlca);
        sToUserName = CurUser.UserName;
        sToOrgID = CurUser.OrgID;
        sToOrgName = CurUser.BelongOrgName;
       
        //��ȡ�������
        sUpdateDate = StringFunction.getToday();
        sUpdateTime = StringFunction.getTodayNow();
		//��ȡ�ͻ�����
        sCustomerType = Sqlca.getString("select CustomerType from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"'");
		if (sCustomerType == null) sCustomerType = "";
		
		
		//****************�������������ţ�*****************
		//���¿ͻ�Ȩ��
		UpdateCustomerBelong(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
        //���¿ͻ��ſ�
		UpdateCustomerInfo(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,Sqlca);
        //������ҵ�ͻ�������Ա���ͻ��߹ܡ����˴�������Ա���ɶ�����������ȨͶ����������������������
		//���¸�����ż����ͥ��Ա���������Ͷ����ҵ���
		UpdateCustomerRelative(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
        //������ҵ�ͻ����������ڻ���������Ϣ�Ϳͻ����¼�
		//���˴��¼�
		UpdateCustomerMemo(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
        //���¹�˾�ͻ��ĵ���Ϣ
		//���˿ͻ��ṩ�������
		UpdateDocLibrary(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToUserName,sToOrgID,sToOrgName,sUpdateTime,Sqlca);
        //���¹�Ʊ��Ϣ
		UpdateCustomerStock(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
        //���³���ծȯ��Ϣ
		UpdateCustomerBond(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
        //������˰��Ϣ
		UpdateCustomerTaxPaying(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
        //���������ʲ���Ϣ
		UpdateImaAsserts(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);	
        //�����������ڻ���ҵ��
		UpdateCustomerOActivity(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
        //���¿ͻ��������
		//�����������
		UpdateCustomerAnarecord(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
		
		
		if(sCustomerType.substring(0,2).equals("01")){  //��˾�ͻ�			
	        //������ҵ�ͻ���
			UpdateEntInfo(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //���¹�Ʊ��
			UpdateEntIPO(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //����ծȯ��
			UpdateEntBondIssue(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //���·��ز��������
			UpdateEntRealtyAuth(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //���½�����ó��
			UpdateEntranceAuth(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //��������Ӫ��ҵ�������֤��Ϣ
			UpdateEntAuth(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //���²�����Ŀ���
			UpdateProjectInfo(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //���²��񱨱�
			UpdateCustomerFSRecord(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,sUpdateTime,Sqlca);
	        //����Ӧ��Ӧ���ʿ���Ϣ
			UpdateEntFOA(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //���¸��´����Ϣ
			UpdateEntInventory(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //���¹̶��ʲ���Ϣ
			UpdateEntFixedAsserts(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);	
	        //�����ֽ���Ԥ��
			UpdateCashRecord(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,Sqlca);
	        //���¿ͻ����õȼ�����
			UpdateEvaluateRecordEnt(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //���·���Ԥ���ź���������������޶�ο�
			UpdateRiskSignal(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	    }	
			
		if(sCustomerType.substring(0,2).equals("03")) 	//���˿ͻ�
		{
	        //���˸ſ���
			UpdateIndInfo(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //����ѧҵ����
			UpdateIndEducation(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //���˹�������
			UpdateIndResume(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //��ᱣ�ա��Ʋ����ա����ٱ���
			UpdateIndSi(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //�����ʲ����
			UpdateCustomerRealty(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //�����ʲ����
			UpdateCustomerVehicle(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //�����ʲ���Ϣ
			UpdateIndOasset(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //������ծ��Ϣ
			UpdateIndOdebt(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //�������õȼ�������Ϣ
			UpdateEvaluateRecordInd(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,Sqlca);
		}	

		return "1";
				
	 }
	
	private void UpdateCustomerBelong(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca) 
		throws Exception
	{
		//��������
	    String sBelongAttribute1 = "",sBelongAttribute2 = "",sBelongAttribute3 = "",sBelongAttribute4 = "";
	    String sNewBelongAttribute1 = "",sNewBelongAttribute2 = "",sNewBelongAttribute3 = "",sNewBelongAttribute4 = "";
	    String sSql = "";
	    ASResultSet rs = null;	
	    
	    //��ԭ�û��Ըÿͻ���Ȩ��ȡ����
		sSql =  " select BelongAttribute1,BelongAttribute2,BelongAttribute3,BelongAttribute4 "+
                " from CUSTOMER_BELONG " +
            	" where CustomerID = '"+sCustomerID+"' "+
            	" and OrgID = '"+sFromOrgID+"' "+
            	" and UserID = '"+sFromUserID+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
		    sBelongAttribute1 = DataConvert.toString(rs.getString("BelongAttribute1"));
		    sBelongAttribute2 = DataConvert.toString(rs.getString("BelongAttribute2"));
		    sBelongAttribute3 = DataConvert.toString(rs.getString("BelongAttribute3"));
		    sBelongAttribute4 = DataConvert.toString(rs.getString("BelongAttribute4"));
		}
	    rs.getStatement().close();
		
		//��Ŀ���û��Ըÿͻ���Ȩ��ȡ����
		sSql =  " select BelongAttribute1,BelongAttribute2,BelongAttribute3,BelongAttribute4 "+
	        	" from CUSTOMER_BELONG " +
	        	" where CustomerID = '"+sCustomerID+"' "+
	        	" and OrgID = '"+sToOrgID+"' "+
	        	" and UserID = '"+sToUserID+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
		    sNewBelongAttribute1 = DataConvert.toString(rs.getString("BelongAttribute1"));
		    sNewBelongAttribute2 = DataConvert.toString(rs.getString("BelongAttribute2"));
		    sNewBelongAttribute3 = DataConvert.toString(rs.getString("BelongAttribute3"));
		    sNewBelongAttribute4 = DataConvert.toString(rs.getString("BelongAttribute4"));
	
            //ȡҵ������Ȩ����Ϣά��Ȩ��ҵ�����Ȩ�ĸ���Ȩ��
            if(Integer.parseInt(sBelongAttribute1) > Integer.parseInt(sNewBelongAttribute1) && sNewBelongAttribute1 != "")
                sBelongAttribute1 = sNewBelongAttribute1;
            if(Integer.parseInt(sBelongAttribute2) > Integer.parseInt(sNewBelongAttribute2) && sNewBelongAttribute2 != "")
                sBelongAttribute2 = sNewBelongAttribute2;
            if(Integer.parseInt(sBelongAttribute3) > Integer.parseInt(sNewBelongAttribute3) && sNewBelongAttribute3 != "")
                sBelongAttribute3 = sNewBelongAttribute3;
            if(Integer.parseInt(sBelongAttribute4) > Integer.parseInt(sNewBelongAttribute4) && sNewBelongAttribute4 != "")
                sBelongAttribute4 = sNewBelongAttribute4;
        }
        rs.getStatement().close();
           		
        //������ݿ��д�����Ҫ�����������ͬ�ļ�¼��������ɾ��ԭ���ļ�¼���ٽ��в����¼�¼��
        sSql =   " delete from CUSTOMER_BELONG where CustomerID='"+sCustomerID+"' and OrgID='"+sToOrgID+"' and UserID='"+sToUserID+"' ";
        Sqlca.executeSQL(sSql);
        
        //����ǰ�û���Ȩ�޸��²����û���ΪĿ���û�
        sSql =  " update CUSTOMER_BELONG set "+
        		" UserID = '"+ sToUserID + "', "+
        		" OrgID = '"+ sToOrgID +"', " +
                " BelongAttribute1 = '"+ sBelongAttribute1 +"'," +
                " BelongAttribute2 = '"+ sBelongAttribute2 +"'," +
                " BelongAttribute3 = '"+ sBelongAttribute3 +"'," +
                " BelongAttribute4 = '"+ sBelongAttribute4 +"', " +
                " UpdateDate = '"+sUpdateDate+"' "+
                " where CustomerID = '"+ sCustomerID +"' "+
                " and OrgID = '"+ sFromOrgID +"' "+
                " and UserID = '"+ sFromUserID +"' ";
        Sqlca.executeSQL(sSql);
	}
	
	 //���¿ͻ��ſ�
	 private void UpdateCustomerInfo(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_INFO set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"' " +
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 //������ҵ�ͻ���
	 private void UpdateEntInfo(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_INFO set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update ENT_INFO set "+
		 		" UpdateUserID = '"+sToUserID+"', "+
		 		" UpdateOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and UpdateUserID = '"+sFromUserID+"' "+
		 		" and UpdateOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);
	 }
	 
	 //���¿ͻ�������Ա���ͻ��߹ܡ����˴�������Ա���ɶ�����������ȨͶ����������������������
	 private void UpdateCustomerRelative(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_RELATIVE set "+
		 		" InputUserID='"+sToUserID+"', "+
		 		" InputOrgID='"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 //���¹�Ʊ��
	 private void UpdateEntIPO(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_IPO set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 //����ծȯ��
	 private void UpdateEntBondIssue(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_BONDISSUE set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	 
	 }
	 
     //���·��ز��������
	 private void UpdateEntRealtyAuth(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_REALTYAUTH set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
     //	���½�����ó��
	 private void UpdateEntranceAuth(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_ENTRANCEAUTH set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	 
	 } 
	 	 	 
	 //��������Ӫ��ҵ�������֤��Ϣ
	 private void UpdateEntAuth(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_AUTH set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	 
	 } 
	 	 
	 //���¿ͻ����������ڻ���������Ϣ�Ϳͻ����¼�
	 private void UpdateCustomerMemo(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_MEMO set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
     //���²�����Ŀ���
	 private void UpdateProjectInfo(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 //������Ŀ�ſ�
		 String sSql = "";
		 sSql = " update PROJECT_INFO set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where ProjectNo in (select ProjectNo from PROJECT_RELATIVE where ObjectType = 'Customer' " +
		 		" and ObjectNo = '"+sCustomerID+"') "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	
		 
		 //������Ŀ�ʽ���Դ		
		 sSql = " update PROJECT_FUNDS set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where ProjectNo in (select ProjectNo from PROJECT_RELATIVE where ObjectType = 'Customer' " +
		 		" and ObjectNo = '"+sCustomerID+"') "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	
		 
		 //������Ŀ��չ���		
		 sSql = " update PROJECT_PROGRESS set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where ProjectNo in (select ProjectNo from PROJECT_RELATIVE where ObjectType = 'Customer' " +
		 		" and ObjectNo = '"+sCustomerID+"') "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	
		 
		 //������ĿͶ�ʸ���		 
		 sSql = " update PROJECT_BUDGET set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where ProjectNo in (select ProjectNo from PROJECT_RELATIVE where ObjectType = 'Customer' " +
		 		" and ObjectNo = '"+sCustomerID+"') "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);
	 } 
	 
     //�����ĵ���Ϣ
	 private void UpdateDocLibrary(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToUserName,String sToOrgID,String sToOrgName,String sUpdateTime,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 //�����ĵ�������Ϣ
		 sSql = " update DOC_LIBRARY set "+
		 		" UserID = '"+sToUserID+"', "+
		 		" UserName = '"+sToUserName+"', "+
		 		" OrgID = '"+sToOrgID+"', " +
		 		" OrgName = '"+sToOrgName+"', " +
		 		" UpdateTime = '"+sUpdateTime+"' "+
		 		" Where DocNo in (select DocNo from DOC_RELATIVE Where ObjectType='Customer' " +
		 		" and ObjectNo= '"+sCustomerID+"') "+
		 		" and UserID = '"+sFromUserID+"' "+
		 		" and OrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update DOC_LIBRARY set "+
		 		" InputUser = '"+sToUserID+"', "+	 		
		 		" InputOrg = '"+sToOrgID+"', " +	 		
		 		" UpdateTime = '"+sUpdateTime+"' "+
		 		" Where DocNo in (select DocNo from DOC_RELATIVE Where ObjectType='Customer' " +
		 		" and ObjectNo= '"+sCustomerID+"') "+
		 		" and InputUser = '"+sFromUserID+"' "+
		 		" and InputOrg = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update DOC_LIBRARY set "+
		 		" UpdateUser = '"+sToUserID+"', "+	 		 				
		 		" UpdateTime = '"+sUpdateTime+"' "+
		 		" Where DocNo in (select DocNo from DOC_RELATIVE Where ObjectType='Customer' " +
		 		" and ObjectNo= '"+sCustomerID+"') "+
		 		" and UpdateUser = '"+sFromUserID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);
		 
		 //�����ĵ�������Ϣ
		 sSql = " update DOC_ATTACHMENT set "+
		 		" InputUser = '"+sToUserID+"', "+		 		
		 		" InputOrg = '"+sToOrgID+"', " +		 		
		 		" UpdateTime = '"+sUpdateTime+"' "+
		 		" Where DocNo in (select DocNo from DOC_RELATIVE Where ObjectType='Customer' " +
		 		" and ObjectNo= '"+sCustomerID+"') "+
		 		" and InputUser = '"+sFromUserID+"' "+
		 		" and InputOrg = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update DOC_ATTACHMENT set "+
		 		" UpdateUser = '"+sToUserID+"', "+	 		 				
		 		" UpdateTime = '"+sUpdateTime+"' "+
		 		" Where DocNo in (select DocNo from DOC_RELATIVE Where ObjectType='Customer' " +
		 		" and ObjectNo= '"+sCustomerID+"') "+
		 		" and UpdateUser = '"+sFromUserID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);
	 } 
	 
     //���²��񱨱�
	 private void UpdateCustomerFSRecord(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,String sUpdateTime,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_FSRECORD set "+
		 		" UserID = '"+sToUserID+"', "+
		 		" OrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and UserID = '"+sFromUserID+"' "+
		 		" and OrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update REPORT_RECORD set "+
		 		" UserID = '"+sToUserID+"', "+
		 		" OrgID = '"+sToOrgID+"', " +
		 		" UpdateTime = '"+sUpdateTime+"' "+
		 		" where ObjectType = 'CustomerFS' " +
		 		" and ObjectNo = '"+sCustomerID+"' "+
		 		" and UserID = '"+sFromUserID+"' "+
		 		" and OrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);
	 } 
	 
	 
     //	����Ӧ��Ӧ���ʿ���Ϣ
	 private void UpdateEntFOA(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_FOA set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
	 //	���´����Ϣ
	 private void UpdateEntInventory(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_INVENTORY set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
	 //	���¹̶��ʲ���Ϣ
	 private void UpdateEntFixedAsserts(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_FIXEDASSETS set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
     //���������ʲ���Ϣ
	 private void UpdateImaAsserts(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_IMASSET set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
     //���³��й�Ʊ��Ϣ
	 private void UpdateCustomerStock(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_STOCK set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
     //���³���ծȯ��Ϣ
	 private void UpdateCustomerBond(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_BOND set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
     //������˰��Ϣ
	 private void UpdateCustomerTaxPaying(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_TAXPAYING set "+
		  		" InputUserID = '"+sToUserID+"', "+
		  		" InputOrgID = '"+sToOrgID+"', " +
		  		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
	 //�����������ڻ���ҵ��
	 private void UpdateCustomerOActivity(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_OACTIVITY set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
     //�����ֽ���Ԥ��
	 private void UpdateCashRecord(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CASHFLOW_RECORD set "+
		 		" UserID = '"+sToUserID+"', "+
		 		" OrgID = '"+sToOrgID+"' " +
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and UserID = '"+sFromUserID+"' "+
		 		" and OrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
	 //���¿ͻ��������
	 private void UpdateCustomerAnarecord(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_ANARECORD set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	
		 
		 sSql = " update CUSTOMER_ANARECORD set "+
		 		" UserID = '"+sToUserID+"', "+
		 		" OrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and UserID = '"+sFromUserID+"' "+
		 		" and OrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);
	 } 
	 
     //���¿ͻ����õȼ�����(010)����������޶�ο�(080)
	 private void UpdateEvaluateRecordEnt(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToUserName,String sToOrgID,Transaction Sqlca)
	    throws Exception
	 { 
		 String sSql = "";
		 sSql = " update EVALUATE_RECORD set "+
		 		" UserID = '"+sToUserID+"', "+
		 		" OrgID = '"+sToOrgID+"' " +
		 		" where ObjectType='Customer' "+
		 		" and ObjectNo = '"+sCustomerID+"'" +
		 		" and ModelNo in (select ModelNo from EVALUATE_CATALOG where ModelType = '010' or ModelType = '080') "+
		 		" and UserID = '"+sFromUserID+"' "+
		 		" and OrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update EVALUATE_RECORD set "+
		 		" CognUserID = '"+sToUserID+"', "+
		 		" CognOrgID = '"+sToOrgID+"' " +
		 		" where ObjectType='Customer' "+
		 		" and ObjectNo = '"+sCustomerID+"'" +
		 		" and ModelNo in (select ModelNo from EVALUATE_CATALOG where ModelType = '010' or ModelType = '080') "+
		 		" and CognUserID = '"+sFromUserID+"' "+
		 		" and CognOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update EVALUATE_RECORD set "+
		 		" CognUserID2 = '"+sToUserID+"', "+
		 		" CognUserName2 = '"+sToUserName+"' " +
		 		" where ObjectType='Customer' "+
		 		" and ObjectNo = '"+sCustomerID+"'" +
		 		" and ModelNo in (select ModelNo from EVALUATE_CATALOG where ModelType = '010' or ModelType = '080') "+
		 		" and CognUserID2 = '"+sFromUserID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update EVALUATE_RECORD set "+
		 		" CognUserID3 = '"+sToUserID+"', "+
		 		" CognUserName3 = '"+sToUserName+"' " +
		 		" where ObjectType='Customer' "+
		 		" and ObjectNo = '"+sCustomerID+"'" +
		 		" and ModelNo in (select ModelNo from EVALUATE_CATALOG where ModelType='010') "+
		 		" and CognUserID3 = '"+sFromUserID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update EVALUATE_RECORD set "+
		 		" CognUserID4 = '"+sToUserID+"', "+
		 		" CognUserName4 = '"+sToUserName+"' " +
		 		" where ObjectType='Customer' "+
		 		" and ObjectNo = '"+sCustomerID+"'" +
		 		" and ModelNo in (select ModelNo from EVALUATE_CATALOG where ModelType='010') "+
		 		" and CognUserID4 = '"+sFromUserID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);
	 } 
	 
	 //���·���Ԥ���ź�����
	 private void UpdateRiskSignal(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update RISK_SIGNAL set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where ObjectType = 'Customer' "+
		 		" and ObjectNo = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update RISKSIGNAL_OPINION set "+
		 		" CheckUser = '"+sToUserID+"', "+
		 		" CheckOrg = '"+sToOrgID+"' " +		 		
		 		" where ObjectNo in (select SerialNo from RISK_SIGNAL where ObjectType = 'Customer' and ObjectNo = '"+sCustomerID+"') "+
		 		" and CheckUser = '"+sFromUserID+"' "+
		 		" and CheckOrg = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update RISKSIGNAL_OPINION set "+
		 		" NextCheckUser = '"+sToUserID+"' "+			 		
		 		" where ObjectNo in (select SerialNo from RISK_SIGNAL where ObjectType = 'Customer' and ObjectNo = '"+sCustomerID+"') "+
		 		" and NextCheckUser = '"+sFromUserID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);
	 } 
	 	 
	 
	 //******************�������*******************	 
	 //���˸ſ���
	 private void UpdateIndInfo(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update IND_INFO set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);
		 
		 sSql = " update IND_INFO set "+
		 		" UpdateUserID = '"+sToUserID+"', "+
		 		" UpdateOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and UpdateUserID = '"+sFromUserID+"' "+
		 		" and UpdateOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);
	 } 
	 	 
	 //������ż����ͥ��Ա������͹�˾�๫��UpdateCustomerRelative��
	 	 
     //����ѧҵ����
	 private void UpdateIndEducation(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update IND_EDUCATION set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
     //���˹�������
	 private void UpdateIndResume(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update IND_RESUME set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
     
	 //	���˴��¼�(ͬ��˾�๫��UpdateCustomerMemo)
	 
	 //�����ṩ�������(ͬ��˾�๫��UpdateDocLibrary)
	 
	 //��ᱣ�ա��Ʋ����ա����ٱ���
	 private void UpdateIndSi(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update IND_SI set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
	 //�����ʲ����
	 private void UpdateCustomerRealty(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_REALTY set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
     //�����ʲ����
	 private void UpdateCustomerVehicle(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_VEHICLE set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	 
	 } 
	 
	 //���й�Ʊ��Ϣ��ͬ��˾�๫��UpdateCustomerStock��
	 
     //����ծȯ��Ϣ��ͬ��˾�๫��UpdateCustomerBond��
	 
	 //Ͷ����ҵ�����ͬ��˾�๫��UpdateCustomerRelative��
	 
     //��˰��Ϣ��ͬ��˾����UpdateCustomerTaxPaying��
	 
     //�����ʲ���Ϣ��ͬ��˾����UpdateImaAsserts��
	 
     //�����ʲ���Ϣ
	 private void UpdateIndOasset(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update IND_OASSET set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	
	 }
	 
	 //������ծ��Ϣ
	 private void UpdateIndOdebt(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update IND_ODEBT set "+
		 		" InputUserID = '"+sToUserID+"', "+
		 		" InputOrgID = '"+sToOrgID+"', " +
		 		" UpdateDate = '"+sUpdateDate+"' "+
		 		" where CustomerID = '"+sCustomerID+"' "+
		 		" and InputUserID = '"+sFromUserID+"' "+
		 		" and InputOrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);	
	 }
	 
	 
	 //�������õȼ�������Ϣ
	 private void UpdateEvaluateRecordInd(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,Transaction Sqlca)
	    throws Exception
	 { 
		 String sSql = "";
		 sSql = " update EVALUATE_RECORD set "+
		 		" UserID = '"+sToUserID+"', "+
		 		" OrgID = '"+sToOrgID+"' " +
		 		" where ObjectType='Customer' "+
		 		" and ObjectNo = '"+sCustomerID+"'" +
		 		" and ModelNo in (select ModelNo from EVALUATE_CATALOG where ModelType = '015') "+
		 		" and UserID = '"+sFromUserID+"' "+
		 		" and OrgID = '"+sFromOrgID+"' ";
		 //ִ��ɾ�����
		 Sqlca.executeSQL(sSql);
	 } 
	 
	 
	 //���������ڻ���ҵ����ͬ��˾����UpdateCustomerOActivity��
	 
	 //�����������(ͬ��˾����UpdateCustomerAnarecord)
	 
	 	 
	 //***********************���ſͻ�***************************	 
	 //���Ÿſ���ͬUpdateCustomerInfo��
	 
	 //���ų�Ա��ͬUpdateCustomerRelative��
	 
}
