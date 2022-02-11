# Defining a module

I started using nvim last week, and I am learning how to customize my plugins
using lua. Defining a module, is simple.

Within the the lua root folder, you define `.lua` files like this:

- lua/my_module.lua
- lua/my_module/nested_module.lua

And you import them like this:
```lua
require('my_module')
require('my_module/nested_module')
require('my_module.nested_module')
```

Inside of each file, you define a module and export it like this:

```lua
local M = {}

function M.my_function()
end

return M
```
