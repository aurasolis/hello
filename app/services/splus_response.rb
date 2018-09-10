module SplusResponse

  def final_response request
    check request
    parsing(request.parsed_response)
  end

  def parsing response
    user = { :first_name => response.fetch('nombre'),
             :last_name => response.fetch('apellidos'),
             :sp_card => response.fetch('numeroTarjetaSP'),
             :birthday => response.fetch('fechaNacimiento'), #se sobreescribiría
             :fav_seat => response.fetch('asientoFavorito'),
             :available_kms => response.fetch('kilometrosDisponibles'),
             :customer_type => response.fetch('tipoSocio') }
             #:trips = res['viajes'] Error: Can't cast array.
  end

  def check request
    if request.code != 200
      flash.now[:danger] = 'Invalid Request'
      redirect_to request.env['HTTP_REFERER']
    end
  end
  
end
