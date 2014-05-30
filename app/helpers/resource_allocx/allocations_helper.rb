module ResourceAllocx
  module AllocationsHelper

    def all_resource_categories(param_name='allocation_resource_%', engine='resource_allocx', version=nil)
      engineConfigs = Authentify::EngineConfig.where('TRIM(engine_name) = ? AND TRIM(engine_version) = ? AND TRIM(argument_name) Like ?', engine.strip,  version.strip, param_name.strip) if engine.present? && version.present?
      engineConfigs = Authentify::EngineConfig.where('TRIM(engine_name) = ? AND TRIM(argument_name) Like ?', engine.strip, param_name.strip) if engine.present? && version.blank?
      all_resources = engineConfigs.map{|r| r.argument_name.split('allocation_resource_')[1] }.compact
    end

    module_function :all_resource_categories

  end
end
