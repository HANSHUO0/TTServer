package com.yy.service;

import com.yy.entity.Person;
import com.yy.entity.Role;

/**
* @author 陈籽伟
* @version 创建时间：2021年1月20日 下午3:15:31
* 类说明
*/
public interface RoleService {

	public Object selRole(Role role);
	public Object editRole(Role role);
	public Object addRole(Role role);
	public Object selRole(Person person);
}
