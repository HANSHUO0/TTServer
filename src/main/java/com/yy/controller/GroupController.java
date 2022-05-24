package com.yy.controller;


import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yy.entity.Group;
import com.yy.service.GroupService;

/**
* @author 陈籽伟
* @version 创建时间：2020年10月27日 下午3:26:27
* 类说明
*/
@Controller
@RequestMapping("group")
@CrossOrigin
public class GroupController {
	
	@Resource
	private GroupService groupService;


	/**
	 * 查询
	 * @param ID
	 * @return
	 */
	@ResponseBody
	@RequestMapping("selgroup.action")
	public Object selGroup(Group group,Integer page, Integer limit) {
		return groupService.selGroup(group,page,limit);
	}
	
	/**
	 * 添加
	 * @return
	 */
	@ResponseBody
	@RequestMapping("addgroup.action")
	public Object addGroup(Group group) {	
		return groupService.addGroup(group);
	}
	
	/**
	 * 修改
	 * @param group
	 * @return
	 */
	@ResponseBody
	@RequestMapping("editgroup.action")
	public Object editGroup(Group group) {		
		return groupService.editGroup(group);
	}
	
	
}
