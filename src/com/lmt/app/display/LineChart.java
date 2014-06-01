package com.lmt.app.display;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Font;
import java.awt.GradientPaint;
import java.io.File;
import java.io.IOException;

import org.jfree.chart.ChartRenderingInfo;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.LegendItemCollection;
import org.jfree.chart.axis.CategoryAxis;
import org.jfree.chart.axis.ValueAxis;
import org.jfree.chart.entity.StandardEntityCollection;
import org.jfree.chart.labels.ItemLabelAnchor;
import org.jfree.chart.labels.ItemLabelPosition;
import org.jfree.chart.labels.StandardCategoryItemLabelGenerator;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.renderer.category.CategoryItemRenderer;
import org.jfree.chart.renderer.category.LineAndShapeRenderer;
import org.jfree.data.category.CategoryDataset;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.ui.RectangleInsets;
import org.jfree.ui.TextAnchor;

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
	public static void setStyle(JFreeChart chart){
		// 得到图表标题，并给其设置字体
		chart.getTitle().setFont(new Font("黑体",0,20));
		// 得到图表底部类别，并给其设置字体
		chart.getLegend().setItemFont(new Font("宋体",0,12));
		// 得到折线图样式的样式，用于设置更多的自定义绘制属性        
		CategoryPlot plot = (CategoryPlot)chart.getPlot();
		// 得到Y坐标轴，并且设置说明字体
		plot.getRangeAxis().setLabelFont(new Font("宋体",0,12));
		// 得到Y坐标轴，并且设置坐标字体
		plot.getRangeAxis().setTickLabelFont(new Font("宋体",0,12));
		// 得到X坐标轴，并且设置说明字体
		plot.getDomainAxis().setLabelFont(new Font("宋体",0,12));
		// 得到X坐标轴，并且设置坐标字体
		plot.getDomainAxis().setTickLabelFont(new Font("宋体",0,12));
		
		GradientPaint bg = new GradientPaint(0, 50, new Color(248, 253, 255),     0, 250, new Color(205, 237, 252));  
		plot.setBackgroundPaint(bg); 
		plot.setDomainGridlinePaint(Color.BLACK);  
		plot.setDomainGridlinesVisible(true);   
		plot.setRangeGridlinePaint(Color.RED); 
		//设置网格背景颜色
        plot.setBackgroundPaint(Color.white);
        //设置网格竖线颜色
        plot.setDomainGridlinePaint(Color.pink);
        //设置网格横线颜色
        plot.setRangeGridlinePaint(Color.pink);
        //设置曲线图与xy轴的距离
        plot.setAxisOffset(new RectangleInsets(0D, 0D, 0D, 10D));
		// 设置横轴标题的字体 
		CategoryAxis domainAxis = plot.getDomainAxis(); 
		domainAxis.setLabelFont(new Font("黑体", Font.BOLD, 15));        
		// 设置纵轴标题文字的字体及其旋转方向  
		ValueAxis rangeAxis = plot.getRangeAxis(); 
		rangeAxis.setLabelFont(new Font("黑体", Font.BOLD, 15)); 
		rangeAxis.setLabelAngle(Math.PI/2);   
		
		// 获取渲染对象        
		LineAndShapeRenderer lineandshaperenderer = (LineAndShapeRenderer) plot.getRenderer(); 
        //设置曲线是否显示数据点
        lineandshaperenderer.setBaseShapesVisible(true);
        //设置数据显示位置
        lineandshaperenderer.setBasePositiveItemLabelPosition(new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BASELINE_CENTER)); 
        //设置曲线显示各数据点的值
        CategoryItemRenderer item = plot.getRenderer();
        item.setBaseItemLabelsVisible(true);
        item.setBasePositiveItemLabelPosition(new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BASELINE_LEFT));
        //下面三句是对设置折线图数据标示的关键代码
        item.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());
        item.setBaseItemLabelFont(new Font("Dialog", 1, 14));
        plot.setRenderer(item);
        /**/
        String bookTitle[] = {"Python", "JAVA", "C#", "Perl", "PHP"};
		// 自定义线段的绘制颜色
		Color color[] = new Color[bookTitle.length]; 
		color[0] = new Color(99,99,0); 
		color[1] = new Color(255,169,66); 
		color[2] = new Color(33,255, 66); 
		color[3] = new Color(33,0,255); 
		color[4] = new Color(255,0,66);  
		for (int i = 0; i < color.length; i++)  { 
			lineandshaperenderer.setSeriesPaint(i, color[i]); 
		}  
		// 自定义线段的绘制风格 
		BasicStroke bs ;  
		for (int i = 0; i < bookTitle.length; i++)  { 
			float dashes[] = {10.0f};  
			bs = new BasicStroke(2.0f, BasicStroke.CAP_ROUND,       BasicStroke.JOIN_ROUND, 10.f, dashes, 0.0f); 
			if (i % 2 != 0)   
				lineandshaperenderer.setSeriesStroke(i, bs);   
			else    
				lineandshaperenderer.setSeriesStroke(i, new BasicStroke(2.0f));
		}
		// 结束自定义图表绘制的相关属性    
		//ChartRenderingInfo info = new ChartRenderingInfo(new StandardEntityCollection());  
		// 设置图片生成格式       
		//String fileName =      ServletUtilities.saveChartAsPNG(chart, width, height, info, session);        
		// 设置图片生成路径  
		//String graphURL =      request.getContextPath() + "/servlet/DisplayChart?filename=" + fileName; 
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
