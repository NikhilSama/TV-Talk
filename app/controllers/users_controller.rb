class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    client = TwitterOAuth::Client.new(
    :consumer_key => '1eIfupUo52SHWo6TjlSNQ',
    :consumer_secret => 'NeSoo58Y7q1IslPtAR2s1GbdWADfiC49twK8joOTJzc'
  )
  request_token = client.request_token(:oauth_callback => 'http://tvtalk.heroku.com/tw_callback')
  session[:token] = request_token.token
  session[:secret] = request_token.secret
  session[:mobile] = params[:mobile]
  redirect_to request_token.authorize_url   
   end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  def tw_callback
   client = TwitterOAuth::Client.new(
      :consumer_key => '1eIfupUo52SHWo6TjlSNQ',
      :consumer_secret => 'NeSoo58Y7q1IslPtAR2s1GbdWADfiC49twK8joOTJzc'
    )

    @access_token = client.authorize(
      session[:token],
      session[:secret],
      :oauth_verifier => params[:oauth_verifier]
    )
    if client.authorized?
      @user = User.new(:mobileid=>session[:mobile], :tw_token=>@access_token.token, :tw_token_secrec=>@access_token.secret)
      @user.save
    else
      
    end
  
  end
  def get_tw_credentials
      @user = User.find_by_mobileid(params[:mobileid])

      if @user.nil?
        render :json => nil
      else
        respond_to do |format|
          format.json  { render_json @user.to_json }
        end
      end
  end
  def render_json(json)
    callback = params[:callback]
    response = begin
      if callback
        "#{callback}(#{json});"
      else
        json
      end
    end
    render({:content_type => :js, :text => response})
  end
  def post_update() 

    @client = TwitterOAuth::Client.new(
      :consumer_key => '1eIfupUo52SHWo6TjlSNQ',
      :consumer_secret => 'NeSoo58Y7q1IslPtAR2s1GbdWADfiC49twK8joOTJzc',
      :token => params[:token],
      :secret => params[:secret])
   
    @resp = @client.update(params[:update])
    debug(@resp);
  end
end
