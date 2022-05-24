package com.yy.service.serviceimpl;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.yy.dao.BaseDesignDao;
import com.yy.entity.BaseDesign;
import com.yy.entity.CreateMySQL;
import com.yy.service.BaseDesignService;
import com.yy.util.Code;

/**
* @author 陈籽伟
* @version 创建时间：2020年8月25日 上午11:12:37
* 类说明
*/

@Service
public class BaseDesignServiceImpl implements BaseDesignService {

	@Resource
	private BaseDesignDao baseDesignDao;

	/**
	 * 查询
	 */
	public Object selDesign(BaseDesign baseDesign) {
		
		List<BaseDesign> selDesigns = baseDesignDao.selDesign(baseDesign);
		
		List<Map<String, Object>> designData = new ArrayList<Map<String, Object>>();
		
		for (int i = 1; i < selDesigns.size()+1; i++) {
			if(selDesigns.get(i-1).getIsDel() == 0) {
				List<String> designs = new ArrayList<String>();	
				designs.add(selDesigns.get(i-1).getCid().toString());
				designs.add(selDesigns.get(i-1).getDesignName());
				designs.add(selDesigns.get(i-1).getPageTitle());
				designs.add(selDesigns.get(i-1).getTableName());
				designs.add(selDesigns.get(i-1).getController());
				designs.add(selDesigns.get(i-1).getViewName());
				designs.add(selDesigns.get(i-1).getTime());
				designs.add(selDesigns.get(i-1).getUserName());
				designs.add(selDesigns.get(i-1).getDesign());
				
				Map<String, Object> over = new HashMap<String, Object>();
				over.put("id", i);
				over.put("data", designs);
				designData.add(over);
			}	
		}
		

		
		Map<String, Object> over2 = new HashMap<String, Object>();
		over2.put("rows", designData);

		return over2;
	}
	
	

public Object selDesign2(BaseDesign baseDesign) {
		
		List<BaseDesign> selDesigns = baseDesignDao.selDesign(baseDesign);
		
		List<Map<String, Object>> designData = new ArrayList<Map<String, Object>>();
		
		for (int i = 1; i < selDesigns.size()+1; i++) {
			if(selDesigns.get(i-1).getIsDel() == 0) {
				List<String> designs = new ArrayList<String>();					
				designs.add(selDesigns.get(i-1).getTableName());
				designs.add(selDesigns.get(i-1).getDesignName());
				designs.add(selDesigns.get(i-1).getDesign());
				designs.add(selDesigns.get(i-1).getCid().toString());
				
				
				
				Map<String, Object> over = new HashMap<String, Object>();
				over.put("id", i);
				over.put("data", designs);
				designData.add(over);
			}
			
		}
		
		Map<String, Object> over2 = new HashMap<String, Object>();
		over2.put("rows", designData);
		
		return over2;
	}
	
	
public Object selDesign3(BaseDesign baseDesign) {
	
	List<BaseDesign> selDesigns = baseDesignDao.selDesign(baseDesign);

	return selDesigns;
}



	
	
	public Object addDesign(BaseDesign baseDesign) {
		String codeId = Code.getCode();
		baseDesign.setID(codeId);
		baseDesign.setCreateUserID(Code.getCode());
		Integer addDesign = baseDesignDao.addDesign(baseDesign);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("msg", "添加成功");
		if(addDesign == 0) {
			map.put("msg", "添加失败");
		}
		return map;
	}
	
	public Object editDesign(BaseDesign baseDesign) {
		Integer editDesign = baseDesignDao.editDesign(baseDesign);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("msg", "修改成功");
		if(editDesign == 0) {
			map.put("msg", "修改失败");
		}
		return map;
	}
	
	
	public Object deleteDesign(String ID) {
		
		Integer deleteDesign = baseDesignDao.deleteDesign(ID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("msg", "删除成功");
		if (deleteDesign == 0) {
			map.put("msg", "删除失败");
		}		
		return map;
	}

	

	@Override
	public Object createMySQL(CreateMySQL createMySQL) {
		
		String url = "jdbc:mysql://localhost:3306/ttserver?useUnicode=true&characterEncoding=UTF-8&serverTimezone=GMT%2B8&useSSL=false";
		String  userName = "root";
		String password = "admin";
		String driver = "com.mysql.jdbc.Driver";
		
		Map<String, Object> map = new HashMap<String, Object>();
        //连接数据库
        try {
			Class.forName(driver);
		} catch (ClassNotFoundException e) {			
			e.printStackTrace();
		}
        
        Connection conn;Statement stat;
		try {
			conn = DriverManager.getConnection(url, userName, password);
			stat = conn.createStatement();
			 //获取数据库表名
	        ResultSet rs = conn.getMetaData().getTables(null, null, "ba_customer", null);
	       // 判断表是否存在，如果存在则什么都不做，否则创建表
	        if( rs.next() ){	        	
	            return null;
	        }
	        else{
	        	String leng = "CREATE TABLE ba_customer(";
	        	String a[] = createMySQL.getClassName().split(",");
	        	String b[] = createMySQL.getMaxLength().split(",");
	        	leng += "`ID` varchar(36) NOT NULL,";
	        	for(int i=0;i<a.length;i++) {	        	
	        		if (Integer.parseInt(b[i])>255) {
	        			leng += "`"+a[i]+"` longtext DEFAULT NULL,";
					}else {
						leng += "`"+a[i]+"` varchar("+b[i]+") DEFAULT NULL,";
					}
	        		
	        	}
	        	leng = leng + "PRIMARY KEY (`ID`)" + ") ENGINE=InnoDB DEFAULT CHARSET=utf8";
	        	
	            stat.executeUpdate(leng);
	          
	        }
	        // 释放资源
	        stat.close();
	        conn.close();
	        map.put("msg", "创建成功");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return map;
	}

	
	
}
