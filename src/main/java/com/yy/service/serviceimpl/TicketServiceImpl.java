package com.yy.service.serviceimpl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.yy.dao.TicketDao;
import com.yy.entity.Ticket;
import com.yy.entity.TicketAccepts;
import com.yy.entity.TicketBehavior;
import com.yy.entity.TicketProgress;
import com.yy.service.TicketService;
import com.yy.util.Code;


/**
* @author 陈籽伟
* @version 创建时间：2020年12月23日 下午4:59:11
* 类说明
*/
@Service
public class TicketServiceImpl implements TicketService {

	@Resource
	private TicketDao ticketDao;
	
	
	
	@Override
	public Object editTicket(Ticket ticket) {
		
		
		if (ticket.getProgress()>0) {
			for (String ticketID : ticket.getId().split(",")) {
				TicketBehavior ticketBehavior = new TicketBehavior();
				ticketBehavior.setGroupID(ticket.getGroupID());
				ticketBehavior.setTicketID(ticketID);			
				ticketBehavior.setBehavior(ticket.getProgress());
				if (ticket.getProgress() == 4) {
					ticketBehavior.setFirstPeople(""); 
					ticketBehavior.setSecondPeople(ticket.getCasePersonName());
					ticketBehavior.setMessage("");
				}
				if (ticket.getProgress() == 5) {		
					ticketBehavior.setFirstPeople(""); 
					ticketBehavior.setSecondPeople("");
					ticketBehavior.setMessage("");
					if (ticket.getAccessPeopleName()!=null) {
						ticketBehavior.setFirstPeople(ticket.getAccessPeopleName()); 
					}
				}
				if (ticket.getProgress() == 7||ticket.getProgress() == 8) {		
					ticketBehavior.setFirstPeople(ticket.getOperationPeople()); 
					ticketBehavior.setSecondPeople("");
					ticketBehavior.setMessage(ticket.getMessage());				
				}
				ticketDao.addTicketBehavior(ticketBehavior);
			}
			if (ticket.getProgress() == 7) {
				ticket.setProgress(1);				
			}
			ticketDao.editTicket(ticket);
		}else {
			ticket.setProgress(null);
			ticketDao.editTicket(ticket);
		}

		return null;
	}
	
	
	
	
	@Override
	public Object addTicket(Ticket ticket) {

		ticketDao.addTicket(ticket);
		
		TicketBehavior ticketBehavior = new TicketBehavior();
		ticketBehavior.setGroupID(ticket.getGroupID());
		ticketBehavior.setTicketID(ticket.getId());
		ticketBehavior.setFirstPeople(ticket.getRegisterPeople());
		ticketBehavior.setBehavior(ticket.getProgress());
		ticketBehavior.setSecondPeople("");
		ticketBehavior.setMessage("");
		ticketDao.addTicketBehavior(ticketBehavior);
		
		return null;
	}

	@Override
	public Object selTicketEnd(Ticket ticket) {
		List<Ticket> selTicket = ticketDao.selTicketEnd(ticket);		
		Map<String, Object> map = new HashMap<String, Object>();
		if (selTicket.size() == 0) {
			 map.put("msg","查询失败");    
	        }else {
           map.put("msg","查询成功"); 
           map.put("data",selTicket);
       }
		return map;
	}

	@Override
	public Object selTicketFirst(Ticket ticket) {
		List<Ticket> selTicket = ticketDao.selTicketFirst(ticket);
		Map<String, Object> map = new HashMap<String, Object>();
		if (selTicket.size() == 0) {
			 map.put("msg","查询失败");    
	        }else {
           map.put("msg","查询成功");          
           map.put("data",selTicket);
       }
		return map;
	}

	@Override
	public Object selTicketForWord(Ticket ticket) {
		List<Ticket> selTicket = ticketDao.selTicketForWord(ticket);
		Map<String, Object> map = new HashMap<String, Object>();
		if (selTicket.size() == 0) {
			 map.put("msg","查询失败");    
	        }else {
           map.put("msg","查询成功");          
           map.put("data",selTicket);
       }
		return map;
	}

	@Override
	public Object selTicketNext(Ticket ticket) {
		List<Ticket> selTicket = ticketDao.selTicketNext(ticket);
		Map<String, Object> map = new HashMap<String, Object>();
		if (selTicket.size() == 0) {
			 map.put("msg","查询失败");    
	        }else {
           map.put("msg","查询成功");          
           map.put("data",selTicket);
       }
		return map;
	}

	@Override
	public Object addTicketProgress(TicketProgress ticketProgress) {
		List<TicketProgress> data = new ArrayList<TicketProgress>();
		for (String j : ticketProgress.getTicketID().split(",")) {			
			for (String i : ticketProgress.getGetUserID().split(",")) {
				TicketProgress ticketProgress2 = new TicketProgress();
				ticketProgress2.setId(Code.getCode());
				ticketProgress2.setGroupID(ticketProgress.getGroupID());
				ticketProgress2.setTicketID(j);
				ticketProgress2.setUserID(ticketProgress.getUserID());
				ticketProgress2.setSendDate(ticketProgress.getSendDate());
				ticketProgress2.setProcessing2(ticketProgress.getProcessing2());
				ticketProgress2.setClaimDate(ticketProgress.getClaimDate());
				ticketProgress2.setFinishDate(ticketProgress.getFinishDate());
				ticketProgress2.setOtherMes(ticketProgress.getOtherMes());
				ticketProgress2.setWages(ticketProgress.getWages());
				ticketProgress2.setIsDel("0");
				ticketProgress2.setGetUserID(i);
				data.add(ticketProgress2);
			}
			TicketBehavior ticketBehavior = new TicketBehavior();
			ticketBehavior.setGroupID(ticketProgress.getGroupID());
			ticketBehavior.setTicketID(j);
			ticketBehavior.setFirstPeople(ticketProgress.getUserName()); 
			ticketBehavior.setBehavior(ticketProgress.getProgress());
			ticketBehavior.setSecondPeople(ticketProgress.getGetUserName());
			ticketBehavior.setMessage(ticketProgress.getOtherMes());
			ticketDao.addTicketBehavior(ticketBehavior);
		}
		
		Integer selTicket = ticketDao.addTicketProgress(data);
		Ticket ticket = new Ticket();
		ticket.setId(ticketProgress.getTicketID());
		ticket.setGroupID(ticketProgress.getGroupID());
		ticket.setProgress(2);
		ticket.setLegalPerson(ticketProgress.getUserID());
		ticket.setSendPerson(ticketProgress.getGetUserName());
		ticket.setSendDate(ticketProgress.getSendDate());
		ticket.setClaimDate(ticketProgress.getClaimDate());
		ticket.setFinishDate(ticketProgress.getFinishDate());
		if (ticketProgress.getProcessing2() != "") {
			ticket.setProcessing2(ticketProgress.getProcessing2());
		}else {
			ticket.setProcessing2("");
		}
		if (ticketProgress.getWages() != "") {
			ticket.setProcessing2(ticketProgress.getWages());
		}else {
			ticket.setWages("");	
		}
		if (ticketProgress.getOtherMes() != "") {
			ticket.setOtherMes(ticketProgress.getOtherMes());
		}else {
			ticket.setOtherMes("");		
		}
		
		ticketDao.editTicket(ticket);
		Map<String, Object> map = new HashMap<String, Object>();
		if (selTicket == 0) {
			 map.put("msg","添加失败");    
	        }else {
           map.put("msg","添加成功");                   
        }
		return map;
	}

	@Override
	public Object selTicket(Ticket ticket) {
		List<Ticket> selTicket = ticketDao.selTicket(ticket);
		Map<String, Object> map = new HashMap<String, Object>();
		if (selTicket.size() == 0) {
			 map.put("msg","查询失败");    
	        }else {
           map.put("msg","查询成功");          
           map.put("data",selTicket);
       }
		return map;
	}

	@Override
	public Object addTicketAccept(TicketAccepts ticketAccepts) {
		ticketDao.addTicketAccept(ticketAccepts);
		Ticket ticket = new Ticket();
		ticket.setId(ticketAccepts.getTicketID());
		ticket.setGroupID(ticketAccepts.getGroupID());
		ticket.setProgress(3);
		ticket.setAssignee(ticketAccepts.getAssignee());
		ticket.setAcceptanceDate(ticketAccepts.getAcceptanceDate());		
		ticketDao.editTicket(ticket); 
		
		TicketBehavior ticketBehavior = new TicketBehavior();
		ticketBehavior.setGroupID(ticketAccepts.getGroupID());
		ticketBehavior.setTicketID(ticketAccepts.getTicketID());
		ticketBehavior.setFirstPeople(ticketAccepts.getUserName()); 
		ticketBehavior.setBehavior(3);
		ticketBehavior.setSecondPeople("");
		ticketBehavior.setMessage("");
		ticketDao.addTicketBehavior(ticketBehavior);
		
		TicketProgress ticketProgress = new TicketProgress();
		ticketProgress.setTicketID(ticketAccepts.getTicketID());
		ticketProgress.setGroupID(ticketAccepts.getGroupID());
		ticketProgress.setIsDel("2");
		ticketDao.editTicketProgress(ticketProgress);
		ticketProgress.setIsDel("1");
		ticketProgress.setGetUserID(ticketAccepts.getAssignee());
		ticketDao.editTicketProgress(ticketProgress);
		
		return null;
	}

	@Override
	public Object editTicketAccept(TicketAccepts ticketAccepts) {	
		ticketDao.deleteTicketProgress(ticketAccepts.getGroupID(),ticketAccepts.getTicketID());
		ticketDao.editTicketAccept(ticketAccepts);
		Ticket ticket = new Ticket();
		ticket.setId(ticketAccepts.getTicketID());
		ticket.setGroupID(ticketAccepts.getGroupID());
		ticket.setProgress(4);
		ticket.setProcessing3(ticketAccepts.getProcessing3());
		ticket.setErrorReason(ticketAccepts.getErrorReason());
		ticket.setSolve(ticketAccepts.getSolve());
		ticket.setCasePerson(ticketAccepts.getCasePerson());
		ticket.setCaseDate(ticketAccepts.getCaseDate());
		ticket.setIntegral(ticketAccepts.getIntegral());
		ticketDao.editTicket(ticket);
		
		
		TicketBehavior ticketBehavior = new TicketBehavior();
		ticketBehavior.setGroupID(ticketAccepts.getGroupID());
		ticketBehavior.setTicketID(ticketAccepts.getTicketID());
		ticketBehavior.setFirstPeople(ticketAccepts.getUserName()); 
		ticketBehavior.setBehavior(4);
		ticketBehavior.setSecondPeople("");
		ticketBehavior.setMessage("");
		ticketDao.addTicketBehavior(ticketBehavior);
		
		
		return null;
	}

	
	
	@Override
	public Object changeTicketProgress(TicketProgress ticketProgress) {
		ticketDao.editTicketProgress(ticketProgress);
		List<TicketProgress> data = new ArrayList<TicketProgress>();
		for (String i : ticketProgress.getGetUserID().split(",")) {
			TicketProgress ticketProgress2 = new TicketProgress();
			ticketProgress2.setId(Code.getCode());
			ticketProgress2.setGroupID(ticketProgress.getGroupID());
			ticketProgress2.setTicketID(ticketProgress.getTicketID());
			ticketProgress2.setUserID(ticketProgress.getUserID());
			ticketProgress2.setSendDate(ticketProgress.getSendDate());
			ticketProgress2.setProcessing2(ticketProgress.getProcessing2());
			ticketProgress2.setClaimDate(ticketProgress.getClaimDate());
			ticketProgress2.setFinishDate(ticketProgress.getFinishDate());
			ticketProgress2.setOtherMes(ticketProgress.getOtherMes());
			ticketProgress2.setIsDel("0");
			ticketProgress2.setWages(ticketProgress.getWages());
			ticketProgress2.setGetUserID(i);
			data.add(ticketProgress2);
		}
		Integer selTicket = ticketDao.addTicketProgress(data);
		
		
		TicketBehavior ticketBehavior = new TicketBehavior();
		ticketBehavior.setGroupID(ticketProgress.getGroupID());
		ticketBehavior.setTicketID(ticketProgress.getTicketID());
		ticketBehavior.setFirstPeople(ticketProgress.getUserName()); 
		ticketBehavior.setBehavior(ticketProgress.getProgress());
		ticketBehavior.setSecondPeople(ticketProgress.getGetUserName());
		ticketBehavior.setMessage(ticketProgress.getOtherMes());
		ticketDao.addTicketBehavior(ticketBehavior);
		
		
		Ticket ticket = new Ticket();
		ticket.setId(ticketProgress.getTicketID());
		ticket.setGroupID(ticketProgress.getGroupID());
		ticket.setProgress(2);
		ticket.setLegalPerson(ticketProgress.getUserID());
		ticket.setSendPerson(ticketProgress.getGetUserName());
		ticket.setSendDate(ticketProgress.getSendDate());
		ticket.setClaimDate(ticketProgress.getClaimDate());
		ticket.setFinishDate(ticketProgress.getFinishDate());
		if (ticketProgress.getProcessing2() != "") 
			ticket.setProcessing2(ticketProgress.getProcessing2());
		else 
			ticket.setProcessing2("");
		if (ticketProgress.getWages() != "") 
			ticket.setWages(ticketProgress.getWages());
		else 
			ticket.setWages("");		
		if (ticketProgress.getOtherMes() != "") 
			ticket.setOtherMes(ticketProgress.getOtherMes());
		else 
			ticket.setOtherMes("");
		ticket.setAssignee("");
		ticket.setAcceptanceDate("");
		ticketDao.editTicket(ticket);
		Map<String, Object> map = new HashMap<String, Object>();
		if (selTicket == 0) {
			 map.put("msg","添加失败");    
	        }else {
           map.put("msg","添加成功");                   
        }
		return map;
	}

	@Override
	public Object returnTicketAccept(TicketAccepts ticketAccepts) {
		Integer selTicket = ticketDao.deleteTicketAccept(ticketAccepts);
		Ticket ticket = new Ticket();
		ticket.setId(ticketAccepts.getTicketID());
		ticket.setGroupID(ticketAccepts.getGroupID());
		ticket.setProgress(2);
		ticket.setAssignee("");
		ticket.setAcceptanceDate("");
		ticketDao.editTicket(ticket);
		Map<String, Object> map = new HashMap<String, Object>();
		if (selTicket == 0) {
			 map.put("msg","重派失败");    
	        }else {
           map.put("msg","重派成功");                   
        }
		return map;
	}



	@Override
	public Object selTicketAll(Ticket ticket) {
		Integer count = ticketDao.selTicketCount(ticket);
		List<Ticket> seList = ticketDao.selTicket(ticket);
		
		Map<String, Object> map = new HashMap<String, Object>();
		if (seList.size() == 0) {
			 map.put("msg","查询失败");    
	    }else {
          map.put("msg","查询成功");
          map.put("count", count);
          map.put("data", seList);
        }
		return map;
	}




	

}
