package com.yy.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yy.dao.BaseDesignDao;
import com.yy.entity.BaseDesign;


/**
* @author 陈籽伟
* @version 创建时间：2020年8月27日 上午10:16:15
* 类说明
*/
@Controller
@RequestMapping("excel")
public class ExcelController {

	@Resource
	private BaseDesignDao baseDesignDao;

	/**
	 * 导出所有数据到excel里
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("toexcelall.action")
	@ResponseBody
	public void excelOutAll(HttpServletResponse response) throws IOException {
	
		//创建excel文件
		@SuppressWarnings("resource")
		HSSFWorkbook hw = new HSSFWorkbook();
		//创建sheet页
		HSSFSheet hs = hw.createSheet();
		//创建标题行
		HSSFRow createRow = hs.createRow(0);
		//创建每一列并赋值
		createRow.createCell(0).setCellValue("设计名称");	
		createRow.createCell(1).setCellValue("页面名称");
		createRow.createCell(2).setCellValue("数据库表");
		createRow.createCell(3).setCellValue("控制器");
		createRow.createCell(4).setCellValue("视图");
		createRow.createCell(5).setCellValue("创建时间");
		createRow.createCell(6).setCellValue("创建人");
		//获取数据
		List<BaseDesign> selDesigns = baseDesignDao.selDesign(null);
		
		//遍历数据
		int point = 1;
		for (BaseDesign baseDesign : selDesigns) {
			//创建列，经行赋值
			HSSFRow createRow2 = hs.createRow(point);
			createRow2.createCell(0).setCellValue(baseDesign.getDesignName());	
			createRow2.createCell(1).setCellValue(baseDesign.getPageTitle());
			createRow2.createCell(2).setCellValue(baseDesign.getTableName());
			createRow2.createCell(3).setCellValue(baseDesign.getController());
			createRow2.createCell(4).setCellValue(baseDesign.getViewName());
			createRow2.createCell(5).setCellValue(baseDesign.getTime());
			createRow2.createCell(6).setCellValue(baseDesign.getUserName());
			point++;
		}
		
		//设置客户端EXCEL的名称
		try {
			String name = new String("设计清单".getBytes(),"iso-8859-1");
			response.setHeader("Content-Disposition", "attachment;filename="+name+".xls");
			ServletOutputStream os = response.getOutputStream();
			hw.write(os);//字节输出流
			os.flush();
			os.close();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
	}
	
	
	
	
	
	/**
	 * 根据选择的数据导出到excel
	 * @param response
	 * @param ids
	 * @throws IOException
	 */
	@RequestMapping("out.action")
	@ResponseBody
	public void excelOut(HttpServletResponse response,Integer[] ids) throws IOException {
	
		//创建excel文件
				@SuppressWarnings("resource")
				HSSFWorkbook hw = new HSSFWorkbook();
				//创建sheet页
				HSSFSheet hs = hw.createSheet();
				//创建标题行
				HSSFRow createRow = hs.createRow(0);
				//创建每一列并赋值
				createRow.createCell(0).setCellValue("设计名称");	
				createRow.createCell(1).setCellValue("页面名称");
				createRow.createCell(2).setCellValue("数据库表");
				createRow.createCell(3).setCellValue("控制器");
				createRow.createCell(4).setCellValue("视图");
				createRow.createCell(5).setCellValue("创建时间");
				createRow.createCell(6).setCellValue("创建人");
				//获取数据
				List<BaseDesign> selDesigns = baseDesignDao.selDesignOut(ids);
				
				//遍历数据
				int point = 1;
				for (BaseDesign baseDesign : selDesigns) {
					//创建列，经行赋值
					HSSFRow createRow2 = hs.createRow(point);
					createRow2.createCell(0).setCellValue(baseDesign.getDesignName());	
					createRow2.createCell(1).setCellValue(baseDesign.getPageTitle());
					createRow2.createCell(2).setCellValue(baseDesign.getTableName());
					createRow2.createCell(3).setCellValue(baseDesign.getController());
					createRow2.createCell(4).setCellValue(baseDesign.getViewName());
					createRow2.createCell(5).setCellValue(baseDesign.getTime());
					createRow2.createCell(6).setCellValue(baseDesign.getUserName());
					point++;
				}
				
				//设置客户端EXCEL的名称
				try {
					String name = new String("设计清单".getBytes(),"iso-8859-1");
					response.setHeader("Content-Disposition", "attachment;filename="+name+".xls");
					ServletOutputStream os = response.getOutputStream();
					hw.write(os);//字节输出流
					os.flush();
					os.close();
				} catch (UnsupportedEncodingException e) {
					e.printStackTrace();
				}
	}
	
	
}