module UsersHelper

  def birthday_parse(user)
    user.birthday = Date.strptime("#{params['birthday(3i)']}/#{params['birthday(2i)']}/#{params['birthday(1i)']}", "%d-%m-%y")
  end

  def validate_req(user)
    query = { :body => { :nombre => user.first_name,
              :apellidos => user.last_name,
              :fechaNacimiento => user.birthday.present? ? user.birthday : "",
              :correo => user.email }.to_json,
              :headers => { 'Content-Type' => 'application/json' } }
    url = ""
    response = HTTParty.post(url, query)
  end

  def login_req(sp_card, nip)
    query = { :body => { :numeroTarjeta => sp_card,
              :nip => nip }.to_json,
              :headers => { 'Content-Type' => 'application/json' } }

    url = ""
    response = HTTParty.post(url, query)
  end

  def obtain_req(user)
    query = { :body => { :numeroTarjeta => user.sp_card,
              :nip => "" }.to_json,
              :headers => { 'Content-Type' => 'application/json' } }
    headers = { :headers => { 'Content-Type' => 'application/json' } }

    url = ""
    debugger
    response = HTTParty.post(url, query)
  end

  def retrieve_req(birthday, email)
    query = { :body => { :fechaNacimiento => birthday,
              :correo => email }.to_json,
              :headers => { 'Content-Type' => 'application/json' } }

    url = ""
    response = HTTParty.post(url, query)
  end

  def parsing_user_info user,res
    user[:sp_card] = res.fetch('numeroTarjetaSP')
    user[:birthday] = res.fetch('fechaNacimiento') #se sobreescribiría
    user[:fav_seat] = res.fetch('asientoFavorito')
    user[:available_kms] = res.fetch('kilometrosDisponibles')
    user[:customer_type] = res.fetch('tipoSocio')
    #user[:trips] = res['viajes'] Error: Can't cast array.
    user.save
  end
end
