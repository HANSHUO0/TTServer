package com.yy.controller;


import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import com.yy.dao.UserDao;
import com.yy.entity.User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.yy.dao.AddFileDao;
import com.yy.dao.CustomerDao;
import com.yy.dao.GroupDao;
import com.yy.entity.AddFile;
import com.yy.entity.Customer;
import com.yy.entity.Group;
import com.yy.util.ExcelUtil;

import lombok.Data;



@Controller
@RequestMapping("upload")
public class UploadController {
	
	 @Resource
	 private GroupDao groupDao;
	 @Resource
	 private CustomerDao customerDao;
	 @Resource 
	 private AddFileDao addFileDao;
	 @Resource
	 private UserDao userDao;
	 
	/**
	 * 上传图片
	 * @param file
	 * @return
	 */
	@RequestMapping("uploadimg.action")
	@ResponseBody
	public Map<String,Object> uploadImg(@RequestParam(required = false)MultipartFile file) {
		
				//第一步存放路径
				String pathName = "C:\\Users\\Administrator\\Desktop\\project\\pud\\src\\main\\webapp\\img";
				String day = new SimpleDateFormat("yyyyMMdd").format(new Date());
				File file1 = new File(pathName+"/"+day);
				if(!file1.exists()&&!file1.isDirectory()) {
					file1.mkdirs();
				}
			
				//设置文件名
				
				String oldName = file.getOriginalFilename();
				String[] split = oldName.split("\\.");
				String string = split[split.length-1];
				String imgName = UUID.randomUUID().toString().replace("-", "")+"."+string;
				File file2 = new File(file1,imgName);
				Map<String, Object> map = new HashMap<String,Object>();
				try {
					file2.createNewFile();
					file.transferTo(file2);

					class uploadReturn {
				        public String src = day+"/"+imgName;
				        public String title; 
				    }

					map.put("msg", "上传成功");
					map.put("code", 200);
					map.put("data", new uploadReturn());

					
				} catch (IOException e) {
		            map.put("msg","上传失败");
		            map.put("code",0);
					e.printStackTrace();
				}
						
				return map;

	}
	
	
	
	
	/**
	 * 导入客户档案excel
	 * @param excelFile
	 * @param response
	 * @return
	 * @throws IOException
	 */
	@ResponseBody
	@RequestMapping("uploadexcel.action")
	public Map<String, Object> excleimport(@RequestParam  MultipartFile excelFile,String groupName,HttpServletResponse response) throws IOException {
		
		response.setHeader("Access-Control-Allow-Origin", "*");
		Map<String, Object> map = new HashMap<String, Object>();
		String name = excelFile.getOriginalFilename();
		if (!name.endsWith(".xls") && !name.endsWith(".xlsx")) {
			map.put("result", "文件类型错误");
		} else {
			 String fileName = excelFile.getOriginalFilename(); // 获取文件名
			 
			 Group group = new Group();
			 group.setCGroupName(groupName);
			 String groupId = groupDao.selGroup(group).get(0).getID();
		     InputStream is = null;
			 is = excelFile.getInputStream();
			 List<Map> customerList = new ExcelUtil(new Customer()).AnalysisExcel(is, fileName,1,groupId);
			 customerDao.addCustomerExcel(customerList);
             map.put("result", "导入成功");
		}
		
		return map;
	}
	
	@ResponseBody
	@RequestMapping("addfile.action")
	public void addFile(AddFile addFile) {
		 addFileDao.addFile(addFile);
	}
	
	
	@ResponseBody
	@RequestMapping("selfile.action")
	public Object selFile(AddFile addFile) {
		 return addFileDao.selAddFile(addFile);
	}

	
	@ResponseBody
	@RequestMapping("deletefile.action")
	public void deleteFile(AddFile addFile) {
		 addFileDao.deleteFile(addFile);
	}
	
}