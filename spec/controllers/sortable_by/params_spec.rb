require 'rails_helper'

describe SortableBy::Params, type: :controller do

  ActiveSupport.on_load(:action_controller) { include SortableBy::Params }

  controller(ActionController::Base) do
    sortable_by :first_name, :last_name, :email,
                display_name: [:first_name, :last_name],
                birth_date: 'user_birthdays.date :dir',
                special: proc { |dir| "some_other_tables.whatever #{dir}" },
                default: :last_name,
                direction: :asc

    def index; end
  end

  describe '#sort_direction' do
    it 'returns asc' do
      expect(controller.sort_direction).to eq(:asc)
    end
    it 'returns desc' do
      controller.params[:dir] = 'desc'
      expect(controller.sort_direction).to eq(:desc)
    end
  end

  describe '#sort_attribute' do
    it 'returns the default' do
      expect(controller.sort_attribute).to eq(:last_name)
    end
    it 'returns the param' do
      controller.params[:sort] = 'email'
      expect(controller.sort_attribute).to eq(:email)
    end
  end

  describe '#sortable_query' do
    it 'returns the value as a hash' do
      controller.params[:sort] = 'email'
      expect(controller.sortable_query).to eq(email: :asc)
    end

    it 'returns a multi value hash' do
      controller.params[:sort] = 'display_name'
      controller.params[:dir] = 'desc'
      expect(controller.sortable_query).to eq(first_name: :desc, last_name: :desc)
    end

    it 'returns a string with substitution' do
      controller.params[:sort] = 'birth_date'
      controller.params[:dir] = 'desc'
      expect(controller.sortable_query).to eq('user_birthdays.date desc')
    end

    it 'returns a string by calling a proc' do
      controller.params[:sort] = 'special'
      controller.params[:dir] = 'desc'
      expect(controller.sortable_query).to eq('some_other_tables.whatever desc')
    end

    it 'returns nothing' do
      controller.params[:sort] = 'not_allowed'
      expect(controller.sortable_query).to eq(nil)
    end
  end
end
