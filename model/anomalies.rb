class Anomaly
  # @abstract

  def initialize(id)
    @id = id
  end

  def getId
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def setId=(id)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class Bug < Anomaly
  def getId
    return @id if @id
  end
  def setId=(id)
    @id = id
  end
end
class Error < Anomaly
  def getId
    return @id if @id
  end
  def setId=(id)
    @id = id
  end
end
class Defect < Anomaly
  def getId
    return @id if @id
  end
  def setId=(id)
    @id = id
  end
end
class Faliure < Anomaly
  def getId
    return @id if @id
  end
  def setId=(id)
    @id = id
  end
end
class Fault < Anomaly
  def getId
    return @id if @id
  end
  def setId=(id)
    @id = id
  end
end
