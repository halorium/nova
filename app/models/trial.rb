class Trial
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  
	attr_reader :account
	attr_reader :contact
	attr_reader :documents
	attr_reader :eproject

  attr_reader :errors

  def initialize
    @errors = {}
    @persisted = false
  end
  
	def setup account, contact, documents, eproject, files=[]
    @account   = account
    @contact   = contact
    @documents = documents
    @files     = files
    @eproject  = eproject

    self
  end

  def persisted?
    @persisted
  end

  def valid?
    validate
    @errors.empty?
  end

  def save
    @account.save
    @contact.save
 
    @account.associate! @contact
    
    @eproject.save
    
    @eproject.associate! @contact
    @eproject.associate! @account
    
    save_documents

    @persisted = true

    self
  end
  
  def id
    @eproject.id
  end

  private

  def validate
    @errors.merge! @account.validate.errors
    @errors.merge! @contact.validate.errors
    if @documents.empty?
      @errors.merge!({"Documents"=>["must have at least one document."]})
    end
    @errors.merge! @eproject.validate.errors

    self
  end

  def save_documents
    @documents.each do |d|
      d.save

      file = @files.pop

      SugarCRM.connection.set_document_revision( d.id,
                                                 d.revision + 1,
                                                 { :file      => file.read,
                                                   :file_name => file.original_filename} )

      # Associate Document to project      
      d.associate!(@eproject)
      d.associate!(@contact)
    end
  end
end
