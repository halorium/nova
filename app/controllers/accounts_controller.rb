class AccountsController < ApplicationController

require 'pry'

  # GET /accounts
  def index
    @accounts = Account.all(:limit => 10, :order_by => "date_entered DESC")
  end

  # GET /accounts/1
  def show
    @account = Account.find(params[:id])
  end

  # GET /accounts/new
  def new
    @account = Account.new
    @contact = Contact.new
    
    # Get dropdown fields
    fields = SugarCRM.connection.get_module_fields("Accounts")
    myf = fields["module_fields"]
    type = myf["account_type"]
    @typeops = type["options"]
    
#    typeops.each do |f|
#      f.each do |a|
#        puts a["name"]
#        puts a["value"]
#        puts "---"
#      end  
#    end  
    
    
    
  end

  # GET /accounts/1/edit
  def edit
    @account = Account.find(params[:id])
  end

  # POST /accounts
  def create
    # Troublshooting - show variables to the view
    #render :text => params.inspect
    #render :text => duped
    #return
    
    # Create a copy of account and remove file elements
    duped = params[:account].dup
    duped.delete :my_file
    duped.delete :my_file2
    duped.delete :my_file3
    
    # Create the account
    @account = SugarCRM::Account.create(duped)
        
    # Create the contact
    @contact = SugarCRM::Contact.create(params[:contact])
    
    # Associate Account and Contact
    @account.associate!(@contact)
        
    # Create the Editing Project
    @eproject = SugarCRM::EDTEditingproject.create(:name => "LH999")
    
    # Associate Editing Project to Account and Contact
    @eproject.associate!(@contact)
    @eproject.associate!(@account)
    
    # Associate the Project and Contact
    #unless @contact.associate!(@eproject)
    #  flash.now[:error] = "Project was not associated to contact."
    #  render action: "new"
    #  return
    #end
    
    # Set the file variable
    @files = [params[:account][:my_file]]
    
    unless params[:account][:my_file2].nil?
      @files << params[:account][:my_file2]
    end
    
    unless params[:account][:my_file3].nil?
      @files << params[:account][:my_file3]
    end
    #file = params[:account][:my_file]
    
    # Create a document instance
    @files.each do |file|
      binding.pry
      @doc = SugarCRM::Document.new
      @doc.active_date = Date.today
      @doc.document_name = file.original_filename
      @doc.filename = file.original_filename
      @doc.revision = 0
      @doc.save!
      
      # Uplaod the document
      SugarCRM.connection.set_document_revision(@doc.id, @doc.revision + 1, {:file => file.read, :file_name => file.original_filename})

      # Relate document to project      
      @doc.associate!(@eproject)
      @doc.associate!(@contact)
    end
      
    redirect_to @account, notice: 'Account was successfully created.'
  end

  # PUT /accounts/1
  def update
    @account = Account.find(params[:id])

      if @account.update_attributes(params[:account])
        redirect_to @account, notice: 'Account was successfully updated.'
      else
        render action: "edit"
      end

  end

  # DELETE /accounts/1
  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    redirect_to accounts_url
  end
  
end