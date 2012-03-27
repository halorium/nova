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
  end

  # GET /accounts/1/edit
  def edit
    @account = Account.find(params[:id])
  end

  # POST /accounts
  def create
    @account = Account.new(params[:account])

      if @account.save
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