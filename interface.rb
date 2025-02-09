class Interface
  def initialize
    @trains = []
    @stations = []
    @routes = []
  end

  def start
    loop do
      show_menu
      choice = get_choice
      action(choice)
      puts
    end
  end

  private

  def show_menu
    menu = ['1 - Создать станцию', '2 - Создать поезд', '3 - Создать маршут, добавить/удалить станцию',
            '4 - Назначить маршурт поезду', '5 - Прицепить вагон поезду', '6 - Отцепить вагон от поезда',
            '7 - Переместить поезд по маршруту', '8 - Просмотреть список станций',
            '9 - Просмотреть список поездов на станции', '0 - Выйти']
    puts "Выберите действие: "
    puts menu
  end

  def get_choice
    STDIN.gets.chomp.to_i
  end

  def action(choice)

    case choice
    when 1
      create_station
    when 2
      create_train
    when 3
      create_route
    when 4
      assign_route
    when 5
      hook_wagon
    when 6
      unhook_wagon
    when 7
      move_train
    when 8
      show_stations
    when 9
      show_trains_on_station
    when 0
      exit
    end
  end

  def create_station
    puts "Введите название станции: "
    station_name = STDIN.gets.chomp

    @stations << Station.new(station_name)
    puts "Станция #{@stations.last.name} создана!"
  end

  def create_train
    puts "Введите номер поезда: "
    train_number = STDIN.gets.chomp
    puts "Введите тип поезда(1 - грузовой, 2 - пассажирский): "
    type_of_train = STDIN.gets.chomp

    case type_of_train.to_i

    when 1
      @trains << CargoTrain.new(train_number)
    when 2
      @trains << PassengerTrain.new(train_number)
    else
      puts "Ошибка при создании поезда!"
    end

    puts "Поезд с номером #{@trains.last.number} создан!"
  end

  def create_route
    puts "Введите название маршрута: "
    name_of_route = STDIN.gets.chomp
    puts
    puts "Список станций: "
    @stations.each { |station| puts station.name }
    puts "Введите название начальной станции: "
    start_station_name = STDIN.gets.chomp
    puts "Введите название конечной станции: "
    final_station_name = STDIN.gets.chomp

    start_station_object = nil
    final_station_object = nil

    @stations.each do |station|
      start_station_object = station if station.name == start_station_name
      final_station_object = station if station.name == final_station_name
    end

    @routes << Route.new(start_station_object, final_station_object, name_of_route)
    loop do

      puts "Добавить станцию или удалить?"
      puts "1. Добавить"
      puts "2. Удалить"
      puts "0. Выйти"
      choice_action = STDIN.gets.chomp.to_i

      break if choice_action == 0

      puts "Введите название станции: "
      station_name = STDIN.gets.chomp

      added_station = nil
      @stations.find { |station| added_station = station if station.name == station_name }

      case choice_action
      when 1
        @routes.last.add_station(added_station)
      when 2
        @routes.last.pop_station(added_station)
      when 0
        break
      end

      @routes.last.print_route
    end

  end

  def assign_route
    puts "Введите название маршрута: "
    route_name = STDIN.gets.chomp
    puts "Введите номер поезда: "
    train_number = STDIN.gets.chomp

    route_object = nil
    @routes.find { |route| route_object = route if route.route_name == route_name }
    train_object = @trains.find { |train| train.number == train_number }

    train_object.add_route(route_object)
    puts "Поезду #{train_object.number} присвоен маршрут #{route_object.route_name}!"
  end

  def hook_wagon
    puts "Введите номер поезда: "
    train_number = STDIN.gets.chomp

    train_object = @trains.find { |train| train.number == train_number }

    if train_object.train_type == 'грузовой'
      wagon = FreightWagon.new
    elsif train_object.train_type == 'пассажирский'
      wagon = PassengerWagon.new
    end

    train_object.add_wagon(wagon)
    puts "Текущее количество вагонов: #{train_object.wagons.size}"
  end

  def unhook_wagon
    puts "Введите номер поезда: "
    train_number = STDIN.gets.chomp

    train_object = @trains.find { |train| train.number == train_number }
    train_object.pop_wagon
    puts "Текущее количество вагонов: #{train_object.wagons.size}"
  end

  def move_train
    puts "Введите номер поезда: "
    train_number = STDIN.gets.chomp

    train_object = @trains.find { |train| train.number == train_number }
    puts "1 - Переместить вперёд"
    puts "2 - Переместить назад"

    choice = STDIN.gets.chomp.to_i

    case choice
    when 1
      train_object.move_forward
      puts "Вы прибыли на станцию #{train_object.current_station.name}"
    when 2
      train_object.move_back
      puts "Вы прибыли на станцию #{train_object.current_station.name}"
    end
  end

  def show_stations
    puts "Список станций:"
    puts @stations.find { |station| puts station.name }
  end

  def show_trains_on_station
    if @stations.empty?
      puts "Сначала необходимо создать станцию"
    else
      puts "Введите станцию"
      name = gets.chomp

      station = @stations.detect { |station| station.name == name }
      if station.nil?
        puts "Такой станции нет"
      else
        puts "Список поездов на станции: "
        station.trains.each { |train| puts train.number }
      end
    end
  end
end




