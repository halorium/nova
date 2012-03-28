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
    @account = SugarCRM::Account.new(params[:account])

    @contact = SugarCRM::Contact.new(params[:contact])

    #@doc1 = :document.doc1

      if @account.save!
        
        @account.contacts << @contact
        @account.contacts.save
        
        def doc1
        # Create a document instance and upload a file
        #file = File.read(File.join(File.dirname(__FILE__),"test_excel.xls"))
        doc = SugarCRM::Document.new
        file = File.read(document.doc1)
        doc.active_date = Date.today
        doc.document_name = document.doc1.original_filename
        doc.filename = document.doc1.original_filename
        doc.revision = 0
        doc.uploadfile = SugarCRM.connection.b64_encode(file)
        doc.save!
        end
        
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