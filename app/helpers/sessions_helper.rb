module SessionsHelper

	def sign_in(user)
		cookies.permanent[:remember_token] = user.remember_token #Cookies can take two values, a 'value' and an optional 'expires' date
		#You can write expiration time in following way "expires: 2.weeks.from_now.utc"
		self.current_user = user
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
		#The ||= invokation above will call find_by_remember_token if @current_user is undefined. 
		#Afterwards, it just returns @current_user so you don't keep hitting the db with token requests.
	end

	def current_user?(user)
		user == current_user
	end

	def signed_in?
    	!current_user.nil?
  	end

  	def sign_out
  		self.current_user = nil
  		cookies.delete(:remember_token)
  	end

  	def redirect_back_or(default)
    	redirect_to(session[:return_to] || default)
    	session.delete(:return_to)
  	end

  	def store_location
    	session[:return_to] = request.url
  	end
end
