module SplusServices #estaba bien que fueran módulos?
  class Splus
  include HTTParty
  base_uri "wcf_qa_sp.primeraplus.com.mx/SiemprePlus_NPV.svc"

  def initialize
  end

  def register(user)
    @options = { :body => { :nombre => user.first_name,
                            :apellidos => user.last_name,
                            :fechaNacimiento => user.birthday.present? ? user.birthday : "",
                            :correo => user.email }.to_json,
                 :headers => { "Content-Type" => "application/json" } }
    self.class.post("/validarRegistro", @options)
  end

  def login(sp_card, nip)
    @options = { :body => { :numeroTarjeta => sp_card,
                            :nip => nip }.to_json,
                 :headers => { "Content-Type" => "application/json" } }
    self.class.post("/loginSP", @options)
  end

  def obtain(sp_card)
    @options = { :body => { :numeroTarjeta => sp_card,
                            :nip => "" }.to_json,
                 :headers => { "Content-Type" => "application/json" } }
    self.class.post("/obtenerDatosCliente", @options)
  end

  def reset(birthday, email)
    @options = { :body => { :fechaNacimiento => '01-01-1956',
                            :correo => email }.to_json,
                 :headers => { "Content-Type" => "application/json" } }
    self.class.post("/recuperarCuenta", @options)
  end
end
end
