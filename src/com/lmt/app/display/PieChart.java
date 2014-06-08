package com.lmt.app.display;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Font;
import java.io.File;
import java.io.IOException;

import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.labels.StandardPieToolTipGenerator;
import org.jfree.chart.plot.PiePlot;
import org.jfree.chart.plot.PiePlot3D;
import org.jfree.data.general.DefaultPieDataset;
import org.jfree.util.Rotation;

import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class PieChart {
	/*
	 * 程序入口
	 */
	public static void main(String[] args) {
		// 创建饼状图对象
		//JFreeChart 饼状图 = ChartFactory.createPieChart("水果市场占有统计", getDataSet(), true, true, true);
		// 给饼状图对象设置样式
		//setStyle(饼状图);
		// 对饼状图对象生成图片
		//生成图片("E:\\饼状图.jpg",饼状图,800,600);
	}
	/*
	 * 得到数据
	 */
	public static DefaultPieDataset getDataSet(String sSql,Transaction Sqlca) throws Exception{
		// 创建柱状数据对象
		DefaultPieDataset PD = new DefaultPieDataset();
		ASResultSet rs=Sqlca.getASResultSet(sSql);
		// 添加数据
		while(rs.next()){
			PD.setValue(rs.getString(1), rs.getDouble(2));
		}
		// 返回数据
		return PD;
	}
	/*
	 * 对图表对象设置样式
	 */
	public static void setStyle(boolean is3D,JFreeChart chart){
		// 得到图表标题，并给其设置字体
		chart.getTitle().setFont(new Font("黑体",0,20));
		// 得到图表底部类别，并给其设置字体
		chart.getLegend().setItemFont(new Font("宋体",0,12));
		// 得到饼状图样式的样式
		PiePlot plot = (PiePlot)chart.getPlot();
		if(is3D){
			plot = (PiePlot3D) chart.getPlot(); 
		}
		// 设置饼状图字体
		plot.setLabelFont(new Font("宋体",0,12));
		// 设置饼图上显示信息
		plot.setSectionOutlinePaint("茄子",Color.white);
		 // 图片背景色    
        chart.setBackgroundPaint(Color.red);  
        //设置开始角度 
        plot.setStartAngle(150D); 
        //设置方向为”顺时针方向“ 
        plot.setDirection(Rotation.CLOCKWISE); 
        //设置透明度，0.5F为半透明，1为不透明，0为全透明 
        plot.setForegroundAlpha(0.5F); 
        plot.setNoDataMessage("无数据显示"); 
        // 图形边框颜色    
        plot.setBaseSectionOutlinePaint(Color.RED);    
        plot.setBaseSectionPaint(Color.WHITE); 
        //指定 section 轮廓线的厚度
        plot.setBaseSectionOutlineStroke(new BasicStroke(0));
        // 图形边框粗细    
        plot.setBaseSectionOutlineStroke(new BasicStroke(1.0f));    
        // 指定图片的透明度(0.0-1.0)    
        plot.setForegroundAlpha(0.65f);    
        // 指定显示的饼图上圆形(false)还椭圆形(true)    
        plot.setCircular(true);    
        // 设置鼠标悬停提示    
        plot.setToolTipGenerator(new StandardPieToolTipGenerator());    
        // 设置突出显示的数据块    
        plot.setExplodePercent("One", 0.1D);    
		
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
