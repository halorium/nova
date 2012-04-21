class Account < SugarCRM::Account
  extend ActiveModel::Naming

  def validate
    if name.blank?
      errors.merge!({"School/Org"=>["cannot be blank"]})
    end
    
    self
  end
end

# SugarCRM::Account.class_eval do
#   def self.model_name
#     ActiveModel::Name.new(Account)
#   end
# end
