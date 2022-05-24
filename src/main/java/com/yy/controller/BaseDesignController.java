package com.yy.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.yy.entity.BaseDesign;
import com.yy.entity.CreateMySQL;
import com.yy.service.BaseDesignService;

/**
* @author 陈籽伟
* @version 创建时间：2020年8月25日 上午11:43:01
* 类说明
*/

@RequestMapping("design")
@Controller
@CrossOrigin
public class BaseDesignController {

	@Resource
	private BaseDesignService baseDesignService;
	
	/**
	 * 查询
	 * @param baseDesign
	 * @return
	 */
	@ResponseBody
	@RequestMapping("seldesign.action")
	public Object selDesign(BaseDesign baseDesign) {
		return baseDesignService.selDesign(baseDesign);
	}
	
	/**
	 * 查询2
	 * @param baseDesign
	 * @return
	 */
	@ResponseBody
	@RequestMapping("seldesign2.action")
	public Object selDesign2(BaseDesign baseDesign) {
		return baseDesignService.selDesign2(baseDesign);
	}	
	
	
	@ResponseBody
	@RequestMapping("seldesign3.action")
	public Object selDesign3(BaseDesign baseDesign) {
		return baseDesignService.selDesign3(baseDesign);
	}
	
	
	
	
	
	/**
	 * 添加
	 * @param baseDesign
	 * @return
	 */
	@ResponseBody
	@PostMapping("adddesign.action")
	public Object addDesign(BaseDesign baseDesign) {
		return baseDesignService.addDesign(baseDesign);
	}
	
	/**
	 * 修改
	 * @param baseDesign
	 * @return
	 */
	@ResponseBody
	@PutMapping("editdesign.action")
	public Object editDesign(BaseDesign baseDesign) {
		return baseDesignService.editDesign(baseDesign);
	}
	
	/**
	 * 删除
	 * @param ID
	 * @return
	 */
	@ResponseBody
	@PostMapping("deletedesign.action")
	public Object deleteDesign(String ID) {
		return baseDesignService.deleteDesign(ID);
	}
	
	/**
	 * 数据库创建表
	 * @return
	 */
	@ResponseBody
	@RequestMapping("createmysql.action")
	public Object addMySQL(CreateMySQL createMySQL) {
		return baseDesignService.createMySQL(createMySQL);	
	}
}
