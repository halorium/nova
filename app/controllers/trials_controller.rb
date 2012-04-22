class TrialsController < ApplicationController
  
  # GET /trials/1
  def show
    eproject  = Eproject.find(params[:id])
    account   = eproject.accounts.last
    contact   = eproject.contacts.last
    documents = eproject.documents
    @trial = Trial.new.setup account, contact, documents, eproject
  end


  # GET /trials/new
  def new
    @trial = Trial.new
    @account = Account.new
    @contact = Contact.new

    create_dropdowns
  end

  # POST /trials
  def create
    # Create the account object
    @account = Account.new(params[:account])
    
    # Create the contact object
    @contact = Contact.new(params[:contact])
    
    # Create the Editing Project
    @eproject = Eproject.new(:autoid => Eproject.last.autoid.next,
                             :name   => "TR-#{Eproject.last.autoid.next}",
                             :status => "Editing")

    @files = create_files

    @documents = create_documents

    @trial = Trial.new.setup @account, @contact, @documents, @eproject, @files
    
    # Check recaptcha
    unless verify_recaptcha
      #captcha is invalid
      @trial.errors.merge!({ 'Captcha' => ["invalid."] })
    end

    # If any errors, return to form
    if @trial.valid?
      @trial.save

      redirect_to @trial, notice: 'Trial was successfully created.'
    else
      create_dropdowns
      render action: "new"
    end
  end

  private

  def create_files
    # Set the files hash
    trial = params[:trial]
    
    files = []
    
    unless trial.nil?
      file1 = params[:trial][:file1]
      files << file1 unless file1.nil?

      file2 = params[:trial][:file2]
      files << file2 unless file2.nil?

      file3 = params[:trial][:file3]
      files << file3 unless file3.nil?
    end

    files
  end

  def create_documents
    documents = []

    @files.each do |file|
      document = Document.new
      document.active_date = Date.today
      document.document_name = file.original_filename
      document.filename = file.original_filename
      document.revision = 0

      documents << document
    end

    documents
  end

  def create_dropdowns
    @salutation  = create_salutation
    @lead_source = create_lead_source
  end

  def create_salutation
    salutation_options = get_contact_field_options 'salutation'
    sugar_options_to_dropdown_options salutation_options
  end

  def create_lead_source
    lead_options = get_contact_field_options 'lead_source'
    sugar_options_to_dropdown_options lead_options
  end

  def sugar_options_to_dropdown_options sugar_options
    dropdown_options = []
    
    sugar_options.each do |so|
      dropdown_options << [so[1]["name"], so[1]["value"]]
    end

    dropdown_options
  end

  def get_contact_field_options type
    contact_fields = SugarCRM.connection.get_fields("Contacts")["module_fields"]
    contact_fields[type]["options"]
  end
end
