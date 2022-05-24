package com.yy.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yy.entity.Department;
import com.yy.service.DepartmentService;

/**
* @author 陈籽伟
* @version 创建时间：2020年11月9日 下午4:51:03
* 类说明
*/
@Controller
@RequestMapping("department")
@CrossOrigin
public class DepartmentController {

	@Resource
	private DepartmentService departmentService;
	
	/**
	 * 查询
	 * @param department
	 * @return
	 */
	@ResponseBody
	@RequestMapping("seldepartment.action")
	public Object selDepartment(String groupID) {
		return departmentService.selDepartment(groupID);
	}
	
	/**
	 * 修改
	 * @param listData
	 * @return
	 */
	@ResponseBody
	@RequestMapping("editdepartment.action")
	public Object editDepartment(Department department) {
		return departmentService.editDepartment(department);
	}
	
}
