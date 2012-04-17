class TrialController < ApplicationController


  # GET /trials/1
  def show
  end

  # GET /trials
  def index
    @account = Account.new
    @contact = Contact.new
    @files = { "file1" => nil, "file2" => nil, "file3" => nil }
    
    # Get dropdown fields
    contact_fields = SugarCRM.connection.get_fields("Contacts")["module_fields"]
    salutation = []
    lead_source = []

    salutation_options = contact_fields["salutation"]["options"]
    lead_options = contact_fields["lead_source"]["options"]

    salutation_options.each do |o|
      salutation << [o[1]["name"], o[1]["value"]]
    end

    lead_options.each do |o|
      lead_source << [o[1]["name"], o[1]["value"]]
    end

    @fields = {"salutation" => salutation, "lead_source" => lead_source}
    
  end


  # POST /trials
  def create
    
    # Create the account object
    @account = SugarCRM::Account.new(params[:account])
    
    # Create the contact object
    @contact = SugarCRM::Contact.new(params[:contact])
    
    # Create the Editing Project
    @eproject = SugarCRM::EDTEditingproject.new(
    :autoid => SugarCRM::EDTEditingproject.last.autoid.next,
    :name => "TR-#{SugarCRM::EDTEditingproject.last.autoid.next}",
    :status => "Editing")
    
    # Verify required attributes
    if @account.name.blank?
      error = {"School/Org"=>["cannot be blank"]}
      @account.errors = @account.errors.merge error
    end
    
    if @contact.last_name.blank?
      error = {"Eng Last name"=>["cannot be blank"]}
      @contact.errors = @contact.errors.merge error
    end
    
    if @contact.cntc_chinese_name_c.blank?
      error = {"Ch name"=>["cannot be blank"]}
      @contact.errors = @contact.errors.merge error
    end
    
    if @contact.email1.blank?
      error = {"Email"=>["cannot be blank"]}
      @contact.errors = @contact.errors.merge error
    end
    
    if @contact.phone_mobile.blank?
      error = {"Mobile phone"=>["cannot be blank"]}
      @contact.errors = @contact.errors.merge error
    end
    
    if @contact.department.blank?
      error = {"Department"=>["cannot be blank"]}
      @contact.errors = @contact.errors.merge error
    end
    
    if @contact.title.blank?
      error = {"Title"=>["cannot be blank"]}
      @contact.errors = @contact.errors.merge error
    end
    
    if @contact.lead_source.blank?
      error = {"Where did you hear about us?"=>["cannot be blank"]}
      @contact.errors = @contact.errors.merge error
    end
    
    # Merge Account & Contact Errors
    @account.errors = @account.errors.merge @contact.errors
    
    
    # Set the files hash
    @files = []
    
    unless params[:files][:file1].nil?
      @files << params[:files][:file1]
    end
    
    unless params[:files][:file2].nil?
      @files << params[:files][:file2]
    end
    
    unless params[:files][:file3].nil?
      @files << params[:files][:file3]
    end
    
    # Document Errors
    if @files.blank?
      error = {"Document 1"=>["cannot be blank"]}
      
      # Merge Document error and Account errors
      @account.errors = @account.errors.merge error
    end
    
    # Check recaptcha
    unless verify_recaptcha
      #captcha is invalid      
      error = {"Captcha"=>["invalid."]}
      @account.errors = @account.errors.merge error
    end
    
    # If any errors, return to form
    if @account.errors.any?
      
      # Get dropdown fields
      contact_fields = SugarCRM.connection.get_fields("Contacts")["module_fields"]
      salutation = []
      lead_source = []

      salutation_options = contact_fields["salutation"]["options"]
      lead_options = contact_fields["lead_source"]["options"]

      salutation_options.each do |o|
        salutation << [o[1]["name"], o[1]["value"]]
      end

      lead_options.each do |o|
        lead_source << [o[1]["name"], o[1]["value"]]
      end

      @fields = {"salutation" => salutation, "lead_source" => lead_source}
      
      render action: "new"
      return
    end
    
    
    
    # If no errors then Save all objects
    @account.save
    @contact.save
    @eproject.save
    
    # Associate Account and Contact
    @account.associate!(@contact)

    # Set the Project Contact field values
    @eproject.contact_id_c = @contact.id
    @eproject.contact = @contact.last_name
    @eproject.save

    # Associate Editing Project to Account and Contact
    @eproject.associate!(@contact)
    @eproject.associate!(@account)
    
    # Create a document instance
    @files.each do |file|
      @doc = SugarCRM::Document.new
      @doc.active_date = Date.today
      @doc.document_name = file.original_filename
      @doc.filename = file.original_filename
      @doc.revision = 0
      @doc.save!
      
      # Uplaod the document
      SugarCRM.connection.set_document_revision(@doc.id, @doc.revision + 1, {:file => file.read, :file_name => file.original_filename})

      # Associate Document to project      
      @doc.associate!(@eproject)
      @doc.associate!(@contact)
    end

    redirect_to @account, notice: 'Account was successfully created.'
  end



end
