package com.yy.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;

import com.yy.entity.AddFile;

/**
* @author 陈籽伟
* @version 创建时间：2021年1月22日 下午2:22:43
* 类说明
*/
public interface AddFileDao {

	@Select("select * from ba_ticket_file where ticketID = #{ticketID}")
	public List<AddFile> selAddFile(AddFile addFile);
	
	@Insert("insert into ba_ticket_file (id,ticketID,attName,fileName,fileSize,createTime) values (uuid(),#{ticketID},#{attName},#{fileName},#{fileSize},now())")
	public void addFile(AddFile addFile);
	
	@Delete("delete from ba_ticket_file where id = #{id}")
	public void deleteFile(AddFile addFile);
}
