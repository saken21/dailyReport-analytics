package src.datalist;

import js.JQuery;
import jp.saken.utils.Ajax;

class Datalist {
	
	/* =======================================================================
	Public - Set
	========================================================================== */
	public static function set(jTarget:JQuery,table:String,columns:Array<String>):Void {

		Ajax.getData(table,columns,function(data:Array<Dynamic>):Void {
			jTarget.html(getHTML(data)).trigger('setDatalist');
		});

	}
	
	/* =======================================================================
	Get HTML
	========================================================================== */
	private static function getHTML(data:Array<Dynamic>):String {
		
		var html:String = '';
		
		for (p in 0...data.length) {
			
			var info:Dynamic = data[p];
			var id  :Int     = info.id;
			
			var clientID:Int = info.client_id;
			var team:String = info.team;
			
			var dataClient:String = (clientID == null) ? '' : ' data-clientid="' + clientID + '"';
			var dataTeam  :String = (team == null) ? '' : ' data-team="' + team + '"';
			
			html += '<option value="' + info.name + '" data-id="' + id + '"' + dataClient + dataTeam + '></option>';
			
		}
		
		return html;
		
	}

}