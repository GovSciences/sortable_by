module SortableBy
  class Engine < ::Rails::Engine
    initializer :controller do
      ActiveSupport.on_load(:action_controller) { include SortableBy::Params }
    end
  end
end
