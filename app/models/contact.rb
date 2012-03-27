class Contact < SugarCRM::Contact
end

SugarCRM::Contact.class_eval do
def self.model_name
ActiveModel::Name.new(Contact)
end
end