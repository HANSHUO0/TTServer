package com.yy.service;

import com.yy.entity.UserGroup;

/**
* @author 陈籽伟
* @version 创建时间：2020年10月30日 下午2:49:03
* 类说明
*/


public interface MenuService {
	
	public Object selMenuGroup(String UserID,String cGroupName);
	
	public void editRoot(UserGroup userGroup);
	
	public Object addMenuGroup(UserGroup userGroup,String choose,String addName);
	
	public Object selUserGroup(String UserID,String cGroupName);
	
	public Object selMenuData(String UserID,String cGroupName,String title);
}
