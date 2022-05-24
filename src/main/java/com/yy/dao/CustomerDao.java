package com.yy.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.yy.entity.*;
import org.apache.ibatis.annotations.Select;


/**
* @author 陈籽伟
* @version 创建时间：2020年12月1日 下午6:23:11
* 类说明
*/
public interface CustomerDao {

	public Integer addCustomer(Customer customer);
	public Integer delCustomer(String[] ids);
	public Integer addCustomerExcel(List<Map> customers);
	
	public List<Customer> selCustomer(Customer customer);
	
	public List<CustomerDesign> selCustomerDesigns(CustomerDesign customerDesign);
	public Integer editCustomerDesign(CustomerDesign customerDesign);
	public Integer addCustomerDesign(CustomerDesign customerDesign);
	
	@Select("select * from im_customerclass where groupID = #{groupID} and selectID = #{selectID}")
	public List<CustomerClass> selCustomerClasses(CustomerClass customerClass);
	
	public Integer addCustomerClass(CustomerClass customerClass);
	public Integer editCustomerClass(CustomerClass customerClass);
	
	public Integer addCustomerPeople(CustomerPeople customerPeople);
	public Integer delCustomerPeople(CustomerPeople customerPeople);
	public List<CustomerPeople> selCustomerPeople(CustomerPeople customerPeople);
	public void editCustomerPeople (CustomerPeople customerPeople);
	
	public Integer addCustomerAddress(CustomerAddress customerAddress);
	public void editCustomerAddress(CustomerAddress customerAddress);
	public Integer delCustomerAddress(CustomerAddress customerAddress);
	public List<CustomerAddress> selCustomerAddress(CustomerAddress customerAddress);
	
	public List<CustomerAssociation> selCustomerAssociation(CustomerAssociation customerAssociation);
	public Integer addCustomerAssociation(CustomerAssociation customerAssociation);
	
	public Integer addCustomerEffective(CustomerEffective customerEffective);

	public List<CustomerEffective> selCustomerEffective(CustomerEffective customerEffective);

	List<HashMap<String, Object>> selCustomerAndPeople(CustomerPeople customerPeople);

	List<CustomerEffective> selectCustomerEffective(User user);

	CustomerPeople selectCustomerMessage(User user);
	Integer editCustomerPhone(User user);
	Integer editCustomerCompanyAddress(User user);
}
