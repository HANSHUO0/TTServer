package com.yy.service;

import com.yy.entity.*;

/**
* @author 陈籽伟
* @version 创建时间：2020年12月2日 上午10:55:44
* 类说明
*/
public interface CustomerService {
	
	public Object addCustomer(Customer customer);
	public Object selCustomer(Customer customer);
	
	public Object selCustomerDesign(CustomerDesign customerDesign,String groupName);
	public Object addCustomerDesign(CustomerDesign customerDesign,String groupName);
	public Object editCustomerDesign(CustomerDesign customerDesign,String groupName);
	
	public Object selCustomerClass(CustomerClass customerClass,String groupName);
	public Object addCustomerClass(CustomerClass customerClass,String groupName);
	public Object editCustomerClass(CustomerClass customerClass,String groupName);
	
	public Object addCustomerPeople(CustomerPeople customerPeople,String groupName);
	public Object addCustomerAddress(CustomerAddress customerAddress,String groupName);
	public Object addCustomerAssociation(CustomerAssociation customerAssociation,String groupName);
	public Object addCustomerEffective(CustomerEffective customerEffective,String groupName);

	Object editCustomerMessage(User user);
}
