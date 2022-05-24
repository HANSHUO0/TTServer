package com.yy.service.serviceimpl;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.yy.dao.DepartmentDao;
import com.yy.entity.Department;
import com.yy.service.DepartmentService;

/**
* @author 陈籽伟
* @version 创建时间：2020年11月9日 下午5:05:00
* 类说明
*/
@Service
public class DepartmentServiceImpl implements DepartmentService {
	@Resource
	private DepartmentDao departmentDao;
	
	/**
	 * 查询组织树
	 */
	@Override
	public Object selDepartment(String groupID) {
		List<Department> seList = departmentDao.selDepartment(groupID);
		Map<String, Object> map = new HashMap<>();
		if (seList.size() == 0) {
			 map.put("msg","查询失败");    
	        }else {
            map.put("msg","查询成功"); 
            map.put("data",seList);
        }
		return map;
	}
	
	/**
	 * 修改组织树
	 */
	@Override
	public Object editDepartment(Department department) {
		Integer editDepartment = departmentDao.editDepartment(department);
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (editDepartment==null) {
			 map.put("msg","修改失败");   
	        }else {
            map.put("msg","修改成功"); 
        }
		return map;
	}

}
