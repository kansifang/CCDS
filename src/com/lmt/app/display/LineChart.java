package com.lmt.app.display;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Font;
import java.awt.GradientPaint;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.TimeZone;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.StandardChartTheme;
import org.jfree.chart.axis.CategoryAxis;
import org.jfree.chart.axis.CategoryLabelPositions;
import org.jfree.chart.axis.PeriodAxis;
import org.jfree.chart.axis.PeriodAxisLabelInfo;
import org.jfree.chart.axis.ValueAxis;
import org.jfree.chart.labels.ItemLabelAnchor;
import org.jfree.chart.labels.ItemLabelPosition;
import org.jfree.chart.labels.StandardCategoryItemLabelGenerator;
import org.jfree.chart.labels.StandardXYItemLabelGenerator;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.category.CategoryItemRenderer;
import org.jfree.chart.renderer.category.LineAndShapeRenderer;
import org.jfree.chart.renderer.xy.XYItemRenderer;
import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer;
import org.jfree.data.category.CategoryDataset;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.data.time.Day;
import org.jfree.data.time.Month;
import org.jfree.data.time.RegularTimePeriod;
import org.jfree.data.time.TimeSeries;
import org.jfree.data.time.TimeSeriesCollection;
import org.jfree.data.time.Year;
import org.jfree.data.xy.XYDataset;
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
	public static XYDataset createDataset(String sSql,Transaction Sqlca) throws Exception {
		// ������������  
		TimeSeries series = new TimeSeries("������"); 
		ASResultSet rs=Sqlca.getASResultSet(sSql);
		// �������
		while(rs.next()){
			String date=rs.getString(3);
			int year=Integer.valueOf(date.substring(0, 4));
			int month=Integer.valueOf(date.substring(5, 7));
			RegularTimePeriod YM=new Month(month,year);
			series.add(YM, rs.getDouble(1));  
		}
         // ���������з���һ�����ݼ�����  
         TimeSeriesCollection dataset = new TimeSeriesCollection();  
         dataset.addSeries(series);   
         return dataset;  
     }
	 /** 
     * �����������,�Զ���λ��ʱ�������ϵ���һ��ʱ��㣬�������ݵ���뵽���������� 
     * 
     * @param series    �������ж��� 
     * @param baseData  ���ɵ�������ݵĻ�׼ֵ 
     * @param regularTime   ������ʱ����(�ꡢ�¡��ա�ʱ���֡����) 
     * @param sampleNum  ���ɵ����ݵ���� 
     */  
    public static void setSeriesData(TimeSeries series, double baseData, RegularTimePeriod regularTime, int sampleNum) {  
        // �������ģ������  
        double value = baseData;  
        for (int i = 0; i < sampleNum; i++) {  
            series.add(regularTime, value);       
            regularTime = regularTime.next();   //�Զ���λ����һ��ʱ���  
            value *= (1.0D + (Math.random() - 0.495D) / 4.0D);  
        }  
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
		
		GradientPaint bg = new GradientPaint(0, 50, new Color(248, 253, 255),0, 250, new Color(205, 237, 252));  
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
		domainAxis.setMinorTickMarksVisible(true);
		domainAxis.setMinorTickMarkInsideLength(500);//ÿ10���̶���ʾһ���̶�ֵ
		//domainAxis.setCategoryLabelPositionOffset(10);
		domainAxis.setCategoryLabelPositions(CategoryLabelPositions.DOWN_45);
		// ��������������ֵ����弰����ת����  
		ValueAxis rangeAxis = plot.getRangeAxis(); 
		rangeAxis.setLabelFont(new Font("����", Font.BOLD, 15)); 
		rangeAxis.setLabelAngle(Math.PI/2);   
		
		// ��ȡ��Ⱦ����        
		LineAndShapeRenderer lineandshaperenderer = (LineAndShapeRenderer) plot.getRenderer(); 
        //���������Ƿ���ʾ���ݵ�
        lineandshaperenderer.setBaseShapesVisible(true);
        //����������ʾλ��
       // lineandshaperenderer.setBasePositiveItemLabelPosition(new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BASELINE_CENTER)); 
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
        //����������ʾ�����ݵ��ֵ
        CategoryItemRenderer item = plot.getRenderer();
        item.setBaseItemLabelsVisible(true);
        //����������ʾλ��
        item.setBasePositiveItemLabelPosition(new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BASELINE_CENTER));
        //���������Ƕ���������ͼ���ݱ�ʾ�Ĺؼ�����
        item.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());
        item.setBaseItemLabelFont(new Font("Dialog", 1, 14));
        plot.setRenderer(item);
        
		// �����Զ���ͼ����Ƶ��������    
		//ChartRenderingInfo info = new ChartRenderingInfo(new StandardEntityCollection());  
		// ����ͼƬ���ɸ�ʽ       
		//String fileName =      ServletUtilities.saveChartAsPNG(chart, width, height, info, session);        
		// ����ͼƬ����·��  
		//String graphURL =      request.getContextPath() + "/servlet/DisplayChart?filename=" + fileName; 
	}
	 /** 
     * ����jfreechartͼ�� 
     * */  
    public static JFreeChart createChart(String sSql,Transaction Sqlca) {  
        // ����ͼ�����ݼ���  
        XYDataset xyDataset=null;
		try {
			//xyDataset = (XYDataset) getDataSet(sSql,Sqlca);
			xyDataset = createDataset(sSql,Sqlca);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}   
        // ���Ӻ���֧��  
        StandardChartTheme standardChartTheme=new StandardChartTheme("CN");     //����������ʽ            
        standardChartTheme.setExtraLargeFont(new Font("����",Font.BOLD,20));    //���ñ�������         
        standardChartTheme.setRegularFont(new Font("SimSun",Font.PLAIN,15));    //����ͼ��������      
        standardChartTheme.setLargeFont(new Font("����",Font.PLAIN,15));      //�������������     
        //�������񱳾���ɫ    
        //standardChartTheme.setBaselinePaint(Color.WHITE); 
        //��������������ɫ   
        //standardChartTheme.setDomainGridlinePaint(Color.blue);
        //�������������ɫ   
        standardChartTheme.setRangeGridlinePaint(Color.green);
        standardChartTheme.setAxisOffset(new RectangleInsets(0D, 1D, 0D, 30D));
        ChartFactory.setChartTheme(standardChartTheme); //Ӧ��������ʽ      
          
        // ����һ��ʱ������ͼ���JFreeChart  
        JFreeChart jFreeChart = ChartFactory.createTimeSeriesChart(  
                "����ͼչʾ",   // ͼ����  
                "ʱ��",               // �����ǩ����  
                "��ֵ",               // �����ǩ����  
                xyDataset,          // ͼ������ݼ���  
                true,               // �Ƿ���ʾͼ����ÿ���������е�˵��  
                false,              // �Ƿ���ʾ������ʾ  
                false);             // �Ƿ���ʾͼ�������õ�url��������  
      
        // XYPlotͼ����������ö���,��������ͼ���һЩ��ʾ����  
        XYPlot xyPlot = (XYPlot) jFreeChart.getPlot();    
 	 		
     // ��ȡ��Ⱦ����    
        // �������ݵ�������ߵ���ʾ��ʽ  
        XYItemRenderer item = xyPlot.getRenderer();
        if (item instanceof XYLineAndShapeRenderer) {  
            XYLineAndShapeRenderer renderer = (XYLineAndShapeRenderer) item;  
            renderer.setBaseShapesVisible(true);    // ���ݵ���ʾ���  
            renderer.setBaseShapesFilled(true); // ���ݵ���������  
            
        }  
         //����������ʾ�����ݵ��ֵ
         //���������Ƿ���ʾ���ݵ�
         //item.setBaseSeriesVisible(true);
         //����������ʾλ��
         item.setBaseItemLabelsVisible(true);
         item.setBasePositiveItemLabelPosition(new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BASELINE_LEFT));
         //item.setBasePositiveItemLabelPosition(new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BASELINE_CENTER));
         //���������Ƕ���������ͼ���ݱ�ʾ�Ĺؼ�����
         item.setBaseItemLabelGenerator(new StandardXYItemLabelGenerator());
         item.setBaseItemLabelFont(new Font("Dialog", 1, 14));
         xyPlot.setRenderer(item);
          
         ///////////////////////////////  �¹��ܵ� /////////////////////////////////////////    
        // �Զ����µ�ʱ���ᣬ������ʾ����ʱ���ǩ  
        PeriodAxis periodAxis = new PeriodAxis("ʱ��");   // �Զ���Xʱ����  
        periodAxis.setTimeZone(TimeZone.getDefault());  // ʹ��Ĭ��ʱ��  
        periodAxis.setAutoRangeTimePeriodClass(Month.class); // ���ø�ʱ����Ĭ���Զ�����ʱ�䵥λΪ�� �� Day.class
        // ���ò�ͬ�ص�ʱ����ʾ��ʽ  
        PeriodAxisLabelInfo[] arrayOfPeriodAxisLabelInfo = new PeriodAxisLabelInfo[2];  
        //arrayOfPeriodAxisLabelInfo[0] = new PeriodAxisLabelInfo(Day.class, new SimpleDateFormat("dd")); // ��һ����ʾ��  
        arrayOfPeriodAxisLabelInfo[0] = new PeriodAxisLabelInfo(Month.class, new SimpleDateFormat("MM"), new RectangleInsets(2.0D,2.0D,2.0D,2.0D), new Font("SansSerif", 1, 10), Color.blue, false, new BasicStroke(5.0F), Color.lightGray); // �ڶ�����ʾ��  
       // arrayOfPeriodAxisLabelInfo[0] = new PeriodAxisLabelInfo(Month.class, new SimpleDateFormat("MM"));
        arrayOfPeriodAxisLabelInfo[1] = new PeriodAxisLabelInfo(Year.class, new SimpleDateFormat("yyyy")); // ��������ʾ��  
        periodAxis.setLabelInfo(arrayOfPeriodAxisLabelInfo); // ����ʱ�����ϵ�ʱ����ʾ��ʽ  
        xyPlot.setDomainAxis(periodAxis);   // ����Xʱ����  
        
        ChartUtilities.applyCurrentTheme(jFreeChart); // ʹ�õ�ǰ����  
          
        //setStyle(jFreeChart);
        return jFreeChart;  
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
