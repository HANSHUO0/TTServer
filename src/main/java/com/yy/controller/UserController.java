package com.yy.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yy.entity.User;
import com.yy.service.UserService;

/**
* @author 陈籽伟
* @version 创建时间：2020年9月8日 下午4:03:41
* 类说明
*/
@Controller
@RequestMapping("user")
@CrossOrigin
public class UserController {
	
	@Resource
	private UserService userService;
	
	
	/**
	 * 查询用户
	 * @param user
	 * @return
	 */
	@ResponseBody
	@RequestMapping("seluser.action")
	public Object selUser(User user) {
	 return	userService.selUser(user);
	}
	
	/**
	 * 添加用户
	 * @param user
	 * @return
	 */
	@ResponseBody
	@RequestMapping("adduser.action")
	public Object addUser(User user) {
		return userService.addUser(user);
	}
	
	/**
	 * 删除用户
	 * @param ID
	 * @return
	 */
	@ResponseBody
	@RequestMapping("deleteuser.action")
	public Object deleteUser(String ID) {
		return userService.deleteUser(ID);
	}
	
	/**
	 * 编辑用户
	 * @param user
	 * @return
	 */
	@ResponseBody
	@RequestMapping("edituser.action")
	public Object editUser(User user) {
		return userService.editUser(user);
	}
	
	/**
	 * 登录检测
	 * @param user
	 * @return
	 */
	@ResponseBody
	@RequestMapping("login.action")
	public Object Login(User user) {
		return userService.login(user);
	}
	
	
	/**
	 * 密码修改
	 * @param user
	 * @return
	 */
	@ResponseBody
	@RequestMapping("changepassword.action")
	public Object ChangePassword(User user) {
		return userService.ChangePassword(user);
	}
	
	
}
