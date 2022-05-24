package com.yy.service;

import com.yy.entity.Department;

/**
* @author 陈籽伟
* @version 创建时间：2020年11月9日 下午4:52:42
* 类说明
*/
public interface DepartmentService {

	public Object selDepartment(String groupID);
	
	public Object editDepartment(Department department);
	

}
