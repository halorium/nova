class AccountsController < ApplicationController

  # GET /accounts
  def index
    @accounts = Account.all(:limit => 10)
  end

  # GET /accounts/1
  def show
    @account = Account.find(params[:id])
  end

  # GET /accounts/new
  def new
    @account = Account.new
    @contact = Contact.new
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
    
    # Create a copy of account and remove file element
    duped = params[:account].dup
    duped.delete :my_file
    
    # Set and save the account or end
    @account = SugarCRM::Account.new(duped)
    unless @account.save!
      flash.now[:error] = "Account was not saved."
      render action: "new"
      return
    end
    
    # Set and save the contact or end
    @contact = SugarCRM::Contact.new(params[:contact])
    @account.contacts << @contact
    unless @account.contacts.save
      flash.now[:error] = "Contact was not saved."
      render action: "new"
      return
    end
    
    # Set and save the project or end
    @project = SugarCRM::EDTEditingproject.new(:name => "LH999")
    @contact.EDTEditingprojects << @project
    unless @contact.EDTEditingprojects.save
      flash.now[:error] = "Project was not saved."
      render action: "new"
      return
    end

    # Set the file variable
    file = params[:account][:my_file]
    
    # Create a document instance
    @doc = SugarCRM::Document.new
    @doc.active_date = Date.today
    @doc.document_name = file.original_filename
    @doc.filename = file.original_filename
    @doc.revision = 0
    unless @doc.save!
      flash.now[:error] = "Document was not saved."
      render action: "new"
      return
    end

    # Uplaod the document
    unless SugarCRM.connection.set_document_revision(@doc.id, @doc.revision + 1, {:file => file.read, :file_name => file.original_filename})
      flash.now[:error] = "Document was not uploaded."
      render action: "new"
      return
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