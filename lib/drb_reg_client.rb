#!/usr/bin/env ruby

# file: drb_reg_client.rb

require 'drb'
require 'json'
require 'rexle'


class DRbRegClient


  def initialize(host: 'localhost', port: '59500')
    DRb.start_service

    # attach to the DRb server via a URI given on the command line
    @reg = DRbObject.new nil, "druby://#{host}:#{port}"
  end

  def delete_key(path)
    @reg.delete_key path
  end

  def get_key(key='', auto_detect_type: false)

    r = @reg.get_key(key, auto_detect_type: auto_detect_type)     

    return unless r

    doc = Rexle.new(r)
    e = doc.root
    
    return e unless auto_detect_type
    
    c = e.attributes[:type]
    s = e.text

    return e if e.elements.length > 0 or s.nil?    
    return s unless c
          
    h = {
      string: ->(x) {x},
      boolean: ->(x){ 
        case x
        when 'true' then true
        when 'false' then false
        when 'on' then true
        when 'off' then false
        else x
        end
      },
      number: ->(x){  x[/^[0-9]+$/] ? x.to_i : x.to_f },
      time:   ->(x) {Time.parse x},
      json:   ->(x) {JSON.parse x}
    }
                            
    h[c.to_sym].call s         

  end
    

  def get_keys(key)
    
    recordset = @reg.get_keys(key)
    return unless recordset

    doc = Rexle.new(recordset)    
    doc.root.elements ? doc.root.elements.to_a : []
   
  end
  
  def import(s)
    @reg.import s
  end

  def set_key(key, value)

    r = @reg.set_key(key, value)
    return unless r

    doc = Rexle.new(r)
    doc.root
  end

  def xpath(path)
    
    r = @reg.xpath path

    return [] if r.empty?

    doc = Rexle.new(r)    
    doc.root.elements ? doc.root.elements.to_a : []
  end

end 
