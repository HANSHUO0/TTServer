package com.yy.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yy.entity.IncreaseRules;
import com.yy.service.IncreaseRulesService;

/**
* @author 陈籽伟
* @version 创建时间：2020年12月11日 上午11:05:12
* 类说明
*/
@Controller
@RequestMapping("increaserules")
@CrossOrigin
public class IncreaseRulesController {
	
	@Resource
	private IncreaseRulesService increaseRulesService;
	
	
	@ResponseBody
	@RequestMapping("selincreaserules.action")
	public Object selIncreaseRules(IncreaseRules increaseRules,String groupName) {
		return increaseRulesService.selIncreaseRules(increaseRules, groupName);
	}
	
	@ResponseBody
	@RequestMapping("addincreaserules.action")
	public Object addIncreaseRules(IncreaseRules increaseRules,String groupName) {
		return increaseRulesService.addIncreaseRules(increaseRules, groupName);
	}
	
	@ResponseBody
	@RequestMapping("editincreaserules.action")
	public Object editIncreaseRules(IncreaseRules increaseRules,String groupName) {
		return increaseRulesService.editIncreaseRules(increaseRules, groupName);
	}
}
