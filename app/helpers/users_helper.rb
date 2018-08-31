module UsersHelper

  def validate_req(user)
    query = { :body => { :nombre => user.first_name,
              :apellidos => user.last_name,
              :fechaNacimiento => user.birthday.present? || "",
              :correo => user.email }.to_json,
              :headers => { 'Content-Type' => 'application/json' } }

    url = "http://wcf_qa_sp.primeraplus.com.mx/SiemprePlus_NPV.svc/validarRegistro"
    response = HTTParty.post(url, query)
  end

  def login_req(sp_card, nip)
    query = { :body => { :numeroTarjeta => sp_card,
              :nip => nip }.to_json,
              :headers => { 'Content-Type' => 'application/json' } }

    url = "http://wcf_qa_sp.primeraplus.com.mx/SiemprePlus_NPV.svc/loginSP"
    response = HTTParty.post(url, query)
  end

  def obtain_req(user)
    query = { :body => { :numeroTarjeta => user.sp_card,
              :nip => "" }.to_json,
              :headers => { 'Content-Type' => 'application/json' } }
    headers = { :headers => { 'Content-Type' => 'application/json' } }
    url = "http://wcf_qa_sp.primeraplus.com.mx/SiemprePlus_NPV.svc/obtenerDatosCliente"
    debugger
    response = HTTParty.post(url, query)
  end

  def retrieve_req(birthday, email)
    query = { :body => { :fechaNacimiento => birthday,
              :correo => email }.to_json,
              :headers => { 'Content-Type' => 'application/json' } }

    url = "http://wcf_qa_sp.primeraplus.com.mx/SiemprePlus_NPV.svc/recuperarCuenta"
    response = HTTParty.post(url, query)
  end

  def parsing_user_info user,res
    user[:sp_card] = res['numeroTarjetaSP']
    user[:birthday] = res['fechaNacimiento'] #se sobreescribiría
    user[:fav_seat] = res['asientoFavorito']
    user[:available_kms] = res['kilometrosDisponibles']
    user[:customer_type] = res['tipoSocio']
    #user[:trips] = res['viajes'] Error: Can't cast array.
    user.save
  end
end
