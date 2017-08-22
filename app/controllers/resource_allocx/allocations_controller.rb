require_dependency "resource_allocx/application_controller"

module ResourceAllocx
  class AllocationsController < ApplicationController
    before_action :require_employee
    before_action :init_resource
    before_action :assigned_positions, :only => [:new, :edit]


    def index
      @title = t('Resource Allocations')
      @allocations = params[:resource_allocx_allocations][:model_ar_r]
      @allocations = @allocations.where('resource_allocx_allocations.resource_id = ?', @resource_id) if @resource_id
      @allocations = @allocations.where('TRIM(resource_allocx_allocations.resource_string) = ?', @resource_string) if @resource_string
      @allocations = @allocations.where('TRIM(resource_allocx_allocations.detailed_resource_category) = ?', @detailed_resource_category) if @detailed_resource_category
      #@allocations = @allocations.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('allocation_index_view_' + @detailed_resource_category, 'resource_allocx')
      #to csv
      respond_to do |format|
        format.html {@allocations = @allocations.page(params[:page]).per_page(@max_pagination) }
        format.csv do
          send_data @allocations.to_engine_csv(params[:index_from].to_i, params[:token?])
        end if @detailed_resource_category && @detailed_resource_category == 'engine'
      end
    end

    def new
      @title = t('New Allocation')
      @allocation = ResourceAllocx::Allocation.new()
      session[:detailed_resource_category] = @detailed_resource_category
      @erb_code = find_config_const('allocation_new_view_' + @detailed_resource_category, 'resource_allocx')
    end

    def create
      @allocation = ResourceAllocx::Allocation.new(new_params)
      @allocation.last_updated_by_id = session[:user_id]
      @detailed_resource_category = session[:detailed_resource_category]
      @allocation.detailed_resource_category = @detailed_resource_category
      @allocation.resource_id = session[:resource_id]
      @allocation.resource_string = session[:resource_string]
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
      if @allocation.update_attributes(edit_params)
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
    
    def destroy  
      ResourceAllocx::Allocation.delete(params[:id].to_i)
      redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Deleted!")
    end
    def multi_csv
      @from_projects = InfoServiceProjectx::Project.where('cancelled = ? AND decommissioned = ?', false, false).order('id DESC')
      @erb_code = find_config_const('allocation_multi_csv_view', 'resource_allocx')
    end
    
    def multi_csv_result
      @allocations = ResourceAllocx::Allocation.where(detailed_resource_category: 'engine').where(resource_id: params[:ids]).all.order('resource_id')
      respond_to do |format|
        format.csv do
          send_data @allocations.m_to_csv()
        end 
      end
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
      @positions = @positions.split(',').map{|x| [  I18n.t(x.strip.humanize.titleize) , x.strip  ] } if @positions      
    end

    private
    
    def new_params
      params.require(:allocation).permit(:resource_id, :resource_string, :detailed_resource_category, :assigned_as, :description, :start_date, :end_date, :status_id,
                     :detailed_resource_id, :active, :show_to_customer)
    end
    
    def edit_params
      params.require(:allocation).permit(:resource_id, :resource_string, :detailed_resource_category, :assigned_as, :description, :start_date, :end_date, :status_id,
                     :detailed_resource_id, :active, :show_to_customer)
    end
  end
end
