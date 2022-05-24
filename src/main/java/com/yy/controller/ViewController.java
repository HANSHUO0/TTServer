package com.yy.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yy.dao.MenuDao;
import com.yy.dao.UserDao;
import com.yy.entity.Menu;
import com.yy.entity.User;
import org.springframework.web.bind.annotation.ResponseBody;


/**
* @author 陈籽伟
* @version 创建时间：2020年9月15日 下午4:32:39
* 类说明
*/
@Controller
@RequestMapping("view")
@CrossOrigin
public class ViewController {
	
	@Resource
	private MenuDao menuDao;
	@Resource 
	private UserDao userDao;

	//客户档案修改
	@RequestMapping("toeditcustomermessage.action")
	public String toMell(String condition,Model model) {		
		return "cloud/editCustomer";
	}
	
	
	//预览
	@RequestMapping("togo.action")
	public String toGO(String designName,Model model) {		
		model.addAttribute("data", designName);
		return "home/go";
	}
	
	//工作台
		@RequestMapping("towork.action")
		public String toWorkBench() {				
			return "home/workBench";
		}
	
	
	//页面设计器
	@RequestMapping("todesign.action")
	public String toDesign() {		
		return "home/webDesign";
	}
	
	//客户档案修改
	@RequestMapping("toeditcustomer.action")
	public String toCustomerDesign() {		
	
		return "customer/edit";
	}
	//客户档案打印修改
	@RequestMapping("tocustomerprint.action")
	public String toCustomerPrint() {		
	
		return "customer/print";
	}
	
	//主界面
	@RequestMapping("toindex.action")
	public String toIndex(String ID,String cGroupName,Model model) {
		List<Menu> selMenuGroup = menuDao.selMenuGroup(ID, cGroupName);
		User user = new User();
		user.setID(ID);
		User user1 = userDao.selUser(user).get(0);
		model.addAttribute("User", user1);
		model.addAttribute("HeadImageData", user1.getHeadImageData());
		model.addAttribute("menu", selMenuGroup);
		model.addAttribute("groupName", cGroupName);
		model.addAttribute("ID", ID);
		return "index";
	}
	
	//申请组织通过
	@RequestMapping("togroup.action")
	public String toGroup() {
		return "admin/group";
	}
	//申请人员通过
	@RequestMapping("toapplication.action")
	public String toApplication() {
		return "admin/application";
	}
	
	//云服务
	@RequestMapping("tocloud.action")
	public String toCloud() {
		return "cloud/CloudService";
	}
	
	//新增客户
	@RequestMapping("toaddcustomer.action")
	public String toAddCustomer() {
		return "cloud/addCustomer";
	}
	
	//客户档案
	@RequestMapping("tocustomer.action")
	public String toCustomer(){
		return "cloud/CustomerProfile";
	}
	
	//修改目录权限
	@RequestMapping("tomenurole.action")
	public String toMenuRole(String userID,Model model) {
		model.addAttribute("userID", userID);
		return "admin/menu";
	}
	
	
	//角色权限
	@RequestMapping("torole.action")
	public String toRole() {
		return "admin/role";
	}
	
	//角色添加
	@RequestMapping("toroleadd.action")
	public String toRoleadd() {
		return "admin/roleAdd";
	}

	//角色修改
	@RequestMapping("toroleedit.action")
	public String toRoleEdit() {
		return "admin/roleEdit";
	}
	
	
	//修改个人资料
	@RequestMapping("todetails.action")
	public String toDetails() {	
		return "userDetails";
	}
	//发布页面
	@RequestMapping("torelease.action")
	public String toRelease(String id) {
		return "release";
	}
	//通讯录
	@RequestMapping("todepartment.action")
	public String toDepartment() {
		return "contacts/department";
	}
	//定义自增规则
	@RequestMapping("toincrement.action")
	public String toIncrement() {
		return "cloud/increment";
	}
	
	//服务工单
	@RequestMapping("torequest.action")
	public String toRequest() {
		return "cloud/workerRequest";
	}
	
	//工单派发
	@RequestMapping("toticketsend.action")
	public String toSend() {
		return "cloud/workRistributed";
	}
	
	
	
	//工单列表
	@RequestMapping("toticketlist.action")
	public String toTicketList() {
		return "cloud/workerList";
	}
	
	//工单受理
	@RequestMapping("toticketaccept.action")
	public String toTicketAccept() {
		return "cloud/workerAccept";
	}
	
	//工单回访
	@RequestMapping("toticketaccess.action")
	public String toTicketAccess() {
		return "cloud/workAccess";
	}
}
