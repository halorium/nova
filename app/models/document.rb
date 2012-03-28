class Document < SugarCRM::Document
end

SugarCRM::Document.class_eval do
def self.model_name
ActiveModel::Name.new(Document)
end
end