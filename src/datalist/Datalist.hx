package src.datalist;

import js.JQuery;
import jp.saken.utils.Ajax;

class Datalist {
	
	/* =======================================================================
	Public - Set
	========================================================================== */
	public static function set(jTarget:JQuery,table:String,where:String = ''):Void {

		Ajax.getData(table,['id','name'],function(data:Array<Dynamic>):Void {
			jTarget.html(getHTML(data));
		},where);

	}
	
	/* =======================================================================
	Get HTML
	========================================================================== */
	private static function getHTML(data:Array<Dynamic>):String {
		
		var html:String = '';
		
		for (p in 0...data.length) {
			
			var info:Dynamic = data[p];
			html += '<option value="' + info.name + '" data-id="' + info.id + '"></option>';
			
		}
		
		return html;
		
	}

}