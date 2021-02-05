module Secured
  def authenticate_user!
    # verificar la estructura del token
    token_regex = /Bearer (\w+)/
    # leer header de auth
    headers = request.headers
    # verificar validez del token"
    if headers['authorization'].present? && headers['authorization'].match(token_regex)
      token = headers['authorization'].match(token_regex)[1]
      if(Current.user = User.find_by_auth_token(token))
        return
      end
    end
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
