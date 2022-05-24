package com.yy.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;


import com.yy.entity.UserGroup;
import com.yy.service.MenuService;

/**
* @author 陈籽伟
* @version 创建时间：2020年10月30日 下午2:57:19
* 类说明
*/

@Controller
@RequestMapping("menu")
@CrossOrigin
public class MenuController {

	@Resource 
	private MenuService menuService;
	
	/**
	 * 查询菜单
	 * @param UserID
	 * @param cGroupName
	 * @return
	 */
	@ResponseBody
	@RequestMapping("selmenugroup.action")
	public Object selMenu(String UserID,String cGroupName) {
		
		return menuService.selMenuGroup(UserID, cGroupName);
	}
	
	/**
	 * 添加用户菜单
	 * @param menu
	 * @param userGroup
	 * @return
	 */
	@ResponseBody
	@RequestMapping("addmenugroup.action")
	public Object addMenu(UserGroup userGroup,String choose,String addName) {		
		return menuService.addMenuGroup(userGroup,choose,addName);
	}
	
	/**
	 * 查询用户菜单
	 * @param userGroup
	 * @return
	 */
	@ResponseBody
	@RequestMapping("selusergroup.action")
	public Object selUserMenu(String UserID,String cGroupName) {		
		return menuService.selUserGroup(UserID, cGroupName);
	}
	/**
	 * 查询发布页面信息
	 * @param UserID
	 * @param cGroupName
	 * @param title
	 * @return
	 */
	@ResponseBody
	@RequestMapping("selgroupdata.action")
	public Object selGroupData(String UserID, String cGroupName, String title) {
		return menuService.selMenuData(UserID, cGroupName, title);
	}
	
	@ResponseBody
	@RequestMapping("editmenu.action")
	public void editRoot(UserGroup userGroup) {
		menuService.editRoot(userGroup);
	}
}
	
