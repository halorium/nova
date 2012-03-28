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
    #@document = Document.new
  end

  # GET /accounts/1/edit
  def edit
    @account = Account.find(params[:id])
  end

  # POST /accounts
  def create
    duped = params[:account].dup
    duped.delete :my_file
    
    #render :text => params.inspect
    #render :text => duped
    #return
    
    @account = SugarCRM::Account.new(duped)
    @contact = SugarCRM::Contact.new(params[:contact])

    file = params[:account][:my_file]

    if @account.save!
        
      @account.contacts << @contact
      @account.contacts.save
        
      # Create a document instance and upload a file
      @doc = SugarCRM::Document.new
      @doc.active_date = Date.today
      @doc.document_name = file.original_filename
      @doc.filename = file.original_filename
      @doc.revision = 0
      @doc.save!
      
      SugarCRM.connection.set_document_revision(@doc.id, @doc.revision + 1, {:file => file.read, :file_name => file.original_filename})
      
      redirect_to @account, notice: 'Account was successfully created.'
    else
      render action: "new"
    end
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