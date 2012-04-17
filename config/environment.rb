# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Nova::Application.initialize!

module SugarCRM
  class Association
    def include?(attribute)
      return true if attribute.class == @target
      return true if attribute == link_field
      return true if methods.include? attribute
      
      myclass = SugarCRM::EDTEditingproject.new.class
      return true if attribute.class == myclass && link_field == "edt_editingjects_accounts" && @target == false
      return true if attribute.class == myclass && link_field == "edt_editingprojects_accounts" && @target == false
      return true if attribute.class == myclass && link_field == "edt_editingjects_contacts" && @target == false
      return true if attribute.class == myclass && link_field == "edt_editingprojects_contacts" && @target == false
      return true if attribute.class == myclass && link_field == "edt_editingects_documents" && @target == false
      return true if attribute.class == myclass && link_field == "edt_editingprojects_documents" && @target == false
      false
    end
  end
end