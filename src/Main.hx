/**
* ================================================================================
*
* Daily Report Analytics ver 1.00.03
*
* Author : KENTA SAKATA
* Since  : 2015/09/01
* Update : 2015/09/15
*
* Licensed under the MIT License
* Copyright (c) Kenta Sakata
* http://saken.jp/
*
* ================================================================================
*
**/
package src;

import js.JQuery;

class Main {
	
	public static function main():Void {
		
		new JQuery('document').ready(Manager.init);
		
	}

}