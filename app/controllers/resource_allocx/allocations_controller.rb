require_dependency "resource_allocx/application_controller"

module ResourceAllocx
  class AllocationsController < ApplicationController
    before_filter :require_employee
    before_filter :init_resource, :assigned_positions


    def index
      @title = t('Resource Allocations')
      @allocations = params[:resource_allocx_allocations][:model_ar_r]
      @allocations = @allocations.where('resource_allocx_allocations.resource_id = ?', @resource_id) if @resource_id
      @allocations = @allocations.where('TRIM(resource_allocx_allocations.resource_string) = ?', @resource_string) if @resource_string
      @allocations = @allocations.where('TRIM(resource_allocx_allocations.detailed_resource_category) = ?', @detailed_resource_category) if @detailed_resource_category
      @allocations = @allocations.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('allocation_index_view_' + @detailed_resource_category, 'resource_allocx')
    end

    def new
      @title = t('New Allocation')
      @allocation = ResourceAllocx::Allocation.new()
      session[:detailed_resource_category] = @detailed_resource_category
      @erb_code = find_config_const('allocation_new_view_' + @detailed_resource_category, 'resource_allocx')
    end

    def create
      @allocation = ResourceAllocx::Allocation.new(params[:allocation], :as => :role_new)
      @allocation.last_updated_by_id = session[:user_id]
      @detailed_resource_category = session[:detailed_resource_category]
      @allocation.detailed_resource_category = @detailed_resource_category
      if @allocation.save
        session[:detailed_resrouce_category] = nil
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        @erb_code = find_config_const('allocation_new_view_' + @detailed_resource_category, 'resource_allocx')
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end

    def edit
      @title = t('Edit Allocation')
      @allocation = ResourceAllocx::Allocation.find(params[:id])
      @erb_code = find_config_const('allocation_edit_view_' + @allocation.detailed_resource_category, 'resource_allocx')
    end

    def update
      @allocation = ResourceAllocx::Allocation.find(params[:id])
      @allocation.last_updated_by_id = session[:user_id]
      if @allocation.update_attributes(params[:allocation], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        @erb_code = find_config_const('allocation_edit_view_' + @allocation.detailed_resource_category, 'resource_allocx')
        flash[:notice] = t('Data Error. Not Saved!')
        render 'edit'
      end

    end

    def show
      @title = t('Allocation Info')
      @allocation = ResourceAllocx::Allocation.find(params[:id])
      @erb_code = find_config_const('allocation_show_view_' + @allocation.detailed_resource_category, 'resource_allocx')
    end

    protected
    
    def init_resource
      @resource_id = ResourceAllocx::Allocation.find_by_id(params[:id]).resource_id if params[:id].present?  
      @resource_id = params[:resource_id].to_i if params[:resource_id].present?
      @resource_string = ResourceAllocx::Allocation.find_by_id(params[:id]).resource_string if params[:id].present? 
      @resource_string = params[:resource_string].strip if params[:resource_string].present?
      @detailed_resource_category = ResourceAllocx::Allocation.find_by_id(params[:id]).detailed_resource_category if params[:id].present? 
      @detailed_resource_category = params[:detailed_resource_category].strip if params[:detailed_resource_category].present?
    end

    def assigned_positions      
      @positions = find_config_const('allocation_assigned_position_' + @detailed_resource_category, 'resource_allocx') if @detailed_resource_category
      @positions = @positions.split(',').map(&:strip) if @positions      
    end

  end
end
