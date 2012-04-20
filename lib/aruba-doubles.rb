require 'tempfile'
require 'shellwords'
require 'aruba-doubles/double'

module ArubaDoubles
  def double_cmd(cmd, output = {})
    argv = Shellwords.split(cmd)
    filename = argv.shift
    double = Double.find(filename) || Double.new(filename)
    double.create { on argv, output }
  end
end
