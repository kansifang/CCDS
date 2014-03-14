<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="com.amarsoft.impl.jsbank_als.Encode" %>

  
 
<%
   	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
   %>
	<%
		String PG_TITLE = "影像操作管理页面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	/*
	  sAction 包括：Scan扫描、Query查询、Print打印
	  sPhaseType 包括:Customer客户阶段、BusinessApply 业务申请审批阶段、BusinessApprove 业务批复阶段 、BusinessApproveList 等级合同阶段
	  				 BusinessContract业务合同阶段、BusinessPutOut放款阶段、AfterLoan贷后阶段、AfterLoanCustomer贷后客户检查、Recovery保全阶段
	  sSerialNo 包括：客户号、业务申请号、业务合同号
	  sRight 分为两种，一种从List页面直接传入，另一种是通过树图点击进入查询是否有权限
	*/
	
	//获得组件参数
	String sAction			= DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Action"));
	String sPhaseType		= DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType"));
	//阶段号 申请阶段、审批、退回补充资料
	//sPutoutNo 的内容为 ApplyChange || false    在业务变更申请处为 ApplyChange 否则为 false
	String sPhaseNo		= DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sSerialNo		= DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sRight		= DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Right"));
	String sPutoutNo   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PutoutNo"));  
	String sInspectNo   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InspectNo"));
	String sBARCODE   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BARCODE"));
	String sAfterloan = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("sAfterloan"));
	String sCustomerID ="",sBusinessSerialno="",sCustomerName="",
	sQuerTime="",sBusinessType="",sBusinessTypeName="",sBusinessContractNo="",sCustomerQuerTime="",sNewBusinessSerialno="",sNewQuerTime="";
	StringBuffer FSN  = new StringBuffer();//控制在某个阶段操作的文件
	String BUSINESS_PHASE_NO ="";//批次号 当某个阶段的文件时分几批录入时，需要传该参数以作区分
	String sManageDepartFlag ="";//业务条线
	if("CustomerView".equals(sPhaseType)){//在客户详情页签时无法出入客户号只能通过以下方式获取客户号,此种情况下阶段类型略有不同
		sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
		sPhaseType ="Customer";
	}
	if(sPhaseType.endsWith("GuarantyContract")){//因业务人员担保人基础资料在担保合同列表修改
		sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantorID"));
		sBusinessSerialno = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
		sPhaseType ="Customer";//担保合同阶段只扫描担保人资料
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
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=获取对接影像的配置信息;]~*/
%>
<%
	//获取同影像平台对接的配置信息
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
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=拼接报文信息;]~*/
%>
<%
	// ----------------------------------获取客户/业务参数Begin-------------------------------------------------
   
    if("Customer".equals(sPhaseType)){//客户阶段---因客户要求担保合同阶段只能扫描担保人的影像资料
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
    		sBusinessSerialno = rs.getString("SerialNo");//除客户资料外,其他所有info的流水号吧必须相同都取业务申请的流水号	
    		sCustomerID = rs.getString("CustomerID");
    		sCustomerName = rs.getString("CustomerName");
    		sQuerTime = rs.getString("InputDate");//查询时间每次必须相同 都取业务申请的录入时间
    		sBusinessType = rs.getString("BusinessType");
    		sBusinessTypeName = rs.getString("BusinessTypeName");
    		 sManageDepartFlag = rs.getString("ManageDepartFlag");
    	}
    	rs.getStatement().close();
    } else if("BusinessContract".equals(sPhaseType)||"BusinessPutOut".equals(sPhaseType) ||"PutOutApprove".equals(sPhaseType) || "AfterLoan".equals(sPhaseType) || "Recovery".equals(sPhaseType)){
    	sBusinessContractNo = sSerialNo;//为了方便影像系统数据查询多传一个合同号
    	String contractSql = "Select ba.ManageDepartFlag,ba.InputDate as InputDate ,ba.BusinessType as BusinessType,ba.SerialNo as SerialNo,ba.CustomerID as CustomerID,ba.CustomerName as CustomerName,getBusinessName(ba.BusinessType) as BusinessTypeName "+
    	                     " from Business_Contract bc,Business_Approve bap,Business_Apply ba where bc.RelativeSerialno=bap.Serialno and bap.RelativeSerialNo=ba.SerialNo and  bc.Serialno='"+sSerialNo+"' ";
    	
    	rs = Sqlca.getASResultSet(contractSql);
    	int RowCount =rs.getRowCount();
    	if(rs.next()){
    		sBusinessSerialno = rs.getString("SerialNo");//除客户资料外,其他所有info的流水号吧必须相同都取业务申请的流水号
    		sCustomerID = rs.getString("CustomerID");
    		sCustomerName = rs.getString("CustomerName");
    		sQuerTime = rs.getString("InputDate");//查询时间每次必须相同 都取业务申请的录入时间
    		sBusinessType = rs.getString("BusinessType");
    		sBusinessTypeName = rs.getString("BusinessTypeName");
    		sManageDepartFlag = rs.getString("ManageDepartFlag");
    	}
    	rs.getStatement().close();
    	if(RowCount==0){//说明该合同为补登合同没有申请审批信息所以只能从该合同中获取
    	 String reinforceContractSql =" Select ManageDepartFlag,InputDate,BusinessType,getBusinessName(BusinessType) as BusinessTypeName,SerialNo,CustomerID,CustomerName "+
    	                    " from Business_Contract where SerialNo ='"+sSerialNo+"' ";
    	 rs = Sqlca.getASResultSet(reinforceContractSql);
    	 if(rs.next()){
    		sBusinessSerialno = rs.getString("SerialNo");//除客户资料外,其他所有info的流水号吧必须相同都取业务申请的流水号
        	sCustomerID = rs.getString("CustomerID");
        	sCustomerName = rs.getString("CustomerName");
        	sQuerTime = rs.getString("InputDate");//查询时间每次必须相同 都取业务申请的录入时间
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
    sQuerTime = sQuerTime.replace("/","");//修改查询时间的格式为YYYYMMDD
    sCustomerQuerTime = Sqlca.getString("SELECT inputdate FROM customer_info where customerid='"+sCustomerID+"'");;
    sCustomerQuerTime=sCustomerQuerTime.replace("/","");
 // ----------------------------------获取客户/业务参数End-------------------------------------------------
   
 // ----------------------------------获取影像权限Begin-------------------------------------------------
    if(sRight == null ||sRight.length()==0){//当点击树图时查询权限，如果是通过列表时权限由外部传入
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
    	alert("对不起，您没有影像权限！");
    	self.close();	
    	</script>
    	<%
    		}
    	     if("Query".equals(sAction)){//查看影像时不需要扫描权限
    	    	 sRight = "01000001";
    	     }
    	  // ----------------------------------获取影像权限End-------------------------------------------------
    	     
    	   // ----------------------------------获取文件等级Begin-------------------------------------------------
    	     StringBuffer sFileLevel = new StringBuffer();
    	     /*获取文件等级
    	                 文件等级是由客户资料等级与业务资料等级组合的
    	     */
    	     //授信业务的业务品种的条线都设置为对公条线
    	     if(sBusinessType.startsWith("30")){
    	     	sManageDepartFlag = "001001";
    	     }
    	     
    	     String sCustomerFlielevel ="",sBusinessFileLevel="";
    	     if("Customer".equals(sPhaseType) || "BusinessApply".equals(sPhaseType) || "BusinessApprove".equals(sPhaseType)|| "BusinessApproveList".equals(sPhaseType)||"BusinessContract".equals(sPhaseType)||"BusinessPutOut".equals(sPhaseType) ||"PutOutApprove".equals(sPhaseType)
    	    		 ||"AfterLoan".equals(sPhaseType)||"AfterLoanCustomer".equals(sPhaseType)||"Recovery".equals(sPhaseType)){
    	    	 //根据客户类型获取文件等级
    	    	 sCustomerFlielevel = Sqlca.getString("Select cl.BankNo from Customer_Info ci,Code_library cl where cl.codeno='FlieLevel' and cl.ItemNo=substr(ci.CustomerType,1,2) and ci.CustomerID='"+sCustomerID+"' ");
    	    	 if("001002".equals(sManageDepartFlag)){//中小企业金融部
    	    		 sCustomerFlielevel = Sqlca.getString("Select BankNo from code_library where codeno ='FlieLevel'  and ItemNo='001002' and ItemName='TX' "); 
    	    	 }else if("001003".equals(sManageDepartFlag)){
    	    		 sCustomerFlielevel = Sqlca.getString("Select BankNo from code_library where codeno ='FlieLevel'  and ItemNo='001003' and ItemName='TX' ");  
    	    	 }
    	    	 //客户阶段的文件等级（中小、微小的客户资料单独列了一个文件等级）
    	    	 sFileLevel.append(sCustomerFlielevel);
    	     }
    	     if("001001".equals(sManageDepartFlag)&&("BusinessApply".equals(sPhaseType) || "BusinessApprove".equals(sPhaseType)|| "BusinessApproveList".equals(sPhaseType)||"BusinessContract".equals(sPhaseType)||"BusinessPutOut".equals(sPhaseType)||"PutOutApprove".equals(sPhaseType)||("AfterLoan").equals(sPhaseType)||"AfterLoanCustomer".equals(sPhaseType) || "Recovery".equals(sPhaseType))){
    	    	 sBusinessFileLevel = Sqlca.getString("Select BankNo from code_library where codeno='FlieLevel' and ItemName='BusinessType' and (ItemNo='"+sBusinessType+"' or ItemNo=substr('"+sBusinessType+"',1,4))");
    	    	//如果该业务没有划分等级
    	    	 if(sBusinessFileLevel !=null)sFileLevel.append(",").append(sBusinessFileLevel);
    	     }
    	   //----------------------------------获取文件等级End-------------------------------------------------
    	    
    	  // 10.67.128.224
    	     //-------------获取放款阶段限定的文件类型和批次号
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
    	 
    	     //----------------------------------获取和扫描文件类型End-------------------------------------------------
    	     

    	     //--SENDBACK_MODIFY
    	     //----------------------------------获取扫描文件类型Begin-----当业务审查审批时在“退回补充资料”需要传这个参数-------------------
    	    String sSENDBACK_MODIFY ="";
    	     if("1030".equals(sPhaseNo)){
    	    	  sSENDBACK_MODIFY = "Y";
    	     }
    	     //----------------------------------获取扫描文件类型Begin-----获取在某一个阶段限定录入的文件-------------------
    	        
    	    //----------------------------------拼接报文Begin-------------------------------------------------
    	    StringBuffer paramData = new StringBuffer();
    	    StringBuffer action = new StringBuffer();
    	    String targetURL = "";	
    	    String sNewPhaseType = "";
    	    com.amarsoft.impl.jsbank_als.Encode encode = new com.amarsoft.impl.jsbank_als.Encode();//间url转换为utf-8
    	    //判断影像的url地址
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
    	    
    	    //客户资料各个阶段都可以查看
    	    if("Customer".equals(sPhaseType) ||"BusinessApply".equals(sPhaseType) || "BusinessApprove".equals(sPhaseType)|| "BusinessApproveList".equals(sPhaseType) ||"BusinessContract".equals(sPhaseType)||"BusinessPutOut".equals(sPhaseType) ||"PutOutApprove".equals(sPhaseType)
    	    		|| ("AfterLoan".equals(sPhaseType) && "ALL".equals(sAfterloan)) ||"Recovery".equals(sPhaseType)){//客户阶段
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
    	    		 || ("AfterLoan".equals(sPhaseType) && "ALL".equals(sAfterloan))||"Recovery".equals(sPhaseType)){//业务阶段    add by xlsun  去除贷后阶段标志，否则显示不够长
    	    	sNewPhaseType = sPhaseType;
    	    	if("PutOut".equals(sPhaseNo) || "ApplyChange".equals(sPutoutNo)){
    	    		sPhaseType = "";
    	    	}
    	    	paramData.append("&info2=BUSI_SERIAL_NO:").append(sBusinessSerialno).append(";OBJECT_NAME:").append("XD_1002").append(";QUERY_TIME:").append(sQuerTime).append(";RIGHT:").append(sRight).append(";FL:").append(sFileLevel).append(";BUSITYPE_ID:").append(sBusinessType).append(";BUSITYPE_NAME:").append(sBusinessTypeName).append(";CUSTOMER_ID:").append(sCustomerID).append(";CUSTOMER_NAME:").append(sCustomerName).append(";BUSINESS_PHASE:").append(sPhaseType).append(";Business_ContractNo:").append(sBusinessContractNo).append(";SENDBACK_MODIFY:").append(sSENDBACK_MODIFY).append(";FSN:").append(FSN);
    	    	paramData.append("&info3=BUSI_SERIAL_NO:").append(sBusinessSerialno).append(";OBJECT_NAME:").append("XD_1003").append(";QUERY_TIME:").append(sQuerTime).append(";RIGHT:").append(sRight).append(";FL:").append(sFileLevel).append(";CUSTOMER_ID:").append(sCustomerID).append(";CUSTOMER_NAME:").append(sCustomerName).append(";BUSINESS_PHASE:").append(sPhaseType).append(";Business_ContractNo:").append(sBusinessContractNo).append(";SENDBACK_MODIFY:").append(sSENDBACK_MODIFY).append(";FSN:").append(FSN);
    	    	paramData.append("&info4=BUSI_SERIAL_NO:").append(sBusinessSerialno).append(";OBJECT_NAME:").append("XD_1004").append(";QUERY_TIME:").append(sQuerTime).append(";RIGHT:").append(sRight).append(";FL:").append(sFileLevel).append(";CUSTOMER_ID:").append(sCustomerID).append(";CUSTOMER_NAME:").append(sCustomerName).append(";BUSINESS_PHASE:").append(sPhaseType).append(";Business_ContractNo:").append(sBusinessContractNo).append(";SENDBACK_MODIFY:").append(sSENDBACK_MODIFY).append(";FSN:").append(FSN);
    	    	sPhaseType = sNewPhaseType;
    	    }
    	   if(("AfterLoan".equals(sPhaseType) && sInspectNo == null)||"Recovery".equals(sPhaseType)){//贷后管理阶段
    	    	paramData.append("&info5=BUSI_SERIAL_NO:").append(sBusinessSerialno).append(";OBJECT_NAME:").append("XD_1005").append(";QUERY_TIME:").append(sQuerTime).append(";RIGHT:").append(sRight).append(";FL:").append(sFileLevel).append(";CUSTOMER_ID:").append(sCustomerID).append(";CUSTOMER_NAME:").append(sCustomerName).append(";BUSINESS_PHASE:").append(sPhaseType).append(";Business_ContractNo:").append(sBusinessContractNo).append(";SENDBACK_MODIFY:").append(sSENDBACK_MODIFY).append(";FSN:").append(FSN);
    	    }
    	    if("AfterLoanCustomer".equals(sPhaseType)){
    	    	paramData.append("&info7=BUSI_SERIAL_NO:").append(sBusinessSerialno).append(";OBJECT_NAME:").append("XD_1007").append(";QUERY_TIME:").append(sQuerTime).append(";RIGHT:").append(sRight).append(";FL:").append(sFileLevel).append(";CUSTOMER_ID:").append(sCustomerID).append(";CUSTOMER_NAME:").append(sCustomerName).append(";BUSINESS_PHASE:").append(sPhaseType).append(";Business_ContractNo:").append(sBusinessContractNo).append(";SENDBACK_MODIFY:").append(sSENDBACK_MODIFY).append(";FSN:").append(FSN);
    	    }
    	   if("Recovery".equals(sPhaseType)){//保全阶段
    	   
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
    		//拼接action
    		action.append(targetURL).append("?").append(paramData);
    		System.out.println(action.toString());
    	    //----------------------------------拼接报文End-------------------------------------------------
    		
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
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>

<%@ include file="/IncludeEnd.jsp"%>