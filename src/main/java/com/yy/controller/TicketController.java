package com.yy.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yy.dao.TicketDao;
import com.yy.entity.Ticket;
import com.yy.entity.TicketAccept;
import com.yy.entity.TicketAccepts;
import com.yy.entity.TicketBehavior;
import com.yy.entity.TicketProgress;
import com.yy.service.TicketService;

/**
* @author 陈籽伟
* @version 创建时间：2020年12月23日 下午5:03:38
* 类说明
*/
@Controller
@RequestMapping("ticket")
public class TicketController {
	@Resource
	private TicketService ticketService;
	@Resource
	private TicketDao ticketDao;
	
	@ResponseBody
	@RequestMapping("selticketend.action")
	public Object selTicketEnd(Ticket ticket) {
		return ticketService.selTicketEnd(ticket);
	}
	
	@ResponseBody
	@RequestMapping("selticketfirst.action")
	public Object selTicketFirst(Ticket ticket) {
		return ticketService.selTicketFirst(ticket);
	}
	
	
	@ResponseBody
	@RequestMapping("selticketforword.action")
	public Object selTicketForword(Ticket ticket) {
		return ticketService.selTicketForWord(ticket);
	}
	
	
	@ResponseBody
	@RequestMapping("selticketnext.action")
	public Object selTicketNext(Ticket ticket) {
		return ticketService.selTicketNext(ticket);
	}
	
	
	@ResponseBody
	@RequestMapping("selticket.action")
	public Object selTicket(Ticket ticket) {
		return ticketService.selTicket(ticket);
	}
	
	
	@ResponseBody
	@RequestMapping("selticketall.action")
	public Object selTicketAll(Ticket ticket) {
		return ticketService.selTicketAll(ticket);
	}
	
	
	@ResponseBody
	@RequestMapping("selticketaccept.action")
	public Object selTicketAccept(TicketAccept ticketAccept) {
		return ticketDao.selTicketAccept(ticketAccept);
	}
	
	
	@ResponseBody
	@RequestMapping("selticketnum.action")
	public Object selTicketNum(Ticket ticket) {
		return ticketDao.selTicketNum(ticket);
	}
	
	
	@ResponseBody
	@RequestMapping("addticket.action")
	public Object addTicket(Ticket ticket) {
		return ticketService.addTicket(ticket);
	}
	
	
	@ResponseBody
	@RequestMapping("editticket.action")
	public Object editTicket(Ticket ticket) {
		return ticketService.editTicket(ticket);
	}
	
	
	//删除
	@ResponseBody
	@RequestMapping("deleteticket.action")
	public Object deleteTicket(String ids) {
		return ticketDao.deleteTicket(ids);
	}
	
	
	
	@ResponseBody
	@RequestMapping("addticketaccept.action")
	public Object addTicketAccept(TicketAccepts ticketAccepts) {
		return ticketService.addTicketAccept(ticketAccepts);
	}
	
	@ResponseBody
	@RequestMapping("editticketaccept.action")
	public Object editTicketAccept(TicketAccepts ticketAccepts) {
		return ticketService.editTicketAccept(ticketAccepts);
	}
	
	
	
	
	
	@ResponseBody
	@RequestMapping("addticketprogress.action")
	public Object addTicketProgress(TicketProgress ticketProgress) {
		return ticketService.addTicketProgress(ticketProgress);
	}
	
	
	@ResponseBody
	@RequestMapping("changeticketprogress.action")
	public Object changeTicketProgress(TicketProgress ticketProgress) {
		return ticketService.changeTicketProgress(ticketProgress);
	}
	
	@ResponseBody
	@RequestMapping("selTicketBehavior.action")
	public Object selTicketBehavior(TicketBehavior ticketBehavior) {
		return ticketDao.selTicketBehavior(ticketBehavior);
	}
}
