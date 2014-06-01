package com.lmt.app.display;

import java.awt.Color;
import java.awt.Font;
import java.awt.GradientPaint;
import java.awt.Paint;
import java.io.File;
import java.io.IOException;

import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.CategoryAxis;
import org.jfree.chart.axis.CategoryLabelPositions;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.labels.ItemLabelAnchor;
import org.jfree.chart.labels.ItemLabelPosition;
import org.jfree.chart.labels.StandardCategoryItemLabelGenerator;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.renderer.category.BarRenderer3D;
import org.jfree.chart.title.TextTitle;
import org.jfree.data.category.CategoryDataset;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.ui.TextAnchor;

import com.lmt.frameapp.sql.ASResultSet;
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
	 * 得到数据
	 */
	public static DefaultCategoryDataset getDataSet(){
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
	public static void setStyle(JFreeChart chart){
		TextTitle textTitle = chart.getTitle(); 
		// 得到图表标题，并给其设置字体
		//设置标题的字体 
		String fontA = "华文细黑"; 
		String fontB = "黑体"; 
		textTitle.setFont(new Font(fontA,Font.PLAIN,13)); 
		textTitle.setBackgroundPaint(new GradientPaint(0.0F, 0.0F, Color.decode("#EEF7FF"), 250F, 0.0F, Color.white, true)); 
		textTitle.setExpandToFitSpace(true); 
		chart.setBackgroundPaint(new GradientPaint(0.0F, 0.0F, Color.decode("#EEF7FF"), 250F, 0.0F, Color.white, true)); 

		// 得到图表底部类别，并给其设置字体
		chart.getLegend().setItemFont(new Font("宋体",0,12));
		// 得到柱状图样式的样式
		CategoryPlot plot = (CategoryPlot) chart.getCategoryPlot(); 
        BarRenderer3D customBarRenderer = (BarRenderer3D) plot.getRenderer(); 
        plot.setDomainGridlinePaint(Color.white); 
        plot.setDomainGridlinesVisible(true); 
        plot.setRangeGridlinePaint(Color.black); 
        plot.setBackgroundPaint(Color.decode("#F9E9D2")); 
        // 设置是否有横线 
        plot.setRangeGridlinesVisible(false); 
        NumberAxis numberaxis = (NumberAxis) plot.getRangeAxis(); 
        numberaxis.setStandardTickUnits(NumberAxis.createIntegerTickUnits()); 
        //设置纵坐标名称的字体 
        numberaxis.setLabelFont(new Font(fontA,Font.PLAIN,16)); 
        //设置纵坐标上显示的数字字体 
        numberaxis.setTickLabelFont(new Font("Fixedsys",Font.PLAIN,13)); 
        //设置横坐标名称的字体 
        CategoryAxis categoryaxis = plot.getDomainAxis(); 
        categoryaxis.setLabelFont(new Font(fontA,Font.PLAIN,16)); 
        //设置横坐标上显示各个业务子项的字体 
        categoryaxis.setTickLabelFont(new Font(fontA,Font.PLAIN,12)); 
        categoryaxis.setMaximumCategoryLabelLines(100); 
        categoryaxis.setMaximumCategoryLabelWidthRatio(100); 
        //横坐标数据倾斜45度 
        categoryaxis.setCategoryLabelPositions(CategoryLabelPositions.UP_45); 
        // 顶端设置 
        numberaxis.setUpperMargin(0.14999999999999999D); 
        // 设置颜色 

        customBarRenderer.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());//显示每个柱的数值 
        customBarRenderer.setBaseItemLabelsVisible(true); 
        //注意：此句很关键，若无此句，那数字的显示会被覆盖，给人数字没有显示出来的问题 
        customBarRenderer.setBasePositiveItemLabelPosition(new ItemLabelPosition( 
        ItemLabelAnchor.OUTSIDE12, TextAnchor.BASELINE_CENTER)); 
        customBarRenderer.setItemLabelAnchorOffset(10D);// 设置柱形图上的文字偏离值 
        customBarRenderer.setItemLabelsVisible(true); 

        //设定柱子上面的颜色 
        customBarRenderer.setSeriesPaint(0, Color.decode("#24F4DB")); // 给series1 Bar 
        customBarRenderer.setSeriesPaint(1, Color.decode("#7979FF")); // 给series2 Bar 
        customBarRenderer.setSeriesPaint(2, Color.decode("#FF5555")); // 给series3 Bar 
        customBarRenderer.setSeriesPaint(3, Color.decode("#F8D661")); // 给series4 Bar 
        customBarRenderer.setSeriesPaint(4, Color.decode("#F284DC")); // 给series5 Bar 
        customBarRenderer.setSeriesPaint(5, Color.decode("#00BF00")); // 给series6 Bar 
        customBarRenderer.setSeriesOutlinePaint(0,Color.BLACK);//边框为黑色 
        customBarRenderer.setSeriesOutlinePaint(1,Color.BLACK);//边框为黑色 
        customBarRenderer.setSeriesOutlinePaint(2,Color.BLACK); //边框为黑色 
        customBarRenderer.setSeriesOutlinePaint(3,Color.BLACK);//边框为黑色 
        customBarRenderer.setSeriesOutlinePaint(4,Color.BLACK);//边框为黑色 
        customBarRenderer.setSeriesOutlinePaint(5,Color.BLACK); //边框为黑色 
        //设置柱子的最大宽度 
        customBarRenderer.setMaximumBarWidth(0.04); 
        customBarRenderer.setItemMargin(0.000000005); 
        plot.setRenderer(customBarRenderer); 
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
