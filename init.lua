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

package.loaded['custom.PostSurround'] = nil
package.loaded['custom.PreSurround'] = nil
package.loaded['custom.TextObjMotion'] = nil
package.loaded['custom.MakeSet'] = nil

require('custom.PostSurround')
require('custom.PreSurround')
require('custom.TextObjMotion')
require('custom.MakeSet')
