package com.yy.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.yy.entity.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yy.dao.ApplicationDao;

/**
* @author 陈籽伟
* @version 创建时间：2021年2月24日 下午4:21:06
* 类说明
*/
@Controller
@RequestMapping("sp")
@CrossOrigin
public class ApplicationController {

	@Resource
	private ApplicationDao applicationDao;
	
	@ResponseBody
	@RequestMapping("selapplication.action")
	public Object selApplication(Application application) {
		List<Application> seList = applicationDao.selApplication(application);
		Map<String, Object> map = new HashMap<String, Object>();
		if (seList.size() == 0) {
			 map.put("code",200);
			 map.put("msg","无数据");    
	    }else {
	         map.put("code",0); 
	         map.put("data",seList);
        }
		return map;
	}
	
	@ResponseBody
	@RequestMapping("addapplication.action")
	public Object addApplication(Application application) {
		return applicationDao.addApplication(application);
	}
	
	@ResponseBody
	@RequestMapping("editapplication.action")
	public Object editApplication(Application application,@RequestParam("customerID") String customerID,@RequestParam("userId") String userId) {
		CustomerUserPeople customerUserPeople = new CustomerUserPeople();
		customerUserPeople.setCusPeoId(customerID);
		customerUserPeople.setCreateUser(userId);
		User user = applicationDao.selectUserID(application);
		customerUserPeople.setUserId(user.getID());
		Integer num = applicationDao.addCustomerUserPeople(customerUserPeople);
		Integer integer = applicationDao.editApplication(application);
		return integer;
	}

	@ResponseBody
	@RequestMapping("selectCustomerApplication.action")
	public Object selectCustomerApplication(Application application) {
		List<HashMap> hashMaps = applicationDao.selectCustomerApplication(application);
		System.out.println(hashMaps);
		return hashMaps;
	}


}
