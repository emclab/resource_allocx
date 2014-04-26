require_dependency "resource_allocx/application_controller"

module ResourceAllocx
  class AllocationsController < ApplicationController
    before_filter :require_employee
    before_filter :load_record


    def index
      @title = t('Resource Allocations')
      @alloc = params[:resource_allocx_allocations][:model_ar_r]
      @alloc = @alloc.where('resource_allocx_allocations.resource_id = ?', params[:resource_id]) if params[:resource_id].present?
      @alloc = @alloc.where('TRIM(resource_allocx_allocations.resource_string) = ?', params[:resource_string].strip) if params[:resource_string].present?
      @alloc = @alloc.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('allocation_index_view', 'resource_allocx')
    end

    def new
      @title = t('New Allocation')
      @allocation = ResourceAllocx::Allocation.new
      @allocation.build_man_power
      @erb_code = find_config_const('allocation_new_view', 'resource_allocx')

    end

    def create
      @alloc = ResourceAllocx::Allocation.new(params[:allocation], :as => :role_new)
      @alloc.last_updated_by_id = session[:user_id]
      if @alloc.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash[:notice] = t('Data Error. Not Saved!')
        @erb_code = find_config_const('allocation_new_view', 'resource_allocx')
        render 'new'
      end

    end

    def edit
      @title = t('Edit Allocation')
      @alloc = ResourceAllocx::Allocation.find(params[:id])
      @erb_code = find_config_const('allocation_edit_view', 'resource_allocx')
    end

    def update
      @alloc = ResourceAllocx::Allocation.find(params[:id])
      @alloc.last_updated_by_id = session[:user_id]
      if @alloc.update_attributes(params[:allocation], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        flash[:notice] = t('Data Error. Not Saved!')
        @erb_code = find_config_const('allocation_edit_view', 'resource_allocx')
        render 'edit'
      end

    end

    def show
      @title = t('Allocation Info')
      @alloc = ResourceAllocx::Allocation.find(params[:id])
      @erb_code = find_config_const('allocation_show_view', 'resource_allocx')
    end

    protected

    def load_record
      @resource_id = params[:resource_id] if params[:resource_id].present?
      @resource_string = params[:resource_string] if params[:resource_string].present?
      @resource_id = ResourceAllocx::Allocation.find_by_id(params[:id]).resource_id if params[:id].present?
      @resource_string = ResourceAllocx::Allocation.find_by_id(params[:id]).resource_string if params[:id].present?
    end

  end
end
