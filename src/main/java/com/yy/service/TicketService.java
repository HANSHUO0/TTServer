package com.yy.service;

import com.yy.entity.Ticket;
import com.yy.entity.TicketAccepts;
import com.yy.entity.TicketProgress;

/**
* @author 陈籽伟
* @version 创建时间：2020年12月23日 下午4:57:59
* 类说明
*/
public interface TicketService {

	public Object addTicket(Ticket ticket);
	public Object selTicket(Ticket ticket);
	public Object editTicket(Ticket ticket);
	public Object selTicketAll(Ticket ticket);
	public Object selTicketEnd(Ticket ticket);
	public Object selTicketFirst(Ticket ticket);
	public Object selTicketForWord(Ticket ticket);
	public Object selTicketNext(Ticket ticket);
	public Object addTicketProgress(TicketProgress ticketProgress);
	public Object changeTicketProgress(TicketProgress ticketProgress);
	
	public Object addTicketAccept(TicketAccepts ticketAccepts);
	public Object editTicketAccept(TicketAccepts ticketAccepts);
	public Object returnTicketAccept(TicketAccepts ticketAccepts);
	
}
