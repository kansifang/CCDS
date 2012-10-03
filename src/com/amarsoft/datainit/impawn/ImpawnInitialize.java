package com.amarsoft.datainit.impawn;

import java.sql.PreparedStatement;
import java.util.HashMap;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.ars.jxl.core.Sheet;
import com.amarsoft.context.ASUser;
import com.amarsoft.datainit.importobj.CopyInfoUtil;
import com.amarsoft.datainit.importobj.ObjImportImpl;
/**
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public class ImpawnInitialize{
	// excel报表头和数据库对应的表
	// 装各下拉框
	private Transaction Sqlca = null;
	private String sTotalTemp="Impawn_Total_Import";
	private String sManageApply="ImpawnManage_Apply";
	private String sPackageInfoHis="ImpawnPackage_Info_His";
	private String sDetailInfoHis="ImpawnDetail_Info_His";
	private String sRightDocHis="ImpawnRightDoc_List_His";
	private String sPackageInfo="ImpawnPackage_Info";
	private String sDetailInfo="ImpawnDetail_Info";
	private String sRightDocList="ImpawnRightDoc_List";
	private String sGValueBook="GuarantyValue_Book";
	private ObjImportImpl OII=null;
	private ASUser CurUser=null;
	/**
	 * 解析xls 将数据插入数据表中
	 * @throws Exception 
	 */
	public ImpawnInitialize(Transaction Sqlca, String[] files,ASUser CurUser) throws Exception {
		this.Sqlca = Sqlca;
		this.CurUser = CurUser;
		this.OII = new ImpawnExcelImport(Sqlca,files,CurUser);
	}
	public void handle() throws Exception{
		double dExist=0;
		HashMap<String,String> mmReplace=null;
		HashMap<String,String> mmAutoSet=null;
		PreparedStatement ps0MIHIS=null,
		ps1PIHIS=null,ps1PI=null,ps1PUHIS=null,ps1PU=null,
		ps2DIHIS=null,ps2DI=null,ps2DUHIS=null,ps2DU=null,
		ps3RIHIS=null,ps3RI=null,ps3RUHIS=null,ps3RU=null,
		ps4VI=null,ps4VU=null;
		String[][]Impawns1={{"020010","质押-存单"},{"020020","质押-基金"},
				{"020040","质押-国债"},{"020050","质押-出口退税"},
				{"020060","质押-保单 "},{"020070","质押-城市重点建设债券 "},
				{"020080","质押-信用证"},{"020090","质押-备用信用证 "},
				{"020150","质押-企业债券 "},{"020210","质押-银行承兑汇票 "},{"020220","质押-汇票、本票、支票"}};
		String[][]Impawns2={{"020010","质押-存单"},{"020020","质押-基金"},
				{"020030","质押-黄金"},{"020110","质押-仓单"},
				{"020120","质押-提单"},{"020130","质押-交通工具"},
				{"020140","质押-汽车合格证"},{"020160","质押-上市公司法人股 "},
				{"020170","质押-上市公司流通股"},{"020180","质押-非上市公司股权"},
				{"020190","质押-应收帐款"},{"020230","质押-其他动产"},{"020250","质押-其他可转让权利"}};
		//1、把Excel导入数据库
		this.OII.action();
		//2、总临时表复制到历史表（过渡表——>过程表）
		ASResultSet rs=Sqlca.getASResultSet("select * from "+this.sTotalTemp+" where ImportNo like 'N"+this.CurUser.UserID+"%000000'");
		while(rs.next()){
			String sPackageNo=DataConvert.toString(rs.getString("PackageNo"));
			String sImpawnID=DataConvert.toString(rs.getString("ImpawnID"));
			String sRightDocNo=DataConvert.toString(rs.getString("RightDocNo"));
			String sRightDoc=DataConvert.toString(rs.getString("RightDoc"));
			String sPackageStatus=DataConvert.toString(rs.getString("PackageStatus"));
			String sRightDocStatus=DataConvert.toString(rs.getString("RightDocStatus"));
			String sImpawnType=DataConvert.toString(rs.getString("ImpawnType"));
		 //1、包和管理申请 检查包信息里是否已存在包好，有的话，不再生成入库申请信息，只更新包
			String sExistIMASerialNo=Sqlca.getString("select IMASerialNo from "+this.sPackageInfoHis +" where PackageNo='"+sPackageNo+"' and PackageStatus='"+sPackageStatus+"'");
			if(sExistIMASerialNo==null||sExistIMASerialNo.trim().length()==0){
				//管理申请
				mmReplace=new HashMap<String,String>();
				mmReplace.put("ApplyUserID","HoldApplyUserID");
				mmReplace.put("ApplyOrgID","HoldApplyOrgID");
				mmReplace.put("HoldLostUnifiedUserID","HoldUnifiedUserID");
				mmReplace.put("HoldLostUnifiedOrgID","HoldUnifiedOrgID");
				sExistIMASerialNo  = DBFunction.getSerialNo(this.sManageApply, "SerialNo", Sqlca);
				mmAutoSet=new HashMap<String,String>();
				mmAutoSet.put("SerialNo", sExistIMASerialNo);
				ps0MIHIS =CopyInfoUtil.copyInfo("insert",rs,"select * from "+this.sManageApply,"",null,mmReplace,mmAutoSet,Sqlca,ps0MIHIS);
				ps0MIHIS.addBatch();
				ps0MIHIS.executeBatch();
				//包
				mmReplace=new HashMap<String,String>();
				mmReplace.put("OccApplyUserID","InputUserID");
				mmReplace.put("OccApplyOrgID","InputOrgID");
				mmAutoSet=new HashMap<String,String>();
				mmAutoSet.put("IMASerialNo", sExistIMASerialNo);
				mmAutoSet.put("SerialNo",DBFunction.getSerialNo("ImpawnPackage_Info_His", "SerialNo", Sqlca));
				ps1PIHIS =CopyInfoUtil.copyInfo("insert",rs,"select * from "+this.sPackageInfoHis,"",null,mmReplace,mmAutoSet,Sqlca,ps1PIHIS);
				ps1PIHIS.addBatch();
				ps1PIHIS.executeBatch();
				mmAutoSet=new HashMap<String,String>();
				mmAutoSet.put("HoldApplySerialNo",sExistIMASerialNo);
				ps1PI =CopyInfoUtil.copyInfo("insert",rs,"select * from "+this.sPackageInfo,"",null,mmReplace,mmAutoSet,Sqlca,ps1PI);
				ps1PI.addBatch();
				ps1PI.executeBatch();
			}else{
				//只更新包
				mmReplace=new HashMap<String,String>();
				mmReplace.put("OccApplyUserID","InputUserID");
				mmReplace.put("OccApplyOrgID","InputOrgID");
				ps1PUHIS=CopyInfoUtil.copyInfo("update",rs,"select * from "+this.sPackageInfoHis,"PackageNo,PackageStatus","SerialNo,IMASerialNo,PackageNo,PackageStatus",mmReplace,null,Sqlca,ps1PUHIS);
				ps1PUHIS.addBatch();
				ps1PUHIS.executeBatch();
				ps1PU=CopyInfoUtil.copyInfo("update",rs,"select * from "+this.sPackageInfo,"PackageNo","HoldApplySerialNo,PackageNo",mmReplace,null,Sqlca,ps1PU);
				ps1PU.addBatch();
				ps1PU.executeBatch();
			}
		 //2、押品详情	
			dExist=Sqlca.getDouble("select count(1) from "+this.sDetailInfoHis +" where PackageNo='"+sPackageNo+"' and ImpawnID='"+sImpawnID+"' and PackageStatus='"+sPackageStatus+"'");
			if(dExist==0){
				mmAutoSet=new HashMap<String,String>();
				mmAutoSet.put("IMASerialNo", sExistIMASerialNo);
				ps2DIHIS=CopyInfoUtil.copyInfo("insert",rs,"select * from "+this.sDetailInfoHis,"",null,null,mmAutoSet,Sqlca,ps2DIHIS);
				ps2DIHIS.addBatch();
				ps2DIHIS.executeBatch();
				ps2DI=CopyInfoUtil.copyInfo("insert",rs,"select * from "+this.sDetailInfo,"",null,null,mmAutoSet,Sqlca,ps2DI);
				ps2DI.addBatch();
				ps2DI.executeBatch();
			}else{
				ps2DUHIS=CopyInfoUtil.copyInfo("update",rs,"select * from "+this.sDetailInfoHis,"PackageNo,ImpawnID","IMASerialNo,PackageNo,ImpawnID,,PackageStatus",null,null,Sqlca,ps2DUHIS);
				ps2DUHIS.addBatch();
				ps2DUHIS.executeBatch();
				ps2DU=CopyInfoUtil.copyInfo("update",rs,"select * from "+this.sDetailInfo,"PackageNo,ImpawnID","IMASerialNo,PackageNo,ImpawnID",null,null,Sqlca,ps2DU);
				ps2DU.addBatch();
				ps2DU.executeBatch();
			}
		 //3、权证
			dExist=Sqlca.getDouble("select count(1) from "+this.sRightDocHis +" where PackageNo='"+sPackageNo+"' and ImpawnID='"+sImpawnID+"' and RightDocNo='"+sRightDocNo+"' and RightDoc='"+sRightDoc+"' and RightDocStatus='"+sRightDocStatus+"'");
			if(dExist==0){
				String sRightSerialNo = DBFunction.getSerialNo(this.sRightDocHis, "SerialNo", Sqlca);//权证流水号
				mmAutoSet=new HashMap<String,String>();
				mmAutoSet.put("IMASerialNo", sExistIMASerialNo);
				mmAutoSet.put("SerialNo", sRightSerialNo);
				ps3RIHIS=CopyInfoUtil.copyInfo("insert",rs,"select * from "+this.sRightDocHis,"",null,null,mmAutoSet,Sqlca,ps3RIHIS);
				ps3RIHIS.addBatch();
				ps3RIHIS.executeBatch();
				ps3RI=CopyInfoUtil.copyInfo("insert",rs,"select * from "+this.sRightDocList,"",null,null,mmAutoSet,Sqlca,ps3RI);
				ps3RI.addBatch();
				ps3RI.executeBatch();
			}else{
				//更新权证历史
				ps3RUHIS=CopyInfoUtil.copyInfo("update",rs,"select * from "+this.sRightDocHis,"PackageNo,ImpawnID,RightDocNo,RigthDoc,RightDocStatus","SerialNo,IMASerialNo,PackageNo,ImpawnID,RightDocNo,RigthDoc,RightDocStatus",null,null,Sqlca,ps3RUHIS);
				ps3RUHIS.addBatch();
				ps3RUHIS.executeBatch();
				//更新权证正式表
				ps3RU=CopyInfoUtil.copyInfo("update",rs,"select * from "+this.sRightDocList,"PackageNo,ImpawnID,RightDocNo","SerialNo,IMASerialNo,PackageNo,ImpawnID,RightDocNo",null,null,Sqlca,ps3RU);
				ps3RU.addBatch();
				ps3RU.executeBatch();
			}
		//4、押品占用信息
			mmReplace=new HashMap<String,String>();
			mmReplace.put("GuarantyRightValue","AboutSum2");//权利价值
			mmReplace.put("UseAbleValue","AboutSum2");//可用价值 初始化为权利价值
			//mmReplace.put("PreAssignValue","AboutSum2");//预占用价值 
			//mmReplace.put("UsedValue","AboutSum2");//已占用价值 
			mmAutoSet =new HashMap<String,String>();
			mmAutoSet.put("ImpawnClass", "30");
			if(sImpawnType.startsWith("010")){//抵押
				mmReplace.put("GuarantyValue","ConfirmValue");//认定价值
			}else if(StringFunction.getAttribute(Impawns1,sImpawnType)!=null){
				mmReplace.put("Currency","GuarantySubType");//币种
				mmReplace.put("GuarantyValue","AboutSum1");//认定价值
			}else if(StringFunction.getAttribute(Impawns2,sImpawnType)!=null){
				mmReplace=new HashMap<String,String>();
				mmReplace.put("Currency","GuarantySubType");//认定价值
				mmReplace.put("GuarantyValue","ConfirmValue");//认定价值
			}
			dExist=Sqlca.getDouble("select count(1) from "+this.sGValueBook +" where ImpawnID='"+sImpawnID+"'");
			if(dExist==0){
				ps4VI=CopyInfoUtil.copyInfo("insert", rs, "select * from "+this.sGValueBook, null, null, mmReplace, mmAutoSet, Sqlca, ps4VI);
				ps4VI.addBatch();
				ps4VI.executeBatch();
			}else{
				ps4VU=CopyInfoUtil.copyInfo("update", rs, "select * from "+this.sGValueBook, "ImpawnID", "ImpawnID,ImpawnClass", mmReplace, null, Sqlca, ps4VU);
				ps4VU.addBatch();
				ps4VU.executeBatch();
			}
		}
		rs.getStatement().close();
		if(ps0MIHIS!=null) ps0MIHIS.close();
		if(ps1PIHIS!=null) ps1PIHIS.close();
		if(ps1PI!=null) ps1PI.close();
		if(ps1PUHIS!=null) ps1PUHIS.close();
		if(ps1PU!=null) ps1PU.close();
		if(ps2DIHIS!=null) ps2DIHIS.close();
		if(ps2DI!=null) ps2DI.close();
		if(ps2DUHIS!=null) ps2DUHIS.close();
		if(ps2DU!=null) ps2DU.close();
		if(ps3RIHIS!=null) ps3RIHIS.close();
		if(ps3RI!=null) ps3RI.close();
		if(ps3RUHIS!=null) ps3RUHIS.close();
		if(ps3RU!=null) ps3RU.close();
		if(ps4VI!=null) ps4VI.close();
		if(ps4VU!=null) ps4VU.close();
		
	}
	//获取excel字段的序号 从0开始
	protected int getExcelColumnIndex(Sheet sheet,String paramString) throws Exception {
		int i=-1;
	    for (i = 0;i<sheet.getColumns()&&!paramString.equals(sheet.getCell(i,0).getContents().trim());++i);
	    if (i >=sheet.getColumns())
	      i = -1;
	    return i;
	  }
}