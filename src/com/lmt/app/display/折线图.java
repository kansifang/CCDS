package com.jfreechart;

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

public class 折线图 {
	/*
	 * 程序入口
	 */
	public static void main(String[] args) {
		// 创建折线图对象
		JFreeChart 折线图 = ChartFactory.createLineChart("水果销量统计", "时间", "销量", 得到数据(), PlotOrientation.VERTICAL, true, true, true);
		// 给折线图对象设置样式
		setStyle(折线图);
		// 对折线图对象生成图片
		生成图片("D:\\折线图.jpg",折线图,800,600);
	}
	/*
	 * 得到数据
	 */
	public static CategoryDataset 得到数据(){
		// 创建折线数据对象
		DefaultCategoryDataset 折线数据 = new DefaultCategoryDataset();
		// 添加数据
		折线数据.addValue(12, "北京", (Integer)1);
		折线数据.addValue(15, "北京", (Integer)2);
		折线数据.addValue(13, "北京", (Integer)3);
		折线数据.addValue(18, "北京", (Integer)1);
		折线数据.addValue(16, "北京", (Integer)2);
		折线数据.addValue(18, "西安", (Integer)3);
		折线数据.addValue(16, "西安", (Integer)1);
		折线数据.addValue(22, "西安", (Integer)2);
		折线数据.addValue(20, "西安", (Integer)3);
		折线数据.addValue(14, "西安", (Integer)1);
		// 返回数据
		return 折线数据;
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
