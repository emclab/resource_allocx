require_dependency "resource_allocx/application_controller"

module ResourceAllocx
  class AllocationsController < ApplicationController
    before_filter :require_employee
    before_filter :init_resource


    def index
      @title = t('Resource Allocations')
      @allocations = params[:resource_allocx_allocations][:model_ar_r]
      @allocations = @allocations.where('resource_allocx_allocations.resource_id = ?', @resource_id) if @resource_id
      @allocations = @allocations.where('TRIM(resource_allocx_allocations.resource_string) = ?', @resource_string) if @resource_string
      @allocations = @allocations.where('TRIM(resource_allocx_allocations.resource_category) = ?', @resource_category) if @resource_category
      @allocations = @allocations.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('allocation_index_view', 'resource_allocx')
    end

    def new
      @title = t('New Allocation')
      @allocation = ResourceAllocx::Allocation.new()
      @allocation.build_man_power
      @erb_code = find_config_const('allocation_new_view', 'resource_allocx')
    end

    def create
      @allocation = ResourceAllocx::Allocation.new(params[:allocation], :as => :role_new)
      @allocation.last_updated_by_id = session[:user_id]
      if @allocation.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        @erb_code = find_config_const('allocation_new_view', 'resource_allocx')
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end

    def edit
      @title = t('Edit Allocation')
      @allocation = ResourceAllocx::Allocation.find(params[:id])
      @erb_code = find_config_const('allocation_edit_view', 'resource_allocx')
    end

    def update
      @allocation = ResourceAllocx::Allocation.find(params[:id])
      @allocation.last_updated_by_id = session[:user_id]
      if @allocation.update_attributes(params[:allocation], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        @erb_code = find_config_const('allocation_edit_view', 'resource_allocx')
        flash[:notice] = t('Data Error. Not Saved!')
        render 'edit'
      end

    end

    def show
      @title = t('Allocation Info')
      @allocation = ResourceAllocx::Allocation.find(params[:id])
      @erb_code = find_config_const('allocation_show_view', 'resource_allocx')
    end

    protected

    def init_resource
      @resource_id = (ResourceAllocx::Allocation.find_by_id(params[:id]).resource_id if params[:id].present?)   ||
                     params[:resource_id] if params[:resource_id].present?
      @resource_string = (ResourceAllocx::Allocation.find_by_id(params[:id]).resource_string if params[:id].present?) ||
                         params[:resource_string].strip if params[:resource_string].present?
      @resource_category = (ResourceAllocx::Allocation.find_by_id(params[:id]).resource_category if params[:id].present?) ||
                           params[:resource_category].strip if params[:resource_category].present?
    end

    def positions
      @positions = @positions || find_config_const('allocation_positions_list', 'resource_allocx')
    end

  end
end
