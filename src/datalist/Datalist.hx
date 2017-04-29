package src.datalist;

class Datalist {
	
	/* =======================================================================
	Get HTML
	========================================================================== */
	public static function getHTML(data:Array<Dynamic>):String {
		
		var html:String = '';
		
		for (p in 0...data.length) {
			
			var info:Dynamic = data[p];
			if (info == null) continue;
			
			var id      :Int    = info.id;
			var clientID:Int    = info.client_id;
			var team    :String = info.team;
			
			var dataClient:String = (clientID == null) ? '' : ' data-clientid="' + clientID + '"';
			var dataTeam  :String = (team == null) ? '' : ' data-team="' + team + '"';
			
			html += '<option value="' + info.name + '" data-id="' + id + '"' + dataClient + dataTeam + '></option>';
			
		}
		
		return html;
		
	}

}