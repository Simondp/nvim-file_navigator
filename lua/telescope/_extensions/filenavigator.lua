return require("telescope").register_extension {
  setup = function(ext_config, config)
    -- access extension config and user config
  end,
  exports = {
    filenavigator = require("telescope._extensions.filenavigator._filenavigator").do_navigate
  },
}
