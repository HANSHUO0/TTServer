package com.yy.dao;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;

import com.yy.entity.Menu;


/**
* @author 陈籽伟
* @version 创建时间：2020年10月30日 下午2:29:46
* 类说明
*/
public interface MenuDao {
		
	
	/**
	 * 查询组织下的菜单
	 * @param 
	 * @return
	 */
    @Select("SELECT menu.* from menu INNER JOIN im_user_group on menu.id = im_user_group.MenuID INNER JOIN im_group on im_user_group.GroupID = im_group.ID where UserID = #{UserID} and im_group.cGroupName = #{cGroupName}")
	List<Menu> selMenuGroup(String UserID,String cGroupName);
	
    
    
	/**
	 * 查询全部菜单
	 * @param menu
	 * @return
	 */
	List<Menu> selMenu(Menu menu);
	
	
	/**
	 * 添加菜单
	 * @param menu
	 * @return
	 */
	@Insert("insert into menu (title,url,parent_id,create_time) values (#{title},#{url},#{parentId},now())")
	public Integer addMenu(Menu menu);
		
}
