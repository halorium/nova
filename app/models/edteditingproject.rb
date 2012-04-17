class EDTEditingproject < SugarCRM::EDTEditingproject
end

SugarCRM::EDTEditingproject.class_eval do
def self.model_name
ActiveModel::Name.new(EDTEditingproject)
end
end