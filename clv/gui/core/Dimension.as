package clv.gui.core 
{
	/**
	 * ...
	 * @author Zvir
	 */
	public class Dimension 
	{
		
		private static const _as	:int	= 1;
		private static const _ae	:int	= 2;
		private static const _ad	:int	= 3;
		private static const _ac	:int	= 5;
		private static const _afs	:int	= 7;
		private static const _afe	:int	= 11;
		private static const _afd	:int	= 13;
		private static const _afc	:int	= 17;
		
		// only for info
		
		private static const d_d		:uint = 0;
		private static const d_e_fs     :uint = 1;
		private static const d_fd	    :uint = 2;
		private static const d_fe_fs	:uint = 3;
		private static const d_fe_s	    :uint = 4;
		private static const d_s_e	    :uint = 5;
		
		private static const s_c_d		:uint = 0;
		private static const s_c_fd     :uint = 1;
		private static const s_e_d      :uint = 2;
		private static const s_e_fd     :uint = 3;
		private static const s_fc_d     :uint = 4;
		private static const s_fc_fd    :uint = 5;
		private static const s_fe_fd	:uint = 6;	
		private static const s_fs       :uint = 7;
		private static const s_s        :uint = 8;
		
		private var _tD:Number;
		private var _tS:Number;
		
		public var u_s	:Boolean;       
		public var u_e	:Boolean; 
		public var u_d	:Boolean; 
		public var u_c	:Boolean; 
		public var u_fs	:Boolean; 
		public var u_fe	:Boolean; 
		public var u_fd	:Boolean; 
		public var u_fc	:Boolean; 
		
		private var _a1:int = _as;
		private var _a2:int = _ad;
		private var _cd:int = _ad;
		
		private var _D:Number;
		private var _S:Number;
		
		// left
		private var __s:Number = 0.0;
		private function get _s():Number { return __s * sc };
		// right
		private var __e:Number = 0.0;
		private function get _e():Number { return __e * sc };
		// width
		private var __d:Number = 0.0;
		private function get _d():Number { return __d * sc };
		// pecentage width
		private var _fd:Number;
		
		
		// percentage left
		private var _fs:Number;
		
		// percentage right
		private var _fe:Number;
		
		
		// horizontal center px
		private var __c:Number;
		private function get _c():Number { return __c * sc };
		
		// horizontal center pr
		private var _fc:Number;
		
		// container width
		private var _L:Number = 0.0;
		private var _setting:Boolean;
		
		public var maxD:Number = Number.MAX_VALUE;
		public var minD:Number = 0;
		
		public var sc:Number = 1;
		
		public function Dimension() 
		{
			
		}
		
		public function update(limit:Number):void
		{
			
			_setting = false;
			
			_L = limit;
			
			_D = NaN;
			_S = NaN;
			
			_tD = NaN;
			_tS = NaN;
			
			_setting = true;
			
			if (_a1 == _ad  || _a2 == _ad ) _tD = d_d;
			if (_a1 == _afd || _a2 == _afd) _tD = d_fd;
			
			if (_a1 == _as  || _a2 == _as ) _tS = s_s;
			if (_a1 == _afs || _a2 == _afs ) _tS = s_fs;
			
			if (_a1 == _ac  || _a2 == _ac ) 
			{
				if (_cd == _ad)
				{
					_tS = s_c_d;
					_tD = d_d;
				}
				else
				{
					_tS = s_c_fd;
					_tD = d_fd;
				}
			}
			
			if (_a1 == _afc  || _a2 == _afc ) 
			{
				if (_cd == _ad)
				{
					_tS = s_fc_d;
					_tD = d_d;
				}
				else
				{
					_tS = s_fc_fd;
					_tD = d_fd;
				}
				
			}
			
			var a:Number = _a1 * _a2;
			
			if (isNaN(_tD))
			{
				switch (a) 
				{
					case 2:		_tD = d_s_e		; 	break;
					case 14:	_tD = d_e_fs	; 	break;
					case 77:	_tD = d_fe_fs	;		break;
					case 11:	_tD = d_fe_s	; 	break;
				}
			}
			
			if (isNaN(_tS))
			{
				switch (a) 
				{
					case 6:		_tS = s_e_d 	; 	break;
					case 26:	_tS = s_e_fd 	; 	break;
					case 15:	_tS = s_c_d 	;	break;
					case 65:	_tS = s_c_fd 	;	break;
					case 143:	_tS = s_fe_fd	; 	break;
				}
			}
			
			switch (_tS) 
			{
				case  s_c_d		 : _S = S_c_d	   (); 	break;
				case  s_c_fd     : _S = S_c_fd     (); 	break;
				case  s_e_d      : _S = S_e_d      (); 	break;
				case  s_e_fd     : _S = S_e_fd     (); 	break;
				case  s_fc_d     : _S = S_fc_d     (); 	break;
				case  s_fc_fd    : _S = S_fc_fd    (); 	break;
				case  s_fe_fd	 : _S = S_fe_fd	   (); 	break;
				case  s_fs       : _S = S_fs       (); 	break;
				case  s_s        : _S = S_s        (); 	break;
			}
			
			switch (_tD) 
			{
				case d_d		: _D = D_d			(); break;
				case d_e_fs     : _D = D_e_fs     	(); break;
				case d_fd	    : _D = D_fd	    	(); break;
				case d_fe_fs	: _D = D_fe_fs		(); break;
				case d_fe_s	    : _D = D_fe_s	    (); break;
				case d_s_e	    : _D = D_s_e	    (); break;
			}
			
		}
		
		public function updateUsed():void
		{
			
			u_s	 = false;
			u_e	 = false;
			u_d	 = false;
			u_c	 = false;
			u_fs = false;	
			u_fe = false;	
			u_fd = false;	
			u_fc = false;	
			
			switch (_tS) 
			{
				case  s_c_d		 : u_c = true; u_d = true; break;
				case  s_c_fd     : u_c = true; u_fd = true; break;
				case  s_e_d      : u_e = true; u_d = true; break;
				case  s_e_fd     : u_e = true; u_fd = true; break;
				case  s_fc_d     : u_fc = true; u_d = true;	break;
				case  s_fc_fd    : u_fc = true; u_fd = true; break;
				case  s_fe_fd	 : u_fe = true; u_fd = true; break;
				case  s_fs       : u_fs = true; break;
				case  s_s        : u_s = true; break;
			}
			
			switch (_tD) 
			{
				case d_d		: u_d = true; break;
				case d_e_fs     : u_e = true; u_fs = true; break;
				case d_fd	    : u_fd = true; break;
				case d_fe_fs	: u_fe = true; u_fs = true; break;
				case d_fe_s	    : u_fe = true; u_s = true; break;
				case d_s_e	    : u_s = true; u_e = true; break;
			}
		}
		
		public function update2(limit:Number):void
		{
			_L = limit;
			
			_D = NaN;
			_S = NaN;
			
			u_s	 = false;
			u_e	 = false;
			u_d	 = false;
			u_c	 = false;
			u_fs = false;	
			u_fe = false;	
			u_fd = false;	
			u_fc = false;	
			
			if (_a1 == _ad  || _a2 == _ad ) _D = D_d();
			if (_a1 == _afd || _a2 == _afd) _D = D_fd();
			
			if (_a1 == _as  || _a2 == _as ) _S = S_s();
			if (_a1 == _afs || _a2 == _afs ) _S = S_fs();
			
			if (_a1 == _ac  || _a2 == _ac ) 
			{
				if (_cd == _ad)
				{
					_S = S_c_d();
					_D = D_d();
				}
				else
				{
					_S = S_c_fd();
					_D = D_fd();
				}
			}
			
			if (_a1 == _afc  || _a2 == _afc ) 
			{
				if (_cd == _ad)
				{
					_S = S_fc_d();
					_D = D_d();
				}
				else
				{
					_S = S_fc_fd()
					_D = D_fd();
				}
				
			}
			
			var a:Number = _a1 * _a2;
			
			if (isNaN(_D))
			{
				switch (a) 
				{
					case 2:		_D = D_s_e		(); 	break;
					case 14:	_D = D_e_fs		(); 	break;
					case 77:	_D = D_fe_fs	();		break;
					case 11:	_D = D_fe_s		(); 	break;
				}
			}
			
			if (isNaN(_S))
			{
				switch (a) 
				{
					case 6:		_S = S_e_d 		(); 	break;
					case 26:	_S = S_e_fd 	(); 	break;
					case 15:	_S = S_c_d 		();		break;
					case 65:	_S = S_c_fd 	();		break;
					case 143:	_S = S_fe_fd	(); 	break;
				}
			}
			
			
		}
		
		/* S */
		
		private function S_s():Number
		{
			return _s;
		}
		
		private function S_fs():Number
		{
			return _fs * _L;
		}
		
		private function S_e_d():Number
		{
			return _L - _e - D_d();
		}
		
		private function S_e_fd():Number
		{
			return _L - _e - D_fd();
		}
		
		private function S_c_d():Number
		{
			return _L / 2 + _c - D_d() / 2;
		}
		
		private function S_c_fd():Number
		{
			return _L / 2 + _c - D_fd() / 2;
		}
		
		private function S_fc_d():Number
		{
			return _fc * _L - D_d() / 2;
		}
		
		private function S_fc_fd():Number
		{
			return _fc * _L - D_fd() / 2;
		}
		
		private function S_fe_fd():Number
		{
			return _fe * _L + D_fd();
		}
		
		
		/* D */
		
		public function get dd():Number
		{
			return D_d();
		}
		
		private function D_d():Number
		{
			var v:Number = _d;
			if (v > maxD) v = maxD;
			if (v < minD) v = minD;
			return v;
		}
		
		private function D_s_e():Number
		{
			var v:Number = _L - _e - _s;
			if (v > maxD) v = maxD;
			if (v < minD) v = minD;
			return v;
		}
		
		private function D_e_fs():Number
		{
			var v:Number =  _L - _e - _fs * _L;
			if (v > maxD) v = maxD;
			if (v < minD) v = minD;
			return v;
		}
		
		private function D_fe_fs():Number
		{
			var v:Number = _fe * _L - _fs * _L;
			if (v > maxD) v = maxD;
			if (v < minD) v = minD;
			return v;
		}
		
		private function D_fd():Number
		{
			var v:Number = _fd * _L;
			if (v > maxD) v = maxD;
			if (v < minD) v = minD;
			return v;
		}
		
		private function D_fe_s():Number
		{
			var v:Number = _fe * _L - _s
			if (v > maxD) v = maxD;
			if (v < minD) v = minD;
			return v;
		}
		
		/* GETTERS AND SETTERS */
		
		public function get s():Number 
		{
			return __s;
		}
		
		public function set s(value:Number):void 
		{
			__s = value;
			a(_as);
		}
		
		public function get e():Number 
		{
			return __e;
		}
		
		public function set e(value:Number):void 
		{
			__e = value;
			a(_ae);
		}
		
		public function get d():Number 
		{
			return __d;
		}
		
		public function set d(value:Number):void 
		{
			__d = value;
			a(_ad);
		}
		
		public function get fd():Number 
		{
			return _fd;
		}
		
		public function set fd(value:Number):void 
		{
			_fd = value;
			a(_afd);
		}
		
		public function get fs():Number 
		{
			return _fs;
		}
		
		public function set fs(value:Number):void 
		{
			_fs = value;
			a(_afs);
		}
		
		public function get fe():Number 
		{
			return _fe;
		}
		
		public function set fe(value:Number):void 
		{
			_fe = value;
			a(_afe);
		}
		
		public function get c():Number 
		{
			return __c;
		}
		
		public function set c(value:Number):void 
		{
			__c = value;
			a(_ac);
		}
		
		public function get fc():Number 
		{
			return _fc;
		}
		
		public function set fc(value:Number):void 
		{
			_fc = value;
			a(_afc);
		}
		
		public function get D():Number 
		{
			return _D;
		}
		
		public function get S():Number 
		{
			return _S;
		}
		
		public function get L():Number 
		{
			return _L;
		}
		
		public function get cd():int 
		{
			return _cd;
		}
		
		public function get a2():int 
		{
			return _a2;
		}
		
		public function get a1():int 
		{
			return _a1;
		}
		
		
		
		private function a(v:int):void
		{
			if (v == _ad)
			{
				_cd = _ad;
			}
			else if (v == _afd)
			{
				_cd = _afd;
			}
			
			if (_a1 == v) return;
			
			if (v == _ad && _a1 == _afd || v == _afd && _a1 == _ad)
			{
				_a1 = v;
				return;
			}
			
			if (v == _as && _a1 == _afs || v == _afs && _a1 == _as)
			{
				_a1 = v;
				return;
			}
			
			if (v == _ae && _a1 == _afe || v == _afe && _a1 == _ae)
			{
				_a1 = v;
				return;
			}
			
			if (v == _as && (_a1 == _ac || _a1 == _afc))
			{
				_a1 = v;
				return;
			}
			
			if (v == _ae && (_a1 == _ac || _a1 == _afc))
			{
				_a1 = v;
				return;
			}
			
			_a2 = _a1;
			_a1 = v;
			
		}
		
		//DEBUG
		
		/*private function get _S():Number
		{
			return __S;
		}
		
		private function set _S(value:Number):void 
		{
			if (_setting)
			{
				if (isNaN(value))
				{
					trace("FUCK");
				}
			}
			__S = value;
		}*/
		
	}

}