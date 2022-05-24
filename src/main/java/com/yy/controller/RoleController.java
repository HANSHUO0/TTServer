package com.yy.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yy.entity.Person;
import com.yy.entity.Role;
import com.yy.service.RoleService;

/**
* @author 陈籽伟
* @version 创建时间：2021年1月20日 下午2:46:28
* 类说明
*/
@Controller
@RequestMapping("role")
@CrossOrigin
public class RoleController {

	@Resource
	private RoleService roleService;
	
	@ResponseBody
	@RequestMapping("selrole.action")
	public Object selRole(Role role) {
		return roleService.selRole(role);
	}
	
	
	@ResponseBody
	@RequestMapping("seluserrole.action")
	public Object selRole(Person person) {
		return roleService.selRole(person);
	}
	
	
	@ResponseBody
	@RequestMapping("addrole.action")
	public Object addRole(Role role) {
		return roleService.addRole(role);
	}
	

	
	@ResponseBody
	@RequestMapping("editrole.action")
	public Object editRole(Role role) {
		return roleService.editRole(role);
	}
	
}
