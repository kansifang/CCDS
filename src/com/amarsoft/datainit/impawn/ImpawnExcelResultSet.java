package com.amarsoft.datainit.impawn;

import java.text.SimpleDateFormat;
import java.util.Date;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.context.ASUser;
import com.amarsoft.datainit.importobj.ExcelResultSet;

public class ImpawnExcelResultSet extends ExcelResultSet {
	private ASUser CurUser=null;
	public ImpawnExcelResultSet(Transaction sqlca,ASUser CurUser) throws Exception {
		super(sqlca);
		this.CurUser=CurUser;
	}
	public void initResultSetMeta(String initWho) throws Exception {
			this.columns.clear();
			this.addColumn(new String[]{"ImpawnID"},new String[]{"抵押物编号","质押物编号"});
			this.addColumn("GCSerialNo", "担保合同编号");
			
			this.addColumn("BCSerialNo", "合同编号");
			this.addColumn("CustomerID", "客户号");
			this.addColumn("CustomerName", "客户名称");
			this.addColumn(new String[]{"ImpawnType"},new String[]{"抵押物类型","质押物类型"});
			this.addColumn("ImpawnStatus", "担保物状态");

		

			this.addColumn("HoldTime", "入库日期");
			this.addColumn("HoldApplyUserID", "入库申请人");
			this.addColumn("HoldApplyOrgID", "入库申请机构");
			this.addColumn("HoldApplyTime", "入库申请时间");
			this.addColumn("HoldUnifiedOrgID", "入库机构");
			this.addColumn("HoldUnifiedUserID", "入库柜员");
			this.addColumn("Remark", "备注");
			this.addColumn("InputUserID", "登记人");
			this.addColumn("InputUserName", "登记人");
			this.addColumn("InputOrgID", "登记机构");
			this.addColumn("InputOrgName", "登记机构");
			this.addColumn("UpdateUserID", "更新人");
			this.addColumn("UpdateOrgID", "更新机构");
			this.addColumn("InputDate", "登记日期");
			this.addColumn("UpdateDate", "更新日期");
			
			this.addColumn("PackageNo", "寄库凭证编号");
			this.addColumn("SealNo", "寄库封签号");
			this.addColumn("TotAmount", "寄库凭证金额");
			this.addColumn("TotAmountCurrency", "寄库凭证币种");
			
			this.addColumn("RightDocStatus", "权证状态");
			this.addColumn("RightDocNo", "权证编号");
			this.addColumn("RightDoc", "权证类型");
			this.addColumn("RightDocDescrible", "权证类型描述");
			this.addColumn("RightDocName", "权证名称");
			this.addColumn("RightBeginDate", "抵质押权利起始日期");
			this.addColumn("RightEndDate", "抵质押权利到期日期");
			this.addColumn("RightValue", "权利价值（权证有标注的要填写）");
			this.addColumn("RightValueCurrency", "权利价值币种");
			this.addColumn("IssueOrganization", "发证机关");
			
			this.addColumn("WarrantType", "保险类型");
			this.addColumn("InsureCertNO", "保险单编号");// 原表长40建议给成150
			this.addColumn("InsuranceCompany", "保险公司名称");
			this.addColumn("WarrantyBeginDate", "保单生效日");
			this.addColumn("WarrantyEndDate", "保单到期日");
			this.addColumn("InsureBeneficiary", "被保险人");
			this.addColumn("InsureSum", "保险金额");
			this.addColumn("InsureValueBy", "投保价值依据");
			this.addColumn("IsDocument", "是否附有批单");
			this.addColumn("DocumentAmount", "所附批单份数");
			this.addColumn("EvalReportEffectiveDate", "评估报告生效日");
			this.addColumn("EvalReportLapseDate", "评估报告到期日");
			
			this.addColumn("ImportNo", "导入批量号",10000);
		if (initWho.equals("抵押-房产")) {
			this.addColumn("GuarantyName", "担保品名称");
			this.addColumn("OwnerID", "权利人代码");
			this.addColumn("OwnerName", "抵押人名称");
			this.addColumn("OwnerType", "抵押人类型");
			this.addColumn("GuarantyRightID", "权证号");
			this.addColumn("GuarantySubType", "房产类型");
			this.addColumn("GuarantyLocation", "房屋详细地址");
			this.addColumn("GuarantyAmount1", "建筑面积(平方米)");
			this.addColumn("AboutOtherID1", "土地证编号");
			this.addColumn("GuarantyDescribe1", "土地使用权单位");
			this.addColumn("GuarantyDescribe2", "地段");
			this.addColumn("GuarantyDescribe3", "土地性质");
			this.addColumn("ThirdParty1", "土地用途");
			this.addColumn("OwnerTime", "土地使用年限(年)");
			this.addColumn("GuarantyDate", "房屋建成时间");
			this.addColumn("GuarantyDescript", "房屋装修情况");
			this.addColumn("EvalMethod", "抵押物价值评估方式");
			this.addColumn("EvalOrgName", "价值评估机构名称");
			this.addColumn("EvalDate", "估价时点");
			this.addColumn("Currency", "币种");
			this.addColumn("EvalNetValue", "抵押物评估价值(元)");
			this.addColumn("ConfirmValue", "抵押物认定价值(元)");
			this.addColumn("AboutSum2", "担保债权金额(元)");
			this.addColumn("OtherGuarantyRight", "他项权证号");
			this.addColumn("RegisterOrgID", "抵押登记机构");
			this.addColumn("RegisterDate", "抵押登记日期");
		} else if (initWho.equals("抵押-土地")) {
			this.addColumn("GUARANTYNAME", "担保品名称");
			this.addColumn("OwnerID", "权利人代码");
			this.addColumn("OwnerName", "抵押人名称");
			this.addColumn("OwnerType", "抵押人类型");
			this.addColumn("GuarantyRightID", "权证号");
			this.addColumn("GuarantyLocation", "土地位置");
			this.addColumn("GuarantySubType", "土地级别");
			this.addColumn("GuarantyDescript", "土地四至");
			this.addColumn("GuarantyAmount1", "面积（平方米）");
			this.addColumn("GuarantyOwnWay", "土地取得方式");
			this.addColumn("ThirdParty1", "土地用途");
			this.addColumn("Flag1", "地上有无附着物");
			this.addColumn("Purpose", "地上附着物名称");
			this.addColumn("GuarantyAmount2", "地上附着物面积");
			this.addColumn("BeginDate", "购入日期");
			this.addColumn("AboutSum1", "土地出让价值(元)");
			this.addColumn("Flag2", "是否交清地价");
			this.addColumn("OwnerTime", "土地剩余使用年限");
			this.addColumn("GuarantyUsing", "土地现状");
			this.addColumn("EvalMethod", "抵押物价值评估方式");
			this.addColumn("EvalOrgName", "价值评估机构名称");
			this.addColumn("EvalDate", "估价时点");
			this.addColumn("Currency", "币种");
			this.addColumn("EvalNetValue", "抵押物评估价值(元)");
			this.addColumn("ConfirmValue", "抵押物认定价值(元)");
			this.addColumn("AboutSum2", "担保债权金额(元)");
			this.addColumn("OtherGuarantyRight", "他项权证号");
			this.addColumn("RegisterOrgID", "抵押登记机构");
			this.addColumn("RegisterDate", "抵押登记日期");
		} else if (initWho.equals("抵押在建工程")) {
			this.addColumn("OwnerID", "权利人代码");
			this.addColumn("OwnerName", "抵押人名称");
			this.addColumn("OwnerType", "抵押人类型");
			this.addColumn("GuarantyRightID", "土地使用权证编号");
			this.addColumn("GuarantyOwnWay", "土地获取方式");
			this.addColumn("GuarantyDescribe1", "已交土地使用权出让金");
			this.addColumn("GuarantyDescribe2", "已投入工程款");
			this.addColumn("GuarantyDescribe3", "已完成工程量");
			this.addColumn("ThirdParty1", "在建工程类型");
			this.addColumn("EvalMethod", "抵押物价值评估方式");
			this.addColumn("EvalOrgName", "价值评估机构名称");
			this.addColumn("EvalDate", "估价时点");
			this.addColumn("Currency", "币种");
			this.addColumn("EvalNetValue", "抵押物评估价值(元)");
			this.addColumn("ConfirmValue", "抵押物认定价值(元)");
			this.addColumn("AboutSum2", "担保债权金额(元)");
			this.addColumn("OtherGuarantyRight", "他项权证号");
			this.addColumn("RegisterOrgID", "抵押登记机构");
			this.addColumn("RegisterDate", "抵押登记日期");
		} else if (initWho.equals("抵押-交通工具")) {
			this.addColumn("OwnerID", "权利人代码");
			this.addColumn("OwnerName", "抵押人名称");
			this.addColumn("OwnerType", "抵押人类型");
			this.addColumn("GuarantyRightID", "权证号（车牌号）");
			this.addColumn("ThirdParty1", "运输工具类型");
			this.addColumn("AboutOtherID1", "品牌");
			this.addColumn("AboutOtherID2", "发动机号");
			this.addColumn("AboutOtherID3", "车架号");
			this.addColumn("ThirdParty2", "颜色");
			this.addColumn("GuarantyAmount1", "已行驶公里数");
			this.addColumn("Flag1", "是否有行驶证");
			this.addColumn("Flag2", "是否有车辆购置附加税证");
			this.addColumn("Flag3", "是否有当年车船使用税证");
			this.addColumn("Flag4", "年检是否正常");
			this.addColumn("AboutSum1", "购入价值(元)");
			this.addColumn("EvalMethod", "抵押物价值评估方式");
			this.addColumn("EvalOrgName", "价值评估机构名称");
			this.addColumn("EvalDate", "估价时点");
			this.addColumn("Currency", "币种");
			this.addColumn("EvalNetValue", "抵押物评估价值(元)");
			this.addColumn("ConfirmValue", "抵押物认定价值(元)");
			this.addColumn("AboutSum2", "担保债权金额(元)");
			this.addColumn("OtherGuarantyRight", "他项权证号");
			this.addColumn("RegisterOrgID", "抵押登记机构");
			this.addColumn("RegisterDate", "抵押登记日期");
		} else // 010040
		if (initWho.equals("抵押-设备")) {
			this.addColumn("OwnerID", "权利人代码");
			this.addColumn("OwnerName", "物权人名称");
			this.addColumn("OwnerType", "抵押人类型");
			this.addColumn("GuarantyRightID", "权证号(发票号码)");
			this.addColumn("GuarantyName", "设备名称");
			this.addColumn("GuarantyDescribe1", "设备生产厂家");
			this.addColumn("GuarantyDescribe2", "设备规格/型号");
			this.addColumn("GuarantyDescribe3", "品牌");
			this.addColumn("GuarantyAmount1", "数量");
			this.addColumn("BeginDate", "购入日期");
			this.addColumn("AboutSum1", "购入价值(人民币元)");
			this.addColumn("GuarantyLocation", "存放地");
			this.addColumn("GuarantyUsing", "设备现状");
			this.addColumn("EvalMethod", "抵押物价值评估方式");
			this.addColumn("EvalOrgName", "价值评估机构名称");
			this.addColumn("EvalDate", "估价时点");
			this.addColumn("Currency", "币种");
			this.addColumn("EvalNetValue", "抵押物评估价值(元)");
			this.addColumn("ConfirmValue", "抵押物认定价值(元)");
			this.addColumn("AboutSum2", "担保债权金额(元)");
			this.addColumn("OtherGuarantyRight", "他项权证号");
			this.addColumn("RegisterOrgID", "抵押登记机构");
			this.addColumn("RegisterDate", "抵押登记日期");
		} else // 010050
		if (initWho.equals("抵押-其他")) {
			this.addColumn("OwnerID", "权利人代码");
			this.addColumn("OwnerName", "抵押人名称");
			this.addColumn("OwnerType", "抵押人类型");
			this.addColumn("GuarantyRightID", "权证号");
			this.addColumn("GuarantyName", "抵押物名称");
			this.addColumn("Purpose", "抵押物用途");
			this.addColumn("GuarantyAmount", "数量");
			this.addColumn("BeginDate", "购入日期");
			this.addColumn("OwnerTime", "持有时间");
			this.addColumn("GuarantyPrice", "抵押物原价值");
			this.addColumn("EvalMethod", "抵押物价值评估方式");
			this.addColumn("EvalOrgName", "价值评估机构名称");
			this.addColumn("EvalDate", "估价时点");
			this.addColumn("Currency", "币种");
			this.addColumn("EvalNetValue", "抵押物评估价值(元)");
			this.addColumn("ConfirmValue", "抵押物认定价值(元)");
			this.addColumn("AboutSum2", "担保债权金额(元)");
			this.addColumn("OtherGuarantyRight", "他项权证号");
			this.addColumn("RegisterOrgID", "抵押登记机构");
			this.addColumn("RegisterDate", "抵押登记日期");
		} else // 010060
		if (initWho.equals("抵押-房地产")) {
			this.addColumn("OwnerID", "权利人代码");
			this.addColumn("OwnerName", "抵押人名称");
			this.addColumn("OwnerType", "抵押人类型");
			this.addColumn("GuarantyRightID", "房屋所有权证号");
			this.addColumn("GuarantySubType", "房产类型");
			this.addColumn("GuarantyLocation", "房屋详细地址");
			this.addColumn("GuarantyDescript", "房屋用途");
			this.addColumn("GuarantyDate", "房屋建成时间");
			this.addColumn("AboutOtherID1", "土地使用权证号");
			this.addColumn("GuarantyDescribe1", "土地使用权单位");
			this.addColumn("GuarantyDescribe2", "土地位置");
			this.addColumn("GuarantyDescribe3", "土地性质");
			this.addColumn("ThirdParty1", "土地用途");
			this.addColumn("GuarantyAmount1", "土地使用权面积");
			this.addColumn("OwnerTime", "土地使用年限(年)");
			this.addColumn("EvalMethod", "抵押物价值评估方式");
			this.addColumn("EvalOrgName", "价值评估机构名称");
			this.addColumn("EvalDate", "估价时点");
			this.addColumn("Currency", "币种");
			this.addColumn("EvalNetValue", "抵押物评估价值(元)");
			this.addColumn("ConfirmValue", "抵押物认定价值(元)");
			this.addColumn("AboutSum2", "担保债权金额(元)");
			this.addColumn("OtherGuarantyRight", "他项权证号");
			this.addColumn("RegisterOrgID", "抵押登记机构");
			this.addColumn("RegisterDate", "抵押登记日期");
		} else // 020010
		if (initWho.equals("质押-存单")) {
			this.addColumn("OwnerName", "出质人名称");
			this.addColumn("OwnerType", "出质人类型");
			this.addColumn("GuarantyRightID", "存单号码");
			this.addColumn("GuarantyLocation", "存单所属行");
			this.addColumn("BeginDate", "起息日期");
			this.addColumn("OwnerTime", "到期日期");
			this.addColumn("GuarantySubType", "币种");
			this.addColumn("AboutSum1", "存单金额");
			this.addColumn("GuarantyOwnWay", "存单支取方式");
			this.addColumn("AboutSum2", "担保债权金额");
		} else // 020020
		if (initWho.equals("质押-基金")) {
			this.addColumn("OwnerID", "出质人代码");
			this.addColumn("OwnerName", "出质人名称");
			this.addColumn("OwnerType", "出质人类型");
			this.addColumn("ThirdParty1", "基金类型");
			this.addColumn("GuarantyName", "基金名称");
			this.addColumn("AboutSum1", "基金发行总额(元)");
			this.addColumn("GuarantyAmount", "质押基金份额(元)");
			this.addColumn("GuarantySubType", "币种");
			this.addColumn("AboutRate", "质押基金份额占总额(%)");
			this.addColumn("GuarantyAmount1", "申请前一日基金收盘价(元)");
			this.addColumn("AboutSum2", "担保债权金额(元)");
		} else // 020030
		if (initWho.equals("质押-黄金")) {
			this.addColumn("OwnerID", "出质人代码");
			this.addColumn("OwnerName", "出质人名称");
			this.addColumn("OwnerType", "出质人类型");
			this.addColumn("ThirdParty1", "黄金品种");
			this.addColumn("GuarantyAmount", "黄金克数");
			this.addColumn("GuarantyPrice", "质押黄金的市价值");
			this.addColumn("EvalMethod", "质押物价值评估方式");
			this.addColumn("GuarantySubType", "币种");
			this.addColumn("EvalOrgName", "价值评估机构名称");
			this.addColumn("EvalDate", "估价时点");
			this.addColumn("EvalNetValue", "质押物评估价值(元)");
			this.addColumn("ConfirmValue", "质押物认定价值(元)");
			this.addColumn("AboutSum2", "担保债权金额(元)");
			this.addColumn("AboutRate", "黄金质押率");
		} else if (initWho.equals("质押-国债")) {
			this.addColumn("OwnerID", "出质人代码");
			this.addColumn("OwnerName", "出质人名称");
			this.addColumn("OwnerType", "出质人类型");
			this.addColumn("GuarantyName", "质押物名称");
			this.addColumn("GuarantyRightID", "权证号码");
			this.addColumn("GuarantyAmount", "数量");
			this.addColumn("GuarantySubType", "币种");
			this.addColumn("AboutSum1", "金额(人民币元)");
			this.addColumn("GuarantyDate", "发行日期");
			this.addColumn("BeginDate", "最近到期日期");
			this.addColumn("AboutSum2", "担保债权金额(元)");
		} else // 020050
		if (initWho.equals("质押-出口退税")) {
			this.addColumn("OwnerID", "出质人代码");
			this.addColumn("OwnerName", "出质人名称");
			this.addColumn("OwnerType", "出质人类型");
			this.addColumn("GuarantyRightID", "权证号码");
			this.addColumn("AboutOtherID1", "出口退税帐户帐号");
			this.addColumn("GuarantySubType", "币种");
			this.addColumn("AboutSum1", "应退未退税金额(元)");
			this.addColumn("AboutSum2", "担保债权金额(元)");
		} else // 020060
		if (initWho.equals("质押-保单")) {
			this.addColumn("OwnerID", "出质人代码");
			this.addColumn("OwnerName", "出质人名称");
			this.addColumn("OwnerType", "出质人类型");
			this.addColumn("GuarantyRightID", "保险单号码");
			this.addColumn("GuarantyResouce", "保险公司名称");
			this.addColumn("GuarantyDescribe1", "保险类型");
			this.addColumn("ThirdParty1", "投保人");
			this.addColumn("GuarantySubType", "币种");
			this.addColumn("ThirdParty2", "被保险人");
			this.addColumn("ThirdParty3", "受益人");
			this.addColumn("AboutSum1", "保险金额(元)");
		} else // 020070
		if (initWho.equals("质押-城市重点建设债券")) {
			this.addColumn("OwnerID", "出质人代码");
			this.addColumn("OwnerName", "出质人名称");
			this.addColumn("OwnerType", "出质人类型");
			this.addColumn("GuarantyRightID", "债券号码");
			this.addColumn("GuarantyResouce", "债券发行单位");
			this.addColumn("GuarantyLocation", "债券代理发行机构");
			this.addColumn("GuarantyName", "债券名称");
			this.addColumn("GuarantyAmount", "债券数量");
			this.addColumn("GuarantySubType", "债券币种");
			this.addColumn("AboutSum1", "债券金额(元)");
			this.addColumn("Flag1", "是否记名债券");
		} else // 020080
		if (initWho.equals("质押-信用证")) {
			this.addColumn("OwnerID", "出质人代码");
			this.addColumn("OwnerName", "出质人名称");
			this.addColumn("GuarantyRightID", "信用证号码");
			this.addColumn("GuarantyName", "开证申请人名称");
			this.addColumn("ThirdParty1", "信用证类型");
			this.addColumn("ThirdParty2", "期限类型");
			this.addColumn("GuarantySubType", "币种");
			this.addColumn("AboutSum1", "金额(元)");
			this.addColumn("GuarantyDate", "开证日期");
			this.addColumn("OwnerTime", "信用证效期");
		} else // 020090
		if (initWho.equals("质押-备用信用证")) {
			this.addColumn("OwnerID", "出质人代码");
			this.addColumn("OwnerName", "出质人名称");
			this.addColumn("GuarantyRightID", "信用证号码");
			this.addColumn("OwnerType", "受益人类型");
			this.addColumn("GuarantyName", "开证申请人名称");
			this.addColumn("GuarantySubType", "币种");
			this.addColumn("AboutSum1", "金额(元)");
			this.addColumn("OwnerTime", "效期");
			this.addColumn("GuarantyResouce", "开证行名称");
			this.addColumn("GuarantyDescribe1", "开证行国家地区");
			this.addColumn("Flag1", "有无保兑");
		} else // 020110
		if (initWho.equals("质押-仓单")) {
			this.addColumn("OwnerName", "出质人名称");
			this.addColumn("OwnerType", "出质人类型");
			this.addColumn("GuarantyRightID", "仓单号码");
			this.addColumn("GuarantyName", "货物名称");
			this.addColumn("GuarantyAmount1", "货物数量");
			this.addColumn("GuarantySubType", "币种");
			this.addColumn("GuarantyPrice", "货物购入价值");
			this.addColumn("GuarantyResouce", "仓储公司名称");
			this.addColumn("GuarantyLocation", "存放地点");
			this.addColumn("BeginDate", "存放起始日期");
			this.addColumn("OwnerTime", "仓单到期日期");
			this.addColumn("EvalMethod", "质押物价值评估方式");
			this.addColumn("EvalOrgName", "价值评估机构名称");
			this.addColumn("EvalDate", "估价时点");
			this.addColumn("EvalNetValue", "质押物评估价值");
			this.addColumn("ConfirmValue", "质押物认定价值");
			this.addColumn("AboutSum2", "担保债权金额");
		} else // 020120
		if (initWho.equals("质押-提单")) {
			this.addColumn("OwnerID", "出质人代码");
			this.addColumn("OwnerName", "出质人名称");
			this.addColumn("OwnerType", "出质人类型");
			this.addColumn("GuarantyRightID", "提单号码");
			this.addColumn("GuarantyName", "货物名称");
			this.addColumn("GuarantyAmount1", "货物数量");
			this.addColumn("GuarantySubType", "币种");
			this.addColumn("GuarantyPrice", "货物购入价值(元)");
			this.addColumn("GuarantyLocation", "提货地点");
			this.addColumn("GuarantyResouce", "供应商名称");
			this.addColumn("OwnerTime", "提单到期日期");
			this.addColumn("EvalMethod", "质押物价值评估方式");
			this.addColumn("EvalOrgName", "价值评估机构名称");
			this.addColumn("EvalDate", "估价时点");
			this.addColumn("EvalNetValue", "质押物评估价值(元)");
			this.addColumn("ConfirmValue", "质押物认定价值(元)");
			this.addColumn("AboutSum2", "担保债权金额(元)");
		} else // 020130
		if (initWho.equals("质押-交通工具")) {
			this.addColumn("OwnerID", "出质人代码");
			this.addColumn("OwnerName", "出质人名称");
			this.addColumn("OwnerType", "出质人类型");
			this.addColumn("GuarantyRightID", "权证号(车牌号)");
			this.addColumn("ThirdParty1", "运输工具类型");
			this.addColumn("ThirdParty3", "车辆品牌");
			this.addColumn("AboutOtherID1", "车辆型号");
			this.addColumn("AboutOtherID2", "发动机号");
			this.addColumn("AboutOtherID3", "车架号");
			this.addColumn("ThirdParty2", "颜色");
			this.addColumn("GuarantyAmount1", "已行驶公里数");
			this.addColumn("Flag1", "是否有行驶证");
			this.addColumn("Flag2", "是否有车辆购置附加税证");
			this.addColumn("Flag3", "是否有当年车船使用税证");
			this.addColumn("Flag4", "年检是否正常");
			this.addColumn("AboutSum1", "购入价值(人民币元)");
			this.addColumn("EvalMethod", "抵押物价值评估方式");
			this.addColumn("EvalOrgName", "价值评估机构名称");
			this.addColumn("EvalDate", "估价时点");
			this.addColumn("GuarantySubType", "币种");
			this.addColumn("EvalNetValue", "抵押物评估价值(元)");
			this.addColumn("ConfirmValue", "抵押物认定价值(元)");
			this.addColumn("AboutSum2", "担保债权金额(元)");
			this.addColumn("OtherGuarantyRight", "他项权证号");
		} else // 020140
		if (initWho.equals("质押-汽车合格证")) {
			this.addColumn("OwnerID", "出质人代码");
			this.addColumn("OwnerName", "出质人名称");
			this.addColumn("OwnerType", "权属人类型");
			this.addColumn("GuarantyRightID", "汽车合格证号码");
			this.addColumn("ThirdParty1", "车辆类型");
			this.addColumn("ThirdParty3", "车辆品牌");
			this.addColumn("AboutOtherID1", "车辆型号");
			this.addColumn("GuarantyAmount", "数量");
			this.addColumn("GuarantySubType", "币种");
			this.addColumn("GuarantyPrice", "车辆购入价值(元)");
			this.addColumn("GuarantyLocation", "车辆存放地点");
			this.addColumn("AboutOtherID2", "供应商");
			this.addColumn("GuarantyResouce", "生产厂家");
			this.addColumn("EvalMethod", "质押物价值评估方式");
			this.addColumn("EvalOrgName", "价值评估机构名称");
			this.addColumn("EvalDate", "估价时点");
			this.addColumn("EvalNetValue", "质押物评估价值(元)");
			this.addColumn("ConfirmValue", "质押物认定价值(元)");
			this.addColumn("AboutSum2", "担保债权金额(元)");
		} else // 020150
		if (initWho.equals("质押-企业债券")) {
			this.addColumn("OwnerID", "出质人代码");
			this.addColumn("OwnerName", "出质人名称");
			this.addColumn("OwnerType", "出质人类型");
			this.addColumn("GuarantyRightID", "债券号码");
			this.addColumn("GuarantyResouce", "债券发行单位");
			this.addColumn("GuarantyLocation", "债券代理发行机构");
			this.addColumn("GuarantyName", "债券名称");
			this.addColumn("GuarantyAmount", "债券数量");
			this.addColumn("GuarantySubType", "债券币种");
			this.addColumn("AboutSum1", "债券金额(元)");
			this.addColumn("Flag1", "是否记名债券");
			this.addColumn("Flag2", "是否需要办理止付");
			this.addColumn("GuarantyDate", "发行日期");
			this.addColumn("AboutSum2", "担保债权金额(元)");
		} else // 020160
		if (initWho.equals("质押-上市公司法人股")) {
			this.addColumn("OwnerID", "出质人代码");
			this.addColumn("OwnerName", "出质人名称");
			this.addColumn("OwnerType", "出质人类型");
			this.addColumn("GuarantyRightID", "股票代码");
			this.addColumn("GuarantyName", "股票名称");
			this.addColumn("GuarantyLocation", "债券代理发行机构");
			this.addColumn("GuarantyAmount", "股票数量(股)");
			this.addColumn("GuarantySubType", "币种");
			this.addColumn("AboutSum1", "最新公布的股票每股净资产(人民币元)");
			this.addColumn("OtherGuarantyRight", "他项权利证号");
			this.addColumn("Flag1", "上市公司是否盈利(是否)");
			this.addColumn("ConfirmValue", "质押物认定价值(元)");
			this.addColumn("AboutSum2", "担保债权金额(元)");
		} else // 020170
		if (initWho.equals("质押-上市公司流通股")) {
			this.addColumn("OwnerID", "出质人代码");
			this.addColumn("OwnerName", "出质人名称");
			this.addColumn("OwnerType", "出质人类型");
			this.addColumn("RelativeAccount", "权利人帐户帐号");
			this.addColumn("GuarantyRightID", "股票代码");
			this.addColumn("GuarantyName", "股票名称");
			this.addColumn("GuarantyAmount", "股票数量(股)");
			this.addColumn("GuarantySubType", "币种");
			this.addColumn("GuarantyLocation", "股票托管券商");
			this.addColumn("AboutSum1", "质押股票上一交易日收盘单股市值(元)");
			this.addColumn("OtherGuarantyRight", "他项权利证号");
			this.addColumn("EvalMethod", "质押物价值评估方式");
			this.addColumn("EvalOrgName", "价值评估机构名称");
			this.addColumn("EvalDate", "估价时点");
			this.addColumn("EvalNetValue", "质押物评估价值(元)");
			this.addColumn("ConfirmValue", "质押物认定价值(元)");
			this.addColumn("AboutSum2", "担保债权金额(元)");
		} else // 020180
		if (initWho.equals("质押-非上市公司股权")) {
			this.addColumn("OwnerID", "出质人代码");
			this.addColumn("OwnerName", "出质人名称");
			this.addColumn("OwnerType", "出质人类型");
			this.addColumn("GuarantyRightID", "权证号码");
			this.addColumn("GuarantyName", "股权名称");
			this.addColumn("GuarantyAmount", "股权数量(股)");
			this.addColumn("GuarantySubType", "币种");
			this.addColumn("AboutSum1", "每股净资产(人民币元)");
			this.addColumn("Flag1", "公司是否盈利");
			this.addColumn("OtherGuarantyRight", "他项权利证号");
			this.addColumn("EvalMethod", "质押物价值评估方式");
			this.addColumn("EvalOrgName", "价值评估机构名称");
			this.addColumn("EvalDate", "估价时点");
			this.addColumn("EvalNetValue", "质押物评估价值(元)");
			this.addColumn("ConfirmValue", "质押物认定价值(元)");
			this.addColumn("AboutSum2", "担保债权金额(元)");
		} else // 020190
		if (initWho.equals("质押-应收帐款")) {
			this.addColumn("OwnerID", "出质人代码");
			this.addColumn("OwnerName", "出质人名称");
			this.addColumn("OwnerType", "出质人类型");
			this.addColumn("GuarantyRightID", "权证号码");
			this.addColumn("GuarantyName", "购货商名称");
			this.addColumn("GuarantySubType", "币种");
			this.addColumn("AboutSum1", "应收帐款金额(元)");
			this.addColumn("BeginDate", "付款到期日期");
			this.addColumn("OwnerTime", "帐龄(月)");
			this.addColumn("EvalMethod", "质押物价值评估方式");
			this.addColumn("EvalOrgName", "价值评估机构名称");
			this.addColumn("EvalDate", "估价时点");
			this.addColumn("EvalNetValue", "质押物评估价值(元)");
			this.addColumn("ConfirmValue", "质押物认定价值(元)");
			this.addColumn("AboutSum2", "担保债权金额(元)");
		} else // 020210
		if (initWho.equals("质押-银行承兑汇票")) {
			this.addColumn("OwnerID", "出质人代码");
			this.addColumn("OwnerName", "出质人名称");
			this.addColumn("OwnerType", "出质人类型");
			this.addColumn("GuarantyRightID", "银行承兑汇票号码");
			this.addColumn("ThirdParty1", "票据类型");
			this.addColumn("GuarantyName", "出票人");
			this.addColumn("GuarantySubType", "币种");
			this.addColumn("GuarantyResouce", "承兑行");
			this.addColumn("ThirdParty2", "收款人");
			this.addColumn("ThirdParty3", "付款行");
			this.addColumn("AboutSum1", "银行承兑汇票金额(元)");
			this.addColumn("GuarantyDate", "出票日");
			this.addColumn("OwnerTime", "承兑日");
			this.addColumn("AboutSum2", "担保债权金额(元)");
		} else // 020220
		if (initWho.equals("质押-汇票、本票、支票")) {
			this.addColumn("OwnerID", "出质人代码");
			this.addColumn("OwnerName", "出质人名称");
			this.addColumn("OwnerType", "出质人类型");
			this.addColumn("GuarantyRightID", "票据号码");
			this.addColumn("ThirdParty1", "票据类型");
			this.addColumn("GuarantyName", "出票人");
			this.addColumn("GuarantySubType", "币种");
			this.addColumn("GuarantyResouce", "出票行");
			this.addColumn("ThirdParty2", "付款人");
			this.addColumn("ThirdParty3", "付款行");
			this.addColumn("AboutSum1", "票面金额(元)");
			this.addColumn("GuarantyDate", "签发日期");
			this.addColumn("OwnerTime", "到期日期");
			this.addColumn("AboutSum2", "担保债权金额(元)");
		} else // 020230
		if (initWho.equals("质押-其他动产")) {
			this.addColumn("OwnerID", "出质人代码");
			this.addColumn("OwnerName", "出质人名称");
			this.addColumn("OwnerType", "出质人类型");
			this.addColumn("Guarantyana", "存放地点");
			this.addColumn("GuarantyRightID", "权证号(发票号码)");
			this.addColumn("GuarantyName", "质押物名称");
			this.addColumn("GuarantyAmount", "质押物数量");
			this.addColumn("BeginDate", "购入日期");
			this.addColumn("OwnerTime", "到期日期");
			this.addColumn("GuarantySubType", "币种");
			this.addColumn("GuarantyPrice", "质押物原价值(人民币元)");
			this.addColumn("EvalMethod", "质押物价值评估方式");
			this.addColumn("EvalOrgName", "价值评估机构名称");
			this.addColumn("EvalDate", "估价时点");
			this.addColumn("EvalNetValue", "质押物评估价值(元)");
			this.addColumn("ConfirmValue", "质押物认定价值(元)");
			this.addColumn("AboutSum2", "担保债权金额(元)");
		} else // 020250
		if (initWho.equals("质押-其他可转让权利")) {
			this.addColumn("OwnerID", "出质人代码");
			this.addColumn("OwnerName", "出质人名称");
			this.addColumn("OwnerType", "出质人类型");
			this.addColumn("GuarantyRightID", "权证号码");
			this.addColumn("GuarantyName", "权利名称");
			this.addColumn("GuarantyResouce", "权利批准机构");
			this.addColumn("BeginDate", "购入/起始日期");
			this.addColumn("OwnerTime", "到期日期");
			this.addColumn("GuarantySubType", "币种");
			this.addColumn("GuarantyPrice", "权利取得价值(元)");
			this.addColumn("EvalMethod", "质押物价值评估方式");
			this.addColumn("EvalOrgName", "价值评估机构名称");
			this.addColumn("EvalDate", "估价时点");
			this.addColumn("EvalNetValue", "质押物评估价值(元)");
			this.addColumn("ConfirmValue", "质押物认定价值(元)");
			this.addColumn("AboutSum2", "担保债权金额(元)");
		} else // 020270
		if (initWho.equals("保证金")) {
			this.addColumn("OwnerID", "出质人代码");
			this.addColumn("OwnerName", "出质人名称");
			this.addColumn("GuarantyRightID", "保证金帐号");
			this.addColumn("GuarantyLocation", "保证金类型");
			this.addColumn("GuarantySubType", "保证金币种");
			this.addColumn("AboutSum1", "保证金金额(元)");
			this.addColumn("AboutSum2", "担保债权金额(元)");
			this.addColumn("AboutRate", "保证金比例(%)");
		} else // 020280
		if (initWho.equals("质押-理财产品")) {
			this.addColumn("OwnerName", "认购客户姓名");
			this.addColumn("OwnerCardType", "客户证件类型");
			this.addColumn("OwnerCardNo", "客户证件号");
			this.addColumn("GUARANTYNAME", "产品名称");
			this.addColumn("GuarantyRegNO", "产品编号");
			this.addColumn("SapvouchType", "产品类型");
			this.addColumn("GuarantySubType", "认购币种");
			this.addColumn("AboutSum1", "认购金额");
			this.addColumn("OwnerOrg", "理财产品受理机构名称");
			this.addColumn("BeginDate", "成立日");
			this.addColumn("OwnerTime", "到期日");
			this.addColumn("GuarantyRightID", "派发收益账号");
		}
	}
	public void initResultSetPara() throws Exception {
		super.initResultSetPara();
		SimpleDateFormat sdf=new SimpleDateFormat("'N"+CurUser.UserID+"'yyyyMMddhhmm");
		this.setString("ImportNo", sdf.format(new Date())+"000000");
	}
}
