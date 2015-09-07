package src.datalist;

import js.JQuery;
import jp.saken.utils.Ajax;

class Datalist {
	
	private var _db:Array<Dynamic>;
	
	/* =======================================================================
	Constructor
	========================================================================== */
	public function new(jTarget:JQuery,table:String,columns:Array<String>):Void {

		Ajax.getData(table,columns,function(data:Array<Dynamic>):Void {
			
			_db = data;
			jTarget.html(getHTML(data)).trigger('setDatalist');
			
		});

	}
	
		/* =======================================================================
		Public - Get DB
		========================================================================== */
		public function getDB():Array<Dynamic> {
			
			var array:Array<Dynamic> = [];
			
			for (p in 0..._db.length) {
				
				var info:Dynamic = _db[p];
				array[info.id] = info;
				
			}

			return array;

		}
	
	/* =======================================================================
	Get HTML
	========================================================================== */
	private function getHTML(data:Array<Dynamic>):String {
		
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