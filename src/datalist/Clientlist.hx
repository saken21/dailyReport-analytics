package src.datalist;

import js.JQuery;
import src.db.Clients;

class Clientlist {
	
	private static var _jOptions:JQuery;
	
	/* =======================================================================
	Public - Init
	========================================================================== */
	public static function init():Void {
		
		new JQuery('#clientlist').html(Datalist.getHTML(Clients.getDB()));
		
	}

}