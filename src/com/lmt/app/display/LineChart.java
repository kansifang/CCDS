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
	 * �������
	 */
	public static void main(String[] args) {
		// ��������ͼ����
		//JFreeChart ����ͼ = ChartFactory.createLineChart("ˮ������ͳ��", "ʱ��", "����", �õ�����(), PlotOrientation.VERTICAL, true, true, true);
		// ������ͼ����������ʽ
		//setStyle(����ͼ);
		// ������ͼ��������ͼƬ
		//����ͼƬ("E:\\����ͼ.jpg",����ͼ,800,600);
	}
	/*
	 * �õ�����
	 */
	public static CategoryDataset getDataSet(String sSql,Transaction Sqlca) throws Exception{
		// ������״���ݶ���
		DefaultCategoryDataset PD = new DefaultCategoryDataset();
		ASResultSet rs=Sqlca.getASResultSet(sSql);
		// �������
		while(rs.next()){
			PD.setValue(rs.getDouble(1), rs.getString(2),rs.getString(3));
		}
		// ��������
		return PD;
		// �����������ݶ���
	}
	/*
	 * ��ͼ�����������ʽ
	 */
	public static void setStyle(JFreeChart chart){
		// �õ�ͼ����⣬��������������
		chart.getTitle().setFont(new Font("����",0,20));
		// �õ�ͼ��ײ���𣬲�������������
		chart.getLegend().setItemFont(new Font("����",0,12));
		// �õ�����ͼ��ʽ����ʽ���������ø�����Զ����������        
		CategoryPlot plot = (CategoryPlot)chart.getPlot();
		// �õ�Y�����ᣬ��������˵������
		plot.getRangeAxis().setLabelFont(new Font("����",0,12));
		// �õ�Y�����ᣬ����������������
		plot.getRangeAxis().setTickLabelFont(new Font("����",0,12));
		// �õ�X�����ᣬ��������˵������
		plot.getDomainAxis().setLabelFont(new Font("����",0,12));
		// �õ�X�����ᣬ����������������
		plot.getDomainAxis().setTickLabelFont(new Font("����",0,12));
		
		GradientPaint bg = new GradientPaint(0, 50, new Color(248, 253, 255),     0, 250, new Color(205, 237, 252));  
		plot.setBackgroundPaint(bg); 
		plot.setDomainGridlinePaint(Color.BLACK);  
		plot.setDomainGridlinesVisible(true);   
		plot.setRangeGridlinePaint(Color.RED); 
		//�������񱳾���ɫ
        plot.setBackgroundPaint(Color.white);
        //��������������ɫ
        plot.setDomainGridlinePaint(Color.pink);
        //�������������ɫ
        plot.setRangeGridlinePaint(Color.pink);
        //��������ͼ��xy��ľ���
        plot.setAxisOffset(new RectangleInsets(0D, 0D, 0D, 10D));
		// ���ú����������� 
		CategoryAxis domainAxis = plot.getDomainAxis(); 
		domainAxis.setLabelFont(new Font("����", Font.BOLD, 15));        
		// ��������������ֵ����弰����ת����  
		ValueAxis rangeAxis = plot.getRangeAxis(); 
		rangeAxis.setLabelFont(new Font("����", Font.BOLD, 15)); 
		rangeAxis.setLabelAngle(Math.PI/2);   
		
		// ��ȡ��Ⱦ����        
		LineAndShapeRenderer lineandshaperenderer = (LineAndShapeRenderer) plot.getRenderer(); 
        //���������Ƿ���ʾ���ݵ�
        lineandshaperenderer.setBaseShapesVisible(true);
        //����������ʾλ��
        lineandshaperenderer.setBasePositiveItemLabelPosition(new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BASELINE_CENTER)); 
        //����������ʾ�����ݵ��ֵ
        CategoryItemRenderer item = plot.getRenderer();
        item.setBaseItemLabelsVisible(true);
        item.setBasePositiveItemLabelPosition(new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BASELINE_LEFT));
        //���������Ƕ���������ͼ���ݱ�ʾ�Ĺؼ�����
        item.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());
        item.setBaseItemLabelFont(new Font("Dialog", 1, 14));
        plot.setRenderer(item);
        /**/
        String bookTitle[] = {"Python", "JAVA", "C#", "Perl", "PHP"};
		// �Զ����߶εĻ�����ɫ
		Color color[] = new Color[bookTitle.length]; 
		color[0] = new Color(99,99,0); 
		color[1] = new Color(255,169,66); 
		color[2] = new Color(33,255, 66); 
		color[3] = new Color(33,0,255); 
		color[4] = new Color(255,0,66);  
		for (int i = 0; i < color.length; i++)  { 
			lineandshaperenderer.setSeriesPaint(i, color[i]); 
		}  
		// �Զ����߶εĻ��Ʒ�� 
		BasicStroke bs ;  
		for (int i = 0; i < bookTitle.length; i++)  { 
			float dashes[] = {10.0f};  
			bs = new BasicStroke(2.0f, BasicStroke.CAP_ROUND,       BasicStroke.JOIN_ROUND, 10.f, dashes, 0.0f); 
			if (i % 2 != 0)   
				lineandshaperenderer.setSeriesStroke(i, bs);   
			else    
				lineandshaperenderer.setSeriesStroke(i, new BasicStroke(2.0f));
		}
		// �����Զ���ͼ����Ƶ��������    
		//ChartRenderingInfo info = new ChartRenderingInfo(new StandardEntityCollection());  
		// ����ͼƬ���ɸ�ʽ       
		//String fileName =      ServletUtilities.saveChartAsPNG(chart, width, height, info, session);        
		// ����ͼƬ����·��  
		//String graphURL =      request.getContextPath() + "/servlet/DisplayChart?filename=" + fileName; 
	}
	/*
	 * ����ͼƬ
	 */
	public static void ����ͼƬ(String �ļ���ַ,JFreeChart ͼ��,int ���,int �߶�){
		try {
			// ʹ��ͼ���߱����ļ�
			ChartUtilities.saveChartAsJPEG(new File(�ļ���ַ),ͼ��,��� ,�߶�);
		}catch (IOException e) {
			e.printStackTrace();
		}
	}
}
