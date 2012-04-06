require 'tempfile'
require 'json'
require 'aruba-doubles/double'

module ArubaDoubles
  def double_cmd(cmd, output = nil)
    d = Double.new(cmd)
    d.on [], output
    d.create
  end
end
