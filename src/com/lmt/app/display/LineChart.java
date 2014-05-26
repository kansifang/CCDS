package com.lmt.app.display;

import java.awt.Font;
import java.io.File;
import java.io.IOException;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.category.CategoryDataset;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.data.general.DefaultPieDataset;

import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class LineChart {
	/*
	 * 程序入口
	 */
	public static void main(String[] args) {
		// 创建折线图对象
		//JFreeChart 折线图 = ChartFactory.createLineChart("水果销量统计", "时间", "销量", 得到数据(), PlotOrientation.VERTICAL, true, true, true);
		// 给折线图对象设置样式
		//setStyle(折线图);
		// 对折线图对象生成图片
		//生成图片("E:\\折线图.jpg",折线图,800,600);
	}
	/*
	 * 得到数据
	 */
	public static CategoryDataset getDataSet(String sSql,Transaction Sqlca) throws Exception{
		// 创建柱状数据对象
		DefaultCategoryDataset PD = new DefaultCategoryDataset();
		ASResultSet rs=Sqlca.getASResultSet(sSql);
		// 添加数据
		while(rs.next()){
			PD.setValue(rs.getDouble(1), rs.getString(2),rs.getString(3));
		}
		// 返回数据
		return PD;
		// 创建折线数据对象
	}
	/*
	 * 对图表对象设置样式
	 */
	public static void setStyle(JFreeChart 图表){
		// 得到图表标题，并给其设置字体
		图表.getTitle().setFont(new Font("黑体",0,20));
		// 得到图表底部类别，并给其设置字体
		图表.getLegend().setItemFont(new Font("宋体",0,12));
		// 得到折线图样式的样式
		CategoryPlot 折线图样式 = (CategoryPlot)图表.getPlot();
		// 得到Y坐标轴，并且设置说明字体
		折线图样式.getRangeAxis().setLabelFont(new Font("宋体",0,12));
		// 得到Y坐标轴，并且设置坐标字体
		折线图样式.getRangeAxis().setTickLabelFont(new Font("宋体",0,12));
		// 得到X坐标轴，并且设置说明字体
		折线图样式.getDomainAxis().setLabelFont(new Font("宋体",0,12));
		// 得到X坐标轴，并且设置坐标字体
		折线图样式.getDomainAxis().setTickLabelFont(new Font("宋体",0,12));
	}
	/*
	 * 生成图片
	 */
	public static void 生成图片(String 文件地址,JFreeChart 图表,int 宽度,int 高度){
		try {
			// 使用图表工具保存文件
			ChartUtilities.saveChartAsJPEG(new File(文件地址),图表,宽度 ,高度);
		}catch (IOException e) {
			e.printStackTrace();
		}
	}
}
