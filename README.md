# lua-resty-response
simple wrapper for ngx.print, ngx.redirect etc.

# Requirements
Nothing.

# Synopsis

```lua
local response = require 'resty.response'

local res = response.Json{foo='bar'} -- get a function
res() -- trigger ngx.print
```
