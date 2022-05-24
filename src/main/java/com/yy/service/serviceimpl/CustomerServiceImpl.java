package com.yy.service.serviceimpl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.yy.entity.*;
import org.springframework.stereotype.Service;
import com.github.pagehelper.PageInfo;
import com.yy.dao.CustomerDao;
import com.yy.dao.GroupDao;
import com.yy.service.CustomerService;
import com.yy.util.Code;

/**
* @author 陈籽伟
* @version 创建时间：2020年12月2日 上午11:11:00
* 类说明
*/
@Service
public class CustomerServiceImpl implements CustomerService {

	@Resource
	private CustomerDao customerDao;
	@Resource
	private GroupDao groupDao;
	
	@Override
	public Object selCustomerDesign(CustomerDesign customerDesign,String groupName) {
		Group group = new Group();
		group.setCGroupName(groupName);
		customerDesign.setGroupID(groupDao.selGroup(group).get(0).getID());
		List<CustomerDesign> seList = customerDao.selCustomerDesigns(customerDesign);
		Map<String, Object> map = new HashMap<String, Object>();
		if (seList.size() == 0) {
			 map.put("msg","查询失败");    
	        }else {
            map.put("msg","查询成功"); 
            map.put("data",seList);
        }
		return map;
	}

	@Override
	public Object addCustomerDesign(CustomerDesign customerDesign,String groupName) {
		Group group = new Group();
		group.setCGroupName(groupName);
		customerDesign.setGroupID(groupDao.selGroup(group).get(0).getID());
		customerDesign.setID(Code.getCode());
		Integer addPerson = customerDao.addCustomerDesign(customerDesign);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("msg", "添加失败");
		if (addPerson!=0) {
			map.put("msg", "添加成功");
		}		
		return map;
	}

	@Override
	public Object editCustomerDesign(CustomerDesign customerDesign,String groupName) {
		Group group = new Group();
		group.setCGroupName(groupName);
		customerDesign.setGroupID(groupDao.selGroup(group).get(0).getID());
		Integer editDepartment = customerDao.editCustomerDesign(customerDesign);
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (editDepartment==null) {
			 map.put("msg","修改失败");   
	        }else {
            map.put("msg","修改成功"); 
        }
		return map;
	}

	@Override
	public Object selCustomerClass(CustomerClass customerClass, String groupName) {
		Group group = new Group();
		group.setCGroupName(groupName);
		customerClass.setGroupID(groupDao.selGroup(group).get(0).getID());
		List<CustomerClass> selCustomerClasses = customerDao.selCustomerClasses(customerClass);
		Map<String, Object> map = new HashMap<String, Object>();
		if (selCustomerClasses.size() == 0) {
			 map.put("msg","查询失败");    
	        }else {
           map.put("msg","查询成功"); 
           map.put("data",selCustomerClasses);
       }
		return map;
	}

	@Override
	public Object addCustomerClass(CustomerClass customerClass, String groupName) {
		Group group = new Group();
		group.setCGroupName(groupName);
		customerClass.setGroupID(groupDao.selGroup(group).get(0).getID());
		customerClass.setID(Code.getCode());
		Integer addPerson = customerDao.addCustomerClass(customerClass);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("msg", "添加失败");
		if (addPerson!=0) {
			map.put("msg", "添加成功");
		}		
		return map;
	}

	@Override
	public Object editCustomerClass(CustomerClass customerClass, String groupName) {
		Group group = new Group();
		group.setCGroupName(groupName);
		customerClass.setGroupID(groupDao.selGroup(group).get(0).getID());
		Integer editDepartment = customerDao.editCustomerClass(customerClass);
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (editDepartment==null) {
			 map.put("msg","修改失败");   
	        }else {
            map.put("msg","修改成功"); 
        }
		return map;
	}

	@Override
	public Object addCustomer(Customer customer) {
		Group group = new Group();
		group.setCGroupName(customer.getGroupName());
		customer.setGroupID(groupDao.selGroup(group).get(0).getID());
		String id = Code.getCode();
		customer.setId(id);
		Integer addInteger = customerDao.addCustomer(customer);
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (addInteger==null) {
			 map.put("msg","修改失败");   
	        }else {
            map.put("msg","修改成功"); 
            map.put("id", id);
        }
		return map;
	}

	@Override
	public Object selCustomer(Customer customer) {
		Group group = new Group();
		group.setCGroupName(customer.getGroupName());
		customer.setGroupID(groupDao.selGroup(group).get(0).getID());
		List<Customer> selCustomers = customerDao.selCustomer(customer);
		PageInfo<Customer> pageInfo= new PageInfo<Customer>(selCustomers);
		long total = pageInfo.getTotal();
		Map<String, Object> map = new HashMap<String, Object>();
		if (selCustomers.size() == 0) {
			 map.put("msg","查询失败");    
	        }else {
           map.put("msg","查询成功"); 
           map.put("count", total);
           map.put("data",selCustomers);
       }
		return map;
	}

	@Override
	public Object addCustomerAddress(CustomerAddress customerAddress, String groupName) {
		Map<String, Object> map = new HashMap<String, Object>();
		
			Group group = new Group();
			group.setCGroupName(groupName);
			customerAddress.setGroupID(groupDao.selGroup(group).get(0).getID());
			customerAddress.setID(Code.getCode());
			Integer addPerson = customerDao.addCustomerAddress(customerAddress);
			
			map.put("msg", "添加失败");
			if (addPerson!=0) {
				map.put("msg", "添加成功");
			}		
		
		
		return map;
	}

	@Override
	public Object addCustomerAssociation(CustomerAssociation customerAssociation, String groupName) {
		Group group = new Group();
		group.setCGroupName(groupName);
		customerAssociation.setGroupID(groupDao.selGroup(group).get(0).getID());
		customerAssociation.setID(Code.getCode());
		Integer addPerson = customerDao.addCustomerAssociation(customerAssociation);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("msg", "添加失败");
		if (addPerson!=0) {
			map.put("msg", "添加成功");
		}		
		return map;
	}

	@Override
	public Object addCustomerEffective(CustomerEffective customerEffective, String groupName) {
		Group group = new Group();
		group.setCGroupName(groupName);
		customerEffective.setGroupID(groupDao.selGroup(group).get(0).getID());
		customerEffective.setID(Code.getCode());
		Integer addPerson = customerDao.addCustomerEffective(customerEffective);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("msg", "添加失败");
		if (addPerson!=0) {
			map.put("msg", "添加成功");
		}		
		return map;
	}

	@Override
	public Object editCustomerMessage(User user) {
		//查询客户
		CustomerPeople customerPeople = customerDao.selectCustomerMessage(user);
		user.setID(customerPeople.getID());
		Integer num = customerDao.editCustomerPhone(user);
		user.setID(customerPeople.getCCusCode());
		Integer num1 = customerDao.editCustomerCompanyAddress(user);
		HashMap<Object, Object> map = new HashMap<>();
		map.put("msg", "添加失败");
		if (num != null && num1 != null && num == 1 && num1 == 1){
			map.put("msg", "添加成功");
		}
		return map;
	}

	@Override
	public Object addCustomerPeople(CustomerPeople customerPeople, String groupName) {
		Group group = new Group();
		group.setCGroupName(groupName);
		customerPeople.setGroupID(groupDao.selGroup(group).get(0).getID());
		customerPeople.setID(Code.getCode());
		Integer addPerson = customerDao.addCustomerPeople(customerPeople);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("msg", "添加失败");
		if (addPerson!=0) {
			map.put("msg", "添加成功");
		}		
		return map;
	}

	
	
	
	
	
}
