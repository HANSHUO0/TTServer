package com.yy.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yy.dao.CustomerDao;
import com.yy.entity.Customer;
import com.yy.entity.CustomerAddress;
import com.yy.entity.CustomerAssociation;
import com.yy.entity.CustomerClass;
import com.yy.entity.CustomerDesign;
import com.yy.entity.CustomerEffective;
import com.yy.entity.CustomerPeople;
import com.yy.service.CustomerService;


/**
* @author 陈籽伟
* @version 创建时间：2020年12月1日 下午6:43:22
* 类说明
*/

@Controller
@RequestMapping("customer")
@CrossOrigin
public class CustomerController {
	
	@Resource
	private CustomerService customerService;
	@Resource
	private CustomerDao customerDao;
	
	@ResponseBody
	@RequestMapping("addcustomer.action")
	public Object addCustomer(Customer customer) {
		return customerService.addCustomer(customer);
	}
	
	@ResponseBody
	@RequestMapping("selcustomer.action")
	public Object selCustomer(Customer customer) {
		return customerService.selCustomer(customer);
	}
	
	@ResponseBody
	@RequestMapping("delcustomer.action")
	public Object eelCustomer(String[] ids) {
		return customerDao.delCustomer(ids);
	}
	
	
	@ResponseBody
	@RequestMapping("selcustomerdesign.action")
	public Object selCustomerDesign(CustomerDesign customerDesign,String groupName) {
		return customerService.selCustomerDesign(customerDesign,groupName);
	}
	
	@ResponseBody
	@RequestMapping("addcustomerdesign.action")
	public Object addCustomerDesign(CustomerDesign customerDesign,String groupName) {
		return customerService.addCustomerDesign(customerDesign,groupName);
	}
	
	
	@ResponseBody
	@RequestMapping("editcustomerdesign.action")
	public Object editCustomerDesign(CustomerDesign customerDesign,String groupName) {
		return customerService.editCustomerDesign(customerDesign,groupName);
	}
	
	@ResponseBody
	@RequestMapping("selcustomerclass.action")
	public Object selCustomerClass(CustomerClass customerClass,String groupName) {
		return customerService.selCustomerClass(customerClass, groupName);
	}
	
	
	@ResponseBody
	@RequestMapping("addcustomerclass.action")
	public Object addCustomerClass(CustomerClass customerClass,String groupName) {
		return customerService.addCustomerClass(customerClass, groupName);
	}
	
	
	@ResponseBody
	@RequestMapping("editcustomerclass.action")
	public Object editCustomerClass(CustomerClass customerClass,String groupName) {
		return customerService.editCustomerClass(customerClass, groupName);
	}
	
	@ResponseBody
	@RequestMapping("addcustomeraddress.action")
	public Object addCustomerAddress(CustomerAddress customerAddress,String groupName) {
		return customerService.addCustomerAddress(customerAddress, groupName);
	}
	
	@ResponseBody
	@RequestMapping("addcustomerassociation.action")
	public Object addCustomerAssociation(CustomerAssociation customerAssociation,String groupName) {
		return customerService.addCustomerAssociation(customerAssociation, groupName);
	}
	
	@ResponseBody
	@RequestMapping("selcustomerassociation.action")
	public Object selCustomerAssociation(CustomerAssociation customerAssociation) {
		return customerDao.selCustomerAssociation(customerAssociation);
	}
	
	
	
	@ResponseBody
	@RequestMapping("addcustomereffective.action")
	public Object addCustomerEffective(CustomerEffective customerEffective,String groupName) {
		return customerService.addCustomerEffective(customerEffective, groupName);
	}
	
	@ResponseBody
	@RequestMapping("addcustomerpeople.action")
	public Object addCustomerPeople(CustomerPeople customerPeople,String groupName) {
		return customerService.addCustomerPeople(customerPeople, groupName);
	}
	
	@ResponseBody
	@RequestMapping("selcustomereffective.action")
	public Object selCustomerEffective(CustomerEffective customerEffective) {
		return customerDao.selCustomerEffective(customerEffective);
	}
	
	@ResponseBody
	@RequestMapping("selcustomerpeople.action")
	public Object selCustomerpeople(CustomerPeople customerPeople) {
		return customerDao.selCustomerPeople(customerPeople);
	}
	
	@ResponseBody
	@RequestMapping("delcustomerpeople.action")
	public Object delCustomerpeople(CustomerPeople customerPeople) {
		return customerDao.delCustomerPeople(customerPeople);
	}
	
	
	@ResponseBody
	@RequestMapping("selcustomeraddress.action")
	public Object selCustomerAddress(CustomerAddress customerAddress) {
		return customerDao.selCustomerAddress(customerAddress);
	}
	
	@ResponseBody
	@RequestMapping("delcustomeraddress.action")
	public Object delCustomerAddress(CustomerAddress customerAddress) {
		return customerDao.delCustomerAddress(customerAddress);
	}
}
