require 'sinatra'
require_relative 'config/application'
require 'pry'

set :bind, '0.0.0.0'  # bind to all interfaces

helpers do
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      session[:user_id] = nil unless @current_user
    end
    @current_user
  end
end

get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  session[:user_id] = user.id
  flash[:notice] = "You're now signed in as #{user.username}!"
  @user_id = session[:user_id]
  redirect back
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect back
end

get '/meetups' do
  @meetups = Meetup.order(:name)
  @current_user = current_user
  erb :'meetups/index'
end

get '/meetups/new' do
  @name = nil
  @description = nil
  @location = nil
  @errors = []

  if current_user.nil?
    redirect '/meetups'
  end

  erb :'/meetups/new'
end

get '/meetups/:id' do
  @meetup = Meetup.find(params['id'])
  @users = @meetup.users
  @success_message = nil
  erb :'/meetups/show'
end

post '/meetups/edit/:id' do
  @meetup = Meetup.find(params['id'])
  @id = @meetup.id
  @name = @meetup.name
  @description = @meetup.description
  @location = @meetup.location

  @meetup.update_attributes({name: params['name'],
    location: params['location'],
    description: params['description']})

  @users = @meetup.users
  @success_message = nil
  erb :'/meetups/show'
end

post '/meetups/new' do
  @meetup = Meetup.create(
    name: params['name'],
    description: params['description'],
    location: params['location'],
    creator: current_user.username
    )

  @users = @meetup.users
  @success_message = "Your meetup has been created!"
  @errors = @meetup.errors.messages.values.flatten

  if @errors.length > 0
    @name = params['name']
    @description = params['description']
    @location = params['location']

    erb :'/meetups/new'
  else
    erb :'/meetups/show'
  end
end

post '/meetups/:id' do
  @sign_in_message = nil
  @join_message = nil
  @duplication_error = nil
  if current_user.nil?
    @sign_in_message = "Please sign in"
    @meetup = Meetup.find(params['id'])
    @users = @meetup.users
    erb :'/meetups/show'
  else
    registration =
      Registration.create(meetup_id: params['id'], user_id: current_user.id)
    @duplication_error = registration.errors[:meetup_id][0]

    if registration.valid?
      @join_message = "You\'re in! Nice!"
    end

    @meetup = Meetup.find(params['id'])
    @users = @meetup.users
    erb :'/meetups/show'
  end
end
