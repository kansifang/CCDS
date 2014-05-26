package com.lmt.app.display;

import java.awt.Font;
import java.io.File;
import java.io.IOException;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.category.DefaultCategoryDataset;

import com.lmt.frameapp.sql.Transaction;

public class BarChart {
	/*
	 * 程序入口
	 */
	public static void main(String[] args) {
		// 创建柱状图对象
		//JFreeChart 柱状图 = ChartFactory.createBarChart3D("水果产量统计", "水果", "产量", 得到数据(), PlotOrientation.VERTICAL, true, true, true);
		// 给柱状图对象设置样式
		//setStyle(柱状图);
		// 对柱状图对象生成图片
		//生成图片("D:\\柱状图.jpg",柱状图,800,600);
	}
	/*
	 * 得到数据
	 */
	public static DefaultCategoryDataset getDataSet(String sSql,Transaction Sqlca){
		// 创建柱状数据对象
		DefaultCategoryDataset 柱状数据 = new DefaultCategoryDataset();
		// 添加数据
		柱状数据.addValue(200, "北京", "苹果");
		柱状数据.addValue(100, "西安", "苹果");
		柱状数据.addValue(200, "新疆", "苹果");
		柱状数据.addValue(50, "北京", "香蕉");
		柱状数据.addValue(30, "西安", "香蕉");
		柱状数据.addValue(10, "新疆", "香蕉");
		柱状数据.addValue(10, "北京", "葡萄");
		柱状数据.addValue(20, "西安", "葡萄");
		柱状数据.addValue(200, "新疆", "葡萄");
		// 返回数据
		return 柱状数据;
	}
	/*
	 * 对图表对象设置样式
	 */
	public static void setStyle(JFreeChart 图表){
		// 得到图表标题，并给其设置字体
		图表.getTitle().setFont(new Font("黑体",0,20));
		// 得到图表底部类别，并给其设置字体
		图表.getLegend().setItemFont(new Font("宋体",0,12));
		// 得到柱状图样式的样式
		CategoryPlot 柱状图样式 = (CategoryPlot)图表.getPlot();
		// 得到Y坐标轴，并且设置说明字体
		柱状图样式.getRangeAxis().setLabelFont(new Font("宋体",0,12));
		// 得到Y坐标轴，并且设置坐标字体
		柱状图样式.getRangeAxis().setTickLabelFont(new Font("宋体",0,12));
		// 得到X坐标轴，并且设置说明字体
		柱状图样式.getDomainAxis().setLabelFont(new Font("宋体",0,12));
		// 得到X坐标轴，并且设置坐标字体
		柱状图样式.getDomainAxis().setTickLabelFont(new Font("宋体",0,12));
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
