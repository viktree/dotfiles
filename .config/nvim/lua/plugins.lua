
-- Only required if you have packer in your `opt` pack
-- vim.cmd [[packadd packer.nvim]]

vim._update_package_paths()


function loadNeoVimPlugins()
  -- Packer can manage itself as an optional plugin
  use {'wbthomason/packer.nvim', opt = true}

  -- ALE
  use {
    'w0rp/ale',
    ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex'},
    cmd = 'ALEEnable',
    config = 'vim.cmd[[ALEEnable]]'
  }
end

return require('packer').startup(loadNeoVimPlugins)
