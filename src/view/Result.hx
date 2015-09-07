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
	
	private static inline var PAYMENT:Int = 3000;
	
	/* =======================================================================
	Public - Init
	========================================================================== */
	public static function init():Void {
		
		_jParent = new JQuery('#result');
		
	}
	
		/* =======================================================================
		Public - Show
		========================================================================== */
		public static function show(clientName:String,workName:String,fromtime:String,totime:String):Void {
			
			DB.load(Clients.getID(clientName),Works.getID(workName),fromtime,totime,function():Void {
				
				if (clientName == '') clientName = '全クライアント';
				if (workName == '') workName = '全案件';

				_jParent.fadeIn(300);
				_jParent.find('.client').text(clientName);
				_jParent.find('.work').text(workName);
				
				setHTML(DB.getExtractedList());
				
			});

		}
	
	/* =======================================================================
	Set HTML
	========================================================================== */
	private static function setHTML(data:Dynamic):Void {
		
		var totaltime   :Float        = data.totaltime;
		var members     :Array<Int>   = data.members;
		var memberLenght:Int          = members.length;
		var memberTimes :Array<Float> = data.memberTimes;
		
		var jDescription:JQuery = _jParent.find('.description');
		
		jDescription.find('.totaltime').find('dd').text(Std.string(totaltime));
		jDescription.find('.perperson').find('dd').text(Std.string(Math.floor(totaltime / memberLenght * 10)  / 10));
		jDescription.find('.price').find('dd').text(Std.string(PAYMENT * totaltime));
		
		_jParent.find('.person').html((function(array:Array<Float>):String {
			
			var html:String = '';
			
			for (p in 0...array.length) {
				
				var memberID:Int = p;
				var hour:Float = array[p];
				
				if (hour == null) continue;
				
				var memberInfo:Dynamic = Members.getDB()[memberID];
				
				html += '
				<dl class="' + memberInfo.parmanent_id + ' ' + memberInfo.team + '">
					<dt>' + memberInfo.name + '</dt>
					<dd>
						<figure></figure>
						<span class="time">' + hour + '</span>
						<span class="ratio">' + Math.floor(hour / totaltime * 100) + '</span>
						<span class="personratio">xx</span>
					</dd>
				</dl>';
				
			}
			
			return html;
			
		})(memberTimes)).find('dl').each(function():Void {
			
			var jTarget:JQuery = JQuery.cur;
			var ratio  :Int    = Std.parseInt(jTarget.find('.ratio').text());
			
			jTarget.find('figure').delay(100 * jTarget.index()).animate({ width:(ratio * .7) + '%' }, 300);
			
		});
		
	}

}

private class DB {
	
	private static var _rowData      :Array<Dynamic>;
	private static var _extractedData:Array<Dynamic>;
	
	private static var _extractedList:Dynamic;
	
	private static inline var TABLE:String = 'tasks';
	private static var COLUMNS:Array<String> = ['member_id','work_id','hour','updatetime'];
	
	/* =======================================================================
	Public - Load
	========================================================================== */
	public static function load(clientID:Int,workID:Int,fromtime:String,totime:String,onLoaded:Void->Void):Void {
		
		var clients:Array<Dynamic> = Clients.getDB();
		var works  :Array<Dynamic> = Works.getDB();
		
		var where:String = 'updatetime >= "' + fromtime + '" AND updatetime <= "' + totime + '"';
		
		Ajax.getData(TABLE,COLUMNS,function(data:Array<Dynamic>):Void {
			
			_rowData = data;
			_extractedData = [];
			
			for (p in 0...data.length) {
				
				var info:Dynamic = data[p];
				var isConcerned:Bool = false;
				
				if (workID == null) {
					
					if (clientID == null || works[info.work_id].client_id == clientID) {
						isConcerned = true;
					}
					
				} else if (info.work_id == workID) {
					
					isConcerned = true;
					
				}
				
				if (isConcerned) _extractedData.push(info);
				
			}
			
			_extractedList = getList(_extractedData);
			
			onLoaded();
			exportCSV(_extractedData);
		
		},where);
		
	}
	
		/* =======================================================================
		Get Extracted List
		========================================================================== */
		public static function getExtractedList():Dynamic {
			
			return _extractedList;
			
		}
		
	/* =======================================================================
	Get List
	========================================================================== */
	private static function getList(data:Array<Dynamic>):Dynamic {
		
		var totaltime  :Float        = 0;
		var members    :Array<Int>   = [];
		var memberTimes:Array<Float> = [];
		
		for (p in 0...data.length) {
			
			var info    :Dynamic = data[p];
			var memberID:Int     = info.member_id;
			var hour    :Float   = Std.parseFloat(info.hour);
			
			totaltime += hour;
			
			if (members.indexOf(memberID) < 0) members.push(memberID);
			
			var memberTime:Float = memberTimes[memberID];
			if (memberTime == null) memberTime = 0;
			
			memberTimes[memberID] = memberTime + hour;
			
		}
		
		return { totaltime:totaltime, members:members, memberTimes:memberTimes };
		
	}
	
	/* =======================================================================
	Export CSV
	========================================================================== */
	private static function exportCSV(data:Array<Dynamic>):Void {

		var clients:Array<Dynamic> = Clients.getDB();
		var works  :Array<Dynamic> = Works.getDB();
		var members:Array<Dynamic> = Members.getDB();

		var array:Array<Array<Dynamic>> = [];

		for (p in 0...data.length) {

			var info      :Dynamic = data[p];
			var memberID  :Int     = info.member_id;
			var workID    :Int     = info.work_id;
			var hour      :Float   = Std.parseFloat(info.hour);
			var updatetime:String  = info.updatetime;

			var workInfo  :Dynamic = works[workID];
			var workName  :String  = workInfo.name;
			var clientName:String  = clients[workInfo.client_id].name;

			var memberInfo:Dynamic = members[memberID];
			var memberName:String  = memberInfo.name;
			var team      :String  = memberInfo.team;

			array.push([clientName,workName,team,memberName,hour,updatetime]);

		}

		Csv.export(array);

	}
	
}