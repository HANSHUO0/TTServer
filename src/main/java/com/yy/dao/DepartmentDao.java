package com.yy.dao;

import java.util.List;

import com.yy.entity.Department;

/**
* @author 陈籽伟
* @version 创建时间：2020年11月9日 下午4:44:04
* 类说明
*/



public interface DepartmentDao {

	public List<Department> selDepartment(String groupID);
	
	public Integer addDepartment(Department department);
	
	public Integer editDepartment(Department department);
}
