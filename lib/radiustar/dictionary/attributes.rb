module Radiustar

  

  class AttributesCollection < Array

    attr_accessor :vendor

    def initialize vendor=nil
      @collection = {}
      @revcollection = {}
      @vendor = vendor if vendor
    end

    def add(name, id, type)
      if vendor?
        @collection[name] ||= Attribute.new(name, id, type, @vendor)
      else
        @collection[name] ||= Attribute.new(name, id, type)
      end
      @revcollection[convert_to_int(id)] ||= @collection[name]
      self << @collection[name]
    end

    def find_by_name(name)
      @collection[name]
    end

    def find_by_id(id)
      @revcollection[id]
    end

    def vendor?
      !!@vendor
    end

    def convert_to_int(obj)
      if obj.kind_of?(String)
        if obj.start_with?('0x')
          obj.to_i(16)
        else
          obj.to_i
        end
      else
        obj
      end
    end
  end

  class Attribute

    include Radiustar

    attr_reader :name, :id, :type, :vendor

    def initialize(name, id, type, vendor=nil)
      @values = ValuesCollection.new
      @name = name
      @id = convert_to_int(id)
      @type = type
      @vendor = vendor if vendor
    end

    def add_value(name, id)
      @values.add(name, convert_to_int(id))
    end

    def find_values_by_name(name)
      @values.find_by_name(name)
    end

    def find_values_by_id(id)
      @values.find_by_id(convert_to_int(id))
    end

    def has_values?
      !@values.empty?
    end

    def values
      @values
    end

    def vendor?
      !!@vendor
    end

    private 
    def convert_to_int(obj)
      if obj.kind_of?(String)
        if obj.start_with?('0x')
          obj.to_i(16)
        else
          obj.to_i
        end
      else
        obj
      end
    end
  end
end
