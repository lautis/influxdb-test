class Origin < ActiveRecord::Base
  class << self
    def find_or_create_by_name(name)
      find_or_create_by(name: name)
    rescue ActiveRecord::RecordNotUnique
      retry
    end
  end

  def pings
    Influxer::Relation.new(Ping, attributes: { origin: name })
  end
end
