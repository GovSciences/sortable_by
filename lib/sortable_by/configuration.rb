module SortableBy
  include ActiveSupport::Configurable

  config_accessor :params_list, :icon_strategy

  # List of params to white list
  self.params_list = [:sort, :dir, :search, :tab]

  # Default icon strategy to be used
  self.icon_strategy = :basic
end
