package com.yy.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yy.entity.Person;
import com.yy.entity.Table;
import com.yy.service.PersonService;

/**
* @author 陈籽伟
* @version 创建时间：2020年11月10日 下午1:51:28
* 类说明
*/
@Controller
@RequestMapping("person")
@CrossOrigin
public class PersonController {

	@Resource
	private PersonService personService;
	
	/**
	 * 查询部门人员
	 * @param person
	 * @return
	 */
	@ResponseBody
	@RequestMapping("selperson.action")
	public Object selPerson(Person person) {
		// System.out.println("===================\n"+person.getUserId()+"============");
		return personService.selPserson(person);
	}
	
	
	/**
	 * 添加部门人员
	 * @param person
	 * @return
	 */
	@ResponseBody
	@RequestMapping("addperson.action")
	public Object addPerson(Person person) {
		return personService.addPerson(person);
	}
	
	/**
	 * 修改部门人员
	 * @param person
	 * @return
	 */
	@ResponseBody
	@RequestMapping("editperson.action")
	public Object editPerson(Person person,String mobilePhone){
		return personService.editPerson(person,mobilePhone);
	}
	
	/**
	 * 添加部门表格
	 * @param table
	 * @return
	 */
	@ResponseBody
	@RequestMapping("addpersontable.action")
	public Object addPersonTable(Table table,String groupName) {
		return personService.addPersonTable(table,groupName);
	}
	
	/**
	 * 查询部门表格
	 * @param table
	 * @return
	 */
	@ResponseBody
	@RequestMapping("selpersontable.action")
	public Object selPersonTable(Table table,String groupName) {
		return personService.selPersonTable(table,groupName);
	}
	/**
	 * 修改部门表格
	 * @param table
	 * @param groupName
	 * @return
	 */
	@ResponseBody
	@RequestMapping("editpersontable.action")
	public Object editPersonTable(Table table,String groupName,String phone) {
		return personService.editPersonTable(table,groupName,phone);
	}
}
