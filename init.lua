-------------------------------------------------------------------------------
--  Neovim Config File                                                       --
-------------------------------------------------------------------------------

package.loaded['config.keymaps'] = nil
package.loaded['config.options'] = nil

require('config.keymaps')
require('config.lazy')
require('config.options')

-------------------------------------------------------------------------------
--  Custom Plugins                                                           --
-------------------------------------------------------------------------------

package.loaded['custom.Surround'] = nil
package.loaded['custom.SurroundInsert'] = nil
package.loaded['custom.TextObjMotion'] = nil
package.loaded['custom.MakeSet'] = nil

require('custom.Surround')
require('custom.SurroundInsert')
require('custom.TextObjMotion')
require('custom.MakeSet')
