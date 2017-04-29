package src.datalist;

import js.JQuery;
import src.db.Clients;

class Clientlist {
	
	private static var _jOptions:JQuery;
	
	/* =======================================================================
	Public - Init
	========================================================================== */
	public static function init():Void {
		
		var jParent:JQuery = new JQuery('#clientlist').html(Datalist.getHTML(Clients.getDB()));
		_jOptions = jParent.find('option');
		
	}
	
	/* =======================================================================
	Public - Get ID
	========================================================================== */
	public static function getID(value:String):Int {
		
		return _jOptions.not('disabled').filter('[value="' + value + '"]').data('id');
		
	}

}