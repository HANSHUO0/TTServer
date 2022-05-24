package com.yy.dao;
/**
* @author 陈籽伟
* @version 创建时间：2021年1月20日 下午2:48:20
* 类说明
*/

import java.util.List;

import com.yy.entity.Role;

public interface RoleDao {

	public List<Role> selRole(Role role);
	public Integer addRole(Role role);
	public Integer deleteRole(Role role);
}
