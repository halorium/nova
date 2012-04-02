class Project < SugarCRM::EDTEditingproject
end

SugarCRM::EDTEditingproject.class_eval do
def self.model_name
ActiveModel::Name.new(Project)
end
end