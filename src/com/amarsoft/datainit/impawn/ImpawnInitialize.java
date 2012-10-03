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
 * @msg. ��ʷѺƷ��Ϣ�����ʼ��
 */
public class ImpawnInitialize{
	// excel����ͷ�����ݿ��Ӧ�ı�
	// װ��������
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
	 * ����xls �����ݲ������ݱ���
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
		String[][]Impawns1={{"020010","��Ѻ-�浥"},{"020020","��Ѻ-����"},
				{"020040","��Ѻ-��ծ"},{"020050","��Ѻ-������˰"},
				{"020060","��Ѻ-���� "},{"020070","��Ѻ-�����ص㽨��ծȯ "},
				{"020080","��Ѻ-����֤"},{"020090","��Ѻ-��������֤ "},
				{"020150","��Ѻ-��ҵծȯ "},{"020210","��Ѻ-���гжһ�Ʊ "},{"020220","��Ѻ-��Ʊ����Ʊ��֧Ʊ"}};
		String[][]Impawns2={{"020010","��Ѻ-�浥"},{"020020","��Ѻ-����"},
				{"020030","��Ѻ-�ƽ�"},{"020110","��Ѻ-�ֵ�"},
				{"020120","��Ѻ-�ᵥ"},{"020130","��Ѻ-��ͨ����"},
				{"020140","��Ѻ-�����ϸ�֤"},{"020160","��Ѻ-���й�˾���˹� "},
				{"020170","��Ѻ-���й�˾��ͨ��"},{"020180","��Ѻ-�����й�˾��Ȩ"},
				{"020190","��Ѻ-Ӧ���ʿ�"},{"020230","��Ѻ-��������"},{"020250","��Ѻ-������ת��Ȩ��"}};
		//1����Excel�������ݿ�
		this.OII.action();
		//2������ʱ���Ƶ���ʷ�����ɱ���>���̱�
		ASResultSet rs=Sqlca.getASResultSet("select * from "+this.sTotalTemp+" where ImportNo like 'N"+this.CurUser.UserID+"%000000'");
		while(rs.next()){
			String sPackageNo=DataConvert.toString(rs.getString("PackageNo"));
			String sImpawnID=DataConvert.toString(rs.getString("ImpawnID"));
			String sRightDocNo=DataConvert.toString(rs.getString("RightDocNo"));
			String sRightDoc=DataConvert.toString(rs.getString("RightDoc"));
			String sPackageStatus=DataConvert.toString(rs.getString("PackageStatus"));
			String sRightDocStatus=DataConvert.toString(rs.getString("RightDocStatus"));
			String sImpawnType=DataConvert.toString(rs.getString("ImpawnType"));
		 //1�����͹������� ������Ϣ���Ƿ��Ѵ��ڰ��ã��еĻ��������������������Ϣ��ֻ���°�
			String sExistIMASerialNo=Sqlca.getString("select IMASerialNo from "+this.sPackageInfoHis +" where PackageNo='"+sPackageNo+"' and PackageStatus='"+sPackageStatus+"'");
			if(sExistIMASerialNo==null||sExistIMASerialNo.trim().length()==0){
				//��������
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
				//��
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
				//ֻ���°�
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
		 //2��ѺƷ����	
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
		 //3��Ȩ֤
			dExist=Sqlca.getDouble("select count(1) from "+this.sRightDocHis +" where PackageNo='"+sPackageNo+"' and ImpawnID='"+sImpawnID+"' and RightDocNo='"+sRightDocNo+"' and RightDoc='"+sRightDoc+"' and RightDocStatus='"+sRightDocStatus+"'");
			if(dExist==0){
				String sRightSerialNo = DBFunction.getSerialNo(this.sRightDocHis, "SerialNo", Sqlca);//Ȩ֤��ˮ��
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
				//����Ȩ֤��ʷ
				ps3RUHIS=CopyInfoUtil.copyInfo("update",rs,"select * from "+this.sRightDocHis,"PackageNo,ImpawnID,RightDocNo,RigthDoc,RightDocStatus","SerialNo,IMASerialNo,PackageNo,ImpawnID,RightDocNo,RigthDoc,RightDocStatus",null,null,Sqlca,ps3RUHIS);
				ps3RUHIS.addBatch();
				ps3RUHIS.executeBatch();
				//����Ȩ֤��ʽ��
				ps3RU=CopyInfoUtil.copyInfo("update",rs,"select * from "+this.sRightDocList,"PackageNo,ImpawnID,RightDocNo","SerialNo,IMASerialNo,PackageNo,ImpawnID,RightDocNo",null,null,Sqlca,ps3RU);
				ps3RU.addBatch();
				ps3RU.executeBatch();
			}
		//4��ѺƷռ����Ϣ
			mmReplace=new HashMap<String,String>();
			mmReplace.put("GuarantyRightValue","AboutSum2");//Ȩ����ֵ
			mmReplace.put("UseAbleValue","AboutSum2");//���ü�ֵ ��ʼ��ΪȨ����ֵ
			//mmReplace.put("PreAssignValue","AboutSum2");//Ԥռ�ü�ֵ 
			//mmReplace.put("UsedValue","AboutSum2");//��ռ�ü�ֵ 
			mmAutoSet =new HashMap<String,String>();
			mmAutoSet.put("ImpawnClass", "30");
			if(sImpawnType.startsWith("010")){//��Ѻ
				mmReplace.put("GuarantyValue","ConfirmValue");//�϶���ֵ
			}else if(StringFunction.getAttribute(Impawns1,sImpawnType)!=null){
				mmReplace.put("Currency","GuarantySubType");//����
				mmReplace.put("GuarantyValue","AboutSum1");//�϶���ֵ
			}else if(StringFunction.getAttribute(Impawns2,sImpawnType)!=null){
				mmReplace=new HashMap<String,String>();
				mmReplace.put("Currency","GuarantySubType");//�϶���ֵ
				mmReplace.put("GuarantyValue","ConfirmValue");//�϶���ֵ
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
	//��ȡexcel�ֶε���� ��0��ʼ
	protected int getExcelColumnIndex(Sheet sheet,String paramString) throws Exception {
		int i=-1;
	    for (i = 0;i<sheet.getColumns()&&!paramString.equals(sheet.getCell(i,0).getContents().trim());++i);
	    if (i >=sheet.getColumns())
	      i = -1;
	    return i;
	  }
}