package src.view;

import js.JQuery;
import jp.saken.utils.Ajax;
import src.db.Clients;
import src.db.Works;
import src.db.Members;
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
		public static function show(clientID:Int,workID:Int,fromtime:String,totime:String):Void {

			_clients = Clients.getDB();
			_works   = Works.getDB();
			_members = Members.getDB();

			setTasks(getWorkIDList(clientID,workID),fromtime,totime);

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
	Set Tasks
	========================================================================== */
	private static function setTasks(workIDList:Array<Int>,fromtime:String,totime:String):Void {
		
		var columns:Array<String> = ['member_id','work_id','hour','updatetime'];
		var where:String = 'updatetime >= "' + fromtime + '" AND updatetime <= "' + totime + '"';
		
		where += ' AND ' + getJoinedWhere(workIDList,'work_id');
		
		Ajax.getData('tasks',columns,function(data:Array<Dynamic>):Void {
			exportCSV(data);
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
	Export CSV
	========================================================================== */
	private static function exportCSV(tasks:Array<Dynamic>):Void {
		
		var array:Array<Array<Dynamic>> = [];
		
		for (p in 0...tasks.length) {
			
			var info      :Dynamic = tasks[p];
			var memberID  :Int     = info.member_id;
			var workID    :Int     = info.work_id;
			var hour      :Float   = Std.parseFloat(info.hour);
			var updatetime:String  = info.updatetime;
			
			var workInfo  :Dynamic = _works[workID];
			var workName  :String  = workInfo.name;
			var clientName:String  = _clients[workInfo.client_id].name;
			
			var memberInfo:Dynamic = _members[memberID];
			var memberName:String  = memberInfo.name;
			var team      :String  = memberInfo.team;
			
			array.push([clientName,workName,team,memberName,hour,updatetime]);
			
		}
		
		Csv.export(array);
		
	}

}