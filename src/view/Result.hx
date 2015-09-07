package src.view;

import js.JQuery;
import jp.saken.utils.Ajax;
import src.datalist.Clientlist;
import src.datalist.Worklist;
import src.datalist.Memberlist;
import src.utils.Csv;

class Result {
	
	private static var _jParent:JQuery;
	
	private static var _clients:Array<Dynamic>;
	private static var _works  :Array<Dynamic>;
	private static var _members:Array<Dynamic>;
	
	/* =======================================================================
	Public - Init
	========================================================================== */
	public static function init():Void {
		
		_jParent = new JQuery('#result');
		
	}
	
		/* =======================================================================
		Public - Show
		========================================================================== */
		public static function show(clientID:Int,workID:Int,team:String,memberID:Int,fromtime:String,totime:String):Void {

			_clients = Clientlist.getDB();
			_works   = Worklist.getDB();
			_members = Memberlist.getDB();

			var workIDList  :Array<Int> = getWorkIDList(clientID,workID);
			var memberIDList:Array<Int> = getMemberIDList(team,memberID);

			setTasks(workIDList,memberIDList,fromtime,totime);

		}
	
	/* =======================================================================
	Get WorkID List
	========================================================================== */
	private static function getWorkIDList(clientID:Int,workID:Int):Array<Int> {
		
		var array:Array<Int> = [];
		
		if (workID == null) {
			
			if (clientID == null) {
				
				for (p in 0..._works.length) {
					
					var info:Dynamic = _works[p];
					if (info != null) array.push(_works[p].id);
					
				}
				
			} else {
				
				for (p in 0..._works.length) {
					
					var info:Dynamic = _works[p];
					if (info != null && info.client_id == clientID) array.push(info.id);
					
				}
				
			}
			
		} else {
			
			array = [workID];
			
		}
		
		return array;
		
	}
	
	/* =======================================================================
	Get MemberID List
	========================================================================== */
	private static function getMemberIDList(team:String,memberID:Int):Array<Int> {
		
		var array:Array<Int> = [];
		
		if (memberID == null) {
			
			if (team == null) {
				
				for (p in 0..._members.length) {
					
					var info:Dynamic = _works[p];
					if (info != null) array.push(_members[p].id);
					
				}
				
			} else {
				
				for (p in 0..._members.length) {
					
					var info:Dynamic = _members[p];
					if (info != null && info.team == team) array.push(info.id);
					
				}
				
			}
			
		} else {
			
			array = [memberID];
			
		}
		
		return array;
		
	}
	
	/* =======================================================================
	Set Tasks
	========================================================================== */
	private static function setTasks(workIDList:Array<Int>,memberIDList:Array<Int>,fromtime:String,totime:String):Void {
		
		var columns:Array<String> = ['member_id','work_id','hour','updatetime'];
		var where:String = 'updatetime >= "' + fromtime + '" AND updatetime <= "' + totime + '"';
		
		where += ' AND ' + getJoinedWhere(workIDList,'work_id');
		where += ' AND ' + getJoinedWhere(memberIDList,'member_id');
		
		Ajax.getData('tasks',columns,function(data:Array<Dynamic>):Void {
			
			analyzeTasks(data);
		
		},where);
		
	}
	
	/* =======================================================================
	Get Joined Where
	========================================================================== */
	private static function getJoinedWhere(IDList:Array<Int>,target:String):String {
		
		var string:String = '';
		var array :Array<String> = [];
		
		for (p in 0...IDList.length) {
			array.push(target + ' = ' + IDList[p]);
		}
		
		string = '(' + array.join(' OR ') + ')';
		
		return string;
		
	}
	
	/* =======================================================================
	Analyze Tasks
	========================================================================== */
	private static function analyzeTasks(tasks:Array<Dynamic>):Void {
		
		var totalHour:Float = 0;
		var array:Array<Array<Dynamic>> = [];
		
		for (p in 0...tasks.length) {
			
			var info      :Dynamic = tasks[p];
			var memberID  :Int     = info.member_id;
			var workID    :Int     = info.work_id;
			var hour      :Float   = info.hour;
			var updatetime:String  = info.updatetime;
			
			var workInfo  :Dynamic = _works[workID];
			var workName  :String  = workInfo.name;
			var clientName:String  = _clients[workInfo.client_id].name;
			
			var memberInfo:Dynamic = _members[memberID];
			var memberName:String  = memberInfo.name;
			var team      :String  = memberInfo.team;
			
			totalHour += Math.floor(info.hour);
			array.push([clientName,workName,team,memberName,hour,updatetime]);
			
		}
		
		Csv.export(array);
		_jParent.text(totalHour + '時間');
		
	}

}