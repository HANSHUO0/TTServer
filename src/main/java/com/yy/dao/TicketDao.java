package com.yy.dao;

import java.util.List;

import org.apache.ibatis.annotations.Select;

import com.yy.entity.Ticket;
import com.yy.entity.TicketAccept;
import com.yy.entity.TicketAccepts;
import com.yy.entity.TicketBehavior;
import com.yy.entity.TicketProgress;

/**
* @author 陈籽伟
* @version 创建时间：2020年12月23日 下午4:56:09
* 类说明
*/
public interface TicketDao {

	public Integer addTicket(Ticket ticket);
	public Integer editTicket(Ticket ticket);
	public Integer deleteTicket(String ids);
	
	public List<Ticket> selTicket(Ticket ticket);
	public List<Ticket> selTicketEnd(Ticket ticket);
	public List<Ticket> selTicketFirst(Ticket ticket);
	public List<Ticket> selTicketNext(Ticket ticket);
	public List<Ticket> selTicketForWord(Ticket ticket);
	
	public List<TicketAccept> selTicketAccept(TicketAccept ticketAccept);
	
	
	@Select("select count(*) from ba_ticket where groupID = #{groupID} and cid like '%${cid}%'")
	public Integer selTicketNum(Ticket ticket);
	
	public Integer selTicketCount(Ticket ticket);
	
	public Integer addTicketProgress(List<TicketProgress> data);
	public Integer editTicketProgress(TicketProgress ticketProgress);
	public void deleteTicketProgress(String groupID,String ticketID);
	
	public Integer addTicketAccept(TicketAccepts ticketAccepts);
	public Integer editTicketAccept(TicketAccepts ticketAccepts);
	public Integer deleteTicketAccept(TicketAccepts ticketAccepts);
	
	public List<TicketBehavior> selTicketBehavior(TicketBehavior ticketBehavior);
	public Integer addTicketBehavior(TicketBehavior ticketBehavior);
}
