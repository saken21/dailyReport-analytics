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
				
				set(DB.getExtractedList(),DB.getRowList());
				
			});

		}
	
	/* =======================================================================
	Set
	========================================================================== */
	private static function set(data:Dynamic,all:Dynamic):Void {
		
		var totaltime:Float = data.totaltime;
		
		setDescription(_jParent.find('.description'),data.members.length,totaltime);
		setTeam(_jParent.find('.team'),data.teamTimes,totaltime,all.teamTimes);
		setPerson(_jParent.find('.person'),data.memberTimes,totaltime,all.memberTimes);
		
	}
	
	/* =======================================================================
	Set Description
	========================================================================== */
	private static function setDescription(jParent:JQuery,memberLength:Int,totaltime:Float):Void {
		
		var perperson:Float = Math.floor(totaltime / memberLength * 10) / 10;
		if (Math.isNaN(perperson)) perperson = 0;
		
		jParent.find('.totaltime').find('dd').text(Std.string(totaltime));
		jParent.find('.perperson').find('dd').text(Std.string(perperson));
		jParent.find('.price').find('dd').text(Std.string(Math.floor(PAYMENT * totaltime)));
		
	}
	
	/* =======================================================================
	Set Team
	========================================================================== */
	private static function setTeam(jParent:JQuery,map:Map<String,Float>,totaltime:Float,all:Map<String,Float>):Void {
		
		jParent.find('dl').each(function():Void {
			
			var jTarget    :JQuery = JQuery.cur;
			var team       :String = jTarget.prop('class');
			var teamTime   :Float  = map.get(team);
			var allTeamTime:Float  = all.get(team);
			
			if (teamTime == null) teamTime = 0;
			if (allTeamTime == null) allTeamTime = 0;
			
			var ratio:Float = getRatio(teamTime / totaltime);
			if (Math.isNaN(ratio)) ratio = 0;
			
			jTarget.find('.time').text(Std.string(teamTime));
			jTarget.find('.ratio').text(Std.string(ratio));
			jTarget.find('.teamratio').text(Std.string(getRatio(teamTime / allTeamTime)));
			
			animateGraph(jTarget,ratio);
			
		});
		
	}
	
	/* =======================================================================
	Set Person
	========================================================================== */
	private static function setPerson(jParent:JQuery,array:Array<Float>,totaltime:Float,all:Array<Float>):Void {
		
		jParent.html(getPersonHTML(array,totaltime,all)).find('dl').each(function():Void {
			
			var jTarget:JQuery = JQuery.cur;
			var ratio  :Int    = Std.parseInt(jTarget.find('.ratio').text());
			
			animateGraph(jTarget,ratio);
			
		});
		
	}
	
	/* =======================================================================
	Get Person HTML
	========================================================================== */
	private static function getPersonHTML(array:Array<Float>,totaltime:Float,all:Array<Float>):String {
		
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
					<span class="ratio">' + getRatio(hour / totaltime) + '</span>
					<span class="personratio">' + getRatio(hour / all[p]) + '</span>
				</dd>
			</dl>';
			
		}
		
		return html;
		
	}
	
	/* =======================================================================
	Get Ratio
	========================================================================== */
	private static function getRatio(value:Float):Float {
		
		return Math.floor(value * 1000) / 10;
		
	}
	
	/* =======================================================================
	Animate Graph
	========================================================================== */
	private static function animateGraph(jTarget:JQuery,ratio:Float):Void {
		
		jTarget.find('figure').delay(100 * jTarget.index()).animate({ width:(ratio * .7) + '%' }, 300);
		
	}

}

private class DB {
	
	private static var _rowData      :Array<Dynamic>;
	private static var _extractedData:Array<Dynamic>;
	
	private static var _rowList      :Dynamic;
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
			
			_rowList       = getList(_rowData);
			_extractedList = getList(_extractedData);
			
			onLoaded();
			exportCSV(_extractedData);
		
		},where);
		
	}
	
		/* =======================================================================
		Get Row List
		========================================================================== */
		public static function getRowList():Dynamic {
			
			return _rowList;
			
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
		
		var totaltime  :Float             = 0;
		var members    :Array<Int>        = [];
		var memberTimes:Array<Float>      = [];
		var teamTimes  :Map<String,Float> = new Map();
		
		for (p in 0...data.length) {
			
			var info    :Dynamic = data[p];
			var memberID:Int     = info.member_id;
			var hour    :Float   = Std.parseFloat(info.hour);
			var team    :String  = Members.getDB()[memberID].team;
			
			totaltime += hour;
			
			if (members.indexOf(memberID) < 0) members.push(memberID);
			
			var memberTime:Float = memberTimes[memberID];
			if (memberTime == null) memberTime = 0;
			
			memberTimes[memberID] = memberTime + hour;
			
			var teamTime:Float = teamTimes.get(team);
			if (teamTime == null) teamTime = 0;
			
			teamTimes.set(team,teamTime + hour);
			
		}
		
		return { totaltime:totaltime, members:members, memberTimes:memberTimes, teamTimes:teamTimes };
		
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