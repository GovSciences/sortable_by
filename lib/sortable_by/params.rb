module SortableBy
  module Params
    extend ActiveSupport::Concern

    module ClassMethods
      attr_accessor :default_sort_attribute, :default_sort_dir, :sortable_mapping

      # Define attributes you wish to sort by
      #
      # This optional configuration method tells the the sortable
      # helpers how they should map attributes to queries. For
      # example a "name" sort might need to sort on first and last
      # name attributes
      #
      # The `default` argument, if passed, will determine the
      # attribute used when no sort param has been passed
      #
      # Usage:
      #
      # sortable_by :email, name: [:last_name, :first_name]
      #             default: :email,
      #             direction: :asc
      #
      #
      def sortable_by(*attributes, **options)
        @default_sort_attribute = options.delete(:default)
        @default_sort_dir = options.delete(:direction) || :asc
        @sortable_mapping = options.merge(attributes.to_h { |att| [att, att] })
      end
    end

    # Return the current sort direction
    #
    # Defaults to :default_sort_dir for all values other than 'asc' or 'desc'
    #
    def sort_direction
      if ['asc', 'desc'].include?(params[:dir])
        params[:dir].to_sym
      else
        self.class.default_sort_dir
      end
    end

    # Return the current sort param
    #
    def sort_attribute
      params[:sort].try(:to_sym) || self.class.default_sort_attribute
    end

    # Return a hash that can be used in an ActiveRecord order query
    #
    # Example:
    #   MyModel.where(...).order(sortable_query).paginate(...)
    #
    def sortable_query
      return unless sort_attribute

      normalize_sort_value(
        sort_attribute,
        sort_direction
      )
    end

    # Translate the sort_by and direction into a sortable hash
    #
    def normalize_sort_value(sort_by, direction)
      mapping = self.class.sortable_mapping[sort_by]
      case mapping
      when Symbol
        { mapping => sort_direction }
      when String
        mapping.gsub(':dir', sort_direction.to_s)
      when Array
        mapping.index_with { |_att| direction }
      when Proc
        mapping.call(direction)
      else
        logger.debug("WARNING: Sort attribute '#{sort_by}' is not recognized. Did you mean to pass it to sortable_by?")
        nil
      end
    end
  end
end
