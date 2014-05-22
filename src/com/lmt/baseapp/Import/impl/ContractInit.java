package com.lmt.baseapp.Import.impl;

import java.sql.PreparedStatement;
import java.util.HashMap;

import com.lmt.baseapp.util.DBFunction;
import com.lmt.baseapp.util.DataConvert;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.log.Log;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

/**
 * 
 * @author bllou
 * history Log: zjzhang1 2012-10-30 删除更新保证金币种 
 */

public class ContractInit {
	private Log logger = null;
	
	public void initCrt(Transaction Sqlca) throws Exception{
		String sSql = "";
		ASResultSet rs=null;
		ASResultSet rs2=null;
		logger = ARE.getLog();
		HashMap<String, String> mmAutoSet = new HashMap<String, String>();
		PreparedStatement ps1 = null,ps2 = null,ps3 = null,ps4 = null;
		String sGISer = "";
		String sBailApplySerialNo = "";
		String sBailcontractno = "";
		String sBailaccountno = "";
		String sBailcurrency = "";
		String sPlholdsum = "";
		boolean isAutoCommit=false;
		try {
			isAutoCommit=Sqlca.conn.getAutoCommit();
			Sqlca.conn.setAutoCommit(false);
			//1、虚拟质押保证金合同
			sSql = "select BCC.RelativeSerialNo as SerialNo," +
						" BCC.CustomerID as GuarantorID,"+
						" getCustomerName(BCC.CustomerID) as GuarantorName,"+
						" BCC.BeginDate as SignDate," +
						" BCC.BeginDate," +
						" BCC.EndDate,"+
						" BPT.BailRatio,"+
						" BPT.PutOutNo as PutOutNo,"+
						" '060' as GuarantyType,"+//已签
						" '020' as ContractType,"+//最高额担保
						" '020' as ContractStatus,"+//已签
						" '1' as IsBailGuaranty,"+//保证金质押合同标志
						" '040' as GuarantyType,"+//押品类型
						" BW.Bailaccountno as GuarantyRightID,"+//保证金账号
						" BPT.BailRatio as AboutRate,"+//保证金比例
						" BW.Bailcurrency as GuarantyCurrency,"+//保证金币种
						" BW.PLHoldSum as AboutSum1,"+//保证金金额
						" BW.PLHoldSum as AboutSum2"+//保证金债权金额
						" from Business_PutOut_Temp BPT," +
						" (select Bailaccountno,Bpputoutno,Bailcurrency,sum(PLHoldSum) As PLHoldSum " +
						"     From Bail_WasteBook_Import BWI Where bwi.importno Like 'N%' " +
						"     Group By bwi.BPPutOutNo,bwi.BailAccountNo,bwi.bailcurrency) BW," +
						" CL_Info CI,Business_ContractCLInfo BCC"+
						" where BPT.PutOutNo=BW.Bpputoutno" +
						" and BPT.ImportNo like 'Nadmin%000000'" +
						" and BPT.LineID=CI.LineID" +
						" and CI.ApplySerialNo=BCC.ApplySerialNo" +
						" and BCC.SerialNo=BCC.CreditAggreement" +
						" and BPT.BailRatio>0";
			rs = Sqlca.getASResultSet(sSql);
			logger.info("1、虚拟质押保证金合同");
			logger.info(sSql);
			while(rs.next()){
				String sBCSerialNo = DataConvert.toString(rs.getString("SerialNo"));
				String sPutOutNo = DataConvert.toString(rs.getString("PutOutNo"));
				sBailaccountno = DataConvert.toString(rs.getString("GuarantyRightID"));
				sSql = "select count(1) from Contract_Relative CR,Guaranty_Contract GC" +
				" where CR.SerialNo='"+sBCSerialNo+"'" +
				" and CR.ObjectType='GuarantyContract'" +
				" and CR.ObjectNo=GC.SerialNo" +
				" and GC.IsBailGuaranty='1'";
				double iExist = Sqlca.getDouble(sSql);
				String sGCSerialNo = "";
				if(iExist==0){
					sGCSerialNo = DBFunction.getSerialNo("Guaranty_Contract","SerialNo",Sqlca);
					//担保合同
					mmAutoSet = new HashMap<String, String>();
					mmAutoSet.put("SerialNo",sGCSerialNo);
					mmAutoSet.put("Remark", "ADMIN");
					mmAutoSet.put("AVAILABLYFLAG", "1");
					ps1 = CopyInfoUtil.copyInfo("insert", rs,"select * from Guaranty_Contract", null, null,null, mmAutoSet, Sqlca, ps1);
					ps1.execute();
					//合同关联信息表
					mmAutoSet = new HashMap<String, String>();
					mmAutoSet.put("ObjectType","GuarantyContract");
					mmAutoSet.put("ObjectNo",sGCSerialNo);
					ps2 = CopyInfoUtil.copyInfo("insert", rs,"select * from Contract_Relative", null, null,null, mmAutoSet, Sqlca, ps2);
					ps2.execute();
				}else{
					//取合同号;
					sGCSerialNo = Sqlca.getString("select GC.Serialno from Contract_Relative CR,Guaranty_Contract GC" +
							" where CR.SerialNo='"+sBCSerialNo+"'" +
							" and CR.ObjectType='GuarantyContract'" +
							" and CR.ObjectNo=GC.SerialNo" +
							" and GC.IsBailGuaranty='1' And Rownum = 1 ");
				}
					//Guaranty_Contract流水置入Business_Putout  bailcontractno
					Sqlca.executeSQL("Update Business_PutOut bp Set bp.bailcontractno = '"+sGCSerialNo+"' Where bp.putoutno = '"+sPutOutNo+"'");
					//押品信息表
					//初始guaranty_info、guaranty_relative、GuarantyValue_Book
					logger.debug("初始guaranty_info、guaranty_relative、GuarantyValue_Book");
					sSql = "SELECT bp.bailcontractno as bailcontractno, "+
					" Bwi.Bailaccountno as Bailaccountno, "+
					" Bwi.Bailcurrency as Bailcurrency, "+
					" SUM(Bwi.Plholdsum) as Plholdsum "+ //--担保债权金额，押品价值 
					" FROM Bail_Wastebook_Import Bwi,Business_PutOut bp " +
					" Where bwi.importno Like 'N%'  and bwi.Bailaccountno = '"+sBailaccountno+"' "+
					" And bwi.bpputoutno = bp.putoutno and bp.putoutno = '"+sPutOutNo+"' "+
					" GROUP BY Bwi.Bailaccountno, Bwi.Bailcurrency,bp.bailcontractno ";
					rs2 = Sqlca.getASResultSet(sSql);
					logger.debug(sSql);
					while(rs2.next()){
						sBailcontractno = DataConvert.toString(rs2.getString("bailcontractno"));
						sBailcurrency = DataConvert.toString(rs2.getString("Bailcurrency"));
						sPlholdsum = DataConvert.toString(rs2.getString("Plholdsum"));
						//guaranty_info
						sGISer = DBFunction.getSerialNo("guaranty_info","guarantyid",Sqlca);
						logger.debug("Insert Into guaranty_info guarantyid="+sGISer);						
						Sqlca.executeSQL("Insert Into guaranty_info " +
								"(guarantyid,guarantytype,guarantystatus,guarantyrightid,GuarantySubType,AboutSum1,AboutSum2,remark) " +
								" Values ('"+sGISer+"','040','02','"+sBailaccountno+"','"+sBailcurrency+"','"+sPlholdsum+"','"+sPlholdsum+"','ADMIN')");
						//guaranty_relative
						logger.debug("Insert Into guaranty_relative objectno="+sBCSerialNo+",guarantyid="+sGISer);						
						Sqlca.executeSQL("Insert Into guaranty_relative (objecttype,objectno,contractno,guarantyid,channel,status,type,describe) " +
								" Values ('BusinessContract','"+sBCSerialNo+"','"+sBailcontractno+"','"+sGISer+"','New','1','New','ADMIN')");
						//GuarantyValue_Book
						logger.debug("Insert Into GuarantyValue_Book Impawnid="+sGISer);						
						Sqlca.executeSQL("Insert Into GuarantyValue_Book " +
								" (Impawnid,Currency,Guarantyvalue,Useablevalue,Usedvalue,Guarantyrightvalue,Impawnclass,Remark) " +
								" Values ('"+sGISer+"','"+sBailcurrency+"','"+sPlholdsum+"','0','"+sPlholdsum+"','"+sPlholdsum+"','10','ADMIN')");
						//插入PutOut_Impawn_Relative_His
						sBailApplySerialNo = DBFunction.getSerialNo("PutOut_Impawn_Relative_His","BailApplySerialNo",Sqlca);
						Sqlca.executeSQL("Insert Into PutOut_Impawn_Relative_His (bpputoutno,Relativecreationtype,Impawnclass,Impawnid,Impawntype,Currency,Usedsum,Bailapplyserialno,Remark) "+
								"Values('"+sPutOutNo+"','10','10','"+sGISer+"','040','"+sBailcurrency+"','"+sPlholdsum+"','"+sBailApplySerialNo+"','ADMIN')");
						Sqlca.executeSQL("Insert Into PutOut_Impawn_Relative (bpputoutno,Impawnclass,Impawnid,Impawntype,Currency,Initusedsum,Curusedsum,Bailapplyserialno,Remark) "+
								"Values('"+sPutOutNo+"','10','"+sGISer+"','040','"+sBailcurrency+"','"+sPlholdsum+"','"+sPlholdsum+"','"+sBailApplySerialNo+"','ADMIN')");
					}
					if(rs2!=null&&rs2.getStatement()!=null) rs2.getStatement().close();
			}
			if(rs!=null) rs.getStatement().close();
			if(rs2!=null&&rs2.getStatement()!=null) rs2.getStatement().close();
			if(ps1!=null) ps1.close();
			if(ps2!=null) ps2.close();
			if(ps3!=null) ps3.close();
			if(ps4!=null) ps4.close();
			Sqlca.conn.commit();
	}catch (Exception e) {
		logger.error("An error occurs : " + e.toString());
		e.printStackTrace();
		Sqlca.conn.rollback();
		throw e;
	}finally{
		Sqlca.conn.setAutoCommit(isAutoCommit);
	}
	}
	
}
