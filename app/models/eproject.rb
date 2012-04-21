class Eproject < SugarCRM::EDTEditingproject
  extend ActiveModel::Naming
  
  def validate
    if name.blank?
      errors.merge!({"EDT Editing Project name"=>["cannot be blank."]})
    end
    
    if autoid.blank?
      errors.merge!({"EDT Editing Project autoid"=>["cannot be blank."]})
    end
    
    if status.blank?
      errors.merge!({"EDT Editing Project status"=>["cannot be blank."]})
    end
    
    self
  end
end
