package com.yy.service.serviceimpl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.yy.dao.GroupDao;
import com.yy.dao.MenuDao;
import com.yy.entity.Group;
import com.yy.entity.Menu;
import com.yy.entity.TreeView;
import com.yy.entity.UserGroup;
import com.yy.service.MenuService;
import com.yy.util.Code;

/**
* @author 陈籽伟
* @version 创建时间：2020年10月30日 下午2:51:57
* 类说明
*/
@Service
public class MenuServiceImpl implements MenuService {
	@Resource 
    private MenuDao menuDao;
	@Resource 
	private GroupDao groupDao;
	 
	
	@Override
	public Object selMenuGroup(String UserID,String cGroupName) {
		
				//查询全部命令
				List<Menu> selMenu = menuDao.selMenu(null);
				//返回用的数据
				List<TreeView> list = new ArrayList<TreeView>();
				//查询组织下的数据
				List<Menu> selMenuGroup = menuDao.selMenuGroup(UserID, cGroupName);
				
				for (Menu menu : selMenu) {
					//判断是否为一级目录
					
					if(menu.getParentId().equals(0)) {
						TreeView t = new TreeView();
						t.setTitle(menu.getTitle());
						t.setId(menu.getId());
						t.setSpread(true);
						for (Menu menu2 : selMenuGroup) {
							
							if(menu2.getId().equals(menu.getId())) {
								t.setChecked(true);
								
							}
						}
						//children 用的数据
						List<TreeView> children = new ArrayList<TreeView>();
						
						for (Menu menu2 : selMenu) {
							//判断是否为一级目录下的子节点
							
							if(menu2.getParentId().equals(menu.getId())) {
								TreeView d = new TreeView();
								d.setTitle(menu2.getTitle());
								d.setId(menu2.getId());
								d.setSpread(true);
								
								for (Menu menu3 : selMenuGroup) {
									if(menu3.getId().equals(menu2.getId())) {
										d.setChecked(true);
										//因为父节点一旦为ture那么会把所有子节点全选上
										//所以给一个false
										t.setChecked(false);
									}
								}
								List<TreeView> children2 = new ArrayList<TreeView>();
								for (Menu menu3 : selMenu) {
									if(menu3.getParentId().equals(menu2.getId())) {
										TreeView q = new TreeView();
										q.setTitle(menu3.getTitle());
										q.setId(menu3.getId());
										q.setSpread(true);
										
										for (Menu menu4 : selMenuGroup) {
											if (menu4.getId().equals(menu3.getId())) {
												q.setChecked(true);
												//因为父节点一旦为ture那么会把所有子节点全选上
												//所以给一个false
												d.setChecked(false);
											}
										}
										children2.add(q);
									}
								}
								
								d.setChildren(children2);
								children.add(d);						
							}					
						}
						
						t.setChildren(children);
						list.add(t);
						
					}
				
				}
				
				return list;
		
	}


	/**
	 * 发布订阅
	 */
	@Override
	public Object addMenuGroup(UserGroup userGroup,String choose,String addName) {
		Menu menu = new Menu();
		menu.setTitle(choose);
		Integer pid = menuDao.selMenu(menu).get(0).getId();
		Menu menu2 = new Menu();
		menu2.setTitle(addName);
		menu2.setParentId(pid);
		menu2.setUrl("/view/torelease.action");
		menuDao.addMenu(menu2);
		userGroup.setID(Code.getCode());
		userGroup.setMenuID(menuDao.selMenu(menu2).get(0).getId());		
		userGroup.setCreateDate(new Date());
		Map<String, String> map = new HashMap<String, String>();
		Integer b = groupDao.addUserGroup(userGroup);
		if (b!=0) {
			 map.put("msg","添加成功");	           
        }else {
         map.put("msg","添加失败");         
     }		
		return map;
	}


	@Override
	public Object selUserGroup(String UserID, String cGroupName) {
		return menuDao.selMenuGroup(UserID, cGroupName);
	}


	@Override
	public Object selMenuData(String UserID, String cGroupName, String title) {
		Group group = new Group();
		group.setCGroupName(cGroupName);
		String GroupID = groupDao.selGroup(group).get(0).getID();
		Menu menu = new Menu();
		menu.setTitle(title);
		List<Menu> menus = menuDao.selMenu(menu);
		return groupDao.selMenuAddData(UserID, GroupID, menus.get(0).getId());
	}


	@Override
	public void editRoot(UserGroup userGroup) {
		groupDao.deleteUserGroup(userGroup);
		
		if (userGroup.getMenuids()!=null&&userGroup.getMenuids()!="") {
			groupDao.addUserGroup2(userGroup);
		}
	}



}
