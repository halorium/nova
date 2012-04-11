class EDTEditingProject < SugarCRM::EDTEditingProject
end

SugarCRM::EDTEditingproject.class_eval do
def self.model_name
ActiveModel::Name.new(EDTEditingProject)
end
end