<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="com.amarsoft.impl.jsbank_als.Encode" %>

  
 
<%
   	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
   %>
	<%
		String PG_TITLE = "Ӱ���������ҳ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	/*
	  sAction ������Scanɨ�衢Query��ѯ��Print��ӡ
	  sPhaseType ����:Customer�ͻ��׶Ρ�BusinessApply ҵ�����������׶Ρ�BusinessApprove ҵ�������׶� ��BusinessApproveList �ȼ���ͬ�׶�
	  				 BusinessContractҵ���ͬ�׶Ρ�BusinessPutOut�ſ�׶Ρ�AfterLoan����׶Ρ�AfterLoanCustomer����ͻ���顢Recovery��ȫ�׶�
	  sSerialNo �������ͻ��š�ҵ������š�ҵ���ͬ��
	  sRight ��Ϊ���֣�һ�ִ�Listҳ��ֱ�Ӵ��룬��һ����ͨ����ͼ��������ѯ�Ƿ���Ȩ��
	*/
	
	//����������
	String sAction			= DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Action"));
	String sPhaseType		= DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType"));
	//�׶κ� ����׶Ρ��������˻ز�������
	//sPutoutNo ������Ϊ ApplyChange || false    ��ҵ�������봦Ϊ ApplyChange ����Ϊ false
	String sPhaseNo		= DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sSerialNo		= DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sRight		= DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Right"));
	String sPutoutNo   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PutoutNo"));  
	String sInspectNo   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InspectNo"));
	String sBARCODE   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BARCODE"));
	String sAfterloan = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("sAfterloan"));
	String sCustomerID ="",sBusinessSerialno="",sCustomerName="",
	sQuerTime="",sBusinessType="",sBusinessTypeName="",sBusinessContractNo="",sCustomerQuerTime="",sNewBusinessSerialno="",sNewQuerTime="";
	StringBuffer FSN  = new StringBuffer();//������ĳ���׶β������ļ�
	String BUSINESS_PHASE_NO ="";//���κ� ��ĳ���׶ε��ļ�ʱ�ּ���¼��ʱ����Ҫ���ò�����������
	String sManageDepartFlag ="";//ҵ������
	if("CustomerView".equals(sPhaseType)){//�ڿͻ�����ҳǩʱ�޷�����ͻ���ֻ��ͨ�����·�ʽ��ȡ�ͻ���,��������½׶��������в�ͬ
		sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
		sPhaseType ="Customer";
	}
	if(sPhaseType.endsWith("GuarantyContract")){//��ҵ����Ա�����˻��������ڵ�����ͬ�б��޸�
		sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantorID"));
		sBusinessSerialno = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
		sPhaseType ="Customer";//������ͬ�׶�ֻɨ�赣��������
	}

	if(sBARCODE == null || "".equals(sBARCODE)) sBARCODE = "";
	if(!"".equals(sBARCODE)){
	  FSN.append(sBARCODE);
	}
	if("".equals(sAfterloan)){
		sAfterloan="";
	}
%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=��ȡ�Խ�Ӱ���������Ϣ;]~*/
%>
<%
	//��ȡͬӰ��ƽ̨�Խӵ�������Ϣ
    String sScanUrl ="",sPrintUrl="",sViewUrl="",sAppID="",sUID="",sPWD="",sCopyUrl="";
	ASResultSet rs = null;
	HashMap map = new HashMap();
	String sSql = " Select ItemNo,ItemName from Code_Library where CodeNo='ImageConfig' and isinuse='1' ";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next()){
		String sItemNo = rs.getString("ItemNo");
		String sItemName = rs.getString("ItemName");
		map.put(sItemNo,sItemName);
	}
	rs.getStatement().close();
	sScanUrl = map.get("ScanUrl").toString();
	sPrintUrl = map.get("PrintUrl").toString();
	sViewUrl = map.get("ViewUrl").toString();
	sAppID = map.get("AppID").toString();
	sUID  = map.get("UID").toString();
	sPWD = map.get("PWD").toString();	
	sCopyUrl = map.get("CopyUrl").toString();
%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=ƴ�ӱ�����Ϣ;]~*/
%>
<%
	// ----------------------------------��ȡ�ͻ�/ҵ�����Begin-------------------------------------------------
   
    if("Customer".equals(sPhaseType)){//�ͻ��׶�---��ͻ�Ҫ�󵣱���ͬ�׶�ֻ��ɨ�赣���˵�Ӱ������
    	String sSql1 = " Select CustomerID,CustomerName,InputDate from Customer_Info where CustomerId='"+sSerialNo+"' ";
        rs = Sqlca.getASResultSet(sSql1); 
    	if(rs.next()){
        	 sCustomerID = rs.getString("CustomerID");
        	 sCustomerName = rs.getString("CustomerName");
        	 sQuerTime = rs.getString("InputDate");
         }
    	rs.getStatement().close();
    }else if("BusinessApply".equals(sPhaseType) || "BusinessApprove".equals(sPhaseType)|| "BusinessApproveList".equals(sPhaseType)){
    	if("BusinessApproveList".equals(sPhaseType)){
    		sSerialNo = Sqlca.getString("Select ba.Serialno from Business_apply ba,Business_Approve bap where ba.Serialno=bap.RelativeSerialNo and bap.Serialno='"+sSerialNo+"' ");
    	}
    	
    	String applySql = "Select SerialNo,CustomerID,CustomerName,InputDate,BusinessType,getBusinessName(BusinessType) as BusinessTypeName,ManageDepartFlag  from Business_Apply where Serialno='"+sSerialNo+"' ";
    	rs = Sqlca.getASResultSet(applySql);
    	if(rs.next()){
    		sBusinessSerialno = rs.getString("SerialNo");//���ͻ�������,��������info����ˮ�Űɱ�����ͬ��ȡҵ���������ˮ��	
    		sCustomerID = rs.getString("CustomerID");
    		sCustomerName = rs.getString("CustomerName");
    		sQuerTime = rs.getString("InputDate");//��ѯʱ��ÿ�α�����ͬ ��ȡҵ�������¼��ʱ��
    		sBusinessType = rs.getString("BusinessType");
    		sBusinessTypeName = rs.getString("BusinessTypeName");
    		 sManageDepartFlag = rs.getString("ManageDepartFlag");
    	}
    	rs.getStatement().close();
    } else if("BusinessContract".equals(sPhaseType)||"BusinessPutOut".equals(sPhaseType) ||"PutOutApprove".equals(sPhaseType) || "AfterLoan".equals(sPhaseType) || "Recovery".equals(sPhaseType)){
    	sBusinessContractNo = sSerialNo;//Ϊ�˷���Ӱ��ϵͳ���ݲ�ѯ�ഫһ����ͬ��
    	String contractSql = "Select ba.ManageDepartFlag,ba.InputDate as InputDate ,ba.BusinessType as BusinessType,ba.SerialNo as SerialNo,ba.CustomerID as CustomerID,ba.CustomerName as CustomerName,getBusinessName(ba.BusinessType) as BusinessTypeName "+
    	                     " from Business_Contract bc,Business_Approve bap,Business_Apply ba where bc.RelativeSerialno=bap.Serialno and bap.RelativeSerialNo=ba.SerialNo and  bc.Serialno='"+sSerialNo+"' ";
    	
    	rs = Sqlca.getASResultSet(contractSql);
    	int RowCount =rs.getRowCount();
    	if(rs.next()){
    		sBusinessSerialno = rs.getString("SerialNo");//���ͻ�������,��������info����ˮ�Űɱ�����ͬ��ȡҵ���������ˮ��
    		sCustomerID = rs.getString("CustomerID");
    		sCustomerName = rs.getString("CustomerName");
    		sQuerTime = rs.getString("InputDate");//��ѯʱ��ÿ�α�����ͬ ��ȡҵ�������¼��ʱ��
    		sBusinessType = rs.getString("BusinessType");
    		sBusinessTypeName = rs.getString("BusinessTypeName");
    		sManageDepartFlag = rs.getString("ManageDepartFlag");
    	}
    	rs.getStatement().close();
    	if(RowCount==0){//˵���ú�ͬΪ���Ǻ�ͬû������������Ϣ����ֻ�ܴӸú�ͬ�л�ȡ
    	 String reinforceContractSql =" Select ManageDepartFlag,InputDate,BusinessType,getBusinessName(BusinessType) as BusinessTypeName,SerialNo,CustomerID,CustomerName "+
    	                    " from Business_Contract where SerialNo ='"+sSerialNo+"' ";
    	 rs = Sqlca.getASResultSet(reinforceContractSql);
    	 if(rs.next()){
    		sBusinessSerialno = rs.getString("SerialNo");//���ͻ�������,��������info����ˮ�Űɱ�����ͬ��ȡҵ���������ˮ��
        	sCustomerID = rs.getString("CustomerID");
        	sCustomerName = rs.getString("CustomerName");
        	sQuerTime = rs.getString("InputDate");//��ѯʱ��ÿ�α�����ͬ ��ȡҵ�������¼��ʱ��
        	sBusinessType = rs.getString("BusinessType");
        	sBusinessTypeName = rs.getString("BusinessTypeName");
        	sManageDepartFlag = rs.getString("ManageDepartFlag");
    	 }
    	 rs.getStatement().close();
    	}
    } else if ("AdheringMotion".equals(sPhaseType)){//add by xlsun date 2013-08-09
    	String sSqlAdheringMotion = " Select ar.Serialno,ba.Customerid,ar.Objectno,ba.InputDate from Apply_Relative ar,Business_Apply ba where ba.Serialno = ar.Objectno and ar.Objectno = '"+sSerialNo+"' and ar.Objecttype = 'AdheringMotion'";
        rs = Sqlca.getASResultSet(sSqlAdheringMotion); 
       	if(rs.next()){
	   		sBusinessSerialno = rs.getString("Objectno");
	   		sCustomerID = rs.getString("Customerid");
	   		sNewBusinessSerialno =  rs.getString("Serialno");
	   		sQuerTime = rs.getString("InputDate");
         }
         rs.getStatement().close();
    	 sSqlAdheringMotion = " Select ba.InputDate from Business_Apply ba where ba.Serialno = '"+sNewBusinessSerialno+"'";
         rs = Sqlca.getASResultSet(sSqlAdheringMotion); 
    	 if(rs.next()){
    		sNewQuerTime = rs.getString("InputDate");
         }
         sNewQuerTime = sNewQuerTime.replace("/","");
         rs.getStatement().close();
    
    }
     if("AfterLoanCustomer".equals(sPhaseType)){
     	sCustomerID = sSerialNo;
    	sBusinessSerialno = "I"+sInspectNo;
    	sQuerTime = Sqlca.getString("SELECT INPUTDATE FROM Inspect_info where Serialno='"+sInspectNo+"'");
    	sQuerTime = sQuerTime.replace("/","");
    }
    sQuerTime = sQuerTime.replace("/","");//�޸Ĳ�ѯʱ��ĸ�ʽΪYYYYMMDD
    sCustomerQuerTime = Sqlca.getString("SELECT inputdate FROM customer_info where customerid='"+sCustomerID+"'");;
    sCustomerQuerTime=sCustomerQuerTime.replace("/","");
 // ----------------------------------��ȡ�ͻ�/ҵ�����End-------------------------------------------------
   
 // ----------------------------------��ȡӰ��Ȩ��Begin-------------------------------------------------
    if(sRight == null ||sRight.length()==0){//�������ͼʱ��ѯȨ�ޣ������ͨ���б�ʱȨ�����ⲿ����
    	 String sSql2 = "Select ImageRight from User_Info where UserID = '"+CurUser.UserID+"' ";
    	   String sUserRight = Sqlca.getString(sSql2);
    	if(sUserRight == null || sUserRight.length()==0){
    	   String sSql3 = " Select ri.ImageRight from Role_Info ri,User_Role ur,User_Info ui "+
    	                  " where ri.RoleID like 'I%' and ur.UserID = ui.UserID and ri.RoleID = ur.RoleID "+
    	                  " and ui.UserID = '"+CurUser.UserID+"' ";
    	    String sRoleRight = Sqlca.getString(sSql3);
    	   	 sRight = sRoleRight;
    	 }else{
    	  	 sRight  = sUserRight;
    	     }
    }
    if(sRight == null ||sRight.length()==0){
%>
    	<script>
    	alert("�Բ�����û��Ӱ��Ȩ�ޣ�");
    	self.close();	
    	</script>
    	<%
    		}
    	     if("Query".equals(sAction)){//�鿴Ӱ��ʱ����Ҫɨ��Ȩ��
    	    	 sRight = "01000001";
    	     }
    	  // ----------------------------------��ȡӰ��Ȩ��End-------------------------------------------------
    	     
    	   // ----------------------------------��ȡ�ļ��ȼ�Begin-------------------------------------------------
    	     StringBuffer sFileLevel = new StringBuffer();
    	     /*��ȡ�ļ��ȼ�
    	                 �ļ��ȼ����ɿͻ����ϵȼ���ҵ�����ϵȼ���ϵ�
    	     */
    	     //����ҵ���ҵ��Ʒ�ֵ����߶�����Ϊ�Թ�����
    	     if(sBusinessType.startsWith("30")){
    	     	sManageDepartFlag = "001001";
    	     }
    	     
    	     String sCustomerFlielevel ="",sBusinessFileLevel="";
    	     if("Customer".equals(sPhaseType) || "BusinessApply".equals(sPhaseType) || "BusinessApprove".equals(sPhaseType)|| "BusinessApproveList".equals(sPhaseType)||"BusinessContract".equals(sPhaseType)||"BusinessPutOut".equals(sPhaseType) ||"PutOutApprove".equals(sPhaseType)
    	    		 ||"AfterLoan".equals(sPhaseType)||"AfterLoanCustomer".equals(sPhaseType)||"Recovery".equals(sPhaseType)){
    	    	 //���ݿͻ����ͻ�ȡ�ļ��ȼ�
    	    	 sCustomerFlielevel = Sqlca.getString("Select cl.BankNo from Customer_Info ci,Code_library cl where cl.codeno='FlieLevel' and cl.ItemNo=substr(ci.CustomerType,1,2) and ci.CustomerID='"+sCustomerID+"' ");
    	    	 if("001002".equals(sManageDepartFlag)){//��С��ҵ���ڲ�
    	    		 sCustomerFlielevel = Sqlca.getString("Select BankNo from code_library where codeno ='FlieLevel'  and ItemNo='001002' and ItemName='TX' "); 
    	    	 }else if("001003".equals(sManageDepartFlag)){
    	    		 sCustomerFlielevel = Sqlca.getString("Select BankNo from code_library where codeno ='FlieLevel'  and ItemNo='001003' and ItemName='TX' ");  
    	    	 }
    	    	 //�ͻ��׶ε��ļ��ȼ�����С��΢С�Ŀͻ����ϵ�������һ���ļ��ȼ���
    	    	 sFileLevel.append(sCustomerFlielevel);
    	     }
    	     if("001001".equals(sManageDepartFlag)&&("BusinessApply".equals(sPhaseType) || "BusinessApprove".equals(sPhaseType)|| "BusinessApproveList".equals(sPhaseType)||"BusinessContract".equals(sPhaseType)||"BusinessPutOut".equals(sPhaseType)||"PutOutApprove".equals(sPhaseType)||("AfterLoan").equals(sPhaseType)||"AfterLoanCustomer".equals(sPhaseType) || "Recovery".equals(sPhaseType))){
    	    	 sBusinessFileLevel = Sqlca.getString("Select BankNo from code_library where codeno='FlieLevel' and ItemName='BusinessType' and (ItemNo='"+sBusinessType+"' or ItemNo=substr('"+sBusinessType+"',1,4))");
    	    	//�����ҵ��û�л��ֵȼ�
    	    	 if(sBusinessFileLevel !=null)sFileLevel.append(",").append(sBusinessFileLevel);
    	     }
    	   //----------------------------------��ȡ�ļ��ȼ�End-------------------------------------------------
    	    
    	  // 10.67.128.224
    	     //-------------��ȡ�ſ�׶��޶����ļ����ͺ����κ�
    	    if("BusinessPutOut".equals(sPhaseType)&&"Scan".equals(sAction)&&"1040".equals(sPhaseNo)){
    	    	//rs = Sqlca.getASResultSet("Select SortNo from code_library where codeno='PhaseFlieTypeCheck' and ItemName='"+sPhaseType+"' ");
    	    	//rs = Sqlca.getASResultSet("Select SortNo from code_library where codeno='PhaseFlieTypeCheck' and ItemName='"+sPhaseType+"' and isinuse='1' and itemdescribe='"+sManageDepartFlag+"' and (itemattribute=substr('"+sBusinessType+"',1,4) or substr('"+sBusinessType+"',1,4) like '%'||itemattribute||'%')");
    	    	 	rs = Sqlca.getASResultSet("Select SortNo from code_library where codeno='PhaseFlieTypeCheck' and ItemName='"+sPhaseType+"' and isinuse='1' and itemdescribe='"+sManageDepartFlag+"' and (itemattribute=substr('"+sBusinessType+"',1,4) or trim(itemattribute) = '%')");
    	    	while(rs.next()){
    	    		FSN.append(rs.getString(1)).append(",");
    	    	}
    	    	rs.getStatement().close();
    	    	BUSINESS_PHASE_NO = sPhaseNo;
    	    }
    	 
    	     //----------------------------------��ȡ��ɨ���ļ�����End-------------------------------------------------
    	     

    	     //--SENDBACK_MODIFY
    	     //----------------------------------��ȡɨ���ļ�����Begin-----��ҵ���������ʱ�ڡ��˻ز������ϡ���Ҫ���������-------------------
    	    String sSENDBACK_MODIFY ="";
    	     if("1030".equals(sPhaseNo)){
    	    	  sSENDBACK_MODIFY = "Y";
    	     }
    	     //----------------------------------��ȡɨ���ļ�����Begin-----��ȡ��ĳһ���׶��޶�¼����ļ�-------------------
    	        
    	    //----------------------------------ƴ�ӱ���Begin-------------------------------------------------
    	    StringBuffer paramData = new StringBuffer();
    	    StringBuffer action = new StringBuffer();
    	    String targetURL = "";	
    	    String sNewPhaseType = "";
    	    com.amarsoft.impl.jsbank_als.Encode encode = new com.amarsoft.impl.jsbank_als.Encode();//��urlת��Ϊutf-8
    	    //�ж�Ӱ���url��ַ
    	    if("Scan".equals(sAction)){
    	    	targetURL = sScanUrl;
    	    }else if("Print".equals(sAction)){
    	    	targetURL = sPrintUrl;
    	    }else if("CopyUrl".equals(sAction)){
    	    	targetURL = sCopyUrl;
    	    }else{
    	    	targetURL = sViewUrl;
    	    }
    	    paramData.append("UID=").append(sUID);
    	    paramData.append("&PWD=").append(sPWD);
    	    paramData.append("&AppID=").append(sAppID);
    	    paramData.append("&UserID=").append(CurUser.UserID);
    	    paramData.append("&UserName=").append(encode.encode(CurUser.UserName));
    	    paramData.append("&OrgID=").append(CurUser.OrgID);
    	    paramData.append("&OrgName=").append(encode.encode(CurOrg.OrgName));
    	    sCustomerName = encode.encode(sCustomerName);
    	    sBusinessTypeName = encode.encode(sBusinessTypeName);
    	    
    	    //�ͻ����ϸ����׶ζ����Բ鿴
    	    if("Customer".equals(sPhaseType) ||"BusinessApply".equals(sPhaseType) || "BusinessApprove".equals(sPhaseType)|| "BusinessApproveList".equals(sPhaseType) ||"BusinessContract".equals(sPhaseType)||"BusinessPutOut".equals(sPhaseType) ||"PutOutApprove".equals(sPhaseType)
    	    		|| ("AfterLoan".equals(sPhaseType) && "ALL".equals(sAfterloan)) ||"Recovery".equals(sPhaseType)){//�ͻ��׶�
    	    	sNewPhaseType = sPhaseType;
    	    	if("PutOut".equals(sPhaseNo) || "ApplyChange".equals(sPutoutNo)){
    	    		sPhaseType = "";
    	    	}
    	    	paramData.append("&info1=BUSI_SERIAL_NO:").append(sCustomerID).append(";OBJECT_NAME:").append("XD_1001").
    	    			  append(";QUERY_TIME:").append(sCustomerQuerTime).append(";RIGHT:").append(sRight).append(";FL:").
    	    			  append(sFileLevel).append(";CUSTOMER_ID:").append(sCustomerID).append(";CUSTOMER_NAME:").
    	    			  append(sCustomerName).append(";BUSINESS_APPLY_SERIALNO:").append(sBusinessSerialno).
    	    			  append(";BUSINESS_PHASE:").append(sPhaseType).append(";SENDBACK_MODIFY:").append(sSENDBACK_MODIFY).append(";FSN:").append(FSN);
    	    	sPhaseType = sNewPhaseType;
    	    			  
    	    }
    	    if("BusinessApply".equals(sPhaseType) || "BusinessApprove".equals(sPhaseType)|| "BusinessApproveList".equals(sPhaseType)||"BusinessContract".equals(sPhaseType)||"BusinessPutOut".equals(sPhaseType) ||"PutOutApprove".equals(sPhaseType)
    	    		 || ("AfterLoan".equals(sPhaseType) && "ALL".equals(sAfterloan))||"Recovery".equals(sPhaseType)){//ҵ��׶�    add by xlsun  ȥ������׶α�־��������ʾ������
    	    	sNewPhaseType = sPhaseType;
    	    	if("PutOut".equals(sPhaseNo) || "ApplyChange".equals(sPutoutNo)){
    	    		sPhaseType = "";
    	    	}
    	    	paramData.append("&info2=BUSI_SERIAL_NO:").append(sBusinessSerialno).append(";OBJECT_NAME:").append("XD_1002").append(";QUERY_TIME:").append(sQuerTime).append(";RIGHT:").append(sRight).append(";FL:").append(sFileLevel).append(";BUSITYPE_ID:").append(sBusinessType).append(";BUSITYPE_NAME:").append(sBusinessTypeName).append(";CUSTOMER_ID:").append(sCustomerID).append(";CUSTOMER_NAME:").append(sCustomerName).append(";BUSINESS_PHASE:").append(sPhaseType).append(";Business_ContractNo:").append(sBusinessContractNo).append(";SENDBACK_MODIFY:").append(sSENDBACK_MODIFY).append(";FSN:").append(FSN);
    	    	paramData.append("&info3=BUSI_SERIAL_NO:").append(sBusinessSerialno).append(";OBJECT_NAME:").append("XD_1003").append(";QUERY_TIME:").append(sQuerTime).append(";RIGHT:").append(sRight).append(";FL:").append(sFileLevel).append(";CUSTOMER_ID:").append(sCustomerID).append(";CUSTOMER_NAME:").append(sCustomerName).append(";BUSINESS_PHASE:").append(sPhaseType).append(";Business_ContractNo:").append(sBusinessContractNo).append(";SENDBACK_MODIFY:").append(sSENDBACK_MODIFY).append(";FSN:").append(FSN);
    	    	paramData.append("&info4=BUSI_SERIAL_NO:").append(sBusinessSerialno).append(";OBJECT_NAME:").append("XD_1004").append(";QUERY_TIME:").append(sQuerTime).append(";RIGHT:").append(sRight).append(";FL:").append(sFileLevel).append(";CUSTOMER_ID:").append(sCustomerID).append(";CUSTOMER_NAME:").append(sCustomerName).append(";BUSINESS_PHASE:").append(sPhaseType).append(";Business_ContractNo:").append(sBusinessContractNo).append(";SENDBACK_MODIFY:").append(sSENDBACK_MODIFY).append(";FSN:").append(FSN);
    	    	sPhaseType = sNewPhaseType;
    	    }
    	   if(("AfterLoan".equals(sPhaseType) && sInspectNo == null)||"Recovery".equals(sPhaseType)){//�������׶�
    	    	paramData.append("&info5=BUSI_SERIAL_NO:").append(sBusinessSerialno).append(";OBJECT_NAME:").append("XD_1005").append(";QUERY_TIME:").append(sQuerTime).append(";RIGHT:").append(sRight).append(";FL:").append(sFileLevel).append(";CUSTOMER_ID:").append(sCustomerID).append(";CUSTOMER_NAME:").append(sCustomerName).append(";BUSINESS_PHASE:").append(sPhaseType).append(";Business_ContractNo:").append(sBusinessContractNo).append(";SENDBACK_MODIFY:").append(sSENDBACK_MODIFY).append(";FSN:").append(FSN);
    	    }
    	    if("AfterLoanCustomer".equals(sPhaseType)){
    	    	paramData.append("&info7=BUSI_SERIAL_NO:").append(sBusinessSerialno).append(";OBJECT_NAME:").append("XD_1007").append(";QUERY_TIME:").append(sQuerTime).append(";RIGHT:").append(sRight).append(";FL:").append(sFileLevel).append(";CUSTOMER_ID:").append(sCustomerID).append(";CUSTOMER_NAME:").append(sCustomerName).append(";BUSINESS_PHASE:").append(sPhaseType).append(";Business_ContractNo:").append(sBusinessContractNo).append(";SENDBACK_MODIFY:").append(sSENDBACK_MODIFY).append(";FSN:").append(FSN);
    	    }
    	   if("Recovery".equals(sPhaseType)){//��ȫ�׶�
    	   
    	    	paramData.append("&info6=BUSI_SERIAL_NO:").append(sBusinessSerialno).append(";OBJECT_NAME:").append("XD_1006").append(";QUERY_TIME:").append(sQuerTime).append(";RIGHT:").append(sRight).append(";FL:").append(sFileLevel).append(";CUSTOMER_ID:").append(sCustomerID).append(";CUSTOMER_NAME:").append(sCustomerName).append(";BUSINESS_PHASE:").append(sPhaseType).append(";Business_ContractNo:").append(sBusinessContractNo).append(";SENDBACK_MODIFY:").append(sSENDBACK_MODIFY).append(";FSN:").append(FSN);
    	    }
    	      if("AdheringMotion".equals(sPhaseType)){
    			paramData.append("&info1=BUSI_SERIAL_NO:").append(sCustomerID).append(";OBJECT_NAME:").append("XD_1001").
    			  append(";QUERY_TIME:").append(sCustomerQuerTime);
    			paramData.append("&info2=BUSI_SERIAL_NO:").append(sBusinessSerialno).append(";OBJECT_NAME:").append("XD_1002").append(";QUERY_TIME:").append(sQuerTime).append(";NEW_BUSI_SERIAL_NO:").append(sNewBusinessSerialno).append(";NEW_QUERY_TIME:").append(sNewQuerTime);
    	    	paramData.append("&info3=BUSI_SERIAL_NO:").append(sBusinessSerialno).append(";OBJECT_NAME:").append("XD_1003").append(";QUERY_TIME:").append(sQuerTime).append(";NEW_BUSI_SERIAL_NO:").append(sNewBusinessSerialno).append(";NEW_QUERY_TIME:").append(sNewQuerTime);
    	    	paramData.append("&info4=BUSI_SERIAL_NO:").append(sBusinessSerialno).append(";OBJECT_NAME:").append("XD_1004").append(";QUERY_TIME:").append(sQuerTime).append(";NEW_BUSI_SERIAL_NO:").append(sNewBusinessSerialno).append(";NEW_QUERY_TIME:").append(sNewQuerTime);
    	    	paramData.append("&info5=BUSI_SERIAL_NO:").append(sBusinessSerialno).append(";OBJECT_NAME:").append("XD_1005").append(";QUERY_TIME:").append(sQuerTime).append(";NEW_BUSI_SERIAL_NO:").append(sNewBusinessSerialno).append(";NEW_QUERY_TIME:").append(sNewQuerTime);
    	    	paramData.append("&info6=BUSI_SERIAL_NO:").append(sBusinessSerialno).append(";OBJECT_NAME:").append("XD_1006").append(";QUERY_TIME:").append(sQuerTime).append(";NEW_BUSI_SERIAL_NO:").append(sNewBusinessSerialno).append(";NEW_QUERY_TIME:").append(sNewQuerTime);
    	   }
    		//ƴ��action
    		action.append(targetURL).append("?").append(paramData);
    		System.out.println(action.toString());
    	    //----------------------------------ƴ�ӱ���End-------------------------------------------------
    		
    		StringBuffer formData = new StringBuffer();
    		formData.append("<html>");
    		formData.append("  <head>");
    		formData.append("    <title>").append(PG_TITLE).append("</title>");
    		formData.append("<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />");
    		formData.append("  </head>");
    		formData.append("  <body>");
    		formData.append("    <form id=\"ImageForm\" name=\"ImageForm\" method=\"post\" action=\"").append(action).append("\" target=\"_self\">");
    		formData.append("    </form>");
    		formData.append("  </body>");
    		formData.append("</html>");
    		formData.append("<script language=javascript>");
    		formData.append("   document.forms(\"ImageForm\").submit();");
    		formData.append("</script>");
    		out.println(formData.toString());
    	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>

<%@ include file="/IncludeEnd.jsp"%>