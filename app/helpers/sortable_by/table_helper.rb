module SortableBy
  module TableHelper

    # Build a table header for a model
    #
    # * path_helper: The helper method you want to use to generate URLs.
    # * model: The class we should use for translations (optional)
    # * permit: Array of request params that are forwarded to the sort links
    #
    # Example:
    #
    # <%= sortable_header :admin_users_path, model: User do |t| %>
    #   <%= t.sortable :name %>
    #   <%= t.sortable :email %>
    #   <%= t.header :last_login %>
    #   <th></th>
    # <% end %>
    #
    # Header labels will be pulled from en.yml. To provide a different
    # label pass the label: option
    #
    # Example:
    #
    # <%= t.header :name, label: 'Full Name' %>
    #
    def sortable_table_header(path_helper, model: nil, permit: [], &block)
      header = SortableBy::TableHeader.new(
        path_helper: path_helper,
        model: model,
        params: params.permit(permit.concat([:sort, :dir, :search, :tab])),
        context: self)
      header.capture(block) if block
      header.to_html
    end
  end
end
