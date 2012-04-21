class Contact < SugarCRM::Contact
  def validate
    
    if last_name.blank?
      errors.merge!({"Eng Last name"=>["cannot be blank"]})
    end
    
    if cntc_chinese_name_c.blank?
      errors.merge!({"Ch name"=>["cannot be blank"]})
    end
    
    if email1.blank?
      errors.merge!({"Email"=>["cannot be blank"]})
    end
    
    if phone_mobile.blank?
      errors.merge!({"Mobile phone"=>["cannot be blank"]})
    end
    
    if department.blank?
      errors.merge!({"Department"=>["cannot be blank"]})
    end
    
    if title.blank?
      errors.merge!({"Title"=>["cannot be blank"]})
    end
    
    if lead_source.blank?
      errors.merge!({"Where did you hear about us?"=>["cannot be blank"]})
    end
    
    self
  end
end

SugarCRM::Contact.class_eval do
  def self.model_name
    ActiveModel::Name.new(Contact)
  end
end