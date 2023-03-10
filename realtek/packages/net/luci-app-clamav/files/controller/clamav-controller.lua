--[[

LuCI ClamAV module

Copyright (C) 2015, Itus Networks, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Author: Marko Ratkaj <marko.ratkaj@sartura.hr>
	Luka Perkov <luka.perkov@sartura.hr>

]]--

module("luci.controller.clamav", package.seeall)

function index()
	entry({"admin", "NAS", "clamav"}, cbi("clamav"), _("ClamAV"))
end
